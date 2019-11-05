# scrape_derramamento_de_oleo_br

Scripts para coleta, limpeza e visualização dos dados sobre derramamento de óleo na praias brasileiras.

Veja [aqui](https://kguidonimartins.github.io/scrape_derramamento_de_oleo_br/)!

## Estrutura

```
├── R
│   ├── 00_get_and_clean_data.R                 # script de coleta e limpeza dos dados
│   └── 01_data-viz.R                           # script para visualização
├── README.md
├── data-clean
│   └── 2019-11-03_LOCALIDADES_AFETADAS.csv     # dados limpos
├── data-raw
│   └── 2019-11-03_LOCALIDADES_AFETADAS.xlsx    # dados originais
├── index.Rmd                                   # script que gera o relatório
├── index.html                                  # relatório renderizado
├── run_all.R                                   # script que automatiza coleta e relatório
├── scrape_derramamento_de_oleo_br.Rproj
└── style
    ├── header.html                             # customização do relatório
    └── style.css                               # customização do relatório
```

## Reprodução do relatório

Para reproduzir este relatório você precisará de instalar o programa R (a IDE RStudio também é recomendada). Clone este repositório, abra o `arquivo scrape_derramamento_de_oleo_br.Rproj` e execute o arquivo `run_all.R`. Pelo terminal, você pode executar:

```bash
git clone https://github.com/kguidonimartins/scrape_derramamento_de_oleo_br.git
cd scrape_derramamento_de_oleo_br
Rscript run_all.R
```
