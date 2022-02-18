# Curriculum Vitae

![Build LaTeX](https://github.com/michidk/resume/workflows/Build%20LaTeX%20document/badge.svg)

My personal résumé and curriculum vitae.

## Download

A `.pdf` build of the most recent version can be found on [my website](https://lohr.dev/cv/).

## Prerequisites

Dependencies are latexmk, texlive, tlmgr and the packages listed in `install-deps.sh` (or alternatively texlive-full).

To use the `just` command, install [just](https://github.com/casey/just/).

## Building

To build the .pdf-files, execute:
`just all`, `just build <file>` or `just <variant>` (as listed below).
Alternivley execute the commands from the `justfile` manually.

## Variants

The following resume variants are available:

| Variant           | File                 | Command               | Explanation                 |
| ----------------- | -------------------- | --------------------- | --------------------------- |
| Curriculum Vitae  | `cv.tex`             | `just cv`             | My whole career path        |
| CV (EU Version)   | `cv-eu.tex`          | `just cv-eu`          | My CV including a mugshot   |
| Résumé            | `resume.tex`         | `just resume`         | A two page summary of my CV |
| Résumé (One Page) | `resume-onepage.tex` | `just resume-onepage` | A one page summary of my CV |
