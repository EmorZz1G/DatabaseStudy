/*
SQLyog Ultimate v12.08 (64 bit)
MySQL - 8.0.0-dmr-log : Database - sc_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`sc_db` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `sc_db`;

/*Table structure for table `course` */

DROP TABLE IF EXISTS `course`;

CREATE TABLE `course` (
  `cno` INT(11) NOT NULL,
  `cname` VARCHAR(63) NOT NULL,
  `ccredit` DOUBLE NOT NULL,
  `cpno` INT(11) DEFAULT NULL,
  PRIMARY KEY (`cno`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

/*Table structure for table `sc` */

DROP TABLE IF EXISTS `sc`;

CREATE TABLE `sc` (
  `sno` INT(11) DEFAULT NULL,
  `cno` INT(11) DEFAULT NULL,
  `grade` DOUBLE NOT NULL,
  KEY `sno` (`sno`),
  KEY `cno` (`cno`),
  CONSTRAINT `sc_ibfk_1` FOREIGN KEY (`sno`) REFERENCES `student` (`sno`),
  CONSTRAINT `sc_ibfk_2` FOREIGN KEY (`cno`) REFERENCES `course` (`cno`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

/*Table structure for table `student` */

DROP TABLE IF EXISTS `student`;

CREATE TABLE `student` (
  `sno` INT(11) NOT NULL,
  `sname` VARCHAR(31) NOT NULL,
  `ssex` VARCHAR(15) NOT NULL,
  `sage` INT(11) DEFAULT NULL,
  `sdept` VARCHAR(15) DEFAULT NULL,
  PRIMARY KEY (`sno`),
) ENGINE=INNODB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
