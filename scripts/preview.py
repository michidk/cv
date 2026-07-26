#!/usr/bin/env python3
"""Generate a local gallery of all CV documents as PNG pages and serve it."""

import glob
import http.server
import os
import threading
import webbrowser

PREVIEW_DIR = "out/preview"
PORT = 7777
DOCS = ["cv", "cv-eu", "resume", "resume-onepage"]


def build_gallery_html(pages: dict[str, list[str]]) -> str:
    items = ""
    for doc, pngs in pages.items():
        items += f"<h2>{doc}.pdf</h2><div class='row'>"
        for png in pngs:
            page_num = png.split("-")[-1].split(".")[0]
            items += f"<div class='page'><img src='{png}'><p>p{page_num}</p></div>"
        items += "</div>"

    return f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>CV Preview</title>
<style>
  body {{ background: #444; margin: 0; padding: 16px; font-family: sans-serif; }}
  h2   {{ color: #fff; margin: 16px 0 8px; }}
  .row {{ display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 8px; }}
  .page {{ text-align: center; }}
  .page img {{ height: 600px; box-shadow: 0 2px 8px rgba(0,0,0,.6); }}
  .page p {{ color: #ccc; margin: 4px 0 0; font-size: 12px; }}
</style>
</head>
<body>
{items}
</body>
</html>"""


def main() -> None:
    os.makedirs(PREVIEW_DIR, exist_ok=True)

    pages: dict[str, list[str]] = {}
    for f in sorted(glob.glob(f"{PREVIEW_DIR}/*.png")):
        base = os.path.basename(f)
        # e.g. "cv-eu-2.png" → doc key "cv-eu"
        parts = base.rsplit("-", 1)
        doc = parts[0]
        pages.setdefault(doc, []).append(base)

    # Sort pages within each doc numerically
    for doc in pages:
        pages[doc].sort(key=lambda f: int(f.rsplit("-", 1)[-1].split(".")[0]))

    html = build_gallery_html(pages)
    index_path = os.path.join(PREVIEW_DIR, "index.html")
    with open(index_path, "w") as f:
        f.write(html)

    os.chdir(PREVIEW_DIR)
    handler = http.server.SimpleHTTPRequestHandler
    handler.log_message = lambda *_: None  # silence request logs
    server = http.server.HTTPServer(("", PORT), handler)

    t = threading.Thread(target=server.serve_forever)
    t.daemon = True
    t.start()

    url = f"http://localhost:{PORT}"
    print(f"Preview → {url}  (Ctrl-C to stop)")
    webbrowser.open(url)

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")


if __name__ == "__main__":
    main()
