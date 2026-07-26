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

preview:
  mkdir -p out/preview/
  typst compile --font-path {{font_dir}} --root {{root_dir}} --format png --ppi 150 {{src_dir}}cv.typ out/preview/cv-{n}.png
  typst compile --font-path {{font_dir}} --root {{root_dir}} --format png --ppi 150 {{src_dir}}cv-eu.typ out/preview/cv-eu-{n}.png
  typst compile --font-path {{font_dir}} --root {{root_dir}} --format png --ppi 150 {{src_dir}}resume.typ out/preview/resume-{n}.png
  typst compile --font-path {{font_dir}} --root {{root_dir}} --format png --ppi 150 {{src_dir}}resume-onepage.typ out/preview/resume-onepage-{n}.png
  python3 scripts/preview.py
