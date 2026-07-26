root_dir := "./"
font_dir := "fonts/"
out_dir := "out/"
src_dir := "src/"

default: build-all

build file="cv":
  mkdir -p out/; typst compile --font-path {{font_dir}} --root {{root_dir}} {{src_dir}}{{file}}.typ {{out_dir}}{{file}}.pdf

build-all:
  @just build "cv"
  @just build "cv-eu"
  @just build "resume"
  @just build "resume-onepage"

watch file="cv":
  mkdir -p out/; typst watch --font-path {{font_dir}} --root {{root_dir}} {{src_dir}}{{file}}.typ {{out_dir}}{{file}}.pdf

preview file="all":
  mkdir -p out/preview/
  tmux kill-session -t cv-preview 2>/dev/null; tmux new-session -d -s cv-preview
  tmux send-keys -t cv-preview "cd '{{justfile_directory()}}' && python3 scripts/preview.py --file {{file}} --watch" Enter
  @echo "Preview at http://localhost:7777"
  @echo "Attach:  tmux attach -t cv-preview"
