CREATE DATABASE company;
USE company;

CREATE TABLE departamento (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_departamento VARCHAR(100),
    cidade VARCHAR(100),
    id_gerente INT
);

CREATE TABLE empregado (
    id_empregado INT AUTO_INCREMENT PRIMARY KEY,
    nome_empregado VARCHAR(100),
    salario DECIMAL(10,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

ALTER TABLE departamento 
ADD FOREIGN KEY (id_gerente) REFERENCES empregado(id_empregado);

CREATE TABLE projeto (
    id_projeto INT AUTO_INCREMENT PRIMARY KEY,
    nome_projeto VARCHAR(100),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE trabalha_em (
    id_empregado INT,
    id_projeto INT,
    horas INT,
    PRIMARY KEY (id_empregado, id_projeto),
    FOREIGN KEY (id_empregado) REFERENCES empregado(id_empregado),
    FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto)
);

CREATE TABLE dependente (
    id_dependente INT AUTO_INCREMENT PRIMARY KEY,
    nome_dependente VARCHAR(100),
    id_empregado INT,
    FOREIGN KEY (id_empregado) REFERENCES empregado(id_empregado)
);

INSERT INTO departamento (nome_departamento, cidade) VALUES
('TI','São Paulo'),
('RH','Rio de Janeiro'),
('Financeiro','Belo Horizonte');

INSERT INTO empregado (nome_empregado, salario, id_departamento) VALUES
('Joao',3000,1),
('Maria',4000,1),
('Carlos',2500,2),
('Ana',5000,3);

UPDATE departamento SET id_gerente = 1 WHERE id_departamento = 1;
UPDATE departamento SET id_gerente = 3 WHERE id_departamento = 2;
UPDATE departamento SET id_gerente = 4 WHERE id_departamento = 3;

INSERT INTO projeto (nome_projeto, id_departamento) VALUES
('Sistema',1),
('Recrutamento',2),
('Auditoria',3);

INSERT INTO trabalha_em VALUES
(1,1,20),
(2,1,30),
(3,2,15),
(4,3,25);

INSERT INTO dependente (nome_dependente, id_empregado) VALUES
('Filho1',1),
('Filho2',1),
('Filho3',3);

CREATE VIEW vw_empregados_por_departamento AS
SELECT d.nome_departamento, d.cidade, COUNT(e.id_empregado) total
FROM departamento d
LEFT JOIN empregado e ON d.id_departamento = e.id_departamento
GROUP BY d.nome_departamento, d.cidade;

CREATE VIEW vw_departamento_gerente AS
SELECT d.nome_departamento, e.nome_empregado gerente
FROM departamento d
LEFT JOIN empregado e ON d.id_gerente = e.id_empregado;

CREATE VIEW vw_projetos_mais_empregados AS
SELECT p.nome_projeto, COUNT(t.id_empregado) total
FROM projeto p
JOIN trabalha_em t ON p.id_projeto = t.id_projeto
GROUP BY p.nome_projeto
ORDER BY total DESC;

CREATE VIEW vw_projetos_departamentos_gerentes AS
SELECT p.nome_projeto, d.nome_departamento, e.nome_empregado gerente
FROM projeto p
JOIN departamento d ON p.id_departamento = d.id_departamento
LEFT JOIN empregado e ON d.id_gerente = e.id_empregado;

CREATE VIEW vw_empregados_dependentes AS
SELECT e.nome_empregado,
COUNT(dep.id_dependente) total_dependentes,
CASE 
WHEN d.id_gerente IS NOT NULL THEN 'Sim'
ELSE 'Nao'
END gerente
FROM empregado e
LEFT JOIN dependente dep ON e.id_empregado = dep.id_empregado
LEFT JOIN departamento d ON e.id_empregado = d.id_gerente
GROUP BY e.nome_empregado;

CREATE USER 'gerente'@'localhost' IDENTIFIED BY '123';
GRANT SELECT ON company.empregado TO 'gerente'@'localhost';
GRANT SELECT ON company.departamento TO 'gerente'@'localhost';
GRANT SELECT ON company.vw_empregados_por_departamento TO 'gerente'@'localhost';

CREATE USER 'funcionario'@'localhost' IDENTIFIED BY '123';
GRANT SELECT ON company.empregado TO 'funcionario'@'localhost';

CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE usuario_backup (
    id INT,
    nome VARCHAR(100),
    email VARCHAR(100),
    data_exclusao DATETIME
);

CREATE TABLE colaborador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    salario DECIMAL(10,2)
);

DELIMITER $$

CREATE TRIGGER trg_backup_usuario
BEFORE DELETE ON usuario
FOR EACH ROW
BEGIN
INSERT INTO usuario_backup VALUES (OLD.id, OLD.nome, OLD.email, NOW());
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_valida_salario
BEFORE UPDATE ON colaborador
FOR EACH ROW
BEGIN
IF NEW.salario < 0 THEN
SET NEW.salario = OLD.salario;
END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_salario_minimo
BEFORE INSERT ON colaborador
FOR EACH ROW
BEGIN
IF NEW.salario < 1200 THEN
SET NEW.salario = 1200;
END IF;
END $$

DELIMITER ;