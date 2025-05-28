TARGET=main
OUTDIR=build

all:
	latexmk -pdf -output-directory=$(OUTDIR) $(TARGET).tex

clean:
	latexmk -C -output-directory=$(OUTDIR)

.PHONY: all clean

