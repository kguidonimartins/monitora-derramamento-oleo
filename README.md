# monitora-derramamento-oleo

[![Build Status](https://travis-ci.com/kguidonimartins/monitora-derramamento-oleo.svg?branch=master)](https://travis-ci.com/kguidonimartins/monitora-derramamento-oleo)

Scripts para coleta, limpeza e visualização dos dados sobre derramamento de óleo nas praias brasileiras usando os dados publicados regularmente pelo [IBAMA](http://www.ibama.gov.br/manchasdeoleo-localidades-atingidas).

Veja o relatório online [aqui](https://kguidonimartins.github.io/monitora-derramamento-oleo/index.html)!

## Reprodução do relatório

Para reproduzir este relatório você precisará de instalar os programas [R](https://www.r-project.org/) e [RStudio](https://rstudio.com/).

### Usando o terminal

Pelo terminal, você pode executar:

```bash
git clone https://github.com/kguidonimartins/monitora-derramamento-oleo.git
cd monitora-derramamento-oleo
Rscript run_all.R
```

### Usando o RStudio

Para reproduzir este relatório pelo RStudio, você precisará seguir os seguintes passos:

1. Clone este repositório;

2. Acesse a pasta `monitora-derramamento-oleo`;

3. Abra o arquivo `monitora-derramamento-oleo.Rproj`;

4. Execute o arquivo `run_all.R`.
