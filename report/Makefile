MASTER = psc-gene_sex_interactions

all: $(MASTER).pdf

final: all
	cp $(MASTER).pdf pdf/`echo $(MASTER) | sed -e "s/-main//"`-`date +"%Y_%m_%d"`.pdf

$(MASTER).tex: $(MASTER).Rnw rnw/*.Rnw Makefile *.bib
	echo "library(knitr); knit('$<')" | R --no-save

$(MASTER).pdf: $(MASTER).tex
	latexmk -pdf "$<"

clean:
	rm -f  $(MASTER).{tex,log,out,pdf,toc,aux,fls,fdb_latexmk}  *~ */*~ cache/* img/knitr/*
