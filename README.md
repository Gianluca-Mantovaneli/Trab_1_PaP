# DBpedia Books Query System

Este repositório contém um sistema para consultar e manipular informações sobre livros usando a DBpedia como fonte de dados. O sistema foi desenvolvido utilizando Prolog e permite diversas consultas, como verificar a quantidade de páginas de um livro, listar livros por autor ou gênero, e identificar livros antigos ou longos.

## Funcionalidades

- **Consulta de livros**: Acesso a informações sobre títulos, autores, países, número de páginas, gênero, data de lançamento e linguagem.
- **Verificação de características**:
  - Identificar se um livro é longo (mais de 300 páginas).
  - Verificar se um livro é antigo (lançado antes de 1960).
- **Listagens**:
  - Listar livros de um autor específico.
  - Listar livros de um determinado país.
  - Listar livros de um gênero específico.
  - Listar livros com um número mínimo de páginas.
- **Comparações**:
  - Verificar se dois livros têm o mesmo idioma.
  - Verificar se dois livros foram lançados no mesmo ano.

## Estrutura do Código

O código principal está organizado em predicados que realizam consultas à DBpedia e processam os resultados:

```prolog
:- data_source(dbpedia_livros,
    sparql("PREFIX db: <http://dbpedia.org/>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX dbo: <http://dbpedia.org/ontology/>
            PREFIX dbp: <http://dbpedia.org/property/>
            PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

            SELECT DISTINCT ?titulo ?autor ?pais ?paginas ?genero ?dataLancamento ?linguagem
            WHERE {
                ?s rdf:type dbo:Book ;
                   rdfs:label ?titulo ;
                   dbo:author ?autor ;
                   dbp:country ?pais ;
                   dbo:numberOfPages ?paginas ;
                   dbo:literaryGenre ?genero ;
                   dbp:releaseDate ?dataLancamento ;
                   dbp:language ?linguagem .
            } LIMIT 1000",
            [ endpoint('http://dbpedia.org/sparql')]) ).
```

## Como Usar

1. **Clone o repositório**:

   ```bash
   git clone https://github.com/seu_usuario/dbpedia_books_query_system.git
   cd dbpedia_books_query_system
   ```

2. **Instale o SWI-Prolog**: O sistema foi desenvolvido com SWI-Prolog. Certifique-se de ter o SWI-Prolog instalado em sua máquina.

3. **Carregue o arquivo em Prolog**:
   Abra o SWI-Prolog e carregue o arquivo de código-fonte.

   ```prolog
   ?- [seu_arquivo].
   ```

4. **Realize consultas**: Você pode agora fazer consultas usando os predicados disponíveis. Exemplos de consultas estão listados no final do arquivo de código.

## Exemplos de Consultas

- **Verificar se um livro é longo**:
  ```prolog
  ?- livro_longo("Nome do livro").
  ```

- **Listar livros de um autor**:
  ```prolog
  ?- livros_autor('genero do livro', Livros).
  ```

- **Listar livros com mais de 400 páginas**:
  ```prolog
  ?- livros_com_mais_paginas(numero de paginas, Livros).
  ```

## Contribuições

Contribuições são bem-vindas! Se você encontrar um bug ou tiver sugestões para melhorias, sinta-se à vontade para abrir uma issue ou enviar um pull request.

## Licença

Este projeto está licenciado sob a MIT License. Veja o arquivo `LICENSE` para mais detalhes.
