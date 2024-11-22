-- MySQL dump 10.13  Distrib 8.3.0, for Linux (x86_64)
--
-- Host: localhost    Database: temporal_visibility
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `executions_visibility`
--

DROP TABLE IF EXISTS `executions_visibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `executions_visibility` (
  `namespace_id` char(64) NOT NULL,
  `run_id` char(64) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `execution_time` datetime(6) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `workflow_type_name` varchar(255) NOT NULL,
  `status` int NOT NULL,
  `close_time` datetime(6) DEFAULT NULL,
  `history_length` bigint DEFAULT NULL,
  `memo` blob,
  `encoding` varchar(64) NOT NULL,
  `task_queue` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`namespace_id`,`run_id`),
  KEY `by_type_start_time` (`namespace_id`,`workflow_type_name`,`status`,`start_time` DESC,`run_id`),
  KEY `by_workflow_id_start_time` (`namespace_id`,`workflow_id`,`status`,`start_time` DESC,`run_id`),
  KEY `by_status_by_start_time` (`namespace_id`,`status`,`start_time` DESC,`run_id`),
  KEY `by_type_close_time` (`namespace_id`,`workflow_type_name`,`status`,`close_time` DESC,`run_id`),
  KEY `by_workflow_id_close_time` (`namespace_id`,`workflow_id`,`status`,`close_time` DESC,`run_id`),
  KEY `by_status_by_close_time` (`namespace_id`,`status`,`close_time` DESC,`run_id`),
  KEY `by_close_time_by_status` (`namespace_id`,`close_time` DESC,`run_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_update_history`
--

DROP TABLE IF EXISTS `schema_update_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_update_history` (
  `version_partition` int NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `manifest_md5` varchar(64) DEFAULT NULL,
  `new_version` varchar(64) DEFAULT NULL,
  `old_version` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`version_partition`,`year`,`month`,`update_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_version`
--

DROP TABLE IF EXISTS `schema_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_version` (
  `version_partition` int NOT NULL,
  `db_name` varchar(255) NOT NULL,
  `creation_time` datetime(6) DEFAULT NULL,
  `curr_version` varchar(64) DEFAULT NULL,
  `min_compatible_version` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`version_partition`,`db_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-15  9:01:16
