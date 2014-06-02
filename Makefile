.SECONDARY:

PRINCIPLES := $(wildcard principles/*.md)

POSTERS_DIR=posters
POSTER_TEMPLATE=templates/poster.html
POSTERS_HTMLS := $(patsubst principles/%.md,$(POSTERS_DIR)/%.html,$(PRINCIPLES))
POSTERS_PDFS := $(POSTERS_HTMLS:.html=.pdf)
POSTERS_PNGS := $(POSTERS_PDFS:.pdf=.png)

all:	$(POSTERS_DIR)/posters.pdf $(POSTERS_PNGS)

init::
	@type  node >/dev/null 2>&1 || { echo >&2 "node command not found"; exit 1; }
	@type  npm >/dev/null 2>&1 || { echo >&2 "npm command not found"; exit 1; }
	@type  wkhtmltopdf >/dev/null 2>&1 || { echo >&2 "wkhtmltopdf command not found"; exit 1; }
	@type gs >/dev/null 2>&1 || { echo >&2 "ghostscript gs command not found"; exit 1; }

	npm install
	@type  pagemaker >/dev/null 2>&1 || { echo >&2 "pagemaker command not found"; exit 1; }


clean::
	rm -rf $(POSTERS_DIR)

#
#  posters
#
$(POSTERS_DIR)/posters.pdf: $(POSTERS_PDFS)
	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$@ $(POSTERS_PDFS)

$(POSTERS_DIR)/%.html:	principles/%.md
	@mkdir -p $(POSTERS_DIR)
	pagemaker convert -t $(POSTER_TEMPLATE) -i $< > $@

# make PDF from HTML
%.pdf:	%.html
	wkhtmltopdf -q $< $@

# make PNG from PDF
%.png:	%.pdf
	gs -q -dNOPAUSE -dBATCH -sDEVICE=pngalpha -r300 -sOutputFile=$@ $<
