-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db_ecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_ecommerce` DEFAULT CHARACTER SET utf8mb4;
USE `db_ecommerce`;

-- -----------------------------------------------------
-- Table `cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `endereco` VARCHAR(255) NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `cliente_pf`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cliente_pf` (
  `id_cliente` INT NOT NULL,
  `nome` VARCHAR(100) NULL,
  `cpf` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC),
  CONSTRAINT `fk_cliente_pf`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `cliente` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `cliente_pj`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cliente_pj` (
  `id_cliente` INT NOT NULL,
  `razao_social` VARCHAR(100) NULL,
  `cnpj` VARCHAR(18) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC),
  CONSTRAINT `fk_cliente_pj`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `cliente` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(50) NULL,
  `descricao` VARCHAR(255) NULL,
  `frete` DECIMAL(10,2) NULL,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedido_cliente_idx` (`cliente_id` ASC),
  CONSTRAINT `fk_pedido_cliente`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `cliente` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `produto` (
  `id_produto` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(50) NULL,
  `descricao` VARCHAR(255) NULL,
  `valor` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id_produto`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `produto_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `produto_pedido` (
  `pedido_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`pedido_id`, `produto_id`),
  INDEX `fk_produto_pedido_produto_idx` (`produto_id` ASC),
  INDEX `fk_produto_pedido_pedido_idx` (`pedido_id` ASC),
  CONSTRAINT `fk_produto_pedido_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `pedido` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_produto_pedido_produto`
    FOREIGN KEY (`produto_id`)
    REFERENCES `produto` (`id_produto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pagamento` (
  `id_pagamento` INT NOT NULL AUTO_INCREMENT,
  `pedido_id` INT NOT NULL,
  `tipo` VARCHAR(50) NULL,
  `valor` DECIMAL(10,2) NULL,
  `status` VARCHAR(50) NULL,
  PRIMARY KEY (`id_pagamento`),
  INDEX `fk_pagamento_pedido_idx` (`pedido_id` ASC),
  CONSTRAINT `fk_pagamento_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `pedido` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `entrega` (
  `id_entrega` INT NOT NULL AUTO_INCREMENT,
  `pedido_id` INT NOT NULL,
  `status` VARCHAR(50) NULL,
  `codigo_rastreio` VARCHAR(100) NULL,
  PRIMARY KEY (`id_entrega`),
  UNIQUE INDEX `pedido_id_UNIQUE` (`pedido_id` ASC),
  CONSTRAINT `fk_entrega_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `pedido` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Restore Settings
-- -----------------------------------------------------
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;