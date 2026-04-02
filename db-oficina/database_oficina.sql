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