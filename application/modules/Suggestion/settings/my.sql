
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: my.sql (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
 
-- -------------------------------------------------------- 
 
DROP TABLE IF EXISTS `engine4_suggestion_introductions`;
CREATE TABLE `engine4_suggestion_introductions` (
  `introduction_id` int(11) NOT NULL auto_increment,
  `content` text NOT NULL,
  PRIMARY KEY  (`introduction_id`)
);

-- --------------------------------------------------------

DROP TABLE IF EXISTS `engine4_suggestion_rejected`;
CREATE TABLE `engine4_suggestion_rejected` (
`rejected_id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
`owner_id` INT( 11 ) NOT NULL ,
`entity` VARCHAR( 20 ) NOT NULL ,
`entity_id` INT( 11 ) NOT NULL ,
`creation_date` datetime NOT NULL,
PRIMARY KEY (  `rejected_id` )
) ENGINE = MYISAM ;

-- --------------------------------------------------------

DROP TABLE IF EXISTS `engine4_suggestion_photos`;
CREATE TABLE `engine4_suggestion_photos` (
  `photo_id` int(11) unsigned NOT NULL,
  `collection_id` int(11) unsigned NOT NULL,
  `owner_id` int(11) NOT NULL,
  PRIMARY KEY  (`photo_id`),
  UNIQUE KEY `photo_id` (`photo_id`),
  KEY `owner_type` (`collection_id`)
) ENGINE=MyISAM ;

-- --------------------------------------------------------

DROP TABLE IF EXISTS `engine4_suggestion_suggestions`;
CREATE TABLE `engine4_suggestion_suggestions` (
  `suggestion_id` int(11) NOT NULL auto_increment,
  `owner_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `entity` varchar(20) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY  (`suggestion_id`)
);

-- --------------------------------------------------------

DROP TABLE IF EXISTS `engine4_suggestion_albums`;
CREATE TABLE `engine4_suggestion_albums` (
  `album_id` int(11) NOT NULL auto_increment,
  `suggestion_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  PRIMARY KEY  (`album_id`)
) ENGINE=MyISAM ;

-- --------------------------------------------------------
--
-- Dumping data for table `engine4_core_menuitems`
--

INSERT INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `custom`, `order`) VALUES
('suggestion_admin_global', 'suggestion', 'Global Settings', NULL, '{"route":"admin_default","module":"suggestion","controller":"global","action":"global"}', 'sugg_admin_main', NULL, 0, 1),

('module_suggestion', 'suggestion', 'Suggestions', '', '{"route":"admin_default","module":"suggestion","controller":"global","action":"global"}', 'core_admin_main_plugins', '', 0, 999),

('suggestion_find_friend', 'suggestion', 'Find Friends', 'Suggestion_Plugin_Menus', '{"route":"default", "icon":"application/modules/Suggestion/externals/images/user-ex.png"}', 'user_home', '', 0, '999'),

('suggestion_explore_suggestion', 'suggestion', 'Explore Suggestions', 'Suggestion_Plugin_Menus', '{"route":"default", "icon":"application/modules/Suggestion/externals/images/sugg_explore.png"}', 'user_home', '', 0, '999'),

('suggestion_friend_profile', 'suggestion', 'Find Friends', 'Suggestion_Plugin_Menus', '{"route":"default", "icon":"application/modules/Suggestion/externals/images/user-ex.png"}', 'user_profile', '', 0, '999');

-- --------------------------------------------------------

--
-- Dumping data for table `engine4_core_modules`
--
INSERT INTO `engine4_core_modules` (`name`, `title`, `description`, `version`, `enabled`, `type`) VALUES
('suggestion', 'Suggestions', 'Suggestions', '4.0.5', 1, 'extra');

-- --------------------------------------------------------
--
-- Dumping data for table `engine4_activity_notificationtypes`
--

INSERT INTO `engine4_activity_notificationtypes` (
`type` ,
`module` ,
`body` ,
`is_request` ,
`handler`
)
VALUES (
'group_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:group}.',  '1',  'suggestion.widget.request-group'
),(
'blog_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:blog}.',  '1',  'suggestion.widget.request-blog'
), (
'event_suggestion',  'suggestion',  '{item:$subject} has suggested to you an {item:$object:event}.',  '1',  'suggestion.widget.request-event'
), (
'album_suggestion',  'suggestion',  '{item:$subject} has suggested to you an {item:$object:album}.',  '1',  'suggestion.widget.request-album'
), (
'classified_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:classified}.',  '1',  'suggestion.widget.request-class'
), (
'video_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:video}.',  '1',  'suggestion.widget.request-video'
), (
'music_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:music}.',  '1',  'suggestion.widget.request-music'
), (
'picture_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:profile photo}.',  '1',  'suggestion.widget.request-photo'
), (
'poll_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:poll}.',  '1',  'suggestion.widget.request-poll'
),(
'forum_suggestion',  'suggestion',  '{item:$subject} has suggested to you a {item:$object:forum}.',  '1',  'suggestion.widget.request-forum'
)
;

-- --------------------------------------------------------
--
-- Dumping data for table `engine4_authorization_permissions`
--


INSERT INTO `engine4_authorization_permissions` (`level_id`, `type`, `name`, `value`, `params`) VALUES
(1, 'suggestion', 'view', 2, NULL),
(2, 'suggestion', 'view', 2, NULL),
(3, 'suggestion', 'view', 2, NULL),
(4, 'suggestion', 'view', 1, NULL);

-- --------------------------------------------------------
--
-- Dumping data for table `engine4_core_settings`
--

INSERT INTO `engine4_core_settings` (`name`, `value`) VALUES
('sugg.mix.wid', '5'),
('sugg.music.wid', '5'),
('sugg.album.wid', '5'),
('sugg.event.wid', '5'),
('suggestion.field.cat', '0'),
('suggestion.popups.limit', '20'),
('sugg.friend.wid', '3'),
('sugg.group.wid', '5'),
('sugg.classified.wid', '5'),
('sugg.video.wid', '5'),
('sugg.blog.wid', '5'),
('sugg.admin.introduction', '0'),
('after.group.create', '1'),
('after.group.join', '1'),
('send.friend.popup', '1'),
('accept.friend.popup', '1'),
('after.classified.create', '1'),
('after.video.create', '1'),
('after.blog.create', '1'),
('after.event.create', '1'),
('after.event.join', '1'),
('after.album.create', '1'),
('after.music.create', '1'),
('sugg.forum.wid', '2'),
('after.forum.create', '1'),
('after.forum.join', '1'),
('sugg.poll.wid', '2'),
('after.poll.create', '1'),
('sugg.bg.color', '#ffffff'),
('mix.serialize', 'a:12:{i:0;s:13:"messagefriend";i:1;s:15:"friendfewfriend";i:2;s:11:"friendphoto";i:3;s:5:"group";i:4;s:5:"event";i:5;s:10:"classified";i:6;s:5:"album";i:7;s:5:"video";i:8;s:5:"music";i:9;s:4:"blog";i:10;s:4:"poll";i:11;s:5:"forum";}');

-- --------------------------------------------------------

UPDATE  `engine4_activity_notificationtypes` SET  `handler` =  'suggestion.widget.request-accept' WHERE CONVERT( `engine4_activity_notificationtypes`.`type` USING utf8 ) =  'friend_request' LIMIT 1 ;


-- --------------------------------------------------------
--
-- Dumping data for table `engine4_suggestion_introductions`
--

INSERT INTO  `engine4_suggestion_introductions` (
`introduction_id` ,
`content`
)
VALUES (
1,  ''
);