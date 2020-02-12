# Script para manipulação de dados em bases relacionais ---#
# parte do curso Projetos de análise de dados em R
# dados originais extraídos de Jeliazkov et al 2020 Sci Data
# (https://doi.org/10.1038/s41597-019-0344-7)
# primeira versão em 2020-02-12
#-----------------------------------------------------------#


# Carregando os pacotes necessários ####
library("tidyr")

# Lendo os dados no R ####
files.path <- list.files(path = "data/cestes",
                         pattern = ".csv",
                         full.names = TRUE)

files.path

## opçao automatizada ####
data <- list()

for (i in 1:length(files.path)) {
  data[[i]] <- read.csv(files.path[1])
}

head(data[[1]])

## opçao manual ####
comm <- read.csv(files.path[1])
coord <- read.csv(files.path[2])
envir <- read.csv(files.path[3])
splist <- read.csv(files.path[4])
traits <- read.csv(files.path[5])

# Entendendo os objetos  ####

## comm ####
head(comm)
dim(comm)
summary(comm)

## cord ####
head(coord)
dim(coord)
summary(coord)

## envir ####
head(envir)
dim(envir)
summary(envir)

## splist ####
head(splist)
dim(splist)
summary(splist)

## traits ####
head(traits)
dim(traits)
summary(traits)

# Sumário dos dados ####

# temos dados de quantas espécies? Podemos simplesmente contar o número de linhas do objeto splist.
nrow(splist)

# quantas áreas amostradas? Podemos contar o número de linhas dos objetos comm ou envir.
nrow(comm)
nrow(envir)

# quantas variáveis ambientais?
# todas as variáveis exceto a primeira coluna com o id
names(envir)[-1]

# contando quantas variáveis
length(names(envir)[-1])

# qual a riqueza de cada área? Primeiro, precisamos transformar a nossa matriz que possui dados de abundância em uma matriz de presença e ausência.
comm.pa <- comm[, -1] > 0
head(comm.pa)

# vamos nomear as linhas das planilhas com o id dos sites
head(envir)
row.names(comm.pa) <- envir$Sites
head(comm.pa)

# no R, os valores de TRUE e FALSE contam como 1 e 0. Vamos calcular a riqueza da área 1, por exemplo, somando a primeira linha do novo objeto comm.pa.
sum(comm.pa[1, ])

# como podemos fazer a soma de forma automatizada para as 97 áreas? Podemos usar a função apply. Essa função aplica uma função às linhas ou colunas de um objeto (do tipo data.frame ou matrix).
rich <- apply(X = comm.pa, MARGIN = 1, FUN = sum)
summary(rich)

# quantas áreas tem riqueza igual a sum?
sum(rich == 1)

# qual área é?
which(rich == 1)

# quais caracteristicas desse site?
envir.coord[which(rich == 1), ]

# Juntando tabelas ####
envir$Sites

summary(envir$Sites)

## transformando tipos de variáveis ####

# se checarmos a classe desse vetor, veremos que é numerica
class(envir$Sites)

# queremos que seja uma variável categórica. Para isso, convertemos em fator
as.factor(envir$Sites)

# se usarmos apenas as.factor, não fazemos a conversão, vamos então fazer uma atribuição
envir$Sites <- as.factor(envir$Sites)

# vamos fazer o mesmo para a variável Sites do objeto coord.
coord$Sites <- as.factor(coord$Sites)

## Juntando coord e envir ####

envir.coord <- merge(x = envir,
                     y = coord,
                     by = "Sites")

# vamos checar o cabeçalho e as dimensões do objeto.
dim(envir)
dim(coord)
dim(envir.coord)
head(envir.coord)

## Transformando uma matrix espécie vs. área ####
# vetor contendo todos os Sites
Sites <- envir$Sites
length(Sites)

# vetor número de espécies
n.sp <- nrow(splist)
n.sp

# criando tabela com cada especie em cada area especies em linhas
comm.df <- tidyr::gather(comm[, -1])

# vamos checar o cabeçalho e as dimensões do objeto.
dim(comm.df)
head(comm.df)

# queremos alterar o nome das colunas de comm.df. Para isso, usaremos a função colnames().

# nomes atuais
colnames(comm.df)
# modificando os nomes das colunas
colnames(comm.df) <-  c("TaxCode", "Abundance")
# checando os novos nomes
colnames(comm.df)

#Queremos agora adicionar a coluna Sites ao novo objeto. Vamos usar a função rep(). Esta função cria sequências. Vamos criar uma sequência de localidades, em que cada uma das 97 localidades se repete 56 vezes. A sequência deve ter também 5432 elementos.

# primeiro criamos a sequência
seq.site <- rep(Sites, times = n.sp)
#each - repete cada elemento em Sites o numero de vezes de n.sp
#times - repete todos os elementos em Sites o numero de vezes de n.sp
# checando a dimensão
length(seq.site)
# adicionando ao objeto comm.df
comm.df$Sites <- seq.site
# checando como ficou
head(comm.df)

# Juntando todas as variáveis à comm.df ####

## tabela comm.df e splist ####
#Primeiro, vamos adicionar as informações das espécies contidas em splist à comm.df usando a coluna TaxCode.
comm.sp <- merge(comm.df, splist, by = "TaxCode")
head(comm.sp)

## tabela comm.sp e traits ####
#Segundo, adicionamos os dados de atributos das espécies à tabela de comunidade. Na tabela traits, a coluna que identifica as espécies é chamada Sp. Antes de fazer a junção, precisamos mudar o nome para bater com o nome da coluna em comm.sp que é TaxCode.
names(traits)

# renomeando o primeiro elemento
colnames(traits)[1] <- "TaxCode"

# juntantos das tabelas
comm.traits <- merge(comm.sp, traits, by = "TaxCode")
head(comm.traits)

## tabela comm.traits e envir.coord ####
#Finalmente, juntamos as variáveis ambientais (que aqui já contém as coordenadas) à tabela geral da comunidade por meio da coluna Sites.

comm.total <- merge(comm.traits, envir.coord, by = "Sites")
head(comm.total)
names(comm.total)

# Exportando as planilhas ####
write.csv(x = comm.total,
          file = "data/01_data_format_combined.csv",
          row.names = FALSE)

