# (1) Formatação de dados

## Padronização

Os dados da planilha "ex04.xlsx" foram formatados da seguinte maneira:

- junção de todas as abas em uma única tabela por meio de criação de uma coluna adicional species;
- remoção da unidade de algumas células;
- remoção de formatações de estilo (e.g. negrito, itálico, linhas);
- padronização dos nomes das colunas.

## Tabela formatada
A tabela formatada está salva no arquivo "dados_formatados.xlsx" e "dados_formatados.csv". Os dados brutos estão mantidos na panilha original como "dados_brutos.xlsx".

### Informações da tabela:

- unidade de medida: cm;
- species: apenas o epiteto específico das espécies de Iris;
- sep.length: comprimento da sépala;
- sep.width: largura da sépala;
- petal.length: comprimento da pétala;
- petal.width: largura da sépala.

# (2) Explorando os dados cestes

A partir das planilhas originais "comm", "coord", "envir", "splist" and "traits", formatamos e transformamos os dados para gerar uma nova planilha "01_data format_combined" que contem além das colunas já existentes nas panilhas originais, uma coluna com a abundância dos sites. Essa tabela foi gerada a partir do script "01_cestes_data_manipulation"
