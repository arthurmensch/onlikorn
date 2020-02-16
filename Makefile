LATEX=pdflatex -synctex=1
LATEXOPT=--shell-escape
NONSTOP=--interaction=nonstopmode

LATEXMK=latexmk
LATEXMKOPT=-pdf -view=none
CONTINUOUS=-pvc

MAIN=article

FIGURES := $(shell find figures -type f)
TEX := $(shell find . -name "*.tex")
BIB=biblio.bib

SOURCES=$(FIGURES) $(BIB) $(TEX)

all: article.pdf

$(MAIN).pdf $(MAIN).bcf: $(MAIN).tex $(SOURCES) figures
	$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

$(MAIN)_embed.pdf: $(MAIN).pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite \
	-sOutputFile=$(MAIN)_embed.pdf $(MAIN).pdf
	
clean:
	$(LATEXMK) -C $(MAIN)
	rm -f $(MAIN).pdfsync
	rm -rf *~ *.tmp
	rm -f *.bbl *.blg *.aux *.end *.fls *.log *.out \
	*.fdb_latexmk *.synctex.gz *.synctex.gz\(busy\) *.lol *.xml
	rm -f $(MAIN)-blx.bib
	rm -f $(MAIN)_embed.pdf
	rm -rf hal hal.zip
	rm -rf *.ptc
	rm -rf supp.zip
	rm -rf paper.pdf
	rm -rf supp/supp.pdf
	rm -rf paper_.pdf
	rm -rf code.zip

extracted.bib: $(MAIN).pdf
	biber -g tools/biber.conf --output-format=bibtex $(MAIN).bcf -O $@

hal.zip:
	bash tools/make_hal.sh

paper.pdf supp/supp.pdf: $(MAIN).pdf
	pdftk $(MAIN).pdf cat 1-10 output main.pdf
	pdftk $(MAIN).pdf cat 11-end output supp/supp.pdf

watch: $(MAIN).tex $(SOURCES)
	$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

split: paper.pdf supp/supp.pdf

supp.zip: supp/supp.pdf
	cd supp && zip -r -D ../supp.zip *

count: 
	texcount $(MAIN).tex

.PHONY: all clean watch count split
