-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES';

CREATE SCHEMA IF NOT EXISTS `db_universidade` DEFAULT CHARACTER SET utf8;
USE `db_universidade`;

-- Pessoa
CREATE TABLE IF NOT EXISTS `Pessoa` (
  `idPessoa` INT NOT NULL,
  `Nome` VARCHAR(45),
  `cpf` VARCHAR(45) NOT NULL,
  `Endereco` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPessoa`)
) ENGINE=InnoDB;

-- Departamento
CREATE TABLE IF NOT EXISTS `Departamento` (
  `idDepartamento` INT NOT NULL,
  PRIMARY KEY (`idDepartamento`)
) ENGINE=InnoDB;

-- Curso
CREATE TABLE IF NOT EXISTS `Curso` (
  `idCurso` INT NOT NULL,
  `Departamento_idDepartamento` INT NOT NULL,
  PRIMARY KEY (`idCurso`, `Departamento_idDepartamento`),
  FOREIGN KEY (`Departamento_idDepartamento`)
    REFERENCES `Departamento` (`idDepartamento`)
) ENGINE=InnoDB;

-- Aluno
CREATE TABLE IF NOT EXISTS `Aluno` (
  `idAluno` INT NOT NULL,
  `Pessoa_idPessoa` INT NOT NULL,
  `Matricula` VARCHAR(45),
  PRIMARY KEY (`idAluno`),
  FOREIGN KEY (`Pessoa_idPessoa`)
    REFERENCES `Pessoa` (`idPessoa`)
) ENGINE=InnoDB;

-- Professor
CREATE TABLE IF NOT EXISTS `Professor` (
  `idProfessor` INT NOT NULL,
  `Departamento_idDepartamento` INT NOT NULL,
  `Pessoa_idPessoa` INT NOT NULL,
  `Registro` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProfessor`, `Departamento_idDepartamento`),
  FOREIGN KEY (`Departamento_idDepartamento`)
    REFERENCES `Departamento` (`idDepartamento`),
  FOREIGN KEY (`Pessoa_idPessoa`)
    REFERENCES `Pessoa` (`idPessoa`)
) ENGINE=InnoDB;

-- Disciplina
CREATE TABLE IF NOT EXISTS `Disciplina` (
  `idDisciplina` INT NOT NULL,
  `Professor_idProfessor` INT NOT NULL,
  `Professor_Departamento_idDepartamento` INT NOT NULL,
  PRIMARY KEY (`idDisciplina`, `Professor_idProfessor`, `Professor_Departamento_idDepartamento`),
  FOREIGN KEY (`Professor_idProfessor`, `Professor_Departamento_idDepartamento`)
    REFERENCES `Professor` (`idProfessor`, `Departamento_idDepartamento`)
) ENGINE=InnoDB;

-- Periodo
CREATE TABLE IF NOT EXISTS `Periodo` (
  `idPeriodo` INT NOT NULL,
  `Semestre` VARCHAR(45),
  `Ano` VARCHAR(45),
  PRIMARY KEY (`idPeriodo`)
) ENGINE=InnoDB;

-- Matriculado 
CREATE TABLE IF NOT EXISTS `Matriculado` (
  `Aluno_idAluno` INT NOT NULL,
  `Disciplina_idDisciplina` INT NOT NULL,
  `Disciplina_Professor_idProfessor` INT NOT NULL,
  `Disciplina_Professor_Departamento_idDepartamento` INT NOT NULL,
  PRIMARY KEY (`Aluno_idAluno`, `Disciplina_idDisciplina`, `Disciplina_Professor_idProfessor`, `Disciplina_Professor_Departamento_idDepartamento`),
  FOREIGN KEY (`Aluno_idAluno`)
    REFERENCES `Aluno` (`idAluno`),
  FOREIGN KEY (`Disciplina_idDisciplina`, `Disciplina_Professor_idProfessor`, `Disciplina_Professor_Departamento_idDepartamento`)
    REFERENCES `Disciplina` (`idDisciplina`, `Professor_idProfessor`, `Professor_Departamento_idDepartamento`)
) ENGINE=InnoDB;

-- Disciplina do curso
CREATE TABLE IF NOT EXISTS `Disciplina_do_curso` (
  `Disciplina_idDisciplina` INT NOT NULL,
  `Curso_idCurso` INT NOT NULL,
  PRIMARY KEY (`Disciplina_idDisciplina`, `Curso_idCurso`),
  FOREIGN KEY (`Disciplina_idDisciplina`)
    REFERENCES `Disciplina` (`idDisciplina`),
  FOREIGN KEY (`Curso_idCurso`)
    REFERENCES `Curso` (`idCurso`)
) ENGINE=InnoDB;

-- Pre requisito
CREATE TABLE IF NOT EXISTS `Pre_requisito` (
  `idPre_requisito` INT NOT NULL,
  PRIMARY KEY (`idPre_requisito`)
) ENGINE=InnoDB;

-- Pre requisito das disciplinas
CREATE TABLE IF NOT EXISTS `Pre_requisito_das_disciplinas` (
  `Disciplina_idDisciplina` INT NOT NULL,
  `Pre_requisito_idPre_requisito` INT NOT NULL,
  PRIMARY KEY (`Disciplina_idDisciplina`, `Pre_requisito_idPre_requisito`),
  FOREIGN KEY (`Disciplina_idDisciplina`)
    REFERENCES `Disciplina` (`idDisciplina`),
  FOREIGN KEY (`Pre_requisito_idPre_requisito`)
    REFERENCES `Pre_requisito` (`idPre_requisito`)
) ENGINE=InnoDB;

-- Oferta de disciplina
CREATE TABLE IF NOT EXISTS `Oferta_de_disciplina` (
  `Disciplina_idDisciplina` INT NOT NULL,
  `Disciplina_Professor_idProfessor` INT NOT NULL,
  `Disciplina_Professor_Departamento_idDepartamento` INT NOT NULL,
  `Periodo_idPeriodo` INT NOT NULL,
  PRIMARY KEY (`Disciplina_idDisciplina`, `Disciplina_Professor_idProfessor`, `Disciplina_Professor_Departamento_idDepartamento`, `Periodo_idPeriodo`),
  FOREIGN KEY (`Disciplina_idDisciplina`, `Disciplina_Professor_idProfessor`, `Disciplina_Professor_Departamento_idDepartamento`)
    REFERENCES `Disciplina` (`idDisciplina`, `Professor_idProfessor`, `Professor_Departamento_idDepartamento`),
  FOREIGN KEY (`Periodo_idPeriodo`)
    REFERENCES `Periodo` (`idPeriodo`)
) ENGINE=InnoDB;

-- Aluno matriculado no curso
CREATE TABLE IF NOT EXISTS `Aluno_matriculado_no_curso` (
  `Aluno_idAluno` INT NOT NULL,
  `Curso_idCurso` INT NOT NULL,
  PRIMARY KEY (`Aluno_idAluno`, `Curso_idCurso`),
  FOREIGN KEY (`Aluno_idAluno`)
    REFERENCES `Aluno` (`idAluno`),
  FOREIGN KEY (`Curso_idCurso`)
    REFERENCES `Curso` (`idCurso`)
) ENGINE=InnoDB;

-- Extensao
CREATE TABLE IF NOT EXISTS `Extensao` (
  `idExtensao` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Area` VARCHAR(45) NOT NULL,
  `Instituicao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idExtensao`)
) ENGINE=InnoDB;

-- Cursos Extras
CREATE TABLE IF NOT EXISTS `Cursos_Extras` (
  `Extensao_idExtensao` INT NOT NULL,
  `Aluno_idAluno` INT NOT NULL,
  PRIMARY KEY (`Extensao_idExtensao`, `Aluno_idAluno`),
  FOREIGN KEY (`Extensao_idExtensao`)
    REFERENCES `Extensao` (`idExtensao`),
  FOREIGN KEY (`Aluno_idAluno`)
    REFERENCES `Aluno` (`idAluno`)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET SQL_MODE=@OLD_SQL_MODE;