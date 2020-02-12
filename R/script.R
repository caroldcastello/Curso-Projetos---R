## script para ler a tabela limpa do exercício
## os dados originais estão em "dados_brutos.xlsx"


# read.csv2 reconhece que o separador de colunas é ; e separador de casas decimais é ,
data_format <- read.csv2("./data/dados_formatados.csv")
head(data_format)
