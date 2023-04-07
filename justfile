root_dir := "./"
font_dir := "fonts/"
out_dir := "out/"
src_dir := "src/"

build file="cv":
  mkdir -p out/; typst compile --font-path {{font_dir}} --root {{root_dir}} {{src_dir}}{{file}}.typ {{out_dir}}{{file}}.pdf

watch file="cv":
  mkdir -p out/; typst watch --font-path {{font_dir}} --root {{root_dir}} {{src_dir}}{{file}}.typ {{out_dir}}{{file}}.pdf
