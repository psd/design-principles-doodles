.SECONDARY:

PRINCIPLES := $(wildcard principles/*.md)

POSTERS_DIR=posters
POSTER_TEMPLATE=templates/poster.html
POSTERS_HTMLS := $(patsubst principles/%.md,$(POSTERS_DIR)/%.html,$(PRINCIPLES))
POSTERS_PDFS := $(POSTERS_HTMLS:.html=.pdf)

all:	$(POSTERS_DIR)/posters.pdf

clean::
	rm -rf $(POSTERS_DIR) $(SLIDES_DIR) $(BOOKLET_DIR)

$(POSTERS_DIR)/posters.pdf: $(POSTERS_PDFS)
	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$@ $(POSTERS_PDFS)

# make poster HTML page from markdown
$(POSTERS_DIR)/%.html:	principles/%.md
	@mkdir -p $(POSTERS_DIR)
	pagemaker convert -t $(POSTER_TEMPLATE) -i $< > $@

# make PDF from HTML
%.pdf:	%.html
	wkhtmltopdf -q $< $@
