USE BiblioTechDB;

-- --- COMANDOS UPDATE ---

-- UPDATE 1: Atualizar o status de um exemplar para 'EM_MANUTENCAO'
-- Exemplo: O exemplar '001' do livro 'Clean Code' precisa de manutenção.
UPDATE EXEMPLAR
SET status_exemplar = 'EM_MANUTENCAO'
WHERE id_livro_fisico = (SELECT id_livro_fisico FROM LIVRO_FISICO WHERE id_item = (SELECT id_item FROM ITEM_ACERVO WHERE titulo = 'Clean Code'))
AND numero_exemplar = '001';

-- UPDATE 2: Registrar o pagamento de uma multa e atualizar o status do usuário.
-- Exemplo: Renan paga sua multa.
UPDATE MULTA
SET data_pagamento = CURDATE(), status_multa = 'QUITADA'
WHERE id_emprestimo = (SELECT id_emprestimo FROM EMPRESTIMO WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nome = 'Renan Silva'))
AND status_multa = 'PENDENTE';

-- Após pagar a multa, o bloqueio do usuário deve ser removido (simulando lógica de aplicação ou trigger)
UPDATE BLOQUEIO
SET data_fim = CURDATE(), status_bloqueio = 'RESOLVIDO'
WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nome = 'Renan Silva')
AND status_bloqueio = 'ATIVO';

-- Atualizar o status do USUARIO para 'ATIVO' após o bloqueio ser resolvido.
UPDATE USUARIO
SET status = 'ATIVO'
WHERE id_usuario IN (SELECT temp_id_usuario FROM (SELECT id_usuario AS temp_id_usuario FROM USUARIO WHERE nome = 'Renan Silva') AS temp_table)
AND status = 'BLOQUEADO';


-- UPDATE 3: Alterar a área de pesquisa de um professor.
-- Exemplo: Dr. Carlos Mendes agora também pesquisa 'Machine Learning'.
UPDATE PROFESSOR
SET area_pesquisa = 'Inteligência Artificial, Machine Learning'
WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nome = 'Dr. Carlos Mendes');

-- --- COMANDOS DELETE ---

-- DELETE 1: Remover reservas expiradas que não foram atendidas.
-- Exemplo: Uma reserva de Ana Paula para Dom Casmurro expirou.
-- Primeiro, é necessário simular que a reserva de Ana Paula expirou
UPDATE RESERVA
SET status_reserva = 'EXPIRADA', data_expiracao = '2023-11-24 10:00:00' -- Data no passado
WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nome = 'Ana Paula Souza')
AND id_item = (SELECT id_item FROM ITEM_ACERVO WHERE titulo = 'Dom Casmurro');

-- Agora, o DELETE
DELETE FROM RESERVA
WHERE status_reserva = 'EXPIRADA' AND data_expiracao < NOW();

-- DELETE 2: Remover um funcionário que não é bibliotecário e não tem outras dependências.
-- Exemplo: Mariana Santos (administrativo) deixou a universidade.
DELETE FROM FUNCIONARIO
WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nome = 'Mariana Santos')
AND is_bibliotecario = FALSE;

-- Como a FK em FUNCIONARIO para USUARIO é ON DELETE CASCADE, o registro de Mariana Santos
-- será automaticamente removido da tabela USUARIO.

-- DELETE 3: Remover um item do acervo que não possui exemplares físicos e não tem reservas ativas.
-- Exemplo: O ebook 'Sapiens' será removido do acervo digital.
-- Primeiro, é necessário garantir que não há reservas ativas para este item
UPDATE RESERVA
SET status_reserva = 'CANCELADA'
WHERE id_item = (SELECT id_item FROM ITEM_ACERVO WHERE titulo = 'Sapiens')
AND status_reserva = 'AGUARDANDO';

DELETE FROM EBOOK
WHERE id_item = (SELECT id_item FROM ITEM_ACERVO WHERE titulo = 'Sapiens');

DELETE FROM ITEM_ACERVO
WHERE titulo = 'Sapiens' AND tipo_item = 'EBOOK';
