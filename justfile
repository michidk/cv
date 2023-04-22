font_dir := "fonts/"

watch file="src/cv":
  typst --font-path {{font_dir}} watch {{file}}.typ {{file}}.pdf

# default: all

# build file outdir="out":
#   latexmk -interaction=nonstopmode -file-line-error -outdir={{outdir}} -xelatex {{file}}.tex

# cv: (build "cv")
# cv-eu: (build "cv-eu")
# resume: (build "resume")
# resume-onepage: (build "resume-onepage")

# all: cv cv-eu resume resume-onepage

# clean:
#   rm -rf out
#   # git clean -Xdf
