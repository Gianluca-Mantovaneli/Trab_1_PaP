% Definindo a fonte de dados da DBpedia para livros
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


% Definindo os fatos para livros
livros(Titulo, Autor, Pais, Paginas, Genero, DataLancamento, Linguagem) :- 
    dbpedia_livros{titulo: Titulo, autor: Autor, pais: Pais, paginas: Paginas, genero: Genero, dataLancamento: DataLancamento, linguagem: Linguagem}.

% Predicado para verificar se um livro é longo (mais de 300 páginas)
livro_longo(Titulo) :- 
    livros(Titulo, _, _, Paginas, _, _, _),
    (atom(Paginas) -> atom_number(Paginas, NumPaginas); NumPaginas = Paginas),  % Converte se for átomo
    NumPaginas > 300,
    format('~w é longo (~d páginas).~n', [Titulo, NumPaginas]).

% Exibindo a data de lançamento de um determinado livro
exibir_ano_lancamento(Titulo) :- 
    livros(Titulo, _, _, _, _, DataLancamento, _),
    (DataLancamento = date(Ano, _, _) -> true; Ano = DataLancamento),
    format('~w foi lançado em ~w.~n', [Titulo, Ano]).

% Predicado para verificar se um livro é antigo (lançado antes de 1960)
livro_antigo(Titulo) :- 
    livros(Titulo, _, _, _, _, DataLancamento, _),
    (DataLancamento = date(Ano, _, _) -> Ano = DataLancamento; Ano = DataLancamento),
    Ano < 1960,
    format('~w é um livro antigo.~n', [Titulo]).


% Predicado para listar livros de um determinado autor
livros_autor(Autor, Livros) :- 
    findall(Titulo, (
        dbpedia_livros{titulo: Titulo, autor: Autor, paginas: _, genero: _, dataLancamento: _, linguagem: _}
    ), Livros).

% Predicado para listar livros de um determinado país
livros_pais(Pais, Livros) :- 
    findall(Titulo, livros(Titulo, _, Pais, _, _, _, _), Livros).

% Predicado para verificar se dois livros têm o mesmo idioma
mesmo_idioma(Titulo1, Titulo2) :- 
    livros(Titulo1, _, _, _, _, _, Lingua1),
    livros(Titulo2, _, _, _, _, _, Lingua2),
    Lingua1 = Lingua2,
    Titulo1 \= Titulo2,
    format('~w e ~w têm o mesmo idioma.~n', [Titulo1, Titulo2]).

% Predicado para listar livros por gênero
livros_genero(Genero, Livros) :- 
    findall(Titulo, livros(Titulo, _, _, _, Genero, _, _), Livros).

% Predicado para verificar se dois livros foram lançados no mesmo ano
mesmo_ano(Titulo1, Titulo2) :- 
    livros(Titulo1, _, _, _, _, Ano1, _),
    livros(Titulo2, _, _, _, _, Ano2, _),
    Ano1 = Ano2,
    Titulo1 \= Titulo2,
    format('~w e ~w foram lançados no mesmo ano.~n', [Titulo1, Titulo2]).

% Predicado para listar livros com mais de um certo número de páginas
livros_com_mais_paginas(Num, Livros) :- 
    findall((Titulo, NumPaginas), (
        livros(Titulo, _, _, Paginas, _, _, _),
        (atom(Paginas) -> atom_number(Paginas, NumPaginas); NumPaginas = Paginas), % Converte somente se for átomo
        NumPaginas > Num
    ), Livros).

% Consultas -------------------------------------------------------------------------------------------
% 
% Listando livros da consulta
% livros(Titulo, Autor, Pais, Paginas, Genero, DataLancamento, Linguagem).
% 
% Verifica se o livro é muito longo (mais de 300 pag)
% livro_longo("Before Mars (novel)").
% 
% Verifica se o livro é mais antigo do que 1960
% livro_antigo("Beezus and Ramona").
% 
% Verifica todos livros encontrados que foram escritos pelo Stephen_King
% livros_autor('http://dbpedia.org/resource/Stephen_King', Livros).
% 
% Encontra todos os livros que são do genero 'Fantasy_fiction'
% livros_genero('http://dbpedia.org/resource/Fantasy_fiction',Livros).
% 
% Verifica se dois livros são do mesmo ano
% mesmo_ano("Moo (novel)","Monsters (collection)").
% 
% Listando livros com mais que 400 paginas
% livros_com_mais_paginas(400, Livros).
