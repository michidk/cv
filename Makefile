FILE := main
OUT  := out

.PHONY: pdf
pdf:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -xelatex -halt-on-error $(FILE)

.PHONY: watch
watch:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -xelatex -pvc -halt-on-error $(FILE)

.PHONY: clean
clean:
	rm -rf $(filter-out $(OUT)/$(FILE).pdf, $(wildcard $(OUT)/*))

.PHONY: purge
purge:
	rm -rf $(OUT)