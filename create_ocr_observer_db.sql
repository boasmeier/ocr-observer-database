-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ocr_observer
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ocr_observer
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ocr_observer` DEFAULT CHARACTER SET utf8 ;
USE `ocr_observer` ;

-- -----------------------------------------------------
-- Table `ocr_observer`.`fields`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocr_observer`.`fields` (
  `idfields` INT NOT NULL AUTO_INCREMENT,
  `signature` VARCHAR(45) NOT NULL,
  `author` VARCHAR(255) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `comment` VARCHAR(255) NOT NULL,
  `category` VARCHAR(45) NULL,
  PRIMARY KEY (`idfields`),
  UNIQUE INDEX `idfields_UNIQUE` (`idfields` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocr_observer`.`history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocr_observer`.`history` (
  `idhistory` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`idhistory`),
  UNIQUE INDEX `idhistory_UNIQUE` (`idhistory` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocr_observer`.`task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocr_observer`.`task` (
  `idtask` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idtask`),
  UNIQUE INDEX `idtask_UNIQUE` (`idtask` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocr_observer`.`dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocr_observer`.`dataset` (
  `iddataset` INT NOT NULL AUTO_INCREMENT,
  `idtask` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`iddataset`),
  UNIQUE INDEX `iddataset_UNIQUE` (`iddataset` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  INDEX `fk_dataset_task1_idx` (`idtask` ASC) VISIBLE,
  CONSTRAINT `fk_dataset_task1`
    FOREIGN KEY (`idtask`)
    REFERENCES `ocr_observer`.`task` (`idtask`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocr_observer`.`image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocr_observer`.`image` (
  `idimage` INT NOT NULL AUTO_INCREMENT,
  `iddataset` INT NOT NULL,
  `idfields` INT NOT NULL,
  `idhistory` INT NOT NULL,
  `destination` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `mimetype` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idimage`),
  UNIQUE INDEX `idimage_UNIQUE` (`idimage` ASC) VISIBLE,
  INDEX `fk_image_fields1_idx` (`idfields` ASC) VISIBLE,
  INDEX `fk_image_history1_idx` (`idhistory` ASC) VISIBLE,
  INDEX `fk_image_dataset1_idx` (`iddataset` ASC) VISIBLE,
  CONSTRAINT `fk_image_fields1`
    FOREIGN KEY (`idfields`)
    REFERENCES `ocr_observer`.`fields` (`idfields`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_image_history1`
    FOREIGN KEY (`idhistory`)
    REFERENCES `ocr_observer`.`history` (`idhistory`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_image_dataset1`
    FOREIGN KEY (`iddataset`)
    REFERENCES `ocr_observer`.`dataset` (`iddataset`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ocr_observer`.`state`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocr_observer`.`state` (
  `idstate` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idstate`),
  UNIQUE INDEX `idstate_UNIQUE` (`idstate` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocr_observer`.`history_has_state`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocr_observer`.`history_has_state` (
  `idhistory` INT NOT NULL,
  `idstate` INT NOT NULL,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idhistory`, `idstate`, `timestamp`),
  INDEX `fk_history_has_state_state1_idx` (`idstate` ASC) VISIBLE,
  INDEX `fk_history_has_state_history1_idx` (`idhistory` ASC) VISIBLE,
  CONSTRAINT `fk_history_has_state_history1`
    FOREIGN KEY (`idhistory`)
    REFERENCES `ocr_observer`.`history` (`idhistory`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_history_has_state_state1`
    FOREIGN KEY (`idstate`)
    REFERENCES `ocr_observer`.`state` (`idstate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TRIGGER when_delete_task_also_delete_dataset BEFORE DELETE ON task
FOR EACH ROW DELETE FROM dataset WHERE idtask = old.idtask;

CREATE TRIGGER when_delete_dataset_also_delete_image BEFORE DELETE ON dataset
FOR EACH ROW DELETE FROM image WHERE iddataset = old.iddataset;

CREATE TRIGGER when_delete_image_also_delete_history AFTER DELETE ON image
FOR EACH ROW DELETE FROM history WHERE idhistory = old.idhistory;

CREATE TRIGGER when_delete_image_also_delete_fields AFTER DELETE ON image
FOR EACH ROW DELETE FROM fields WHERE idfields = old.idfields;

CREATE TRIGGER when_delete_histroy_also_delete_history_has_state AFTER DELETE ON history
FOR EACH ROW DELETE FROM history_has_state WHERE idhistory = old.idhistory;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
