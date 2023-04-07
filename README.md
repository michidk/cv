# Curriculum Vitae

My personal résumé and curriculum vitae.

## Download

A `.pdf` build of the most recent version can be found on [my website](https://lohr.dev/cv/).

## Prerequisites

Uses [typst](https://github.com/typst/typst) to build the `.pdf`-files.

To use the `just` command runner, install [just](https://github.com/casey/just/).

## Building

To build the .pdf-files, execute:
`just all`, `just build <file>` or `just <variant>` (as listed below).

Alternatively, execute the commands from the `justfile` manually (see `just -l`).

## Variants

The following resume variants are available:

| Variant           | File                 | Command               | Explanation                 |
| ----------------- | -------------------- | --------------------- | --------------------------- |
| Curriculum Vitae  | `cv.typ`             | `just cv`             | My whole career path        |
| CV (EU Version)   | `cv-eu.typ`          | `just cv-eu`          | My CV including a mugshot   |
| Résumé            | `resume.typ`         | `just resume`         | A two page summary of my CV |
| Résumé (One Page) | `resume-onepage.typ` | `just resume-onepage` | A one page summary of my CV |
