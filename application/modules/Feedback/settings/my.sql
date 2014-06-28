-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedbacks`
--

DROP TABLE IF EXISTS `engine4_feedbacks`;
CREATE TABLE IF NOT EXISTS `engine4_feedbacks` (
  `feedback_id` int(10) NOT NULL auto_increment,
  `owner_id` int(11) NOT NULL,
  `owner_type` varchar(128) NOT NULL,
  `category_id` INT( 11 ) NOT NULL DEFAULT '0',
  `feedback_title` text NOT NULL,
  `feedback_slug` TEXT NOT NULL,
  `feedback_description` text NOT NULL,
  `image_id` INT( 12 ) NOT NULL,
  `feedback_private` VARCHAR( 10 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `ip_address` varchar(128) NOT NULL,
  `browser_name` text NOT NULL,
  `modified_date` datetime NOT NULL,
  `comment_count` int(11) NOT NULL DEFAULT '0',
  `views` int( 10 ) NOT NULL,
  `severity_id` INT( 5 ) NOT NULL DEFAULT '0',
  `search` TINYINT( 2 ) NOT NULL DEFAULT '1',
  `featured` TINYINT( 2 ) NOT NULL DEFAULT '0',
  `stat_id` INT( 5 ) NOT NULL DEFAULT '0',
  `status_body` text NOT NULL,
  `total_votes` INT( 11 ) NOT NULL DEFAULT '0',
  `total_images` INT( 11 ) NOT NULL DEFAULT '0',
  `user_id` int(12) NOT NULL default '-1',
  `anonymous_email` varchar(128) character set utf8 collate utf8_unicode_ci default NULL,
  `anonymous_name` varchar(128) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`feedback_id`),
  KEY `owner_type` (`owner_type`, `owner_id`),
  KEY `search` (`search`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_albums`
--


DROP TABLE IF EXISTS `engine4_feedback_albums`;
CREATE TABLE `engine4_feedback_albums` (
  `album_id` int(11) NOT NULL AUTO_INCREMENT,
  `feedback_id` int(11) NOT NULL,
  `collectible_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`album_id`),
  KEY `feedback_id` (`feedback_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;


-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_images`
--


DROP TABLE IF EXISTS `engine4_feedback_images`;
CREATE TABLE `engine4_feedback_images` (
  `image_id` int(11) NOT NULL AUTO_INCREMENT,
  `album_id` int(11) NOT NULL,
  `feedback_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `collection_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `album_id` (`album_id`),
  KEY `feedback_id` (`feedback_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;


-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_categories`
--

DROP TABLE IF EXISTS `engine4_feedback_categories`;
CREATE TABLE `engine4_feedback_categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `category_name` varchar(128) NOT NULL,
  PRIMARY KEY (`category_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `engine4_feedback_categories`
--

INSERT IGNORE INTO `engine4_feedback_categories` (`category_id`, `user_id`, `category_name`) VALUES
(1, 1, 'Idea'),
(2, 1, 'Question'),
(3, 1, 'Problem'),
(4, 1, 'Praise');

-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_severities`
--

DROP TABLE IF EXISTS `engine4_feedback_severities`;
CREATE TABLE `engine4_feedback_severities` (
  `severity_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `severity_name` varchar(128) NOT NULL,
  PRIMARY KEY (`severity_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `engine4_feedback_severities`
--

INSERT IGNORE INTO `engine4_feedback_severities` (`severity_id`, `user_id`, `severity_name`) VALUES
(1, 1, 'Feature'),
(2, 1, 'Trivial'),
(3, 1, 'Text'),
(4, 1, 'Tweak'),
(5, 1, 'Minor'),
(6, 1, 'Major'),
(7, 1, 'Crash'),
(8, 1, 'Block');

-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_status`
--

DROP TABLE IF EXISTS `engine4_feedback_status`;
CREATE TABLE `engine4_feedback_status` (
  `stat_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `stat_name` varchar(128) NOT NULL,
  `stat_color` VARCHAR( 128 ) NOT NULL DEFAULT '#f00ce8',
  PRIMARY KEY (`stat_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `engine4_feedback_status`
--

INSERT IGNORE INTO `engine4_feedback_status` (`stat_id`, `user_id`, `stat_name`, `stat_color`) VALUES
(1, 1, 'Planned', '#F0BA00'),
(2, 1, 'Started', '#6FBC00'),
(3, 1, 'Completed', '#7D7EDF'),
(4, 1, 'Declined', '#BBBBBB'),
(5, 1, 'Response', '#0d0af0'),
(6, 1, 'Under Review', '#999999');

-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_votes`
--

DROP TABLE IF EXISTS `engine4_feedback_votes`;
CREATE TABLE `engine4_feedback_votes` (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `feedback_id` int(11) NOT NULL,
  `voter_id` int(11) NOT NULL,
  `total_votes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vote_id`),
  KEY `voter_id` (`voter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_blockusers`
--

DROP TABLE IF EXISTS `engine4_feedback_blockusers`;
CREATE TABLE `engine4_feedback_blockusers` (
  `blockuser_id` int(11) NOT NULL ,
  `block_comment` int(11) NOT NULL DEFAULT '0',
  `block_feedback` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`blockuser_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `engine4_feedback_blockips`
--

DROP TABLE IF EXISTS `engine4_feedback_blockips`;
CREATE TABLE `engine4_feedback_blockips` (
  `blockip_id` int(11) NOT NULL  AUTO_INCREMENT,
  `blockip_address` varchar(128) NOT NULL,
  `blockip_comment` int(11) NOT NULL DEFAULT '0',
  `blockip_feedback` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`blockip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- --------------------------------------------------------
--
-- Dumping data for table `engine4_core_menuitems`
--

INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `order`) VALUES
('core_sitemap_feedback', 'feedback', 'Feedback', '', '{"route":"feedback_browse"}', 'core_sitemap', '', 4),

('core_admin_main_plugins_feedback', 'feedback', 'Feedbacks', '', '{"route":"admin_default","module":"feedback","controller":"settings"}', 'core_admin_main_plugins', '', 999),

('feedback_admin_main_manage', 'feedback', 'View Feedbacks', '', '{"route":"admin_default","module":"feedback","controller":"manage"}', 'feedback_admin_main', '', 1),
('feedback_admin_main_settings', 'feedback', 'Global Settings', '', '{"route":"admin_default","module":"feedback","controller":"settings"}', 'feedback_admin_main', '', 2),
('feedback_admin_main_severities', 'feedback', 'Severities', '', '{"route":"admin_default","module":"feedback","controller":"settings", "action":"severities"}', 'feedback_admin_main', '', 3),
('feedback_admin_main_categories', 'feedback', 'Categories', '', '{"route":"admin_default","module":"feedback","controller":"settings", "action":"categories"}', 'feedback_admin_main', '', 4),
('feedback_admin_main_status', 'feedback', 'Status', '', '{"route":"admin_default","module":"feedback","controller":"settings", "action":"status"}', 'feedback_admin_main', '', 5),
('feedback_admin_main_blockuser', 'feedback', 'Block Users', '', '{"route":"admin_default","module":"feedback","controller":"manage", "action":"blockuser"}', 'feedback_admin_main', '', 6),
('feedback_admin_main_blockips', 'feedback', 'Block IP Addresses', '', '{"route":"admin_default","module":"feedback","controller":"settings", "action":"blockips"}', 'feedback_admin_main', '', 7),
('feedback_admin_main_statistic', 'feedback', 'Statistics', '', '{"route":"admin_default","module":"feedback","controller":"settings", "action":"statistic"}', 'feedback_admin_main', '', 8);

-- --------------------------------------------------------

--
-- Dumping data for table `engine4_core_modules`
--



INSERT INTO `engine4_core_modules` (`name`, `title`, `description`, `version`, `enabled`, `type`) VALUES
('feedback', 'Feedbacks', 'Feedbacks', '4.0.2', 1, 'extra');


-- --------------------------------------------------------

--
-- Dumping data for table `engine4_activity_actiontypes`
--


INSERT INTO `engine4_activity_actiontypes` (`type`, `module`, `body`, `enabled`, `displayable`, `attachable`, `commentable`, `shareable`, `is_generated`) VALUES
('feedback_new', 'feedback', '{item:$subject} wrote a new feedback:', 1, 5, 1, 3, 1, 1),
('comment_feedback', 'feedback', '{item:$subject} commented on {item:$owner}''s {item:$object:feedback}: {body:$body}', 1, 1, 1, 1, 1, 0);

-- --------------------------------------------------------

--
-- Dumping data for table `engine4_authorization_permissions`
--

INSERT IGNORE INTO `engine4_authorization_permissions` (`level_id`, `type`, `name`, `value`, `params`) VALUES
(1, 'feedback', 'comment', 1, NULL),
(1, 'feedback', 'view', 1, NULL),
(1, 'feedback', 'auth_comment', 1, 'a:4:{i:0;s:8:"everyone";i:1;s:13:"member_member";i:2;s:6:"member";i:3;s:5:"owner";}'),

(2, 'feedback', 'comment', 2, NULL),
(2, 'feedback', 'view', 1, NULL),
(2, 'feedback', 'auth_comment', 1, 'a:4:{i:0;s:8:"everyone";i:1;s:13:"member_member";i:2;s:6:"member";i:3;s:5:"owner";}'),

(3, 'feedback', 'comment', 1, NULL),
(3, 'feedback', 'view', 1, NULL),
(3, 'feedback', 'auth_comment', 1, 'a:4:{i:0;s:8:"everyone";i:1;s:13:"member_member";i:2;s:6:"member";i:3;s:5:"owner";}'),

(4, 'feedback', 'comment', 1, NULL),
(4, 'feedback', 'view', 1, NULL),
(4, 'feedback', 'auth_comment', 1, 'a:4:{i:0;s:8:"everyone";i:1;s:13:"member_member";i:2;s:6:"member";i:3;s:5:"owner";}'),

(5, 'feedback', 'view', 1, NULL),
(5, 'feedback', 'auth_comment', 1, 'a:4:{i:0;s:8:"everyone";i:1;s:13:"member_member";i:2;s:6:"member";i:3;s:5:"owner";}');

-- --------------------------------------------------------

--
-- Dumping data for table `engine4_core_settings`
--

INSERT INTO `engine4_core_settings` (`name`, `value`) VALUES
('feedback.allow.image', 1),
('feedback.license.key', ''),
('feedback.show.browse', 1),
('feedback.default.visibility', 'public'),
('feedback.email.notify', 1),
('feedback.page', 10),
('feedback.public', 1),
('feedback.post', 0),
('feedback.option.post', 0),
('feedback.report', 1),
('feedback.button.color1', '#0267cc'),
('feedback.button.color2', '#ff0000'),
('feedback.button.position', 1),
('feedback.severity', 1),
('feedbackbutton.visible', 0);

-- --------------------------------------------------------

--
-- Dumping data for table `engine4_core_mailtemplates`
--
INSERT IGNORE INTO `engine4_core_mailtemplates` (`type`, `vars`) VALUES
('notify_feedback_create', '[feedback_title], [feedback_owner], [feedback_status], [feedback_date], [email]');

