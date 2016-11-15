CREATE DATABASE `squid_log` DEFAULT CHARACTER SET latin1 ;
USE `squid_log`;
CREATE TABLE `access_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
