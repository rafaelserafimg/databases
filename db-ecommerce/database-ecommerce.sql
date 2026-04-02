CREATE DATABASE db_ecommerce;
USE db_ecommerce;

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  endereco VARCHAR(100)
);

CREATE TABLE cliente_pf (
  id_cliente INT,
  nome VARCHAR(100),
  cpf VARCHAR(20),
  PRIMARY KEY (id_cliente),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE cliente_pj (
  id_cliente INT,
  razao_social VARCHAR(100),
  cnpj VARCHAR(20),
  PRIMARY KEY (id_cliente),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  status VARCHAR(50),
  descricao VARCHAR(100),
  frete DECIMAL(10,2),
  cliente_id INT,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id_cliente)
);

CREATE TABLE produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(100),
  valor DECIMAL(10,2)
);

CREATE TABLE produto_pedido (
  pedido_id INT,
  produto_id INT,
  quantidade INT,
  PRIMARY KEY (pedido_id, produto_id),
  FOREIGN KEY (pedido_id) REFERENCES pedido(id_pedido),
  FOREIGN KEY (produto_id) REFERENCES produto(id_produto)
);

CREATE TABLE pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT,
  tipo VARCHAR(50),
  valor DECIMAL(10,2),
  FOREIGN KEY (pedido_id) REFERENCES pedido(id_pedido)
);

CREATE TABLE entrega (
  id_entrega INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT,
  status VARCHAR(50),
  codigo_rastreio VARCHAR(50),
  FOREIGN KEY (pedido_id) REFERENCES pedido(id_pedido)
);

CREATE TABLE fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  razao_social VARCHAR(100)
);

CREATE TABLE produto_fornecedor (
  fornecedor_id INT,
  produto_id INT,
  PRIMARY KEY (fornecedor_id, produto_id),
  FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id_fornecedor),
  FOREIGN KEY (produto_id) REFERENCES produto(id_produto)
);

CREATE TABLE estoque (
  id_estoque INT AUTO_INCREMENT PRIMARY KEY,
  local VARCHAR(100)
);

CREATE TABLE produto_estoque (
  produto_id INT,
  estoque_id INT,
  quantidade INT,
  PRIMARY KEY (produto_id, estoque_id),
  FOREIGN KEY (produto_id) REFERENCES produto(id_produto),
  FOREIGN KEY (estoque_id) REFERENCES estoque(id_estoque)
);

INSERT INTO cliente (endereco) VALUES ('Rua A'), ('Rua B');

INSERT INTO cliente_pf VALUES (1, 'Joao', '11111111111');
INSERT INTO cliente_pj VALUES (2, 'Empresa X', '22222222222');

INSERT INTO produto (descricao, valor) VALUES 
('Notebook', 3000),
('Mouse', 50);

INSERT INTO pedido (status, descricao, frete, cliente_id) VALUES 
('Enviado', 'Pedido 1', 20, 1),
('Pendente', 'Pedido 2', 60, 2);

INSERT INTO produto_pedido VALUES 
(1,1,1),
(1,2,2),
(2,2,3);

INSERT INTO pagamento (pedido_id, tipo, valor) VALUES 
(1, 'cartao', 3100),
(1, 'pix', 50),
(2, 'boleto', 150);

INSERT INTO entrega (pedido_id, status, codigo_rastreio) VALUES 
(1, 'Em transporte', 'ABC123'),
(2, 'Separando', 'XYZ999');

INSERT INTO fornecedor (razao_social) VALUES ('Fornecedor A');

INSERT INTO produto_fornecedor VALUES (1,1), (1,2);

INSERT INTO estoque (local) VALUES ('SP');

INSERT INTO produto_estoque VALUES (1,1,10), (2,1,50);

SELECT cliente_id, COUNT(*) 
FROM pedido
GROUP BY cliente_id;

SELECT * 
FROM pedido
WHERE frete > 50;

SELECT pedido_id, SUM(quantidade * valor)
FROM produto_pedido
JOIN produto ON produto_id = id_produto
GROUP BY pedido_id;

SELECT * 
FROM pedido
ORDER BY frete;

SELECT cliente_id, COUNT(*)
FROM pedido
GROUP BY cliente_id
HAVING COUNT(*) > 1;

SELECT pedido_id, descricao, quantidade
FROM produto_pedido
JOIN produto ON produto_id = id_produto;

SELECT descricao, quantidade
FROM produto
JOIN produto_estoque ON id_produto = produto_id;

SELECT razao_social, descricao
FROM fornecedor
JOIN produto_fornecedor ON id_fornecedor = fornecedor_id
JOIN produto ON produto_id = id_produto;