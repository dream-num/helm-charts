-- MySQL dump 10.13  Distrib 8.3.0, for Linux (x86_64)
--
-- Host: localhost    Database: temporal
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
-- Table structure for table `activity_info_maps`
--

DROP TABLE IF EXISTS `activity_info_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_info_maps` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `schedule_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`,`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `buffered_events`
--

DROP TABLE IF EXISTS `buffered_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buffered_events` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `data` mediumblob NOT NULL,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`,`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `build_id_to_task_queue`
--

DROP TABLE IF EXISTS `build_id_to_task_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `build_id_to_task_queue` (
  `namespace_id` binary(16) NOT NULL,
  `build_id` varchar(255) NOT NULL,
  `task_queue_name` varchar(255) NOT NULL,
  PRIMARY KEY (`namespace_id`,`build_id`,`task_queue_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `child_execution_info_maps`
--

DROP TABLE IF EXISTS `child_execution_info_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `child_execution_info_maps` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `initiated_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`,`initiated_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_membership`
--

DROP TABLE IF EXISTS `cluster_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_membership` (
  `membership_partition` int NOT NULL,
  `host_id` binary(16) NOT NULL,
  `rpc_address` varchar(128) DEFAULT NULL,
  `rpc_port` smallint NOT NULL,
  `role` tinyint NOT NULL,
  `session_start` timestamp NULL DEFAULT '1970-01-02 00:00:01',
  `last_heartbeat` timestamp NULL DEFAULT '1970-01-02 00:00:01',
  `record_expiry` timestamp NULL DEFAULT '1970-01-02 00:00:01',
  PRIMARY KEY (`membership_partition`,`host_id`),
  KEY `role` (`role`,`host_id`),
  KEY `role_2` (`role`,`last_heartbeat`),
  KEY `rpc_address` (`rpc_address`,`role`),
  KEY `last_heartbeat` (`last_heartbeat`),
  KEY `record_expiry` (`record_expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_metadata`
--

DROP TABLE IF EXISTS `cluster_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_metadata` (
  `metadata_partition` int NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL DEFAULT 'Proto3',
  `version` bigint NOT NULL DEFAULT '1',
  PRIMARY KEY (`metadata_partition`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_metadata_info`
--

DROP TABLE IF EXISTS `cluster_metadata_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_metadata_info` (
  `metadata_partition` int NOT NULL,
  `cluster_name` varchar(255) NOT NULL,
  `data` mediumblob NOT NULL,
  `data_encoding` varchar(16) NOT NULL,
  `version` bigint NOT NULL,
  PRIMARY KEY (`metadata_partition`,`cluster_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `current_executions`
--

DROP TABLE IF EXISTS `current_executions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `current_executions` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `create_request_id` varchar(255) DEFAULT NULL,
  `state` int NOT NULL,
  `status` int NOT NULL,
  `start_version` bigint NOT NULL DEFAULT '0',
  `last_write_version` bigint NOT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `executions`
--

DROP TABLE IF EXISTS `executions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `executions` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `next_event_id` bigint NOT NULL,
  `last_write_version` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  `state` mediumblob,
  `state_encoding` varchar(16) NOT NULL,
  `db_record_version` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_immediate_tasks`
--

DROP TABLE IF EXISTS `history_immediate_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_immediate_tasks` (
  `shard_id` int NOT NULL,
  `category_id` int NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob NOT NULL,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`category_id`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_node`
--

DROP TABLE IF EXISTS `history_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_node` (
  `shard_id` int NOT NULL,
  `tree_id` binary(16) NOT NULL,
  `branch_id` binary(16) NOT NULL,
  `node_id` bigint NOT NULL,
  `txn_id` bigint NOT NULL,
  `data` mediumblob NOT NULL,
  `data_encoding` varchar(16) NOT NULL,
  `prev_txn_id` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`shard_id`,`tree_id`,`branch_id`,`node_id`,`txn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_scheduled_tasks`
--

DROP TABLE IF EXISTS `history_scheduled_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_scheduled_tasks` (
  `shard_id` int NOT NULL,
  `category_id` int NOT NULL,
  `visibility_timestamp` datetime(6) NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob NOT NULL,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`category_id`,`visibility_timestamp`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_tree`
--

DROP TABLE IF EXISTS `history_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_tree` (
  `shard_id` int NOT NULL,
  `tree_id` binary(16) NOT NULL,
  `branch_id` binary(16) NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`tree_id`,`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `namespace_metadata`
--

DROP TABLE IF EXISTS `namespace_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `namespace_metadata` (
  `partition_id` int NOT NULL,
  `notification_version` bigint NOT NULL,
  PRIMARY KEY (`partition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `namespaces`
--

DROP TABLE IF EXISTS `namespaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `namespaces` (
  `partition_id` int NOT NULL,
  `id` binary(16) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notification_version` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  `is_global` tinyint(1) NOT NULL,
  PRIMARY KEY (`partition_id`,`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `queue`
--

DROP TABLE IF EXISTS `queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queue` (
  `queue_type` int NOT NULL,
  `message_id` bigint NOT NULL,
  `message_payload` mediumblob,
  `message_encoding` varchar(16) NOT NULL DEFAULT 'Json',
  PRIMARY KEY (`queue_type`,`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `queue_metadata`
--

DROP TABLE IF EXISTS `queue_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queue_metadata` (
  `queue_type` int NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL DEFAULT 'Json',
  `version` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`queue_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replication_tasks`
--

DROP TABLE IF EXISTS `replication_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replication_tasks` (
  `shard_id` int NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replication_tasks_dlq`
--

DROP TABLE IF EXISTS `replication_tasks_dlq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replication_tasks_dlq` (
  `source_cluster_name` varchar(255) NOT NULL,
  `shard_id` int NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`source_cluster_name`,`shard_id`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `request_cancel_info_maps`
--

DROP TABLE IF EXISTS `request_cancel_info_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_cancel_info_maps` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `initiated_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`,`initiated_id`)
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

--
-- Table structure for table `shards`
--

DROP TABLE IF EXISTS `shards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shards` (
  `shard_id` int NOT NULL,
  `range_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `signal_info_maps`
--

DROP TABLE IF EXISTS `signal_info_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `signal_info_maps` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `initiated_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`,`initiated_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `signals_requested_sets`
--

DROP TABLE IF EXISTS `signals_requested_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `signals_requested_sets` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `signal_id` varchar(255) NOT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`,`signal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_queue_user_data`
--

DROP TABLE IF EXISTS `task_queue_user_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_queue_user_data` (
  `namespace_id` binary(16) NOT NULL,
  `task_queue_name` varchar(255) NOT NULL,
  `data` mediumblob NOT NULL,
  `data_encoding` varchar(16) NOT NULL,
  `version` bigint NOT NULL,
  PRIMARY KEY (`namespace_id`,`task_queue_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_queues`
--

DROP TABLE IF EXISTS `task_queues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_queues` (
  `range_hash` int unsigned NOT NULL,
  `task_queue_id` varbinary(272) NOT NULL,
  `range_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`range_hash`,`task_queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `range_hash` int unsigned NOT NULL,
  `task_queue_id` varbinary(272) NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`range_hash`,`task_queue_id`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timer_info_maps`
--

DROP TABLE IF EXISTS `timer_info_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timer_info_maps` (
  `shard_id` int NOT NULL,
  `namespace_id` binary(16) NOT NULL,
  `workflow_id` varchar(255) NOT NULL,
  `run_id` binary(16) NOT NULL,
  `timer_id` varchar(255) NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`shard_id`,`namespace_id`,`workflow_id`,`run_id`,`timer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timer_tasks`
--

DROP TABLE IF EXISTS `timer_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timer_tasks` (
  `shard_id` int NOT NULL,
  `visibility_timestamp` datetime(6) NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`visibility_timestamp`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transfer_tasks`
--

DROP TABLE IF EXISTS `transfer_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfer_tasks` (
  `shard_id` int NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `visibility_tasks`
--

DROP TABLE IF EXISTS `visibility_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visibility_tasks` (
  `shard_id` int NOT NULL,
  `task_id` bigint NOT NULL,
  `data` mediumblob NOT NULL,
  `data_encoding` varchar(16) NOT NULL,
  PRIMARY KEY (`shard_id`,`task_id`)
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

-- Dump completed on 2024-10-15  9:00:54
