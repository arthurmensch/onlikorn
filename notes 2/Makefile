LATEX=pdflatex -synctex=1
LATEXOPT=--shell-escape
NONSTOP=--interaction=nonstopmode

LATEXMK=latexmk
LATEXMKOPT=-pdf -view=none
CONTINUOUS=-pvc

MAIN=notes

BIB=biblio.bib

SOURCES=$(MAIN).tex commands.tex $(BIB)

all: $(MAIN).pdf

$(MAIN).pdf $(MAIN).bcf: $(MAIN).tex $(SOURCES)
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

extracted.bib: $(MAIN).pdf
	biber -g tools/biber.conf --output-format=bibtex $(MAIN).bcf -O $@

hal.zip:
	bash tools/make_hal.sh

$(MAIN)_main.pdf $(MAIN)_supp.pdf: $(MAIN)_embed.pdf
	pdftk $(MAIN)_embed.pdf cat 1-10 output $(MAIN)_main.pdf
	pdftk $(MAIN)_embed.pdf cat 11-end output $(MAIN)_supp.pdf

watch: $(MAIN).tex $(SOURCES)
	$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

count: 
	texcount $(MAIN).tex

.PHONY: all clean watch count
