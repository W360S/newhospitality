INSERT INTO `engine4_core_modules` (`name`, `title`, `description`, `version`, `enabled`, `type`) VALUES
('bang', 'Bang', 'Bang s modules', '0.0.1', 1, 'extra');

-- ADS MODULE 

DROP TABLE IF EXISTS `engine4_bang_requests`;
CREATE TABLE IF NOT EXISTS `engine4_bang_requests` (
  `request_id` int(10) NOT NULL auto_increment,
  `owner_id` int(11) NOT NULL,
  `owner_type` varchar(128) NOT NULL,
  `ad_title` text NOT NULL,
  `ad_subtitle` text NOT NULL,
  `ad_description` text NOT NULL,
  `user_id` int(12) NOT NULL default '-1',
  `ad_email` varchar(128) character set utf8 collate utf8_unicode_ci default NULL,
  `ad_phone` varchar(128) character set utf8 collate utf8_unicode_ci default NULL,
  `ad_name` varchar(128) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`request_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;	

INSERT IGNORE INTO `engine4_core_mailtemplates` (`type`, `vars`) VALUES
('notify_request_create', '[ad_title], [ad_subtitle], [ad_name], [ad_phone], [ad_email]');