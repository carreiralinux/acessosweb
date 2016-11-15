-- Créditos do desenvolvedor.
-- Copyright (C) 1996-2016 The Squid Software Foundation and contributors
--
-- Squid software is distributed under GPLv2+ license and includes
-- contributions from numerous individuals and organizations.
-- Please see the COPYING and CONTRIBUTORS files for details.
--

CREATE DATABASE IF NOT EXISTS `squid_log` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `squid_log`;

DROP TABLE IF EXISTS `access_log`;
CREATE TABLE `access_log` (
  `id` int(11) NOT NULL,
  `time_since_epoch` decimal(15,3) DEFAULT NULL,
  `time_response` int(11) DEFAULT NULL,
  `ip_client` char(15) DEFAULT NULL,
  `ip_server` char(15) DEFAULT NULL,
  `http_status_code` varchar(10) DEFAULT NULL,
  `http_reply_size` int(11) DEFAULT NULL,
  `http_method` varchar(20) DEFAULT NULL,
  `http_url` text,
  `http_username` varchar(20) DEFAULT NULL,
  `http_mime_type` varchar(50) DEFAULT NULL,
  `squid_hier_status` varchar(20) DEFAULT NULL,
  `squid_request_status` varchar(20) DEFAULT NULL,
  `date_day` date DEFAULT NULL,
  `date_time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TRIGGER IF EXISTS `extract_date_day_bi`;
DELIMITER $$
CREATE TRIGGER `extract_date_day_bi` BEFORE INSERT ON `access_log` FOR EACH ROW BEGIN
	SET NEW.date_day  = DATE(FROM_UNIXTIME(NEW.time_since_epoch));
    SET NEW.date_time = TIME(FROM_UNIXTIME(NEW.time_since_epoch));
END
$$
DELIMITER ;
DROP VIEW IF EXISTS `avg_req_per_minute`;
CREATE TABLE `avg_req_per_minute` (
`COUNT(*)` bigint(21)
);
DROP VIEW IF EXISTS `biggest_requests`;
CREATE TABLE `biggest_requests` (
`id` int(11)
,`time_since_epoch` decimal(15,3)
,`time_response` int(11)
,`ip_client` char(15)
,`ip_server` char(15)
,`http_status_code` varchar(10)
,`http_reply_size` int(11)
,`http_method` varchar(20)
,`http_url` text
,`http_username` varchar(20)
,`http_mime_type` varchar(50)
,`squid_hier_status` varchar(20)
,`squid_request_status` varchar(20)
,`date_day` date
,`date_time` time
);
DROP VIEW IF EXISTS `cache_clients`;
CREATE TABLE `cache_clients` (
`ip_client` char(15)
);
DROP VIEW IF EXISTS `cache_clients_with_infos`;
CREATE TABLE `cache_clients_with_infos` (
`ip_client` char(15)
,`total_requests` bigint(21)
,`requests_perc` decimal(27,4)
,`total_traffic` decimal(32,0)
,`traffic_perc` decimal(39,4)
,`hit_perc` decimal(27,4)
,`miss_perc` decimal(27,4)
,`first_access_date` date
,`first_access_time` time
,`last_access_date` date
,`last_access_time` time
);
DROP VIEW IF EXISTS `days_with_infos`;
CREATE TABLE `days_with_infos` (
`date_day` date
,`first_req_time` time
,`last_req_time` time
,`number_of_requests` bigint(21)
,`total_traffic_bytes` decimal(32,0)
,`total_traffic_megabytes` decimal(36,4)
,`number_of_clients` bigint(21)
,`avg_time_response` decimal(14,4)
,`max_time_response` int(11)
,`most_active_client_r` varchar(15)
,`most_active_client_r_nr` bigint(21)
,`most_active_client_r_pc` decimal(27,4)
,`most_active_client_t` varchar(15)
,`most_active_client_t_b` decimal(32,0)
,`most_active_client_t_mb` decimal(36,4)
,`most_active_client_t_pc` decimal(39,4)
);
DROP VIEW IF EXISTS `hits_misses_perc`;
CREATE TABLE `hits_misses_perc` (
`hits` varchar(6)
,`percentage` decimal(27,4)
);
DROP VIEW IF EXISTS `hits_per_day`;
CREATE TABLE `hits_per_day` (
`date_day` date
,`num_hits` bigint(21)
);
DROP VIEW IF EXISTS `hits_per_day_perc`;
CREATE TABLE `hits_per_day_perc` (
`date_day` date
,`hits_per_day_perc` decimal(27,4)
);
DROP VIEW IF EXISTS `http_methods`;
CREATE TABLE `http_methods` (
`http_method` varchar(20)
,`COUNT(*)` bigint(21)
);
DROP VIEW IF EXISTS `http_methods_perc`;
CREATE TABLE `http_methods_perc` (
`http_method` varchar(20)
,`perc` decimal(27,4)
);
DROP VIEW IF EXISTS `last_10_queries`;
CREATE TABLE `last_10_queries` (
`id` int(11)
,`time_since_epoch` decimal(15,3)
,`time_response` int(11)
,`ip_client` char(15)
,`ip_server` char(15)
,`http_status_code` varchar(10)
,`http_reply_size` int(11)
,`http_method` varchar(20)
,`http_url` text
,`http_username` varchar(20)
,`http_mime_type` varchar(50)
,`squid_hier_status` varchar(20)
,`squid_request_status` varchar(20)
,`date_day` date
,`date_time` time
);
DROP VIEW IF EXISTS `last_10_queries_by_client`;
CREATE TABLE `last_10_queries_by_client` (
`id` int(11)
,`time_since_epoch` decimal(15,3)
,`time_response` int(11)
,`ip_client` char(15)
,`ip_server` char(15)
,`http_status_code` varchar(10)
,`http_reply_size` int(11)
,`http_method` varchar(20)
,`http_url` text
,`http_username` varchar(20)
,`http_mime_type` varchar(50)
,`squid_hier_status` varchar(20)
,`squid_request_status` varchar(20)
,`date_day` date
,`date_time` time
);
DROP VIEW IF EXISTS `last_query_by_client`;
CREATE TABLE `last_query_by_client` (
`ip_client` char(15)
,`last_query_id` int(11)
);
DROP VIEW IF EXISTS `most_active_clients`;
CREATE TABLE `most_active_clients` (
`ip_client` char(15)
,`total_bytes` decimal(32,0)
,`total_kilobytes` decimal(36,4)
,`total_megabytes` decimal(36,4)
);
DROP VIEW IF EXISTS `requests_in_last_minute`;
CREATE TABLE `requests_in_last_minute` (
`id` int(11)
,`time_since_epoch` decimal(15,3)
,`time_response` int(11)
,`ip_client` char(15)
,`ip_server` char(15)
,`http_status_code` varchar(10)
,`http_reply_size` int(11)
,`http_method` varchar(20)
,`http_url` text
,`http_username` varchar(20)
,`http_mime_type` varchar(50)
,`squid_hier_status` varchar(20)
,`squid_request_status` varchar(20)
,`date_day` date
,`date_time` time
);
DROP VIEW IF EXISTS `requests_per_day`;
CREATE TABLE `requests_per_day` (
`date_day` date
,`num_of_requests` bigint(21)
);
DROP VIEW IF EXISTS `requests_per_day_2`;
CREATE TABLE `requests_per_day_2` (
`date_day` date
,`num_of_requests` bigint(21)
);
DROP VIEW IF EXISTS `requests_per_day_per_client`;
CREATE TABLE `requests_per_day_per_client` (
`date_day` date
,`ip_client` char(15)
,`num_of_requests` bigint(21)
);
DROP VIEW IF EXISTS `requests_per_minute`;
CREATE TABLE `requests_per_minute` (
`date_day` date
,`date_hour` int(2)
,`date_minute` int(2)
,`num_of_requests` bigint(21)
);
DROP VIEW IF EXISTS `requests_status_perc`;
CREATE TABLE `requests_status_perc` (
`squid_request_status` varchar(20)
,`percentage` decimal(27,4)
);
DROP VIEW IF EXISTS `slowest_requests`;
CREATE TABLE `slowest_requests` (
`id` int(11)
,`time_since_epoch` decimal(15,3)
,`time_response` int(11)
,`ip_client` char(15)
,`ip_server` char(15)
,`http_status_code` varchar(10)
,`http_reply_size` int(11)
,`http_method` varchar(20)
,`http_url` text
,`http_username` varchar(20)
,`http_mime_type` varchar(50)
,`squid_hier_status` varchar(20)
,`squid_request_status` varchar(20)
,`date_day` date
,`date_time` time
);
DROP VIEW IF EXISTS `slowest_request_by_method`;
CREATE TABLE `slowest_request_by_method` (
`id` int(11)
,`time_since_epoch` decimal(15,3)
,`time_response` int(11)
,`ip_client` char(15)
,`ip_server` char(15)
,`http_status_code` varchar(10)
,`http_reply_size` int(11)
,`http_method` varchar(20)
,`http_url` text
,`http_username` varchar(20)
,`http_mime_type` varchar(50)
,`squid_hier_status` varchar(20)
,`squid_request_status` varchar(20)
,`date_day` date
,`date_time` time
);
DROP VIEW IF EXISTS `time_response_graph`;
CREATE TABLE `time_response_graph` (
`time_response` int(11)
,`num_req` bigint(21)
);
DROP VIEW IF EXISTS `time_response_ranges`;
CREATE TABLE `time_response_ranges` (
`0..500` varchar(10)
,`percentage` decimal(27,4)
);
DROP VIEW IF EXISTS `traffic_by_client`;
CREATE TABLE `traffic_by_client` (
`ip_client` char(15)
,`total_bytes` decimal(32,0)
,`total_kilobytes` decimal(36,4)
,`total_megabytes` decimal(36,4)
);
DROP VIEW IF EXISTS `traffic_by_http_mime_type`;
CREATE TABLE `traffic_by_http_mime_type` (
`http_mime_type` varchar(50)
,`total_bytes` decimal(32,0)
);
DROP VIEW IF EXISTS `traffic_per_day`;
CREATE TABLE `traffic_per_day` (
`date_day` date
,`total_bytes` decimal(32,0)
,`total_kilobytes` decimal(36,4)
,`total_megabytes` decimal(36,4)
);
DROP VIEW IF EXISTS `traffic_per_day_per_client`;
CREATE TABLE `traffic_per_day_per_client` (
`date_day` date
,`ip_client` char(15)
,`total_bytes` decimal(32,0)
,`total_kilobytes` decimal(36,4)
,`total_megabytes` decimal(36,4)
);
DROP VIEW IF EXISTS `traffic_per_month_per_client`;
CREATE TABLE `traffic_per_month_per_client` (
`date_year` int(4)
,`date_month` int(2)
,`ip_client` char(15)
,`total_bytes` decimal(32,0)
,`total_kilobytes` decimal(36,4)
,`total_megabytes` decimal(36,4)
);
DROP TABLE IF EXISTS `avg_req_per_minute`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `avg_req_per_minute`  AS  select count(0) AS `COUNT(*)` from `requests_in_last_minute` ;
DROP TABLE IF EXISTS `biggest_requests`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `biggest_requests`  AS  select `access_log`.`id` AS `id`,`access_log`.`time_since_epoch` AS `time_since_epoch`,`access_log`.`time_response` AS `time_response`,`access_log`.`ip_client` AS `ip_client`,`access_log`.`ip_server` AS `ip_server`,`access_log`.`http_status_code` AS `http_status_code`,`access_log`.`http_reply_size` AS `http_reply_size`,`access_log`.`http_method` AS `http_method`,`access_log`.`http_url` AS `http_url`,`access_log`.`http_username` AS `http_username`,`access_log`.`http_mime_type` AS `http_mime_type`,`access_log`.`squid_hier_status` AS `squid_hier_status`,`access_log`.`squid_request_status` AS `squid_request_status`,`access_log`.`date_day` AS `date_day`,`access_log`.`date_time` AS `date_time` from `access_log` order by `access_log`.`http_reply_size` desc limit 10 ;
DROP TABLE IF EXISTS `cache_clients`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cache_clients`  AS  select distinct `access_log`.`ip_client` AS `ip_client` from `access_log` order by 1 ;
DROP TABLE IF EXISTS `cache_clients_with_infos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cache_clients_with_infos`  AS  select `a`.`ip_client` AS `ip_client`,count(0) AS `total_requests`,((count(0) / (select count(0) from `access_log`)) * 100) AS `requests_perc`,sum(`a`.`http_reply_size`) AS `total_traffic`,((sum(`a`.`http_reply_size`) / (select sum(`access_log`.`http_reply_size`) from `access_log`)) * 100) AS `traffic_perc`,(((select count(0) from `access_log` `a1` where ((`a1`.`ip_client` = `a`.`ip_client`) and (`a1`.`squid_request_status` like '%HIT%'))) / (select count(0) from `access_log`)) * 100) AS `hit_perc`,(((select count(0) from `access_log` `a1` where ((`a1`.`ip_client` = `a`.`ip_client`) and (`a1`.`squid_request_status` like '%MISS%'))) / (select count(0) from `access_log`)) * 100) AS `miss_perc`,min(`a`.`date_day`) AS `first_access_date`,min(`a`.`date_time`) AS `first_access_time`,max(`a`.`date_day`) AS `last_access_date`,max(`a`.`date_time`) AS `last_access_time` from `access_log` `a` group by 1 order by 1 ;
DROP TABLE IF EXISTS `days_with_infos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `days_with_infos`  AS  select `a`.`date_day` AS `date_day`,min(`a`.`date_time`) AS `first_req_time`,max(`a`.`date_time`) AS `last_req_time`,count(0) AS `number_of_requests`,sum(`a`.`http_reply_size`) AS `total_traffic_bytes`,(sum(`a`.`http_reply_size`) / 1048576) AS `total_traffic_megabytes`,count(distinct `a`.`ip_client`) AS `number_of_clients`,avg(`a`.`time_response`) AS `avg_time_response`,max(`a`.`time_response`) AS `max_time_response`,(select `r`.`ip_client` from `requests_per_day_per_client` `r` where (`r`.`date_day` = `a`.`date_day`) order by `r`.`num_of_requests` desc limit 1) AS `most_active_client_r`,(select `r`.`num_of_requests` from `requests_per_day_per_client` `r` where (`r`.`date_day` = `a`.`date_day`) order by `r`.`num_of_requests` desc limit 1) AS `most_active_client_r_nr`,(((select `r`.`num_of_requests` from `requests_per_day_per_client` `r` where (`r`.`date_day` = `a`.`date_day`) order by 1 desc limit 1) / (select count(0) from `access_log` `a1` where (`a`.`date_day` = `a1`.`date_day`))) * 100) AS `most_active_client_r_pc`,(select `t`.`ip_client` from `traffic_per_day_per_client` `t` where (`t`.`date_day` = `a`.`date_day`) order by `t`.`total_bytes` desc limit 1) AS `most_active_client_t`,(select `t`.`total_bytes` from `traffic_per_day_per_client` `t` where (`t`.`date_day` = `a`.`date_day`) order by `t`.`total_bytes` desc limit 1) AS `most_active_client_t_b`,((select `t`.`total_bytes` from `traffic_per_day_per_client` `t` where (`t`.`date_day` = `a`.`date_day`) order by `t`.`total_bytes` desc limit 1) / 1048576) AS `most_active_client_t_mb`,(((select `t`.`total_bytes` from `traffic_per_day_per_client` `t` where (`t`.`date_day` = `a`.`date_day`) order by `t`.`total_bytes` desc limit 1) / (select sum(`a1`.`http_reply_size`) from `access_log` `a1` where (`a`.`date_day` = `a1`.`date_day`))) * 100) AS `most_active_client_t_pc` from `access_log` `a` group by 1 order by 1 ;
DROP TABLE IF EXISTS `hits_misses_perc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hits_misses_perc`  AS  select 'hits' AS `hits`,(((select count(0) from `access_log` where (`access_log`.`squid_request_status` like '%HIT%')) / (select count(0) from `access_log`)) * 100) AS `percentage` union select 'misses' AS `misses`,(((select count(0) from `access_log` where (`access_log`.`squid_request_status` like '%MISS%')) / (select count(0) from `access_log`)) * 100) AS `pecentage` ;
DROP TABLE IF EXISTS `hits_per_day`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hits_per_day`  AS  select `access_log`.`date_day` AS `date_day`,count(0) AS `num_hits` from `access_log` where (`access_log`.`squid_request_status` like '%HIT%') group by 1 ;
DROP TABLE IF EXISTS `hits_per_day_perc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hits_per_day_perc`  AS  select `r`.`date_day` AS `date_day`,((`h`.`num_hits` / `r`.`num_of_requests`) * 100) AS `hits_per_day_perc` from (`requests_per_day` `r` join `hits_per_day` `h` on((`r`.`date_day` = `h`.`date_day`))) ;
DROP TABLE IF EXISTS `http_methods`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `http_methods`  AS  select `access_log`.`http_method` AS `http_method`,count(0) AS `COUNT(*)` from `access_log` group by 1 order by 1 ;
DROP TABLE IF EXISTS `http_methods_perc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `http_methods_perc`  AS  select `access_log`.`http_method` AS `http_method`,((count(0) / (select count(0) from `access_log`)) * 100) AS `perc` from `access_log` group by 1 order by 2 desc ;
DROP TABLE IF EXISTS `last_10_queries`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `last_10_queries`  AS  select `access_log`.`id` AS `id`,`access_log`.`time_since_epoch` AS `time_since_epoch`,`access_log`.`time_response` AS `time_response`,`access_log`.`ip_client` AS `ip_client`,`access_log`.`ip_server` AS `ip_server`,`access_log`.`http_status_code` AS `http_status_code`,`access_log`.`http_reply_size` AS `http_reply_size`,`access_log`.`http_method` AS `http_method`,`access_log`.`http_url` AS `http_url`,`access_log`.`http_username` AS `http_username`,`access_log`.`http_mime_type` AS `http_mime_type`,`access_log`.`squid_hier_status` AS `squid_hier_status`,`access_log`.`squid_request_status` AS `squid_request_status`,`access_log`.`date_day` AS `date_day`,`access_log`.`date_time` AS `date_time` from `access_log` where (`access_log`.`id` > ((select max(`access_log`.`id`) from `access_log`) - 10)) order by `access_log`.`id` desc ;
DROP TABLE IF EXISTS `last_10_queries_by_client`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `last_10_queries_by_client`  AS  select `a`.`id` AS `id`,`a`.`time_since_epoch` AS `time_since_epoch`,`a`.`time_response` AS `time_response`,`a`.`ip_client` AS `ip_client`,`a`.`ip_server` AS `ip_server`,`a`.`http_status_code` AS `http_status_code`,`a`.`http_reply_size` AS `http_reply_size`,`a`.`http_method` AS `http_method`,`a`.`http_url` AS `http_url`,`a`.`http_username` AS `http_username`,`a`.`http_mime_type` AS `http_mime_type`,`a`.`squid_hier_status` AS `squid_hier_status`,`a`.`squid_request_status` AS `squid_request_status`,`a`.`date_day` AS `date_day`,`a`.`date_time` AS `date_time` from `access_log` `a` where (`a`.`id` > ((select `l`.`last_query_id` from `last_query_by_client` `l` where (`l`.`ip_client` = `a`.`ip_client`)) - 10)) order by `a`.`ip_client`,`a`.`id` desc ;
DROP TABLE IF EXISTS `last_query_by_client`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `last_query_by_client`  AS  select `access_log`.`ip_client` AS `ip_client`,max(`access_log`.`id`) AS `last_query_id` from `access_log` group by `access_log`.`ip_client` ;
DROP TABLE IF EXISTS `most_active_clients`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `most_active_clients`  AS  select `access_log`.`ip_client` AS `ip_client`,sum(`access_log`.`http_reply_size`) AS `total_bytes`,(sum(`access_log`.`http_reply_size`) / 1024) AS `total_kilobytes`,(sum(`access_log`.`http_reply_size`) / 1048576) AS `total_megabytes` from `access_log` group by 1 order by 2 desc limit 10 ;
DROP TABLE IF EXISTS `requests_in_last_minute`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `requests_in_last_minute`  AS  select `access_log`.`id` AS `id`,`access_log`.`time_since_epoch` AS `time_since_epoch`,`access_log`.`time_response` AS `time_response`,`access_log`.`ip_client` AS `ip_client`,`access_log`.`ip_server` AS `ip_server`,`access_log`.`http_status_code` AS `http_status_code`,`access_log`.`http_reply_size` AS `http_reply_size`,`access_log`.`http_method` AS `http_method`,`access_log`.`http_url` AS `http_url`,`access_log`.`http_username` AS `http_username`,`access_log`.`http_mime_type` AS `http_mime_type`,`access_log`.`squid_hier_status` AS `squid_hier_status`,`access_log`.`squid_request_status` AS `squid_request_status`,`access_log`.`date_day` AS `date_day`,`access_log`.`date_time` AS `date_time` from `access_log` where (`access_log`.`time_since_epoch` >= ((select max(`access_log`.`time_since_epoch`) from `access_log`) - 60)) ;
DROP TABLE IF EXISTS `requests_per_day`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `requests_per_day`  AS  select cast(from_unixtime(`access_log`.`time_since_epoch`) as date) AS `date_day`,count(0) AS `num_of_requests` from `access_log` group by 1 order by 1 ;
DROP TABLE IF EXISTS `requests_per_day_2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `requests_per_day_2`  AS  select `access_log`.`date_day` AS `date_day`,count(0) AS `num_of_requests` from `access_log` group by 1 order by 1 ;
DROP TABLE IF EXISTS `requests_per_day_per_client`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `requests_per_day_per_client`  AS  select cast(from_unixtime(`access_log`.`time_since_epoch`) as date) AS `date_day`,`access_log`.`ip_client` AS `ip_client`,count(0) AS `num_of_requests` from `access_log` group by 1,2 order by 1,2 ;
DROP TABLE IF EXISTS `requests_per_minute`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `requests_per_minute`  AS  select cast(from_unixtime(`access_log`.`time_since_epoch`) as date) AS `date_day`,hour(from_unixtime(`access_log`.`time_since_epoch`)) AS `date_hour`,minute(from_unixtime(`access_log`.`time_since_epoch`)) AS `date_minute`,count(0) AS `num_of_requests` from `access_log` group by 1,2,3 order by 1,2,3 ;
DROP TABLE IF EXISTS `requests_status_perc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `requests_status_perc`  AS  select `access_log`.`squid_request_status` AS `squid_request_status`,((count(0) / (select count(0) from `access_log`)) * 100) AS `percentage` from `access_log` group by `access_log`.`squid_request_status` order by 2 desc ;
DROP TABLE IF EXISTS `slowest_requests`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `slowest_requests`  AS  select `access_log`.`id` AS `id`,`access_log`.`time_since_epoch` AS `time_since_epoch`,`access_log`.`time_response` AS `time_response`,`access_log`.`ip_client` AS `ip_client`,`access_log`.`ip_server` AS `ip_server`,`access_log`.`http_status_code` AS `http_status_code`,`access_log`.`http_reply_size` AS `http_reply_size`,`access_log`.`http_method` AS `http_method`,`access_log`.`http_url` AS `http_url`,`access_log`.`http_username` AS `http_username`,`access_log`.`http_mime_type` AS `http_mime_type`,`access_log`.`squid_hier_status` AS `squid_hier_status`,`access_log`.`squid_request_status` AS `squid_request_status`,`access_log`.`date_day` AS `date_day`,`access_log`.`date_time` AS `date_time` from `access_log` order by `access_log`.`time_response` desc limit 10 ;
DROP TABLE IF EXISTS `slowest_request_by_method`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `slowest_request_by_method`  AS  select `access_log`.`id` AS `id`,`access_log`.`time_since_epoch` AS `time_since_epoch`,`access_log`.`time_response` AS `time_response`,`access_log`.`ip_client` AS `ip_client`,`access_log`.`ip_server` AS `ip_server`,`access_log`.`http_status_code` AS `http_status_code`,`access_log`.`http_reply_size` AS `http_reply_size`,`access_log`.`http_method` AS `http_method`,`access_log`.`http_url` AS `http_url`,`access_log`.`http_username` AS `http_username`,`access_log`.`http_mime_type` AS `http_mime_type`,`access_log`.`squid_hier_status` AS `squid_hier_status`,`access_log`.`squid_request_status` AS `squid_request_status`,`access_log`.`date_day` AS `date_day`,`access_log`.`date_time` AS `date_time` from `access_log` group by `access_log`.`http_method` order by `access_log`.`http_method`,`access_log`.`time_response` desc ;
DROP TABLE IF EXISTS `time_response_graph`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `time_response_graph`  AS  select `access_log`.`time_response` AS `time_response`,count(0) AS `num_req` from `access_log` group by 1 order by 1 ;
DROP TABLE IF EXISTS `time_response_ranges`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `time_response_ranges`  AS  select '0..500' AS `0..500`,((count(0) / (select count(0) from `access_log`)) * 100) AS `percentage` from `access_log` where ((`access_log`.`time_response` >= 0) and (`access_log`.`time_response` < 500)) union select '500..1000' AS `500..1000`,((count(0) / (select count(0) from `access_log`)) * 100) AS `percentage` from `access_log` where ((`access_log`.`time_response` >= 500) and (`access_log`.`time_response` < 1000)) union select '1000..2000' AS `1000..2000`,((count(0) / (select count(0) from `access_log`)) * 100) AS `percentage` from `access_log` where ((`access_log`.`time_response` >= 1000) and (`access_log`.`time_response` < 2000)) union select '>= 2000' AS `>= 2000`,((count(0) / (select count(0) from `access_log`)) * 100) AS `percentage` from `access_log` where (`access_log`.`time_response` >= 2000) ;
DROP TABLE IF EXISTS `traffic_by_client`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `traffic_by_client`  AS  select `access_log`.`ip_client` AS `ip_client`,sum(`access_log`.`http_reply_size`) AS `total_bytes`,(sum(`access_log`.`http_reply_size`) / 1024) AS `total_kilobytes`,(sum(`access_log`.`http_reply_size`) / 1048576) AS `total_megabytes` from `access_log` group by 1 order by 1 ;
DROP TABLE IF EXISTS `traffic_by_http_mime_type`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `traffic_by_http_mime_type`  AS  select `access_log`.`http_mime_type` AS `http_mime_type`,sum(`access_log`.`http_reply_size`) AS `total_bytes` from `access_log` group by `access_log`.`http_mime_type` order by 2 desc ;
DROP TABLE IF EXISTS `traffic_per_day`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `traffic_per_day`  AS  select `access_log`.`date_day` AS `date_day`,sum(`access_log`.`http_reply_size`) AS `total_bytes`,(sum(`access_log`.`http_reply_size`) / 1024) AS `total_kilobytes`,(sum(`access_log`.`http_reply_size`) / 1048576) AS `total_megabytes` from `access_log` group by 1 order by 1 ;
DROP TABLE IF EXISTS `traffic_per_day_per_client`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `traffic_per_day_per_client`  AS  select `access_log`.`date_day` AS `date_day`,`access_log`.`ip_client` AS `ip_client`,sum(`access_log`.`http_reply_size`) AS `total_bytes`,(sum(`access_log`.`http_reply_size`) / 1024) AS `total_kilobytes`,(sum(`access_log`.`http_reply_size`) / 1048576) AS `total_megabytes` from `access_log` group by 1,2 order by 1,2 desc ;
DROP TABLE IF EXISTS `traffic_per_month_per_client`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `traffic_per_month_per_client`  AS  select year(`access_log`.`date_day`) AS `date_year`,month(`access_log`.`date_day`) AS `date_month`,`access_log`.`ip_client` AS `ip_client`,sum(`access_log`.`http_reply_size`) AS `total_bytes`,(sum(`access_log`.`http_reply_size`) / 1024) AS `total_kilobytes`,(sum(`access_log`.`http_reply_size`) / 1048576) AS `total_megabytes` from `access_log` group by 2,3 order by 1,2,3 ;


ALTER TABLE `access_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date_day_idx` (`date_day`),
  ADD KEY `client_ip_idx` (`ip_client`),
  ADD KEY `client_req_status_idx` (`ip_client`,`squid_request_status`),
  ADD KEY `req_status_idx` (`squid_request_status`),
  ADD KEY `time_response_idx` (`time_response`),
  ADD KEY `client_ip_record_id_idx` (`ip_client`,`id`);


ALTER TABLE `access_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
