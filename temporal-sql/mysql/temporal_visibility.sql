-- MySQL dump 10.13  Distrib 8.0.39, for Linux (x86_64)
--
-- Host: localhost    Database: temporal_visibility
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Dumping data for table `executions_visibility`
--

LOCK TABLES `executions_visibility` WRITE;
/*!40000 ALTER TABLE `executions_visibility` DISABLE KEYS */;
INSERT INTO `executions_visibility` VALUES ('32049b68-7872-4094-8e63-d0dd59896a83','2f959015-10a8-4a83-b279-333537411c3a','2025-10-29 05:45:10.526880','2025-10-29 12:00:00.526880','temporal-sys-history-scanner','temporal-sys-history-scanner-workflow',1,NULL,NULL,'','Proto3','temporal-sys-history-scanner-taskqueue-0'),('32049b68-7872-4094-8e63-d0dd59896a83','9260ed18-e7c8-4e60-96ef-8730ef9e5643','2025-10-29 05:45:10.526880','2025-10-29 12:00:00.526880','temporal-sys-tq-scanner','temporal-sys-tq-scanner-workflow',1,NULL,NULL,'','Proto3','temporal-sys-tq-scanner-taskqueue-0'),('32049b68-7872-4094-8e63-d0dd59896a83','d420c5d0-c3d0-40eb-8f9d-edcca601eef3','2025-10-29 05:45:12.563586','2025-10-29 05:45:12.563586','temporal-sys-add-search-attributes-workflow','temporal-sys-add-search-attributes-workflow',2,'2025-10-29 05:45:12.772395',23,'','Proto3','default-worker-tq');
/*!40000 ALTER TABLE `executions_visibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_update_history`
--

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
-- Dumping data for table `schema_update_history`
--

LOCK TABLES `schema_update_history` WRITE;
/*!40000 ALTER TABLE `schema_update_history` DISABLE KEYS */;
INSERT INTO `schema_update_history` VALUES (0,2025,10,'2025-10-29 05:45:10.016535','initial version','','0.0','0'),(0,2025,10,'2025-10-29 05:45:10.190884','base version of visibility schema','698373883c1c0dd44607a446a62f2a79','1.0','0.0'),(0,2025,10,'2025-10-29 05:45:10.223126','add close time & status index','e286f8af0a62e291b35189ce29d3fff3','1.1','1.0');
/*!40000 ALTER TABLE `schema_update_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_version`
--

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

--
-- Dumping data for table `schema_version`
--

LOCK TABLES `schema_version` WRITE;
/*!40000 ALTER TABLE `schema_version` DISABLE KEYS */;
INSERT INTO `schema_version` VALUES (0,'temporal_visibility','2025-10-29 05:45:10.218202','1.1','0.1');
/*!40000 ALTER TABLE `schema_version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-29  5:45:55
