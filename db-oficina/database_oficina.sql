CREATE DATABASE oficina;
USE oficina;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(150)
);

CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10),
    modelo VARCHAR(50),
    marca VARCHAR(50),
    ano INT,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE mecanico (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(150),
    especialidade VARCHAR(50)
);

CREATE TABLE equipe (
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    nome_equipe VARCHAR(50)
);

CREATE TABLE equipe_mecanico (
    id_equipe INT,
    id_mecanico INT,
    PRIMARY KEY (id_equipe, id_mecanico),
    FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),
    FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico)
);

CREATE TABLE ordem_servico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    data_emissao DATE,
    data_conclusao DATE,
    status VARCHAR(30),
    valor_total DECIMAL(10,2),
    id_veiculo INT,
    id_equipe INT,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
);

CREATE TABLE servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100),
    valor_mao_obra DECIMAL(10,2)
);

CREATE TABLE os_servico (
    id_os INT,
    id_servico INT,
    quantidade INT,
    valor DECIMAL(10,2),
    PRIMARY KEY (id_os, id_servico),
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

CREATE TABLE peca (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    valor_unitario DECIMAL(10,2)
);

CREATE TABLE os_peca (
    id_os INT,
    id_peca INT,
    quantidade INT,
    valor DECIMAL(10,2),
    PRIMARY KEY (id_os, id_peca),
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);

INSERT INTO cliente (nome, telefone, endereco) VALUES
('João Silva', '11999999999', 'Rua A'),
('Maria Souza', '11888888888', 'Rua B');

INSERT INTO veiculo (placa, modelo, marca, ano, id_cliente) VALUES
('ABC1234', 'Gol', 'Volkswagen', 2015, 1),
('XYZ5678', 'Civic', 'Honda', 2018, 2);

INSERT INTO mecanico (nome, endereco, especialidade) VALUES
('Carlos', 'Rua C', 'Motor'),
('Pedro', 'Rua D', 'Freios');

INSERT INTO equipe (nome_equipe) VALUES
('Equipe A'),
('Equipe B');

INSERT INTO equipe_mecanico VALUES
(1,1),
(1,2),
(2,2);

INSERT INTO ordem_servico (data_emissao, data_conclusao, status, valor_total, id_veiculo, id_equipe) VALUES
('2026-03-01','2026-03-05','CONCLUIDO',500,1,1),
('2026-03-02',NULL,'EM_EXECUCAO',300,2,2);

INSERT INTO servico (descricao, valor_mao_obra) VALUES
('Troca de óleo', 100),
('Revisão geral', 200);

INSERT INTO os_servico VALUES
(1,1,1,100),
(1,2,1,200),
(2,1,1,100);

INSERT INTO peca (nome, valor_unitario) VALUES
('Filtro de óleo', 50),
('Pastilha de freio', 150);

INSERT INTO os_peca VALUES
(1,1,1,50),
(1,2,1,150),
(2,1,1,50);

SELECT * FROM cliente;

SELECT * FROM ordem_servico
WHERE status = 'EM_EXECUCAO';

SELECT os.id_os,
       SUM(os_servico.valor + os_peca.valor) AS total_calculado
FROM ordem_servico os
LEFT JOIN os_servico ON os.id_os = os_servico.id_os
LEFT JOIN os_peca ON os.id_os = os_peca.id_os
GROUP BY os.id_os;

SELECT * FROM ordem_servico
ORDER BY valor_total DESC;

SELECT id_os, SUM(valor_total) AS total
FROM ordem_servico
GROUP BY id_os
HAVING total > 400;

SELECT c.nome, os.id_os, os.status
FROM cliente c
JOIN veiculo v ON c.id_cliente = v.id_cliente
JOIN ordem_servico os ON v.id_veiculo = os.id_veiculo;

SELECT os.id_os, s.descricao, os_servico.quantidade
FROM ordem_servico os
JOIN os_servico ON os.id_os = os_servico.id_os
JOIN servico s ON os_servico.id_servico = s.id_servico;

SELECT os.id_os, e.nome_equipe
FROM ordem_servico os
JOIN equipe e ON os.id_equipe = e.id_equipe;