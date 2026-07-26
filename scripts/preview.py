#!/usr/bin/env python3
"""CV preview server — compile docs as PNG pages, serve a gallery with auto-refresh.

Usage:
  python3 scripts/preview.py              # compile all, watch, open browser
  python3 scripts/preview.py --file cv   # compile + watch only cv
  python3 scripts/preview.py --no-open   # skip browser open
"""

import argparse
import glob
import http.server
import json
import os
import subprocess
import threading
import time
import webbrowser

PORT = 7777
ALL_DOCS = ["cv", "cv-eu", "resume", "resume-onepage"]

_lock = threading.Lock()
_last_updated: int = 0  # ms timestamp, bumped on every gallery rebuild


# ---------------------------------------------------------------------------
# Compilation
# ---------------------------------------------------------------------------

def compile_doc(doc: str, root: str, preview_dir: str) -> bool:
    src = os.path.join(root, "src", f"{doc}.typ")
    out = os.path.join(preview_dir, f"{doc}-{{n}}.png")

    # Remove stale pages so page-count changes are visible immediately
    for stale in glob.glob(os.path.join(preview_dir, f"{doc}-*.png")):
        os.remove(stale)

    result = subprocess.run(
        [
            "typst", "compile",
            "--font-path", os.path.join(root, "fonts/"),
            "--root", root,
            "--format", "png",
            "--ppi", "150",
            src, out,
        ],
        capture_output=True, text=True, cwd=root,
    )
    if result.returncode != 0:
        print(f"  ✗ {doc}: {result.stderr.strip()}", flush=True)
    return result.returncode == 0


def compile_all(docs: list[str], root: str, preview_dir: str) -> None:
    for doc in docs:
        print(f"  {doc} ...", end=" ", flush=True)
        print("ok" if compile_doc(doc, root, preview_dir) else "FAILED")


# ---------------------------------------------------------------------------
# Gallery HTML
# ---------------------------------------------------------------------------

def build_gallery(docs: list[str], preview_dir: str) -> None:
    global _last_updated

    pages: dict[str, list[str]] = {}
    for f in glob.glob(os.path.join(preview_dir, "*.png")):
        base = os.path.basename(f)
        doc = base.rsplit("-", 1)[0]
        if doc in docs:
            pages.setdefault(doc, []).append(base)

    for pngs in pages.values():
        pngs.sort(key=lambda n: int(n.rsplit("-", 1)[-1].split(".")[0]))

    with _lock:
        ts = int(time.time() * 1000)
        _last_updated = ts

    rows = ""
    for doc in docs:          # preserve document order
        if doc not in pages:
            continue
        rows += f"<h2>{doc}.pdf</h2><div class='row'>"
        for png in pages[doc]:
            num = png.rsplit("-", 1)[-1].split(".")[0]
            rows += f"<div class='page'><img src='{png}'><p>p{num}</p></div>"
        rows += "</div>"

    html = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>CV Preview</title>
<style>
  body {{background:#444;margin:0;padding:16px;font-family:sans-serif}}
  h2   {{color:#fff;margin:16px 0 8px}}
  .row {{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:8px}}
  .page img {{height:600px;box-shadow:0 2px 8px rgba(0,0,0,.6);display:block}}
  .page p {{color:#ccc;margin:4px 0 0;font-size:12px;text-align:center}}
</style>
<script>
  let ts = {ts};
  setInterval(async () => {{
    try {{
      const t = await (await fetch('/last-updated')).json();
      if (t > ts) {{ ts = t; location.reload(); }}
    }} catch (_) {{}}
  }}, 2000);
</script>
</head>
<body>
{rows}
</body>
</html>"""

    with open(os.path.join(preview_dir, "index.html"), "w") as fh:
        fh.write(html)


# ---------------------------------------------------------------------------
# HTTP server
# ---------------------------------------------------------------------------

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self) -> None:
        if self.path == "/last-updated":
            with _lock:
                body = json.dumps(_last_updated).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        else:
            super().do_GET()

    def log_message(self, *_) -> None:
        pass


# ---------------------------------------------------------------------------
# File watcher
# ---------------------------------------------------------------------------

def _watched_paths(docs: list[str], root: str) -> list[str]:
    return (
        [os.path.join(root, "src", f"{d}.typ") for d in docs]
        + glob.glob(os.path.join(root, "src", "template", "*.typ"))
        + glob.glob(os.path.join(root, "src", "lib", "*.typ"))
        + [os.path.join(root, "data", "resume.json")]
    )


def watch_loop(docs: list[str], root: str, preview_dir: str) -> None:
    paths = _watched_paths(docs, root)
    mtimes = {p: os.path.getmtime(p) for p in paths if os.path.exists(p)}

    while True:
        time.sleep(2)
        changed: set[str] = set()

        for path in _watched_paths(docs, root):
            if not os.path.exists(path):
                continue
            m = os.path.getmtime(path)
            if mtimes.get(path) != m:
                mtimes[path] = m
                base = os.path.basename(path)
                if any(seg in path for seg in ("template", "lib")) or base == "resume.json":
                    changed.update(docs)
                else:
                    for d in docs:
                        if base == f"{d}.typ":
                            changed.add(d)

        if changed:
            print(f"  ↻  {', '.join(sorted(changed))}", flush=True)
            for d in sorted(changed):
                compile_doc(d, root, preview_dir)
            build_gallery(docs, preview_dir)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="CV preview server")
    parser.add_argument(
        "--file", default="all",
        help="Document to preview: cv | cv-eu | resume | resume-onepage | all (default)",
    )
    parser.add_argument("--watch", action="store_true", help="Watch sources and auto-recompile")
    parser.add_argument("--no-open", action="store_true", help="Don't open browser")
    args = parser.parse_args()

    docs = ALL_DOCS if args.file == "all" else [args.file]
    root = os.path.abspath(".")
    preview_dir = os.path.join(root, "out", "preview")
    os.makedirs(preview_dir, exist_ok=True)

    print("Compiling...")
    compile_all(docs, root, preview_dir)
    build_gallery(docs, preview_dir)

    if args.watch:
        threading.Thread(
            target=watch_loop, args=(docs, root, preview_dir), daemon=True
        ).start()

    os.chdir(preview_dir)
    server = http.server.HTTPServer(("", PORT), Handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()

    url = f"http://localhost:{PORT}"
    mode = "watching + serving" if args.watch else "serving"
    print(f"{mode.capitalize()} → {url}  (Ctrl-C to stop)")
    if not args.no_open:
        webbrowser.open(url)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nStopped.")


if __name__ == "__main__":
    main()
