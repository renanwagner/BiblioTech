USE BiblioTechDB;

-- Consulta 1: Listar todos os livros físicos disponíveis, com seus autores e categorias.
SELECT
    ia.titulo AS TituloLivro,
    a.nome_autor AS Autor,
    c.nome_categoria AS Categoria,
    lf.isbn AS ISBN,
    e.numero_exemplar AS NumeroExemplar,
    l.andar AS Andar,
    l.estante AS Estante,
    l.prateleira AS Prateleira
FROM ITEM_ACERVO ia
JOIN LIVRO_FISICO lf ON ia.id_item = lf.id_item
JOIN EXEMPLAR e ON lf.id_livro_fisico = e.id_livro_fisico
JOIN LOCALIZACAO l ON e.id_localizacao = l.id_localizacao
JOIN ITEM_AUTOR iau ON ia.id_item = iau.id_item
JOIN AUTOR a ON iau.id_autor = a.id_autor
JOIN CATEGORIA c ON ia.id_categoria = c.id_categoria
WHERE e.status_exemplar = 'DISPONIVEL'
ORDER BY ia.titulo, a.nome_autor;

-- Consulta 2: Mostrar os usuários com multas pendentes, incluindo o valor da multa e o título do livro.
SELECT
    u.nome AS NomeUsuario,
    u.email AS EmailUsuario,
    m.valor_multa AS ValorMulta,
    ia.titulo AS TituloLivroAtrasado,
    em.data_retirada AS DataRetirada,
    em.data_devolucao_prevista AS DevolucaoPrevista
FROM USUARIO u
JOIN EMPRESTIMO em ON u.id_usuario = em.id_usuario
JOIN MULTA m ON em.id_emprestimo = m.id_emprestimo
JOIN EXEMPLAR ex ON em.id_exemplar = ex.id_exemplar
JOIN LIVRO_FISICO lf ON ex.id_livro_fisico = lf.id_livro_fisico
JOIN ITEM_ACERVO ia ON lf.id_item = ia.id_item
WHERE m.status_multa = 'PENDENTE'
ORDER BY u.nome, m.data_geracao DESC;

-- Consulta 3: Listar os 5 itens do acervo mais reservados, com o número total de reservas.
SELECT
    ia.titulo AS TituloItem,
    ia.tipo_item AS TipoItem,
    COUNT(r.id_reserva) AS TotalReservas
FROM ITEM_ACERVO ia
JOIN RESERVA r ON ia.id_item = r.id_item
GROUP BY ia.id_item, ia.titulo, ia.tipo_item
ORDER BY TotalReservas DESC
LIMIT 5;

-- Consulta 4: Detalhes de empréstimos ativos de alunos, incluindo curso e semestre.
SELECT
    u.nome AS NomeAluno,
    a.matricula AS MatriculaAluno,
    cu.nome_curso AS CursoAluno,
    a.semestre AS SemestreAluno,
    ia.titulo AS TituloLivroEmprestado,
    em.data_retirada AS DataRetirada,
    em.data_devolucao_prevista AS DevolucaoPrevista
FROM USUARIO u
JOIN ALUNO a ON u.id_usuario = a.id_usuario
JOIN CURSO cu ON a.id_curso = cu.id_curso
JOIN EMPRESTIMO em ON u.id_usuario = em.id_usuario
JOIN EXEMPLAR ex ON em.id_exemplar = ex.id_exemplar
JOIN LIVRO_FISICO lf ON ex.id_livro_fisico = lf.id_livro_fisico
JOIN ITEM_ACERVO ia ON lf.id_item = ia.id_item
WHERE em.status_emprestimo = 'EM_ANDAMENTO'
ORDER BY u.nome;
