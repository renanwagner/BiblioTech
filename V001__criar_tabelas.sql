-- Desativa a verificação de chaves estrangeiras temporariamente para permitir a criação de tabelas em qualquer ordem,
-- útil em scripts grandes, mas será reativado ao final.
SET FOREIGN_KEY_CHECKS = 0;

-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS BiblioTechDB;
USE BiblioTechDB;

-- 1. Tabela CATEGORIA
CREATE TABLE CATEGORIA (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL UNIQUE,
    codigo_dewey VARCHAR(10) NOT NULL UNIQUE
);

-- 2. Tabela AUTOR
CREATE TABLE AUTOR (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome_autor VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50)
);

-- 3. Tabela EDITORA
CREATE TABLE EDITORA (
    id_editora INT AUTO_INCREMENT PRIMARY KEY,
    nome_editora VARCHAR(100) NOT NULL UNIQUE,
    pais_origem VARCHAR(50)
);

-- 4. Tabela LOCALIZACAO
CREATE TABLE LOCALIZACAO (
    id_localizacao INT AUTO_INCREMENT PRIMARY KEY,
    andar INT NOT NULL,
    estante VARCHAR(10) NOT NULL,
    prateleira VARCHAR(10) NOT NULL,
    secao VARCHAR(50),
    UNIQUE(andar, estante, prateleira)
);

-- 5. Tabela CURSO
CREATE TABLE CURSO (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL UNIQUE,
    area_conhecimento VARCHAR(100)
);

-- 6. Tabela DEPARTAMENTO
CREATE TABLE DEPARTAMENTO (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_departamento VARCHAR(100) NOT NULL UNIQUE,
    sigla VARCHAR(10) NOT NULL UNIQUE
);

-- 7. Tabela USUARIO (Superclasse para Aluno, Professor, Funcionario)
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    tipo_usuario VARCHAR(20) NOT NULL, -- 'ALUNO', 'PROFESSOR', 'FUNCIONARIO'
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVO', -- 'ATIVO', 'BLOQUEADO', 'INATIVO'
    data_cadastro DATE NOT NULL
);

-- 8. Tabela ALUNO (Subclasse de USUARIO)
CREATE TABLE ALUNO (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    semestre INT,
    id_curso INT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 9. Tabela PROFESSOR (Subclasse de USUARIO)
CREATE TABLE PROFESSOR (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    area_pesquisa VARCHAR(100),
    id_departamento INT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTO(id_departamento) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 10. Tabela FUNCIONARIO (Subclasse de USUARIO)
CREATE TABLE FUNCIONARIO (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    data_admissao DATE NOT NULL,
    is_bibliotecario BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 11. Tabela ITEM_ACERVO (Superclasse para Livro_Fisico, Ebook, Periodico, Tese_Dissertacao)
CREATE TABLE ITEM_ACERVO (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    ano_publicacao INT,
    sinopse TEXT,
    tipo_item VARCHAR(20) NOT NULL, -- 'LIVRO_FISICO', 'EBOOK', 'PERIODICO', 'TESE_DISSERTACAO'
    capa_url VARCHAR(255),
    id_editora INT,
    id_categoria INT,
    FOREIGN KEY (id_editora) REFERENCES EDITORA(id_editora) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 12. Tabela LIVRO_FISICO (Subclasse de ITEM_ACERVO)
CREATE TABLE LIVRO_FISICO (
    id_livro_fisico INT AUTO_INCREMENT PRIMARY KEY,
    id_item INT NOT NULL UNIQUE,
    isbn VARCHAR(17) NOT NULL UNIQUE,
    FOREIGN KEY (id_item) REFERENCES ITEM_ACERVO(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 13. Tabela EBOOK (Subclasse de ITEM_ACERVO)
CREATE TABLE EBOOK (
    id_ebook INT AUTO_INCREMENT PRIMARY KEY,
    id_item INT NOT NULL UNIQUE,
    url_acesso VARCHAR(255) NOT NULL,
    formato_digital VARCHAR(10), -- 'PDF', 'EPUB'
    FOREIGN KEY (id_item) REFERENCES ITEM_ACERVO(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 14. Tabela PERIODICO (Subclasse de ITEM_ACERVO)
CREATE TABLE PERIODICO (
    id_periodico INT AUTO_INCREMENT PRIMARY KEY,
    id_item INT NOT NULL UNIQUE,
    issn VARCHAR(9) NOT NULL UNIQUE,
    volume VARCHAR(10),
    numero VARCHAR(10),
    FOREIGN KEY (id_item) REFERENCES ITEM_ACERVO(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 15. Tabela TESE_DISSERTACAO (Subclasse de ITEM_ACERVO)
CREATE TABLE TESE_DISSERTACAO (
    id_tese INT AUTO_INCREMENT PRIMARY KEY,
    id_item INT NOT NULL UNIQUE,
    tipo_trabalho VARCHAR(50) NOT NULL, -- 'TCC', 'DISSERTACAO', 'TESE'
    url_repositorio VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_item) REFERENCES ITEM_ACERVO(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 16. Tabela EXEMPLAR
CREATE TABLE EXEMPLAR (
    id_exemplar INT AUTO_INCREMENT PRIMARY KEY,
    id_livro_fisico INT NOT NULL,
    numero_exemplar VARCHAR(10) NOT NULL,
    status_exemplar VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL', -- 'DISPONIVEL', 'EMPRESTADO', 'EM_MANUTENCAO'
    id_localizacao INT,
    FOREIGN KEY (id_livro_fisico) REFERENCES LIVRO_FISICO(id_livro_fisico) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_localizacao) REFERENCES LOCALIZACAO(id_localizacao) ON DELETE SET NULL ON UPDATE CASCADE,
    UNIQUE(id_livro_fisico, numero_exemplar)
);

-- 17. Tabela EMPRESTIMO
CREATE TABLE EMPRESTIMO (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_exemplar INT NOT NULL,
    data_retirada DATE NOT NULL,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    status_emprestimo VARCHAR(20) NOT NULL DEFAULT 'EM_ANDAMENTO', -- 'EM_ANDAMENTO', 'ATRASADO', 'DEVOLVIDO', 'CANCELADO'
    numero_renovacoes INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (id_exemplar) REFERENCES EXEMPLAR(id_exemplar) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- 18. Tabela RESERVA
CREATE TABLE RESERVA (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_item INT NOT NULL,
    data_solicitacao DATETIME NOT NULL,
    data_disponibilizacao DATETIME,
    data_expiracao DATETIME,
    status_reserva VARCHAR(20) NOT NULL DEFAULT 'AGUARDANDO', -- 'AGUARDANDO', 'DISPONIVEL', 'ATENDIDA', 'EXPIRADA', 'CANCELADA'
    posicao_fila INT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES ITEM_ACERVO(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 19. Tabela MULTA
CREATE TABLE MULTA (
    id_multa INT AUTO_INCREMENT PRIMARY KEY,
    id_emprestimo INT NOT NULL,
    valor_multa DECIMAL(10,2) NOT NULL,
    data_geracao DATE NOT NULL,
    data_pagamento DATE,
    status_multa VARCHAR(20) NOT NULL DEFAULT 'PENDENTE', -- 'PENDENTE', 'QUITADA', 'PERDOADA'
    FOREIGN KEY (id_emprestimo) REFERENCES EMPRESTIMO(id_emprestimo) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 20. Tabela PAGAMENTO
CREATE TABLE PAGAMENTO (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_multa INT NOT NULL UNIQUE,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME NOT NULL,
    forma_pagamento VARCHAR(50),
    FOREIGN KEY (id_multa) REFERENCES MULTA(id_multa) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 21. Tabela ITEM_AUTOR (Tabela Associativa N:M)
CREATE TABLE ITEM_AUTOR (
    id_item INT NOT NULL,
    id_autor INT NOT NULL,
    tipo_participacao VARCHAR(50), -- 'PRINCIPAL', 'COAUTOR', 'ORGANIZADOR'
    PRIMARY KEY (id_item, id_autor),
    FOREIGN KEY (id_item) REFERENCES ITEM_ACERVO(id_item) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES AUTOR(id_autor) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 22. Tabela NOTIFICACAO
CREATE TABLE NOTIFICACAO (
    id_notificacao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_notificacao VARCHAR(50) NOT NULL, -- 'LEMBRETE_DEVOLUCAO', 'RESERVA_DISPONIVEL', 'MULTA_GERADA'
    mensagem TEXT NOT NULL,
    data_envio DATETIME NOT NULL,
    status_leitura BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 23. Tabela RENOVACAO
CREATE TABLE RENOVACAO (
    id_renovacao INT AUTO_INCREMENT PRIMARY KEY,
    id_emprestimo INT NOT NULL,
    data_renovacao DATETIME NOT NULL,
    nova_data_devolucao DATE NOT NULL,
    numero_renovacao INT NOT NULL,
    FOREIGN KEY (id_emprestimo) REFERENCES EMPRESTIMO(id_emprestimo) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(id_emprestimo, numero_renovacao)
);

-- 24. Tabela BLOQUEIO
CREATE TABLE BLOQUEIO (
    id_bloqueio INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    motivo_bloqueio TEXT,
    status_bloqueio VARCHAR(20) NOT NULL DEFAULT 'ATIVO', -- 'ATIVO', 'RESOLVIDO'
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Reativa a verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;
