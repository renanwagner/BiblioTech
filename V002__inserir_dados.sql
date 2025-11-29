USE BiblioTechDB;

-- Inserção de dados nas tabelas de lookup e base
INSERT INTO CATEGORIA (nome_categoria, codigo_dewey) VALUES
('Ciência da Computação', '004'),
('Literatura Brasileira', '869.3'),
('História Antiga', '930'),
('Engenharia de Software', '005.1'),
('Inteligência Artificial', '006.3');

INSERT INTO AUTOR (nome_autor, nacionalidade) VALUES
('Machado de Assis', 'Brasileira'),
('Martin Fowler', 'Britânica'),
('Yuval Noah Harari', 'Israelense'),
('Robert C. Martin', 'Americana'),
('Isaac Asimov', 'Russo-Americana');

INSERT INTO EDITORA (nome_editora, pais_origem) VALUES
('Editora Globo', 'Brasil'),
('Addison-Wesley', 'EUA'),
('Companhia das Letras', 'Brasil'),
('Prentice Hall', 'EUA'),
('HarperCollins', 'EUA');

INSERT INTO LOCALIZACAO (andar, estante, prateleira, secao) VALUES
(1, 'A1', '01', 'Tecnologia'),
(1, 'A1', '02', 'Tecnologia'),
(2, 'B2', '03', 'Literatura'),
(2, 'B2', '04', 'Literatura'),
(3, 'C3', '05', 'História');

INSERT INTO CURSO (nome_curso, area_conhecimento) VALUES
('Ciência da Computação', 'Tecnologia'),
('Engenharia de Software', 'Tecnologia'),
('Letras', 'Humanas'),
('História', 'Humanas');

INSERT INTO DEPARTAMENTO (nome_departamento, sigla) VALUES
('Departamento de Computação', 'DCOMP'),
('Departamento de Letras', 'DLET'),
('Departamento de História', 'DHIST');

-- Inserção de USUARIOS
INSERT INTO USUARIO (nome, email, telefone, tipo_usuario, status, data_cadastro) VALUES
('Renan Silva', 'renan.silva@email.com', '11987654321', 'ALUNO', 'ATIVO', '2023-01-10'),
('Ana Paula Souza', 'ana.souza@email.com', '21998765432', 'ALUNO', 'ATIVO', '2023-02-15'),
('Dr. Carlos Mendes', 'carlos.mendes@email.com', '31987651234', 'PROFESSOR', 'ATIVO', '2022-05-20'),
('Dra. Laura Costa', 'laura.costa@email.com', '41991234567', 'PROFESSOR', 'ATIVO', '2022-08-01'),
('Pedro Almeida', 'pedro.almeida@email.com', '51987659876', 'FUNCIONARIO', 'ATIVO', '2021-11-01'),
('Mariana Santos', 'mariana.santos@email.com', '11999998888', 'FUNCIONARIO', 'ATIVO', '2021-03-10');

-- Inserção de ALUNOS
INSERT INTO ALUNO (id_usuario, matricula, semestre, id_curso) VALUES
(1, '2023001', 3, 1), -- Renan Silva (Ciência da Computação)
(2, '2023002', 2, 3); -- Ana Paula Souza (Letras)

-- Inserção de PROFESSORES
INSERT INTO PROFESSOR (id_usuario, area_pesquisa, id_departamento) VALUES
(3, 'Inteligência Artificial', 1), -- Dr. Carlos Mendes (DCOMP)
(4, 'Literatura Comparada', 2); -- Dra. Laura Costa (DLET)

-- Inserção de FUNCIONARIOS
INSERT INTO FUNCIONARIO (id_usuario, cargo, data_admissao, is_bibliotecario) VALUES
(5, 'Atendente de Biblioteca', '2021-11-01', TRUE), -- Pedro Almeida
(6, 'Administrativo', '2021-03-10', FALSE); -- Mariana Santos

-- Inserção de ITENS_ACERVO (e suas subclasses)
-- Livro Físico 1: Dom Casmurro
INSERT INTO ITEM_ACERVO (titulo, ano_publicacao, sinopse, tipo_item, capa_url, id_editora, id_categoria) VALUES
('Dom Casmurro', 1899, 'Clássico da literatura brasileira, narra a história de Bentinho e Capitu.', 'LIVRO_FISICO', 'url_domcasmurro.jpg', 1, 2);
SET @id_item_domcasmurro = LAST_INSERT_ID();
INSERT INTO LIVRO_FISICO (id_item, isbn) VALUES (@id_item_domcasmurro, '978-8504000001');

-- Livro Físico 2: Clean Code
INSERT INTO ITEM_ACERVO (titulo, ano_publicacao, sinopse, tipo_item, capa_url, id_editora, id_categoria) VALUES
('Clean Code: A Handbook of Agile Software Craftsmanship', 2008, 'Guia essencial para escrever código limpo e de fácil manutenção.', 'LIVRO_FISICO', 'url_cleancode.jpg', 4, 4);
SET @id_item_cleancode = LAST_INSERT_ID();
INSERT INTO LIVRO_FISICO (id_item, isbn) VALUES (@id_item_cleancode, '978-0132350884');

-- Ebook 1: Sapiens
INSERT INTO ITEM_ACERVO (titulo, ano_publicacao, sinopse, tipo_item, capa_url, id_editora, id_categoria) VALUES
('Sapiens: Uma Breve História da Humanidade', 2011, 'Explora a história da humanidade desde a Idade da Pedra até o século XXI.', 'EBOOK', 'url_sapiens.jpg', 3, 3);
SET @id_item_sapiens = LAST_INSERT_ID();
INSERT INTO EBOOK (id_item, url_acesso, formato_digital) VALUES (@id_item_sapiens, 'http://ebooks.com/sapiens', 'PDF');

-- Periódico 1: Revista Brasileira de Computação
INSERT INTO ITEM_ACERVO (titulo, ano_publicacao, sinopse, tipo_item, capa_url, id_editora, id_categoria) VALUES
('Revista Brasileira de Computação', 2023, 'Artigos científicos sobre avanços em computação.', 'PERIODICO', 'url_rbc.jpg', 1, 1);
SET @id_item_rbc = LAST_INSERT_ID();
INSERT INTO PERIODICO (id_item, issn, volume, numero) VALUES (@id_item_rbc, '1234-5678', 'Vol. 10', 'No. 2');

-- Tese 1: Tese sobre Redes Neurais
INSERT INTO ITEM_ACERVO (titulo, ano_publicacao, sinopse, tipo_item, capa_url, id_editora, id_categoria) VALUES
('Otimização de Redes Neurais para Processamento de Linguagem Natural', 2022, 'Tese de doutorado sobre PNL e IA.', 'TESE_DISSERTACAO', NULL, 4, 5);
SET @id_item_tese = LAST_INSERT_ID();
INSERT INTO TESE_DISSERTACAO (id_item, tipo_trabalho, url_repositorio) VALUES (@id_item_tese, 'TESE', 'http://repositorio.universidade.br/tese_pnl.pdf');

-- Inserção de EXEMPLARES
INSERT INTO EXEMPLAR (id_livro_fisico, numero_exemplar, status_exemplar, id_localizacao) VALUES
((SELECT id_livro_fisico FROM LIVRO_FISICO WHERE id_item = @id_item_domcasmurro), '001', 'DISPONIVEL', 3),
((SELECT id_livro_fisico FROM LIVRO_FISICO WHERE id_item = @id_item_domcasmurro), '002', 'EMPRESTADO', 3),
((SELECT id_livro_fisico FROM LIVRO_FISICO WHERE id_item = @id_item_cleancode), '001', 'DISPONIVEL', 1),
((SELECT id_livro_fisico FROM LIVRO_FISICO WHERE id_item = @id_item_cleancode), '002', 'DISPONIVEL', 1);

-- Inserção de ITEM_AUTOR
INSERT INTO ITEM_AUTOR (id_item, id_autor, tipo_participacao) VALUES
(@id_item_domcasmurro, (SELECT id_autor FROM AUTOR WHERE nome_autor = 'Machado de Assis'), 'PRINCIPAL'),
(@id_item_cleancode, (SELECT id_autor FROM AUTOR WHERE nome_autor = 'Robert C. Martin'), 'PRINCIPAL'),
(@id_item_sapiens, (SELECT id_autor FROM AUTOR WHERE nome_autor = 'Yuval Noah Harari'), 'PRINCIPAL'),
(@id_item_rbc, (SELECT id_autor FROM AUTOR WHERE nome_autor = 'Martin Fowler'), 'COAUTOR'), -- Exemplo de coautor
(@id_item_tese, (SELECT id_autor FROM AUTOR WHERE nome_autor = 'Isaac Asimov'), 'ORIENTADOR'); -- Exemplo de orientador

-- Inserção de EMPRESTIMOS
INSERT INTO EMPRESTIMO (id_usuario, id_exemplar, data_retirada, data_devolucao_prevista, status_emprestimo, numero_renovacoes) VALUES
(1, 2, '2023-11-20', '2023-11-27', 'EM_ANDAMENTO', 0); -- Renan pegou Dom Casmurro (exemplar 002)

-- Inserção de RESERVAS
INSERT INTO RESERVA (id_usuario, id_item, data_solicitacao, status_reserva, posicao_fila) VALUES
(2, @id_item_domcasmurro, '2023-11-22 10:00:00', 'AGUARDANDO', 1); -- Ana reservou Dom Casmurro

-- Inserção de MULTAS (para o empréstimo de Renan, simulando atraso)
INSERT INTO MULTA (id_emprestimo, valor_multa, data_geracao, status_multa) VALUES
(1, 4.00, '2023-11-29', 'PENDENTE'); -- Multa para Renan por atraso de 2 dias

-- Inserção de BLOQUEIOS (para Renan devido à multa)
INSERT INTO BLOQUEIO (id_usuario, data_inicio, motivo_bloqueio, status_bloqueio) VALUES
(1, '2023-11-29', 'Multas pendentes acima do limite', 'ATIVO');

-- Inserção de NOTIFICACOES
INSERT INTO NOTIFICACAO (id_usuario, tipo_notificacao, mensagem, data_envio, status_leitura) VALUES
(1, 'LEMBRETE_DEVOLUCAO', 'Seu livro Dom Casmurro está atrasado.', '2023-11-28 09:00:00', FALSE),
(2, 'RESERVA_DISPONIVEL', 'O livro Dom Casmurro que você reservou está disponível.', '2023-12-01 14:30:00', FALSE);

-- Inserção de RENOVACAO (se o empréstimo de Renan tivesse sido renovado)
INSERT INTO RENOVACAO (id_emprestimo, data_renovacao, nova_data_devolucao, numero_renovacao) VALUES
(1, '2023-11-26 15:00:00', '2023-12-03', 1);
