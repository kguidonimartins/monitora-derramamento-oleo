all: get-data build-site

get-data:
	Rscript -e "source('R/00_get_and_clean_data.R')" 

build-site:
	Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"