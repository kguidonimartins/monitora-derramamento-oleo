echo 'Updating data' 
Rscript -e "source('R/00_get_and_clean_data.R')" 
echo 'Building site'
Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"
