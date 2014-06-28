-- MySQL dump 10.11
--
-- Host: localhost    Database: feeeddback
-- ------------------------------------------------------
-- Server version	5.0.67-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `engine4_activity_actions`
--

DROP TABLE IF EXISTS `engine4_activity_actions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_actions` (
  `action_id` int(11) unsigned NOT NULL auto_increment,
  `type` varchar(32) collate utf8_unicode_ci NOT NULL,
  `subject_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `subject_id` int(11) unsigned NOT NULL,
  `object_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `object_id` int(11) unsigned NOT NULL,
  `body` text collate utf8_unicode_ci,
  `params` text collate utf8_unicode_ci,
  `date` datetime NOT NULL,
  `attachment_count` smallint(3) unsigned NOT NULL default '0',
  `comment_count` mediumint(5) unsigned NOT NULL default '0',
  `like_count` mediumint(5) unsigned NOT NULL default '0',
  PRIMARY KEY  (`action_id`),
  KEY `SUBJECT` (`subject_type`,`subject_id`),
  KEY `OBJECT` (`object_type`,`object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_actions`
--

LOCK TABLES `engine4_activity_actions` WRITE;
/*!40000 ALTER TABLE `engine4_activity_actions` DISABLE KEYS */;
INSERT INTO `engine4_activity_actions` VALUES (1,'signup','user',2,'user',2,'','[]','2010-07-02 07:12:26',0,0,0);
/*!40000 ALTER TABLE `engine4_activity_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_actionsettings`
--

DROP TABLE IF EXISTS `engine4_activity_actionsettings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_actionsettings` (
  `user_id` int(11) unsigned NOT NULL,
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `publish` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`user_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_actionsettings`
--

LOCK TABLES `engine4_activity_actionsettings` WRITE;
/*!40000 ALTER TABLE `engine4_activity_actionsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_activity_actionsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_actiontypes`
--

DROP TABLE IF EXISTS `engine4_activity_actiontypes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_actiontypes` (
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `module` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL default '1',
  `displayable` tinyint(1) NOT NULL default '3',
  `attachable` tinyint(1) NOT NULL default '1',
  `commentable` tinyint(1) NOT NULL default '1',
  `shareable` tinyint(1) NOT NULL default '1',
  `is_generated` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_actiontypes`
--

LOCK TABLES `engine4_activity_actiontypes` WRITE;
/*!40000 ALTER TABLE `engine4_activity_actiontypes` DISABLE KEYS */;
INSERT INTO `engine4_activity_actiontypes` VALUES ('album_photo_new','album','{item:$subject} added {var:$count} photo(s) to the album {item:$object}:',1,5,1,3,1,1),('blog_new','blog','{item:$subject} wrote a new blog entry:',1,5,1,3,1,1),('classified_new','classified','{item:$subject} posted a new classified listing:',1,5,1,3,1,1),('comment_album','album','{item:$subject} commented on {item:$owner}\'s {item:$object:album}: {body:$body}',1,1,1,1,1,0),('comment_album_photo','album','{item:$subject} commented on {item:$owner}\'s {item:$object:photo}: {body:$body}',1,1,1,1,1,0),('comment_blog','blog','{item:$subject} commented on {item:$owner}\'s {item:$object:blog entry}: {body:$body}',1,1,1,1,1,0),('comment_classified','classified','{item:$subject} commented on {item:$owner}\'s {item:$object:classified listing}: {body:$body}',1,1,1,1,1,0),('comment_playlist','music','{item:$subject} commented on {item:$owner}\'s {item:$object:music_playlist}.',1,1,1,1,1,1),('comment_video','video','{item:$subject} commented on {item:$owner}\'s {item:$object:video}: {body:$body}',1,1,1,1,1,0),('event_create','event','{item:$subject} created a new event:',1,5,1,1,1,1),('event_join','event','{item:$subject} joined the event {item:$object}',1,3,1,1,1,1),('event_photo_upload','event','{item:$subject} added {var:$count} photo(s).',1,3,2,1,1,1),('event_topic_create','event','{item:$subject} posted a {item:$object:topic} in the event {itemParent:$object:event}: {body:$body}',1,3,1,1,1,1),('event_topic_reply','event','{item:$subject} replied to a {item:$object:topic} in the event {itemParent:$object:event}: {body:$body}',1,3,1,1,1,1),('fields_change_generic','fields','{item:$subject} changed their {translate:$label} to \"{var:$value}\".',1,3,1,1,1,1),('friends','user','{item:$subject} is now friends with {item:$object}.',1,3,0,1,1,1),('friends_follow','user','{item:$subject} is now following {item:$object}.',1,3,0,1,1,1),('group_create','group','{item:$subject} created a new group:',1,5,1,1,1,1),('group_join','group','{item:$subject} joined the group {item:$object}',1,3,1,1,1,1),('group_photo_upload','group','{item:$subject} added {var:$count} photo(s).',1,3,2,1,1,1),('group_promote','group','{item:$subject} has been made an officer for the group {item:$object}',1,3,1,1,1,1),('group_topic_create','group','{item:$subject} posted a {item:$object:topic} in the group {itemParent:$object:group}: {body:$body}',1,3,1,1,1,1),('group_topic_reply','group','{item:$subject} replied to a {item:$object:topic} in the group {itemParent:$object:group}: {body:$body}',1,3,1,1,1,1),('login','user','{item:$subject} has signed in.',0,1,0,1,1,1),('logout','user','{item:$subject} has signed out.',0,1,0,1,1,1),('music_playlist_new','music','{item:$subject} created a new playlist: {item:$object}',1,5,1,3,1,1),('network_join','network','{item:$subject} joined the network {item:$object}',1,3,1,1,1,1),('post','user','{actors:$subject:$object}: {body:$body}',1,7,1,1,1,0),('post_self','user','{item:$subject} {body:$body}',1,5,1,1,1,0),('profile_photo_update','user','{item:$subject} has added a new profile photo.',1,5,1,1,1,1),('signup','user','{item:$subject} has just signed up. Say hello!',1,5,0,1,1,1),('status','user','{item:$subject} {body:$body}',1,5,0,1,4,0),('tagged','user','{item:$subject} tagged {item:$object} in a {var:$label}:',1,7,1,1,0,1),('video_new','video','{item:$subject} posted a new video:',1,5,1,3,1,0);
/*!40000 ALTER TABLE `engine4_activity_actiontypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_attachments`
--

DROP TABLE IF EXISTS `engine4_activity_attachments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_attachments` (
  `attachment_id` int(11) unsigned NOT NULL auto_increment,
  `action_id` int(11) unsigned NOT NULL,
  `type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `id` int(11) unsigned NOT NULL,
  `mode` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`attachment_id`),
  KEY `action_id` (`action_id`),
  KEY `type_id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_attachments`
--

LOCK TABLES `engine4_activity_attachments` WRITE;
/*!40000 ALTER TABLE `engine4_activity_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_activity_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_comments`
--

DROP TABLE IF EXISTS `engine4_activity_comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_comments` (
  `comment_id` int(11) unsigned NOT NULL auto_increment,
  `resource_id` int(11) unsigned NOT NULL,
  `poster_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `poster_id` int(11) unsigned NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY  (`comment_id`),
  KEY `resource_type` (`resource_id`),
  KEY `poster_type` (`poster_type`,`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_comments`
--

LOCK TABLES `engine4_activity_comments` WRITE;
/*!40000 ALTER TABLE `engine4_activity_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_activity_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_likes`
--

DROP TABLE IF EXISTS `engine4_activity_likes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_likes` (
  `like_id` int(11) unsigned NOT NULL auto_increment,
  `resource_id` int(11) unsigned NOT NULL,
  `poster_type` varchar(16) character set latin1 collate latin1_general_ci NOT NULL,
  `poster_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`like_id`),
  KEY `resource_id` (`resource_id`),
  KEY `poster_type` (`poster_type`,`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_likes`
--

LOCK TABLES `engine4_activity_likes` WRITE;
/*!40000 ALTER TABLE `engine4_activity_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_activity_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_notifications`
--

DROP TABLE IF EXISTS `engine4_activity_notifications`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_notifications` (
  `notification_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `subject_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `subject_id` int(11) unsigned NOT NULL,
  `object_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `object_id` int(11) unsigned NOT NULL,
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `params` text collate utf8_unicode_ci,
  `read` tinyint(1) NOT NULL default '0',
  `mitigated` tinyint(1) NOT NULL default '0',
  `date` datetime NOT NULL,
  PRIMARY KEY  (`notification_id`),
  KEY `LOOKUP` (`user_id`,`date`),
  KEY `subject` (`subject_type`,`subject_id`),
  KEY `object` (`object_type`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_notifications`
--

LOCK TABLES `engine4_activity_notifications` WRITE;
/*!40000 ALTER TABLE `engine4_activity_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_activity_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_notificationsettings`
--

DROP TABLE IF EXISTS `engine4_activity_notificationsettings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_notificationsettings` (
  `user_id` int(11) unsigned NOT NULL,
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `email` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`user_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_notificationsettings`
--

LOCK TABLES `engine4_activity_notificationsettings` WRITE;
/*!40000 ALTER TABLE `engine4_activity_notificationsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_activity_notificationsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_notificationtypes`
--

DROP TABLE IF EXISTS `engine4_activity_notificationtypes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_notificationtypes` (
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `module` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `is_request` tinyint(1) NOT NULL default '0',
  `handler` varchar(32) collate utf8_unicode_ci NOT NULL default '',
  PRIMARY KEY  (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_notificationtypes`
--

LOCK TABLES `engine4_activity_notificationtypes` WRITE;
/*!40000 ALTER TABLE `engine4_activity_notificationtypes` DISABLE KEYS */;
INSERT INTO `engine4_activity_notificationtypes` VALUES ('commented','activity','{item:$subject} has commented on your {item:$object:$label}.',0,''),('commented_classified','classified','{item:$subject} has commented on a {item:$object:classified listing} you commented on.',0,''),('commented_commented','activity','{item:$subject} has commented on a {item:$object:$label} you commented on.',0,''),('commented_video','video','{item:$subject} has commented on a {item:$object:video} you commented on.',0,''),('comment_classified','classified','{item:$subject} has commented on your {item:$object:classified listing}.',0,''),('comment_video','video','{item:$subject} has commented on your {item:$object:video}.',0,''),('event_accepted','event','Your request to join the event {item:$subject} has been approved.',0,''),('event_discussion_reply','event','{item:$subject} has {item:$object:posted} on a {itemParent:$object::event topic} you posted on.',0,''),('event_discussion_response','event','{item:$subject} has {item:$object:posted} on a {itemParent:$object::event topic} you created.',0,''),('event_invite','event','{item:$subject} has invited you to the event {item:$object}.',0,''),('friend_accepted','user','You and {item:$subject} are now friends.',0,''),('friend_follow','user','{item:$subject} is now following you.',0,''),('friend_follow_accepted','user','You are now following {item:$subject}.',0,''),('friend_follow_request','user','{item:$subject} has requested to follow you.',1,'user.friends.request-follow'),('friend_request','user','{item:$subject} has requested to be your friend.',1,'user.friends.request-friend'),('group_accepted','group','Your request to join the group {item:$subject} has been approved.',0,''),('group_approve','group','{item:$object} has requested to join the group {item:$subject}.',0,''),('group_discussion_reply','group','{item:$subject} has {item:$object:posted} on a {itemParent:$object::group topic} you posted on.',0,''),('group_discussion_response','group','{item:$subject} has {item:$object:posted} on a {itemParent:$object::group topic} you created.',0,''),('group_invite','group','{item:$subject} has invited you to the group {item:$object}.',1,'group.widget.request-group'),('group_promote','group','You were promoted to officer in the group {item:$object}.',0,''),('liked','activity','{item:$subject} likes your {item:$object:$label}.',0,''),('liked_classified','classified','{item:$subject} has commented on a {item:$object:classified listing} you liked.',0,''),('liked_commented','activity','{item:$subject} has commented on a {item:$object:$label} you liked.',0,''),('liked_video','video','{item:$subject} has commented on a {item:$object:video} you liked.',0,''),('like_classified','classified','{item:$subject} likes your {item:$object:classified listing}.',0,''),('like_video','video','{item:$subject} likes your {item:$object:video}.',0,''),('message_new','messages','{item:$subject} has sent you a {item:$object:message}.',0,''),('post_user','user','{item:$subject} has posted on your {item:$object:profile}.',0,''),('tagged','user','{item:$subject} tagged you in a {item:$object:$label}.',0,''),('video_processed','video','Your {item:$object:video} is ready to be viewed.',0,'');
/*!40000 ALTER TABLE `engine4_activity_notificationtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_activity_stream`
--

DROP TABLE IF EXISTS `engine4_activity_stream`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_activity_stream` (
  `target_type` varchar(16) character set latin1 collate latin1_general_ci NOT NULL,
  `target_id` int(11) unsigned NOT NULL,
  `subject_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `subject_id` int(11) unsigned NOT NULL,
  `object_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `object_id` int(11) unsigned NOT NULL,
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `action_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`target_type`,`target_id`,`action_id`),
  KEY `SUBJECT` (`subject_type`,`subject_id`,`action_id`),
  KEY `OBJECT` (`object_type`,`object_id`,`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_activity_stream`
--

LOCK TABLES `engine4_activity_stream` WRITE;
/*!40000 ALTER TABLE `engine4_activity_stream` DISABLE KEYS */;
INSERT INTO `engine4_activity_stream` VALUES ('everyone',0,'user',2,'user',2,'signup',1),('owner',2,'user',2,'user',2,'signup',1),('parent',2,'user',2,'user',2,'signup',1),('registered',0,'user',2,'user',2,'signup',1);
/*!40000 ALTER TABLE `engine4_activity_stream` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_album_albums`
--

DROP TABLE IF EXISTS `engine4_album_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_album_albums` (
  `album_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` mediumtext collate utf8_unicode_ci NOT NULL,
  `owner_type` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `owner_id` int(11) unsigned NOT NULL,
  `category_id` int(11) unsigned NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `photo_id` int(11) unsigned NOT NULL default '0',
  `view_count` int(11) unsigned NOT NULL default '0',
  `comment_count` int(11) unsigned NOT NULL default '0',
  `search` tinyint(1) NOT NULL default '1',
  `type` enum('wall','profile','message') collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`album_id`),
  KEY `owner_type` (`owner_type`,`owner_id`),
  KEY `search` (`search`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_album_albums`
--

LOCK TABLES `engine4_album_albums` WRITE;
/*!40000 ALTER TABLE `engine4_album_albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_album_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_album_categories`
--

DROP TABLE IF EXISTS `engine4_album_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_album_categories` (
  `category_id` int(11) NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `category_name` varchar(128) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`category_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_album_categories`
--

LOCK TABLES `engine4_album_categories` WRITE;
/*!40000 ALTER TABLE `engine4_album_categories` DISABLE KEYS */;
INSERT INTO `engine4_album_categories` VALUES (1,1,'Arts & Culture'),(2,1,'Business'),(3,1,'Entertainment'),(5,1,'Family & Home'),(6,1,'Health'),(7,1,'Recreation'),(8,1,'Personal'),(9,1,'Shopping'),(10,1,'Society'),(11,1,'Sports'),(12,1,'Technology'),(13,1,'Other');
/*!40000 ALTER TABLE `engine4_album_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_album_photos`
--

DROP TABLE IF EXISTS `engine4_album_photos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_album_photos` (
  `photo_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` mediumtext collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `collection_id` int(11) unsigned NOT NULL,
  `owner_type` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `owner_id` int(11) unsigned NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`photo_id`),
  KEY `collection_id` (`collection_id`),
  KEY `owner_type` (`owner_type`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_album_photos`
--

LOCK TABLES `engine4_album_photos` WRITE;
/*!40000 ALTER TABLE `engine4_album_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_album_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_announcement_announcements`
--

DROP TABLE IF EXISTS `engine4_announcement_announcements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_announcement_announcements` (
  `announcement_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime default NULL,
  PRIMARY KEY  (`announcement_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_announcement_announcements`
--

LOCK TABLES `engine4_announcement_announcements` WRITE;
/*!40000 ALTER TABLE `engine4_announcement_announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_announcement_announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_authorization_allow`
--

DROP TABLE IF EXISTS `engine4_authorization_allow`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_authorization_allow` (
  `resource_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `resource_id` int(11) unsigned NOT NULL,
  `action` varchar(16) character set latin1 collate latin1_general_ci NOT NULL,
  `role` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `role_id` int(11) unsigned NOT NULL default '0',
  `value` tinyint(1) NOT NULL default '0',
  `params` text collate utf8_unicode_ci,
  PRIMARY KEY  (`resource_type`,`resource_id`,`action`,`role`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_authorization_allow`
--

LOCK TABLES `engine4_authorization_allow` WRITE;
/*!40000 ALTER TABLE `engine4_authorization_allow` DISABLE KEYS */;
INSERT INTO `engine4_authorization_allow` VALUES ('user',1,'comment','everyone',0,1,NULL),('user',1,'comment','member',0,1,NULL),('user',1,'comment','registered',0,1,NULL),('user',1,'view','everyone',0,1,NULL),('user',1,'view','member',0,1,NULL),('user',1,'view','registered',0,1,NULL),('user',2,'comment','member',0,1,NULL),('user',2,'view','everyone',0,1,NULL),('user',2,'view','member',0,1,NULL),('user',2,'view','registered',0,1,NULL);
/*!40000 ALTER TABLE `engine4_authorization_allow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_authorization_levels`
--

DROP TABLE IF EXISTS `engine4_authorization_levels`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_authorization_levels` (
  `level_id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `description` text collate utf8_unicode_ci NOT NULL,
  `type` enum('public','user','moderator','admin') collate utf8_unicode_ci NOT NULL default 'user',
  `flag` enum('default','superadmin','public') collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`level_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_authorization_levels`
--

LOCK TABLES `engine4_authorization_levels` WRITE;
/*!40000 ALTER TABLE `engine4_authorization_levels` DISABLE KEYS */;
INSERT INTO `engine4_authorization_levels` VALUES (1,'Superadmins','Users of this level can modify all of your settings and data.  This level cannot be modified or deleted.','admin','superadmin'),(2,'Admins','Users of this level have full access to all of your network settings and data.','admin',''),(3,'Moderators','Users of this level may edit user-side content.','moderator',''),(4,'Default Level','This is the default user level.  New users are assigned to it automatically.','user','default'),(5,'Public','Settings for this level apply to users who have not logged in.','public','public');
/*!40000 ALTER TABLE `engine4_authorization_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_authorization_permissions`
--

DROP TABLE IF EXISTS `engine4_authorization_permissions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_authorization_permissions` (
  `level_id` int(11) unsigned NOT NULL,
  `type` varchar(16) character set latin1 collate latin1_general_ci NOT NULL,
  `name` varchar(16) character set latin1 collate latin1_general_ci NOT NULL,
  `value` tinyint(3) NOT NULL default '0',
  `params` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`level_id`,`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_authorization_permissions`
--

LOCK TABLES `engine4_authorization_permissions` WRITE;
/*!40000 ALTER TABLE `engine4_authorization_permissions` DISABLE KEYS */;
INSERT INTO `engine4_authorization_permissions` VALUES (1,'admin','view',1,NULL),(1,'album','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'album','auth_tag',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'album','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'album','comment',2,NULL),(1,'album','create',2,NULL),(1,'album','delete',2,NULL),(1,'album','edit',2,NULL),(1,'album','tag',2,NULL),(1,'album','view',2,NULL),(1,'announcement','create',1,NULL),(1,'announcement','delete',2,NULL),(1,'announcement','edit',2,NULL),(1,'announcement','view',2,NULL),(1,'blog','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'blog','auth_html',3,'strong, b, em, i, u, strike, sub, sup, p, div, pre, address, h1, h2, h3, h4, h5, h6, span, ol, li, ul, a, img, embed, br, hr'),(1,'blog','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'blog','comment',1,NULL),(1,'blog','create',1,NULL),(1,'blog','css',1,NULL),(1,'blog','delete',1,NULL),(1,'blog','edit',1,NULL),(1,'blog','max',3,'20'),(1,'blog','view',1,NULL),(1,'chat','chat',1,NULL),(1,'chat','im',1,NULL),(1,'classified','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'classified','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'classified','comment',1,NULL),(1,'classified','create',1,NULL),(1,'classified','delete',1,NULL),(1,'classified','edit',1,NULL),(1,'classified','max',3,'20'),(1,'classified','photo',1,NULL),(1,'classified','view',1,NULL),(1,'core_link','create',1,NULL),(1,'core_link','view',2,NULL),(1,'event','auth_comment',5,'[\"registered\", \"member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'event','auth_photo',5,'[\"member\",\"owner\"]'),(1,'event','auth_view',5,'[\"everyone\", \"registered\", \"member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'event','comment',2,NULL),(1,'event','create',1,NULL),(1,'event','delete',2,NULL),(1,'event','edit',2,NULL),(1,'event','invite',2,NULL),(1,'event','photo',2,NULL),(1,'event','view',2,NULL),(1,'general','activity',1,NULL),(1,'general','style',1,NULL),(1,'group','auth_comment',5,'[\"registered\", \"member\", \"officer\",\"owner\"]'),(1,'group','auth_photo',5,'[\"registered\", \"member\",\"officer\", \"owner\"]'),(1,'group','auth_view',5,'[\"everyone\", \"registered\",\"member\", \"officer\", \"owner\"]'),(1,'group','comment',2,NULL),(1,'group','create',1,NULL),(1,'group','delete',2,NULL),(1,'group','edit',2,NULL),(1,'group','photo',2,NULL),(1,'group','view',2,NULL),(1,'messages','create',1,NULL),(1,'music_playlist','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'music_playlist','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'music_playlist','comment',2,NULL),(1,'music_playlist','create',1,NULL),(1,'music_playlist','delete',2,NULL),(1,'music_playlist','edit',2,NULL),(1,'music_playlist','max_filesize',1,'10000'),(1,'music_playlist','max_songs',1,'30'),(1,'music_playlist','max_storage',1,'100000'),(1,'music_playlist','view',2,NULL),(1,'user','auth_comment',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(1,'user','auth_view',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(1,'user','block',1,NULL),(1,'user','comment',2,NULL),(1,'user','create',1,NULL),(1,'user','delete',2,NULL),(1,'user','edit',2,NULL),(1,'user','search',1,NULL),(1,'user','status',1,NULL),(1,'user','username',1,NULL),(1,'user','view',2,NULL),(1,'video','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'video','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(1,'video','comment',1,NULL),(1,'video','create',1,NULL),(1,'video','delete',1,NULL),(1,'video','edit',2,NULL),(1,'video','max',3,'20'),(1,'video','upload',1,NULL),(1,'video','view',2,NULL),(2,'admin','view',1,NULL),(2,'album','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'album','auth_tag',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'album','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'album','comment',2,NULL),(2,'album','create',2,NULL),(2,'album','delete',2,NULL),(2,'album','edit',2,NULL),(2,'album','tag',2,NULL),(2,'album','view',2,NULL),(2,'announcement','create',1,NULL),(2,'announcement','delete',2,NULL),(2,'announcement','edit',2,NULL),(2,'announcement','view',2,NULL),(2,'blog','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'blog','auth_html',3,'strong, b, em, i, u, strike, sub, sup, p, div, pre, address, h1, h2, h3, h4, h5, h6, span, ol, li, ul, a, img, embed, br, hr'),(2,'blog','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'blog','comment',2,NULL),(2,'blog','create',1,NULL),(2,'blog','css',1,NULL),(2,'blog','delete',1,NULL),(2,'blog','edit',1,NULL),(2,'blog','max',3,'20'),(2,'blog','view',1,NULL),(2,'chat','chat',1,NULL),(2,'chat','im',1,NULL),(2,'classified','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'classified','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'classified','comment',1,NULL),(2,'classified','create',1,NULL),(2,'classified','delete',1,NULL),(2,'classified','edit',1,NULL),(2,'classified','max',3,'20'),(2,'classified','photo',1,NULL),(2,'classified','view',1,NULL),(2,'core_link','create',1,NULL),(2,'core_link','view',2,NULL),(2,'event','auth_comment',5,'[\"registered\",\"member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'event','auth_photo',5,'[\"member\",\"owner\"]'),(2,'event','auth_view',5,'[\"everyone\",\"registered\", member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'event','comment',2,NULL),(2,'event','create',1,NULL),(2,'event','delete',2,NULL),(2,'event','edit',2,NULL),(2,'event','invite',2,NULL),(2,'event','photo',2,NULL),(2,'event','view',2,NULL),(2,'general','activity',1,NULL),(2,'general','style',1,NULL),(2,'group','auth_comment',5,'[\"registered\", \"member\", \"officer\",\"owner\"]'),(2,'group','auth_photo',5,'[\"registered\", \"member\",\"officer\", \"owner\"]'),(2,'group','auth_view',5,'[\"everyone\", \"registered\",\"member\", \"officer\", \"owner\"]'),(2,'group','comment',2,NULL),(2,'group','create',1,NULL),(2,'group','delete',2,NULL),(2,'group','edit',2,NULL),(2,'group','photo',2,NULL),(2,'group','view',2,NULL),(2,'messages','create',1,NULL),(2,'music_playlist','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'music_playlist','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'music_playlist','comment',2,NULL),(2,'music_playlist','create',1,NULL),(2,'music_playlist','delete',2,NULL),(2,'music_playlist','edit',2,NULL),(2,'music_playlist','max_filesize',1,'10000'),(2,'music_playlist','max_songs',1,'30'),(2,'music_playlist','max_storage',1,'100000'),(2,'music_playlist','view',2,NULL),(2,'user','auth_comment',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(2,'user','auth_view',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(2,'user','block',1,NULL),(2,'user','comment',2,NULL),(2,'user','create',1,NULL),(2,'user','delete',2,NULL),(2,'user','edit',2,NULL),(2,'user','search',1,NULL),(2,'user','status',1,NULL),(2,'user','username',1,NULL),(2,'user','view',2,NULL),(2,'video','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'video','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(2,'video','comment',1,NULL),(2,'video','create',1,NULL),(2,'video','delete',1,NULL),(2,'video','edit',2,NULL),(2,'video','max',3,'20'),(2,'video','upload',1,NULL),(2,'video','view',2,NULL),(3,'album','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'album','auth_tag',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'album','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'album','comment',2,NULL),(3,'album','create',2,NULL),(3,'album','delete',2,NULL),(3,'album','edit',2,NULL),(3,'album','tag',2,NULL),(3,'album','view',2,NULL),(3,'announcement','create',0,NULL),(3,'announcement','delete',0,NULL),(3,'announcement','edit',0,NULL),(3,'announcement','view',1,NULL),(3,'blog','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'blog','auth_html',3,'strong, b, em, i, u, strike, sub, sup, p, div, pre, address, h1, h2, h3, h4, h5, h6, span, ol, li, ul, a, img, embed, br, hr'),(3,'blog','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'blog','comment',1,NULL),(3,'blog','create',1,NULL),(3,'blog','css',1,NULL),(3,'blog','delete',1,NULL),(3,'blog','edit',1,NULL),(3,'blog','max',3,'20'),(3,'blog','view',1,NULL),(3,'chat','chat',1,NULL),(3,'chat','im',1,NULL),(3,'classified','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'classified','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'classified','comment',1,NULL),(3,'classified','create',1,NULL),(3,'classified','delete',1,NULL),(3,'classified','edit',1,NULL),(3,'classified','max',3,'20'),(3,'classified','photo',1,NULL),(3,'classified','view',1,NULL),(3,'core_link','create',1,NULL),(3,'core_link','view',2,NULL),(3,'event','auth_comment',5,'[\"registered\",\"member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'event','auth_photo',5,'[\"member\",\"owner\"]'),(3,'event','auth_view',5,'[\"everyone\",\"registered\", \"member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'event','comment',2,NULL),(3,'event','create',1,NULL),(3,'event','delete',2,NULL),(3,'event','edit',2,NULL),(3,'event','invite',2,NULL),(3,'event','photo',2,NULL),(3,'event','view',2,NULL),(3,'general','activity',1,NULL),(3,'general','style',1,NULL),(3,'group','auth_comment',5,'[\"registered\", \"member\", \"officer\",\"owner\"]'),(3,'group','auth_photo',5,'[\"registered\", \"member\",\"officer\", \"owner\"]'),(3,'group','auth_view',5,'[\"everyone\", \"registered\",\"member\", \"officer\", \"owner\"]'),(3,'group','comment',2,NULL),(3,'group','create',1,NULL),(3,'group','delete',2,NULL),(3,'group','edit',2,NULL),(3,'group','view',2,NULL),(3,'messages','create',1,NULL),(3,'music_playlist','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'music_playlist','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'music_playlist','comment',2,NULL),(3,'music_playlist','create',1,NULL),(3,'music_playlist','delete',2,NULL),(3,'music_playlist','edit',2,NULL),(3,'music_playlist','max_filesize',1,'10000'),(3,'music_playlist','max_songs',1,'30'),(3,'music_playlist','max_storage',1,'100000'),(3,'music_playlist','view',2,NULL),(3,'user','auth_comment',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(3,'user','auth_view',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(3,'user','block',1,NULL),(3,'user','comment',2,NULL),(3,'user','create',1,NULL),(3,'user','delete',2,NULL),(3,'user','edit',2,NULL),(3,'user','search',1,NULL),(3,'user','status',1,NULL),(3,'user','username',1,NULL),(3,'user','view',2,NULL),(3,'video','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'video','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(3,'video','comment',1,NULL),(3,'video','create',1,NULL),(3,'video','delete',1,NULL),(3,'video','edit',1,NULL),(3,'video','max',3,'20'),(3,'video','upload',1,NULL),(3,'video','view',1,NULL),(4,'album','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'album','auth_tag',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'album','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'album','comment',1,NULL),(4,'album','create',1,NULL),(4,'album','delete',1,NULL),(4,'album','edit',1,NULL),(4,'album','tag',1,NULL),(4,'album','view',1,NULL),(4,'announcement','create',0,NULL),(4,'announcement','delete',0,NULL),(4,'announcement','edit',0,NULL),(4,'announcement','view',1,NULL),(4,'blog','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'blog','auth_html',3,'strong, b, em, i, u, strike, sub, sup, p, div, pre, address, h1, h2, h3, h4, h5, h6, span, ol, li, ul, a, img, embed, br, hr'),(4,'blog','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'blog','comment',1,NULL),(4,'blog','create',1,NULL),(4,'blog','css',1,NULL),(4,'blog','delete',1,NULL),(4,'blog','edit',1,NULL),(4,'blog','max',3,'20'),(4,'blog','view',1,NULL),(4,'chat','chat',1,NULL),(4,'chat','im',1,NULL),(4,'classified','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'classified','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'classified','comment',1,NULL),(4,'classified','create',1,NULL),(4,'classified','delete',1,NULL),(4,'classified','edit',1,NULL),(4,'classified','max',3,'20'),(4,'classified','photo',1,NULL),(4,'classified','view',1,NULL),(4,'core_link','create',1,NULL),(4,'core_link','view',1,NULL),(4,'event','auth_comment',5,'[\"registered\",\"member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'event','auth_photo',5,'[\"member\",\"owner\"]'),(4,'event','auth_view',5,'[\"everyone\", \"registered\", \"member\", \"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'event','comment',1,NULL),(4,'event','create',1,NULL),(4,'event','delete',1,NULL),(4,'event','edit',1,NULL),(4,'event','invite',1,NULL),(4,'event','photo',1,NULL),(4,'event','view',1,NULL),(4,'general','activity',0,NULL),(4,'general','style',1,NULL),(4,'group','auth_comment',5,'[\"registered\", \"member\", \"officer\",\"owner\"]'),(4,'group','auth_photo',5,'[\"registered\", member\",\"officer\", \"owner\"]'),(4,'group','auth_view',5,'[\"everyone\", \"registered\",\"member\", \"officer\", \"owner\"]'),(4,'group','comment',1,NULL),(4,'group','create',1,NULL),(4,'group','delete',1,NULL),(4,'group','edit',1,NULL),(4,'group','photo',1,NULL),(4,'group','view',1,NULL),(4,'messages','create',1,NULL),(4,'music_playlist','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'music_playlist','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'music_playlist','comment',1,NULL),(4,'music_playlist','create',1,NULL),(4,'music_playlist','delete',1,NULL),(4,'music_playlist','edit',1,NULL),(4,'music_playlist','max_filesize',1,'10000'),(4,'music_playlist','max_songs',1,'30'),(4,'music_playlist','max_storage',1,'100000'),(4,'music_playlist','view',1,NULL),(4,'user','auth_comment',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(4,'user','auth_view',5,'[\"everyone\",\"registered\",\"network\",\"member\",\"owner\"]'),(4,'user','block',1,NULL),(4,'user','comment',1,NULL),(4,'user','create',1,NULL),(4,'user','delete',1,NULL),(4,'user','edit',1,NULL),(4,'user','search',1,NULL),(4,'user','status',1,NULL),(4,'user','username',1,NULL),(4,'user','view',1,NULL),(4,'video','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'video','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(4,'video','comment',1,NULL),(4,'video','create',1,NULL),(4,'video','delete',1,NULL),(4,'video','edit',1,NULL),(4,'video','max',3,'20'),(4,'video','upload',1,NULL),(4,'video','view',1,NULL),(5,'album','tag',0,NULL),(5,'album','view',1,NULL),(5,'announcement','view',1,NULL),(5,'blog','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(5,'blog','auth_html',3,'strong, b, em, i, u, strike, sub, sup, p, div, pre, address, h1, h2, h3, h4, h5, h6, span, ol, li, ul, a, img, embed, br, hr'),(5,'blog','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(5,'blog','css',1,NULL),(5,'blog','max',3,'20'),(5,'blog','view',1,NULL),(5,'classified','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(5,'classified','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(5,'classified','max',3,'20'),(5,'classified','photo',1,NULL),(5,'classified','view',1,NULL),(5,'core_link','view',1,NULL),(5,'event','view',1,NULL),(5,'group','view',1,NULL),(5,'messages','create',0,NULL),(5,'music_playlist','auth_comment',3,'[]'),(5,'music_playlist','auth_view',3,'[]'),(5,'music_playlist','create',0,NULL),(5,'music_playlist','max_filesize',1,'10000'),(5,'music_playlist','max_songs',1,'30'),(5,'music_playlist','max_storage',1,'100000'),(5,'music_playlist','view',1,NULL),(5,'user','view',1,NULL),(5,'video','auth_comment',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(5,'video','auth_view',5,'[\"everyone\",\"owner_network\",\"owner_member_member\",\"owner_member\",\"owner\"]'),(5,'video','max',3,'20'),(5,'video','view',1,NULL);
/*!40000 ALTER TABLE `engine4_authorization_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_blog_blogs`
--

DROP TABLE IF EXISTS `engine4_blog_blogs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_blog_blogs` (
  `blog_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `body` longtext collate utf8_unicode_ci NOT NULL,
  `owner_type` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `owner_id` int(11) unsigned NOT NULL,
  `category_id` int(11) unsigned NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `view_count` int(11) unsigned NOT NULL default '0',
  `comment_count` int(11) unsigned NOT NULL default '0',
  `search` tinyint(1) NOT NULL default '1',
  `draft` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`blog_id`),
  KEY `owner_type` (`owner_type`,`owner_id`),
  KEY `search` (`search`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_blog_blogs`
--

LOCK TABLES `engine4_blog_blogs` WRITE;
/*!40000 ALTER TABLE `engine4_blog_blogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_blog_blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_blog_categories`
--

DROP TABLE IF EXISTS `engine4_blog_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_blog_categories` (
  `category_id` int(11) NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `category_name` varchar(128) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`category_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_blog_categories`
--

LOCK TABLES `engine4_blog_categories` WRITE;
/*!40000 ALTER TABLE `engine4_blog_categories` DISABLE KEYS */;
INSERT INTO `engine4_blog_categories` VALUES (1,1,'Arts & Culture'),(2,1,'Business'),(3,1,'Entertainment'),(5,1,'Family & Home'),(6,1,'Health'),(7,1,'Recreation'),(8,1,'Personal'),(9,1,'Shopping'),(10,1,'Society'),(11,1,'Sports'),(12,1,'Technology'),(13,1,'Other');
/*!40000 ALTER TABLE `engine4_blog_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_chat_bans`
--

DROP TABLE IF EXISTS `engine4_chat_bans`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_chat_bans` (
  `ban_id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) default NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `expires` int(11) NOT NULL default '0',
  PRIMARY KEY  (`ban_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_chat_bans`
--

LOCK TABLES `engine4_chat_bans` WRITE;
/*!40000 ALTER TABLE `engine4_chat_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_chat_bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_chat_events`
--

DROP TABLE IF EXISTS `engine4_chat_events`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_chat_events` (
  `event_id` bigint(20) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `type` varchar(64) collate utf8_unicode_ci NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`event_id`),
  KEY `user_id` (`user_id`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_chat_events`
--

LOCK TABLES `engine4_chat_events` WRITE;
/*!40000 ALTER TABLE `engine4_chat_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_chat_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_chat_messages`
--

DROP TABLE IF EXISTS `engine4_chat_messages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_chat_messages` (
  `message_id` int(11) NOT NULL auto_increment,
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `system` tinyint(1) NOT NULL default '0',
  `body` text collate utf8_unicode_ci NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY  (`message_id`),
  KEY `room_id` (`room_id`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_chat_messages`
--

LOCK TABLES `engine4_chat_messages` WRITE;
/*!40000 ALTER TABLE `engine4_chat_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_chat_rooms`
--

DROP TABLE IF EXISTS `engine4_chat_rooms`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_chat_rooms` (
  `room_id` int(11) NOT NULL auto_increment,
  `title` varchar(64) collate utf8_unicode_ci default NULL,
  `user_count` smallint(6) NOT NULL,
  `modified_date` datetime NOT NULL,
  `public` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`room_id`),
  KEY `public` (`public`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_chat_rooms`
--

LOCK TABLES `engine4_chat_rooms` WRITE;
/*!40000 ALTER TABLE `engine4_chat_rooms` DISABLE KEYS */;
INSERT INTO `engine4_chat_rooms` VALUES (1,'General Chat',0,'2010-02-02 00:44:04',1),(2,'Introduce Yourself',0,'2010-02-02 00:44:04',1);
/*!40000 ALTER TABLE `engine4_chat_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_chat_roomusers`
--

DROP TABLE IF EXISTS `engine4_chat_roomusers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_chat_roomusers` (
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `state` tinyint(1) NOT NULL default '1',
  `date` datetime NOT NULL,
  PRIMARY KEY  (`room_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `date` (`date`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_chat_roomusers`
--

LOCK TABLES `engine4_chat_roomusers` WRITE;
/*!40000 ALTER TABLE `engine4_chat_roomusers` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_chat_roomusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_chat_users`
--

DROP TABLE IF EXISTS `engine4_chat_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_chat_users` (
  `user_id` int(11) NOT NULL,
  `state` tinyint(1) NOT NULL default '1',
  `date` datetime NOT NULL,
  `event_count` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`user_id`),
  KEY `date` (`date`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_chat_users`
--

LOCK TABLES `engine4_chat_users` WRITE;
/*!40000 ALTER TABLE `engine4_chat_users` DISABLE KEYS */;
INSERT INTO `engine4_chat_users` VALUES (1,1,'2010-07-02 07:41:19',0);
/*!40000 ALTER TABLE `engine4_chat_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_chat_whispers`
--

DROP TABLE IF EXISTS `engine4_chat_whispers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_chat_whispers` (
  `whisper_id` bigint(20) NOT NULL auto_increment,
  `recipient_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `date` datetime NOT NULL,
  `recipient_deleted` tinyint(1) NOT NULL default '0',
  `sender_deleted` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`whisper_id`),
  KEY `recipient_id` (`recipient_id`),
  KEY `sender_id` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_chat_whispers`
--

LOCK TABLES `engine4_chat_whispers` WRITE;
/*!40000 ALTER TABLE `engine4_chat_whispers` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_chat_whispers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_albums`
--

DROP TABLE IF EXISTS `engine4_classified_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_albums` (
  `album_id` int(11) unsigned NOT NULL auto_increment,
  `classified_id` int(11) unsigned NOT NULL,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` mediumtext collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `search` tinyint(1) NOT NULL default '1',
  `photo_id` int(11) unsigned NOT NULL default '0',
  `view_count` int(11) unsigned NOT NULL default '0',
  `comment_count` int(11) unsigned NOT NULL default '0',
  `collectible_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`album_id`),
  KEY `classified_id` (`classified_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_albums`
--

LOCK TABLES `engine4_classified_albums` WRITE;
/*!40000 ALTER TABLE `engine4_classified_albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_classified_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_categories`
--

DROP TABLE IF EXISTS `engine4_classified_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_categories` (
  `category_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `category_name` varchar(128) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`category_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_categories`
--

LOCK TABLES `engine4_classified_categories` WRITE;
/*!40000 ALTER TABLE `engine4_classified_categories` DISABLE KEYS */;
INSERT INTO `engine4_classified_categories` VALUES (1,1,'Arts & Culture'),(2,1,'Business'),(3,1,'Entertainment'),(5,1,'Family & Home'),(6,1,'Health'),(7,1,'Recreation'),(8,1,'Personal'),(9,1,'Shopping'),(10,1,'Society'),(11,1,'Sports'),(12,1,'Technology'),(13,1,'Other');
/*!40000 ALTER TABLE `engine4_classified_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_classifieds`
--

DROP TABLE IF EXISTS `engine4_classified_classifieds`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_classifieds` (
  `classified_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `body` longtext collate utf8_unicode_ci NOT NULL,
  `owner_id` int(11) unsigned NOT NULL,
  `category_id` int(11) unsigned NOT NULL,
  `photo_id` int(10) unsigned NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `view_count` int(11) unsigned NOT NULL default '0',
  `comment_count` int(11) unsigned NOT NULL default '0',
  `search` tinyint(1) NOT NULL default '1',
  `closed` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`classified_id`),
  KEY `owner_id` (`owner_id`),
  KEY `search` (`search`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_classifieds`
--

LOCK TABLES `engine4_classified_classifieds` WRITE;
/*!40000 ALTER TABLE `engine4_classified_classifieds` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_classified_classifieds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_fields_maps`
--

DROP TABLE IF EXISTS `engine4_classified_fields_maps`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_fields_maps` (
  `field_id` int(11) NOT NULL,
  `option_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `order` smallint(6) NOT NULL,
  PRIMARY KEY  (`field_id`,`option_id`,`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_fields_maps`
--

LOCK TABLES `engine4_classified_fields_maps` WRITE;
/*!40000 ALTER TABLE `engine4_classified_fields_maps` DISABLE KEYS */;
INSERT INTO `engine4_classified_fields_maps` VALUES (0,0,2,2),(0,0,3,3);
/*!40000 ALTER TABLE `engine4_classified_fields_maps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_fields_meta`
--

DROP TABLE IF EXISTS `engine4_classified_fields_meta`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_fields_meta` (
  `field_id` int(11) NOT NULL auto_increment,
  `type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `label` varchar(64) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `alias` varchar(32) collate utf8_unicode_ci NOT NULL default '',
  `required` tinyint(1) NOT NULL default '0',
  `display` tinyint(1) unsigned NOT NULL,
  `search` tinyint(1) unsigned NOT NULL default '0',
  `order` smallint(3) unsigned NOT NULL default '999',
  `config` text collate utf8_unicode_ci NOT NULL,
  `validators` text collate utf8_unicode_ci,
  `filters` text collate utf8_unicode_ci,
  `style` text collate utf8_unicode_ci,
  `error` text collate utf8_unicode_ci,
  PRIMARY KEY  (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_fields_meta`
--

LOCK TABLES `engine4_classified_fields_meta` WRITE;
/*!40000 ALTER TABLE `engine4_classified_fields_meta` DISABLE KEYS */;
INSERT INTO `engine4_classified_fields_meta` VALUES (2,'currency','Price','','price',0,1,1,999,'{\"unit\":\"USD\"}',NULL,NULL,NULL,NULL),(3,'location','Location','','location',0,1,1,999,'',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `engine4_classified_fields_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_fields_options`
--

DROP TABLE IF EXISTS `engine4_classified_fields_options`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_fields_options` (
  `option_id` int(11) NOT NULL auto_increment,
  `field_id` int(11) NOT NULL,
  `label` varchar(255) collate utf8_unicode_ci NOT NULL,
  `order` smallint(6) NOT NULL default '999',
  PRIMARY KEY  (`option_id`),
  KEY `field_id` (`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_fields_options`
--

LOCK TABLES `engine4_classified_fields_options` WRITE;
/*!40000 ALTER TABLE `engine4_classified_fields_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_classified_fields_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_fields_search`
--

DROP TABLE IF EXISTS `engine4_classified_fields_search`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_fields_search` (
  `item_id` int(11) NOT NULL,
  `price` double default NULL,
  `location` varchar(255) default NULL,
  PRIMARY KEY  (`item_id`),
  KEY `price` (`price`),
  KEY `location` (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_fields_search`
--

LOCK TABLES `engine4_classified_fields_search` WRITE;
/*!40000 ALTER TABLE `engine4_classified_fields_search` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_classified_fields_search` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_fields_values`
--

DROP TABLE IF EXISTS `engine4_classified_fields_values`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_fields_values` (
  `item_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `index` smallint(3) NOT NULL default '0',
  `value` text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`item_id`,`field_id`,`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_fields_values`
--

LOCK TABLES `engine4_classified_fields_values` WRITE;
/*!40000 ALTER TABLE `engine4_classified_fields_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_classified_fields_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_classified_photos`
--

DROP TABLE IF EXISTS `engine4_classified_photos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_classified_photos` (
  `photo_id` int(11) unsigned NOT NULL auto_increment,
  `album_id` int(11) unsigned NOT NULL,
  `classified_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `collection_id` int(11) unsigned NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY  (`photo_id`),
  KEY `album_id` (`album_id`),
  KEY `classified_id` (`classified_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_classified_photos`
--

LOCK TABLES `engine4_classified_photos` WRITE;
/*!40000 ALTER TABLE `engine4_classified_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_classified_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_adcampaigns`
--

DROP TABLE IF EXISTS `engine4_core_adcampaigns`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_adcampaigns` (
  `adcampaign_id` int(11) unsigned NOT NULL auto_increment,
  `end_settings` tinyint(4) NOT NULL,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `limit_view` int(11) unsigned NOT NULL default '0',
  `limit_click` int(11) unsigned NOT NULL default '0',
  `limit_ctr` varchar(11) collate utf8_unicode_ci NOT NULL default '0',
  `network` varchar(255) collate utf8_unicode_ci NOT NULL,
  `level` varchar(255) collate utf8_unicode_ci NOT NULL,
  `views` int(11) unsigned NOT NULL default '0',
  `clicks` int(11) unsigned NOT NULL default '0',
  `public` tinyint(4) NOT NULL default '0',
  `status` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`adcampaign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_adcampaigns`
--

LOCK TABLES `engine4_core_adcampaigns` WRITE;
/*!40000 ALTER TABLE `engine4_core_adcampaigns` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_adcampaigns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_adphotos`
--

DROP TABLE IF EXISTS `engine4_core_adphotos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_adphotos` (
  `adphoto_id` int(11) unsigned NOT NULL auto_increment,
  `ad_id` int(11) unsigned NOT NULL,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY  (`adphoto_id`),
  KEY `ad_id` (`ad_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_adphotos`
--

LOCK TABLES `engine4_core_adphotos` WRITE;
/*!40000 ALTER TABLE `engine4_core_adphotos` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_adphotos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_ads`
--

DROP TABLE IF EXISTS `engine4_core_ads`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_ads` (
  `ad_id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(16) collate utf8_unicode_ci NOT NULL,
  `ad_campaign` int(11) unsigned NOT NULL,
  `views` int(11) unsigned NOT NULL default '0',
  `clicks` int(11) unsigned NOT NULL default '0',
  `media_type` varchar(255) collate utf8_unicode_ci NOT NULL,
  `html_code` text collate utf8_unicode_ci NOT NULL,
  `photo_id` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`ad_id`),
  KEY `ad_campaign` (`ad_campaign`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_ads`
--

LOCK TABLES `engine4_core_ads` WRITE;
/*!40000 ALTER TABLE `engine4_core_ads` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_ads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_auth`
--

DROP TABLE IF EXISTS `engine4_core_auth`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_auth` (
  `id` varchar(40) character set latin1 collate latin1_general_ci NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `type` varchar(32) character set latin1 collate latin1_general_ci default NULL,
  `expires` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`,`user_id`),
  KEY `expires` (`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_auth`
--

LOCK TABLES `engine4_core_auth` WRITE;
/*!40000 ALTER TABLE `engine4_core_auth` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_comments`
--

DROP TABLE IF EXISTS `engine4_core_comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_comments` (
  `comment_id` int(11) unsigned NOT NULL auto_increment,
  `resource_type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `resource_id` int(11) unsigned NOT NULL,
  `poster_type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `poster_id` int(11) unsigned NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY  (`comment_id`),
  KEY `resource_type` (`resource_type`,`resource_id`),
  KEY `poster_type` (`poster_type`,`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_comments`
--

LOCK TABLES `engine4_core_comments` WRITE;
/*!40000 ALTER TABLE `engine4_core_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_content`
--

DROP TABLE IF EXISTS `engine4_core_content`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_content` (
  `content_id` int(11) unsigned NOT NULL auto_increment,
  `page_id` int(11) unsigned NOT NULL,
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL default 'widget',
  `name` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `parent_content_id` int(11) unsigned default NULL,
  `order` int(11) NOT NULL default '1',
  `params` text collate utf8_unicode_ci,
  `attribs` text collate utf8_unicode_ci,
  PRIMARY KEY  (`content_id`),
  KEY `page_id` (`page_id`,`order`)
) ENGINE=InnoDB AUTO_INCREMENT=583 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_content`
--

LOCK TABLES `engine4_core_content` WRITE;
/*!40000 ALTER TABLE `engine4_core_content` DISABLE KEYS */;
INSERT INTO `engine4_core_content` VALUES (100,1,'container','main',NULL,1,'',NULL),(110,1,'widget','core.menu-mini',100,1,'',NULL),(111,1,'widget','core.menu-logo',100,2,'',NULL),(112,1,'widget','core.menu-main',100,3,'',NULL),(200,2,'container','main',NULL,1,'',NULL),(210,2,'widget','core.menu-footer',200,2,'',NULL),(300,3,'container','main',NULL,1,'',NULL),(310,3,'container','left',300,1,'',NULL),(311,3,'container','right',300,2,'',NULL),(312,3,'container','middle',300,3,'',NULL),(320,3,'widget','user.login-or-signup',310,1,'',NULL),(321,3,'widget','user.list-online',310,2,'{\"title\":\"%s Members Online\"}',NULL),(322,3,'widget','core.statistics',310,3,'{\"title\":\"Network Stats\"}',NULL),(330,3,'widget','user.list-signups',311,1,'{\"title\":\"Newest Members\"}',NULL),(331,3,'widget','user.list-popular',311,2,'{\"title\":\"Popular Members\"}',NULL),(340,3,'widget','announcement.list-announcements',312,1,'',NULL),(341,3,'widget','activity.feed',312,2,'{\"title\":\"What\'s New\"}',NULL),(400,4,'container','main',NULL,1,'',NULL),(410,4,'container','left',400,1,'',NULL),(411,4,'container','right',400,2,'',NULL),(412,4,'container','middle',400,3,'',NULL),(420,4,'widget','user.home-photo',410,1,'',NULL),(421,4,'widget','user.home-links',410,2,'',NULL),(422,4,'widget','user.list-online',410,3,'{\"title\":\"%s Members Online\"}',NULL),(423,4,'widget','core.statistics',410,4,'{\"title\":\"Network Stats\"}',NULL),(430,4,'widget','activity.list-requests',411,1,'{\"title\":\"Requests\"}',NULL),(431,4,'widget','user.list-signups',411,2,'{\"title\":\"Newest Members\"}',NULL),(432,4,'widget','user.list-popular',411,3,'{\"title\":\"Popular Members\"}',NULL),(440,4,'widget','announcement.list-announcements',412,1,'',NULL),(441,4,'widget','activity.feed',412,2,'{\"title\":\"What\'s New\"}',NULL),(500,5,'container','main',NULL,1,'',NULL),(510,5,'container','left',500,1,'',NULL),(511,5,'container','middle',500,3,'',NULL),(520,5,'widget','user.profile-photo',510,1,'',NULL),(521,5,'widget','user.profile-options',510,2,'',NULL),(522,5,'widget','user.profile-friends-common',510,3,'{\"title\":\"Mutual Friends\"}',NULL),(523,5,'widget','user.profile-info',510,4,'{\"title\":\"Member Info\"}',NULL),(530,5,'widget','user.profile-status',511,1,'',NULL),(531,5,'widget','core.container-tabs',511,2,'{\"max\":\"6\"}',NULL),(540,5,'widget','activity.feed',531,1,'{\"title\":\"Updates\"}',NULL),(541,5,'widget','user.profile-fields',531,2,'{\"title\":\"Info\"}',NULL),(542,5,'widget','user.profile-friends',531,3,'{\"title\":\"Friends\",\"titleCount\":true}',NULL),(546,5,'widget','core.profile-links',531,7,'{\"title\":\"Links\",\"titleCount\":true}',NULL),(547,5,'widget','album.profile-albums',531,4,'{\"title\":\"Albums\",\"titleCount\":true}',NULL),(548,5,'widget','event.profile-events',531,8,'{\"title\":\"Events\",\"titleCount\":true}',NULL),(549,6,'container','main',NULL,1,'',NULL),(550,6,'container','middle',549,3,'',NULL),(551,6,'container','left',549,1,'',NULL),(552,6,'widget','core.container-tabs',550,2,'{\"max\":\"6\"}',NULL),(553,6,'widget','event.profile-status',550,1,'',NULL),(554,6,'widget','event.profile-photo',551,1,'',NULL),(555,6,'widget','event.profile-options',551,2,'',NULL),(556,6,'widget','event.profile-info',551,3,'',NULL),(557,6,'widget','event.profile-rsvp',551,4,'',NULL),(558,6,'widget','activity.feed',552,1,'{\"title\":\"Updates\"}',NULL),(559,6,'widget','event.profile-members',552,2,'{\"title\":\"Guests\",\"titleCount\":true}',NULL),(560,6,'widget','event.profile-photos',552,3,'{\"title\":\"Photos\",\"titleCount\":true}',NULL),(561,6,'widget','event.profile-discussions',552,4,'{\"title\":\"Discussions\",\"titleCount\":true}',NULL),(562,6,'widget','core.profile-links',552,5,'{\"title\":\"Links\",\"titleCount\":true}',NULL),(563,5,'widget','video.profile-videos',531,12,'{\"title\":\"Videos\",\"titleCount\":true}',NULL),(564,5,'widget','classified.profile-classifieds',531,6,'{\"title\":\"Classifieds\",\"titleCount\":true}',NULL),(565,5,'widget','blog.profile-blogs',531,6,'{\"title\":\"Blogs\",\"titleCount\":true}',NULL),(566,5,'widget','music.profile-music',531,10,'{\"title\":\"Music\",\"titleCount\":true}',NULL),(567,5,'widget','music.profile-player',510,5,'',NULL),(568,5,'widget','group.profile-groups',531,9,'{\"title\":\"Groups\",\"titleCount\":true}',NULL),(569,7,'container','main',NULL,1,'',NULL),(570,7,'container','middle',569,3,'',NULL),(571,7,'container','left',569,1,'',NULL),(572,7,'widget','core.container-tabs',570,2,'{\"max\":\"6\"}',NULL),(573,7,'widget','group.profile-status',570,1,'',NULL),(574,7,'widget','group.profile-photo',571,1,'',NULL),(575,7,'widget','group.profile-options',571,2,'',NULL),(576,7,'widget','group.profile-info',571,3,'',NULL),(577,7,'widget','activity.feed',572,1,'{\"title\":\"Updates\"}',NULL),(578,7,'widget','group.profile-members',572,2,'{\"title\":\"Members\",\"titleCount\":true}',NULL),(579,7,'widget','group.profile-photos',572,3,'{\"title\":\"Photos\",\"titleCount\":true}',NULL),(580,7,'widget','group.profile-discussions',572,4,'{\"title\":\"Discussions\",\"titleCount\":true}',NULL),(581,7,'widget','core.profile-links',572,5,'{\"title\":\"Links\",\"titleCount\":true}',NULL),(582,7,'widget','group.profile-events',572,6,'{\"title\":\"Events\",\"titleCount\":true}',NULL);
/*!40000 ALTER TABLE `engine4_core_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_geotags`
--

DROP TABLE IF EXISTS `engine4_core_geotags`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_geotags` (
  `geotag_id` int(11) unsigned NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  PRIMARY KEY  (`geotag_id`),
  KEY `latitude` (`latitude`,`longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_geotags`
--

LOCK TABLES `engine4_core_geotags` WRITE;
/*!40000 ALTER TABLE `engine4_core_geotags` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_geotags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_languages`
--

DROP TABLE IF EXISTS `engine4_core_languages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_languages` (
  `language_id` int(11) unsigned NOT NULL auto_increment,
  `code` varchar(8) character set latin1 collate latin1_general_ci NOT NULL,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `fallback` varchar(8) character set latin1 collate latin1_general_ci default NULL,
  `order` smallint(6) NOT NULL default '1',
  PRIMARY KEY  (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_languages`
--

LOCK TABLES `engine4_core_languages` WRITE;
/*!40000 ALTER TABLE `engine4_core_languages` DISABLE KEYS */;
INSERT INTO `engine4_core_languages` VALUES (1,'en','English','en',1);
/*!40000 ALTER TABLE `engine4_core_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_likes`
--

DROP TABLE IF EXISTS `engine4_core_likes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_likes` (
  `like_id` int(11) unsigned NOT NULL auto_increment,
  `resource_type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `resource_id` int(11) unsigned NOT NULL,
  `poster_type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `poster_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`like_id`),
  KEY `resource_type` (`resource_type`,`resource_id`),
  KEY `poster_type` (`poster_type`,`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_likes`
--

LOCK TABLES `engine4_core_likes` WRITE;
/*!40000 ALTER TABLE `engine4_core_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_links`
--

DROP TABLE IF EXISTS `engine4_core_links`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_links` (
  `link_id` int(11) unsigned NOT NULL auto_increment,
  `uri` varchar(255) collate utf8_unicode_ci NOT NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `description` text collate utf8_unicode_ci NOT NULL,
  `photo_id` int(11) unsigned NOT NULL default '0',
  `parent_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `parent_id` int(11) unsigned NOT NULL,
  `owner_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `owner_id` int(11) unsigned NOT NULL,
  `view_count` mediumint(6) unsigned NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `search` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`link_id`),
  KEY `owner` (`owner_type`,`owner_id`),
  KEY `parent` (`parent_type`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_links`
--

LOCK TABLES `engine4_core_links` WRITE;
/*!40000 ALTER TABLE `engine4_core_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_listitems`
--

DROP TABLE IF EXISTS `engine4_core_listitems`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_listitems` (
  `listitem_id` int(11) unsigned NOT NULL auto_increment,
  `list_id` int(11) unsigned NOT NULL,
  `child_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`listitem_id`),
  KEY `list_id` (`list_id`),
  KEY `child_id` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_listitems`
--

LOCK TABLES `engine4_core_listitems` WRITE;
/*!40000 ALTER TABLE `engine4_core_listitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_listitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_lists`
--

DROP TABLE IF EXISTS `engine4_core_lists`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_lists` (
  `list_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL default '',
  `owner_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `owner_id` int(11) unsigned NOT NULL,
  `child_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `child_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`list_id`),
  KEY `owner_type` (`owner_type`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_lists`
--

LOCK TABLES `engine4_core_lists` WRITE;
/*!40000 ALTER TABLE `engine4_core_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_mail`
--

DROP TABLE IF EXISTS `engine4_core_mail`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_mail` (
  `mail_id` int(11) unsigned NOT NULL auto_increment,
  `type` enum('system','zend') character set latin1 collate latin1_general_ci NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `priority` smallint(3) default '100',
  `recipient_count` int(11) unsigned default '0',
  PRIMARY KEY  (`mail_id`),
  KEY `priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_mail`
--

LOCK TABLES `engine4_core_mail` WRITE;
/*!40000 ALTER TABLE `engine4_core_mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_mail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_mailrecipients`
--

DROP TABLE IF EXISTS `engine4_core_mailrecipients`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_mailrecipients` (
  `recipient_id` int(11) unsigned NOT NULL auto_increment,
  `mail_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned default NULL,
  `email` varchar(128) default NULL,
  PRIMARY KEY  (`recipient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_mailrecipients`
--

LOCK TABLES `engine4_core_mailrecipients` WRITE;
/*!40000 ALTER TABLE `engine4_core_mailrecipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_mailrecipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_mailtemplates`
--

DROP TABLE IF EXISTS `engine4_core_mailtemplates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_mailtemplates` (
  `mailtemplate_id` int(11) unsigned NOT NULL auto_increment,
  `type` varchar(255) character set latin1 collate latin1_general_ci NOT NULL,
  `vars` varchar(255) NOT NULL,
  PRIMARY KEY  (`mailtemplate_id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_mailtemplates`
--

LOCK TABLES `engine4_core_mailtemplates` WRITE;
/*!40000 ALTER TABLE `engine4_core_mailtemplates` DISABLE KEYS */;
INSERT INTO `engine4_core_mailtemplates` VALUES (1,'core_invitecode','[displayname],[email],[message],[code],[link]'),(2,'core_invite','[displayname],[email],[message],[link]'),(3,'core_verification','[displayname],[email],[link]'),(4,'core_verification_password','[displayname],[email],[link],[password]'),(5,'core_welcome','[displayname],[email], [link]'),(6,'core_welcome_password','[displayname],[email],[password],[link]'),(7,'core_lostpassword','[displayname],[email],[link]'),(8,'notify_commented','[displayname],[subject],[item],[message],[link]'),(9,'notify_commented_commented','[displayname],[subject],[item],[link]'),(10,'notify_friend_accepted','[displayname],[friendname],[link]'),(11,'notify_friend_request','[displayname],[friendname],[link]'),(12,'notify_friend_follow','[displayname],[friendname],[link]'),(13,'notify_friend_follow_accepted','[displayname],[friendname],[link]'),(14,'notify_friend_follow_request','[displayname],[friendname],[link]'),(15,'notify_liked','[displayname],[subject],[item],[link]'),(16,'notify_liked_commented','[displayname],[subject],[item],[link]'),(17,'core_contact','[displayname],[email],[message]');
/*!40000 ALTER TABLE `engine4_core_mailtemplates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_menuitems`
--

DROP TABLE IF EXISTS `engine4_core_menuitems`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_menuitems` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `module` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `label` varchar(32) collate utf8_unicode_ci NOT NULL,
  `plugin` varchar(32) character set latin1 collate latin1_general_ci default NULL,
  `params` text collate utf8_unicode_ci NOT NULL,
  `menu` varchar(32) character set latin1 collate latin1_general_ci default NULL,
  `submenu` varchar(32) character set latin1 collate latin1_general_ci default NULL,
  `custom` tinyint(1) NOT NULL default '0',
  `order` smallint(6) NOT NULL default '999',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `LOOKUP` (`name`,`order`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_menuitems`
--

LOCK TABLES `engine4_core_menuitems` WRITE;
/*!40000 ALTER TABLE `engine4_core_menuitems` DISABLE KEYS */;
INSERT INTO `engine4_core_menuitems` VALUES (1,'core_main_home','core','Home','User_Plugin_Menus','','core_main','',0,1),(2,'core_sitemap_home','core','Home','','{\"route\":\"default\"}','core_sitemap','',0,1),(3,'core_footer_privacy','core','Privacy','','{\"route\":\"default\",\"module\":\"core\",\"controller\":\"help\",\"action\":\"privacy\"}','core_footer','',0,1),(4,'core_footer_terms','core','Terms of Service','','{\"route\":\"default\",\"module\":\"core\",\"controller\":\"help\",\"action\":\"terms\"}','core_footer','',0,2),(5,'core_footer_contact','core','Contact','','{\"route\":\"default\",\"module\":\"core\",\"controller\":\"help\",\"action\":\"contact\"}','core_footer','',0,3),(6,'core_mini_admin','core','Admin','User_Plugin_Menus','','core_mini','',0,6),(7,'core_mini_profile','user','My Profile','User_Plugin_Menus','','core_mini','',0,5),(8,'core_mini_settings','user','Settings','User_Plugin_Menus','','core_mini','',0,3),(9,'core_mini_auth','user','Auth','User_Plugin_Menus','','core_mini','',0,2),(10,'core_mini_signup','user','Signup','User_Plugin_Menus','','core_mini','',0,1),(11,'core_admin_main_home','core','Home','','{\"route\":\"admin_default\"}','core_admin_main','',0,1),(12,'core_admin_main_manage','core','Manage','','{\"uri\":\"javascript:void(0);this.blur();\"}','core_admin_main','core_admin_main_manage',0,2),(13,'core_admin_main_settings','core','Settings','','{\"uri\":\"javascript:void(0);this.blur();\"}','core_admin_main','core_admin_main_settings',0,3),(14,'core_admin_main_plugins','core','Plugins','','{\"uri\":\"javascript:void(0);this.blur();\"}','core_admin_main','core_admin_main_plugins',0,4),(15,'core_admin_main_layout','core','Layout','','{\"uri\":\"javascript:void(0);this.blur();\"}','core_admin_main','core_admin_main_layout',0,5),(16,'core_admin_main_ads','core','Ads','','{\"uri\":\"javascript:void(0);this.blur();\"}','core_admin_main','core_admin_main_ads',0,6),(17,'core_admin_main_stats','core','Stats','','{\"uri\":\"javascript:void(0);this.blur();\"}','core_admin_main','core_admin_main_stats',0,7),(18,'core_admin_main_manage_levels','core','Member Levels','','{\"route\":\"admin_default\",\"module\":\"authorization\",\"controller\":\"level\"}','core_admin_main_manage','',0,2),(19,'core_admin_main_manage_networks','network','Networks','','{\"route\":\"admin_default\",\"module\":\"network\",\"controller\":\"manage\"}','core_admin_main_manage','',0,3),(20,'core_admin_main_manage_announcements','announcement','Announcements','','{\"route\":\"admin_default\",\"module\":\"announcement\",\"controller\":\"manage\"}','core_admin_main_manage','',0,4),(21,'core_admin_main_manage_reports','core','Abuse Reports','','{\"route\":\"admin_default\",\"module\":\"core\",\"controller\":\"report\"}','core_admin_main_manage','',0,5),(22,'core_admin_main_manage_packages','core','Packages & Plugins','','{\"route\":\"admin_default\",\"module\":\"core\",\"controller\":\"packages\"}','core_admin_main_manage','',0,6),(23,'core_admin_main_settings_general','core','General Settings','','{\"route\":\"core_admin_settings\",\"action\":\"general\"}','core_admin_main_settings','',0,1),(24,'core_admin_main_settings_locale','core','Locale Settings','','{\"route\":\"core_admin_settings\",\"action\":\"locale\"}','core_admin_main_settings','',0,1),(25,'core_admin_main_settings_fields','fields','Profile Questions','','{\"route\":\"admin_default\",\"module\":\"user\",\"controller\":\"fields\"}','core_admin_main_settings','',0,2),(26,'core_admin_main_settings_spam','core','Spam & Banning Tools','','{\"route\":\"core_admin_settings\",\"action\":\"spam\"}','core_admin_main_settings','',0,5),(27,'core_admin_main_settings_email','core','System Emails','','{\"route\":\"core_admin_settings\",\"action\":\"email\"}','core_admin_main_settings','',0,7),(28,'core_admin_main_settings_performance','core','Performance & Caching','','{\"route\":\"core_admin_settings\",\"action\":\"performance\"}','core_admin_main_settings','',0,8),(29,'core_admin_main_settings_password','core','Admin Password','','{\"route\":\"core_admin_settings\",\"action\":\"password\"}','core_admin_main_settings','',0,9),(30,'core_admin_main_layout_content','core','Layout Editor','','{\"route\":\"admin_default\",\"controller\":\"content\"}','core_admin_main_layout','',0,1),(31,'core_admin_main_layout_themes','core','Theme Editor','','{\"route\":\"admin_default\",\"controller\":\"themes\"}','core_admin_main_layout','',0,2),(32,'core_admin_main_layout_files','core','File & Media Manager','','{\"route\":\"admin_default\",\"controller\":\"files\"}','core_admin_main_layout','',0,3),(33,'core_admin_main_layout_language','core','Language Manager','','{\"route\":\"admin_default\",\"controller\":\"language\"}','core_admin_main_layout','',0,4),(34,'core_admin_main_layout_menus','core','Menu Editor','','{\"route\":\"admin_default\",\"controller\":\"menus\"}','core_admin_main_layout','',0,5),(35,'core_admin_main_ads_manage','core','Manage Ad Campaigns','','{\"route\":\"admin_default\",\"controller\":\"ads\"}','core_admin_main_ads','',0,1),(36,'core_admin_main_ads_create','core','Create New Campaign','','{\"route\":\"admin_default\",\"controller\":\"ads\",\"action\":\"create\"}','core_admin_main_ads','',0,2),(37,'core_admin_main_stats_statistics','core','Site-wide Statistics','','{\"route\":\"admin_default\",\"controller\":\"stats\"}','core_admin_main_stats','',0,1),(38,'core_admin_main_stats_url','core','Referring URLs','','{\"route\":\"admin_default\",\"controller\":\"stats\",\"action\":\"referrers\"}','core_admin_main_stats','',0,2),(39,'core_admin_main_stats_resources','core','Server Information','','{\"route\":\"admin_default\",\"controller\":\"system\"}','core_admin_main_stats','',0,3),(40,'core_admin_main_stats_logs','core','Log Browser','','{\"route\":\"admin_default\",\"controller\":\"system\",\"action\":\"log\"}','core_admin_main_stats','',0,3),(41,'core_admin_levels_general','core','General','','{\"route\":\"authorization_admin_levels\",\"module\":\"authorization\",\"controller\":\"admin-level\",\"action\":\"edit\"}','core_admin_levels','',0,1),(42,'adcampaign_admin_main_edit','core','Edit Settings','','{\"route\":\"admin_default\",\"module\":\"core\",\"controller\":\"ads\",\"action\":\"edit\"}','adcampaign_admin_main','',0,1),(43,'adcampaign_admin_main_manageads','core','Manage Advertisements','','{\"route\":\"admin_default\",\"module\":\"core\",\"controller\":\"ads\",\"action\":\"manageads\"}','adcampaign_admin_main','',0,2),(44,'core_admin_main_settings_activity','activity','Activity Feed Settings','','{\"route\":\"activity_admin_settings_general\"}','core_admin_main_settings','',0,4),(45,'authorization_admin_main_manage','authorization','View Member Levels','','{\"route\":\"admin_default\",\"module\":\"authorization\",\"controller\":\"level\"}','authorization_admin_main','',0,1),(46,'authorization_admin_main_level','authorization','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"authorization\",\"controller\":\"level\",\"action\":\"edit\"}','authorization_admin_main','',0,3),(47,'core_main_user','user','Members','','{\"route\":\"user_general\",\"action\":\"browse\"}','core_main','',0,2),(48,'core_sitemap_user','user','Members','','{\"route\":\"user_general\",\"action\":\"browse\"}','core_sitemap','',0,2),(49,'user_home_updates','user','View Recent Updates','','{\"route\":\"recent_activity\",\"icon\":\"application/modules/User/externals/images/links/updates.png\"}','user_home','',0,1),(50,'user_home_view','user','View My Profile','User_Plugin_Menus','{\"route\":\"user_profile_self\",\"icon\":\"application/modules/User/externals/images/links/profile.png\"}','user_home','',0,2),(51,'user_home_edit','user','Edit My Profile','User_Plugin_Menus','{\"route\":\"user_extended\",\"module\":\"user\",\"controller\":\"edit\",\"action\":\"profile\",\"icon\":\"application/modules/User/externals/images/links/edit.png\"}','user_home','',0,3),(52,'user_home_friends','user','Browse Members','','{\"route\":\"user_general\",\"controller\":\"index\",\"action\":\"browse\",\"icon\":\"application/modules/User/externals/images/links/search.png\"}','user_home','',0,4),(53,'user_profile_edit','user','Edit Profile','User_Plugin_Menus','','user_profile','',0,1),(54,'user_profile_friend','user','Friends','User_Plugin_Menus','','user_profile','',0,2),(55,'user_profile_block','user','Block','User_Plugin_Menus','','user_profile','',0,4),(56,'user_profile_report','user','Report User','User_Plugin_Menus','','user_profile','',0,5),(57,'user_edit_profile','user','Personal Info','','{\"route\":\"user_extended\",\"module\":\"user\",\"controller\":\"edit\",\"action\":\"profile\"}','user_edit','',0,1),(58,'user_edit_photo','user','Edit My Photo','','{\"route\":\"user_extended\",\"module\":\"user\",\"controller\":\"edit\",\"action\":\"photo\"}','user_edit','',0,2),(59,'user_edit_style','user','Profile Style','','{\"route\":\"user_extended\",\"module\":\"user\",\"controller\":\"edit\",\"action\":\"style\"}','user_edit','',0,3),(60,'user_settings_general','user','General','','{\"route\":\"user_extended\",\"module\":\"user\",\"controller\":\"settings\",\"action\":\"general\"}','user_settings','',0,1),(61,'user_settings_privacy','user','Privacy','','{\"route\":\"user_extended\",\"module\":\"user\",\"controller\":\"settings\",\"action\":\"privacy\"}','user_settings','',0,2),(62,'user_settings_password','user','Change Password','','{\"route\":\"user_extended\", \"module\":\"user\", \"controller\":\"settings\", \"action\":\"password\"}','user_settings','',0,4),(63,'user_settings_delete','user','Delete Account','','{\"route\":\"user_extended\", \"module\":\"user\", \"controller\":\"settings\", \"action\":\"delete\"}','user_settings','',0,5),(64,'core_admin_main_manage_members','user','Members','','{\"route\":\"admin_default\",\"module\":\"user\",\"controller\":\"manage\"}','core_admin_main_manage','',0,1),(65,'core_admin_main_signup','user','Signup Process','','{\"route\":\"admin_default\", \"controller\":\"signup\", \"module\":\"user\"}','core_admin_main_settings','',0,3),(66,'core_admin_main_facebook','user','Facebook Integration','','{\"route\":\"admin_default\", \"action\":\"facebook\", \"controller\":\"settings\", \"module\":\"user\"}','core_admin_main_settings','',0,4),(67,'core_admin_main_settings_friends','user','Friendship Settings','','{\"route\":\"admin_default\",\"module\":\"user\",\"controller\":\"settings\",\"action\":\"friends\"}','core_admin_main_settings','',0,6),(68,'core_mini_messages','messages','Messages','Messages_Plugin_Menus','','core_mini','',0,4),(69,'user_profile_message','messages','Send Message','Messages_Plugin_Menus','','user_profile','',0,3),(70,'core_admin_levels_messages','messages','Messages','','{\"route\":\"admin_default\",\"module\":\"messages\",\"controller\":\"admin-settings\",\"action\":\"level\"}','core_admin_levels','',0,3),(71,'user_settings_network','network','Networks','','{\"route\":\"user_extended\", \"module\":\"user\", \"controller\":\"settings\", \"action\":\"network\"}','user_settings','',0,3),(72,'core_main_album','album','Albums','','{\"route\":\"album_general\",\"action\":\"browse\"}','core_main','',0,3),(73,'core_sitemap_album','album','Albums','','{\"route\":\"album_general\",\"action\":\"browse\"}','core_sitemap','',0,3),(74,'album_main_browse','album','Everyone\'s Albums','','{\"route\":\"album_general\",\"action\":\"browse\"}','album_main','',0,1),(75,'album_main_manage','album','My Albums','','{\"route\":\"album_general\",\"action\":\"manage\"}','album_main','',0,2),(76,'album_main_upload','album','Add New Photos','','{\"route\":\"album_general\",\"action\":\"upload\"}','album_main','',0,3),(77,'core_admin_main_plugins_album','album','Photo Albums','','{\"route\":\"admin_default\",\"module\":\"album\",\"controller\":\"settings\",\"action\":\"index\"}','core_admin_main_plugins','',0,999),(78,'album_admin_main_manage','album','View Albums','','{\"route\":\"admin_default\",\"module\":\"album\",\"controller\":\"manage\"}','album_admin_main','',0,1),(79,'album_admin_main_settings','album','Global Settings','','{\"route\":\"admin_default\",\"module\":\"album\",\"controller\":\"settings\"}','album_admin_main','',0,2),(80,'album_admin_main_level','album','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"album\",\"controller\":\"level\"}','album_admin_main','',0,3),(81,'album_admin_main_categories','album','Categories','','{\"route\":\"admin_default\",\"module\":\"album\",\"controller\":\"settings\", \"action\":\"categories\"}','album_admin_main','',0,4),(82,'core_main_event','event','Events','','{\"route\":\"event_general\"}','core_main','',0,6),(83,'core_sitemap_event','event','Events','','{\"route\":\"event_general\"}','core_sitemap','',0,6),(84,'event_main_upcoming','event','Upcoming Events','','{\"route\":\"event_upcoming\"}','event_main','',0,1),(85,'event_main_past','event','Past Events','','{\"route\":\"event_past\"}','event_main','',0,2),(86,'event_main_manage','event','My Events','Event_Plugin_Menus','{\"route\":\"event_general\",\"action\":\"manage\"}','event_main','',0,3),(87,'event_main_create','event','Create New Event','Event_Plugin_Menus','{\"route\":\"event_general\",\"action\":\"create\"}','event_main','',0,4),(88,'event_profile_edit','event','Edit Profile','Event_Plugin_Menus','','event_profile','',0,1),(89,'event_profile_style','event','Edit Styles','Event_Plugin_Menus','','event_profile','',0,2),(90,'event_profile_member','event','Member','Event_Plugin_Menus','','event_profile','',0,3),(91,'event_profile_report','event','Report Event','Event_Plugin_Menus','','event_profile','',0,4),(92,'event_profile_share','event','Share','Event_Plugin_Menus','','event_profile','',0,5),(93,'event_profile_invite','event','Invite','Event_Plugin_Menus','','event_profile','',0,6),(94,'event_profile_message','event','Message Members','Event_Plugin_Menus','','event_profile','',0,7),(95,'core_admin_main_plugins_event','event','Events','','{\"route\":\"admin_default\",\"module\":\"event\",\"controller\":\"manage\"}','core_admin_main_plugins','',0,999),(96,'event_admin_main_manage','event','Manage Events','','{\"route\":\"admin_default\",\"module\":\"event\",\"controller\":\"manage\"}','event_admin_main','',0,1),(97,'event_admin_main_level','event','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"event\",\"controller\":\"settings\",\"action\":\"level\"}','event_admin_main','',0,2),(98,'event_admin_main_categories','event','Categories','','{\"route\":\"admin_default\",\"module\":\"event\",\"controller\":\"settings\",\"action\":\"categories\"}','event_admin_main','',0,3),(99,'core_main_video','video','Videos','','{\"route\":\"video_general\"}','core_main','',0,7),(100,'core_sitemap_video','video','Videos','','{\"route\":\"video_general\"}','core_sitemap','',0,7),(101,'core_admin_main_plugins_video','video','Videos','','{\"route\":\"admin_default\",\"module\":\"video\",\"controller\":\"settings\"}','core_admin_main_plugins','',0,999),(102,'video_main_browse','video','Browse Videos','','{\"route\":\"video_general\"}','video_main','',0,1),(103,'video_main_manage','video','My Videos','Video_Plugin_Menus','{\"route\":\"video_general\",\"action\":\"manage\"}','video_main','',0,2),(104,'video_main_create','video','Post New Video','Video_Plugin_Menus','{\"route\":\"video_general\",\"action\":\"create\"}','video_main','',0,3),(105,'video_admin_main_manage','video','Manage Videos','','{\"route\":\"admin_default\",\"module\":\"video\",\"controller\":\"manage\"}','video_admin_main','',0,1),(106,'video_admin_main_utility','video','Video Utilities','','{\"route\":\"admin_default\",\"module\":\"video\",\"controller\":\"settings\",\"action\":\"utility\"}','video_admin_main','',0,2),(107,'video_admin_main_settings','video','Global Settings','','{\"route\":\"admin_default\",\"module\":\"video\",\"controller\":\"settings\"}','video_admin_main','',0,3),(108,'video_admin_main_level','video','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"video\",\"controller\":\"settings\",\"action\":\"level\"}','video_admin_main','',0,4),(109,'video_admin_main_categories','video','Categories','','{\"route\":\"admin_default\",\"module\":\"video\",\"controller\":\"settings\",\"action\":\"categories\"}','video_admin_main','',0,5),(110,'core_main_chat','chat','Chat','','{\"route\":\"default\",\"module\":\"chat\"}','core_main','',0,5),(111,'core_sitemap_chat','chat','Chat','','{\"route\":\"default\",\"module\":\"chat\"}','core_sitemap','',0,5),(112,'core_admin_main_plugins_chat','chat','Chat','','{\"route\":\"admin_default\",\"module\":\"chat\",\"controller\":\"settings\"}','core_admin_main_plugins','',0,999),(113,'chat_admin_main_manage','chat','Manage Chat Rooms','','{\"route\":\"admin_default\",\"module\":\"chat\",\"controller\":\"manage\"}','chat_admin_main','',0,1),(114,'chat_admin_main_settings','chat','Global Settings','','{\"route\":\"admin_default\",\"module\":\"chat\",\"controller\":\"settings\"}','chat_admin_main','',0,2),(115,'chat_admin_main_level','chat','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"chat\",\"controller\":\"settings\",\"action\":\"level\"}','chat_admin_main','',0,3),(116,'core_main_classified','classified','Classifieds','','{\"route\":\"classified_browse\"}','core_main','',0,4),(117,'core_sitemap_classified','classified','Classifieds','','{\"route\":\"classified_browse\"}','core_sitemap','',0,4),(118,'core_admin_main_plugins_classified','classified','Classifieds','','{\"route\":\"admin_default\",\"module\":\"classified\",\"controller\":\"settings\"}','core_admin_main_plugins','',0,999),(119,'classified_admin_main_manage','classified','View Classifieds','','{\"route\":\"admin_default\",\"module\":\"classified\",\"controller\":\"manage\"}','classified_admin_main','',0,1),(120,'classified_admin_main_settings','classified','Global Settings','','{\"route\":\"admin_default\",\"module\":\"classified\",\"controller\":\"settings\"}','classified_admin_main','',0,2),(121,'classified_admin_main_level','classified','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"classified\",\"controller\":\"level\"}','classified_admin_main','',0,3),(122,'classified_admin_main_fields','classified','Classified Questions','','{\"route\":\"admin_default\",\"module\":\"classified\",\"controller\":\"fields\"}','classified_admin_main','',0,4),(123,'classified_admin_main_categories','classified','Categories','','{\"route\":\"admin_default\",\"module\":\"classified\",\"controller\":\"settings\",\"action\":\"categories\"}','classified_admin_main','',0,5),(124,'core_main_blog','blog','Blogs','','{\"route\":\"blog_browse\"}','core_main','',0,4),(125,'core_sitemap_blog','blog','Blogs','','{\"route\":\"blog_browse\"}','core_sitemap','',0,4),(126,'core_admin_main_plugins_blog','blog','Blogs','','{\"route\":\"admin_default\",\"module\":\"blog\",\"controller\":\"settings\"}','core_admin_main_plugins','',0,999),(127,'blog_admin_main_manage','blog','View Blogs','','{\"route\":\"admin_default\",\"module\":\"blog\",\"controller\":\"manage\"}','blog_admin_main','',0,1),(128,'blog_admin_main_settings','blog','Global Settings','','{\"route\":\"admin_default\",\"module\":\"blog\",\"controller\":\"settings\"}','blog_admin_main','',0,2),(129,'blog_admin_main_level','blog','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"blog\",\"controller\":\"level\"}','blog_admin_main','',0,3),(130,'blog_admin_main_categories','blog','Categories','','{\"route\":\"admin_default\",\"module\":\"blog\",\"controller\":\"settings\", \"action\":\"categories\"}','blog_admin_main','',0,4),(131,'core_main_music','music','Music','','{\"route\":\"default\",\"module\":\"music\"}','core_main','',0,100),(132,'core_sitemap_music','music','Music','','{\"route\":\"default\",\"module\":\"music\"}','core_sitemap','',0,100),(133,'core_admin_main_plugins_music','music','Music','','{\"route\":\"admin_default\",\"module\":\"music\",\"controller\":\"settings\"}','core_admin_main_plugins','',0,999),(134,'music_admin_main_manage','music','Manage Music','','{\"route\":\"admin_default\",\"module\":\"music\",\"controller\":\"manage\"}','music_admin_main','',0,1),(135,'music_admin_main_settings','music','Global Settings','','{\"route\":\"admin_default\",\"module\":\"music\",\"controller\":\"settings\"}','music_admin_main','',0,2),(136,'music_admin_main_level','music','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"music\",\"controller\":\"level\"}','music_admin_main','',0,3),(137,'core_main_group','group','Groups','','{\"route\":\"group_general\"}','core_main','',0,6),(138,'core_sitemap_group','group','Groups','','{\"route\":\"group_general\"}','core_sitemap','',0,6),(139,'group_main_browse','group','Browse Groups','','{\"route\":\"group_general\",\"action\":\"browse\"}','group_main','',0,1),(140,'group_main_manage','group','My Groups','Group_Plugin_Menus','{\"route\":\"group_general\",\"action\":\"manage\"}','group_main','',0,2),(141,'group_main_create','group','Create New Group','Group_Plugin_Menus','{\"route\":\"group_general\",\"action\":\"create\"}','group_main','',0,3),(142,'group_profile_edit','group','Edit Profile','Group_Plugin_Menus','','group_profile','',0,1),(143,'group_profile_style','group','Edit Styles','Group_Plugin_Menus','','group_profile','',0,2),(144,'group_profile_member','group','Member','Group_Plugin_Menus','','group_profile','',0,3),(145,'group_profile_report','group','Report Group','Group_Plugin_Menus','','group_profile','',0,4),(146,'group_profile_share','group','Share','Group_Plugin_Menus','','group_profile','',0,5),(147,'group_profile_invite','group','Invite','Group_Plugin_Menus','','group_profile','',0,6),(148,'group_profile_message','group','Message Members','Group_Plugin_Menus','','group_profile','',0,7),(149,'core_admin_main_plugins_group','group','Groups','','{\"route\":\"admin_default\",\"module\":\"group\",\"controller\":\"manage\"}','core_admin_main_plugins','',0,999),(150,'group_admin_main_manage','group','Manage Groups','','{\"route\":\"admin_default\",\"module\":\"group\",\"controller\":\"manage\"}','group_admin_main','',0,1),(151,'group_admin_main_level','group','Member Level Settings','','{\"route\":\"admin_default\",\"module\":\"group\",\"controller\":\"level\"}','group_admin_main','',0,2),(152,'group_admin_main_categories','group','Categories','','{\"route\":\"admin_default\",\"module\":\"group\",\"controller\":\"settings\",\"action\":\"categories\"}','group_admin_main','',0,3);
/*!40000 ALTER TABLE `engine4_core_menuitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_menus`
--

DROP TABLE IF EXISTS `engine4_core_menus`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_menus` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `type` enum('standard','hidden','custom') character set latin1 collate latin1_general_ci NOT NULL default 'standard',
  `title` varchar(64) collate utf8_unicode_ci NOT NULL,
  `order` smallint(3) NOT NULL default '999',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `order` (`order`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_menus`
--

LOCK TABLES `engine4_core_menus` WRITE;
/*!40000 ALTER TABLE `engine4_core_menus` DISABLE KEYS */;
INSERT INTO `engine4_core_menus` VALUES (1,'core_main','standard','Main Navigation Menu',1),(2,'core_mini','standard','Mini Navigation Menu',2),(3,'core_footer','standard','Footer Menu',3),(4,'core_sitemap','standard','Sitemap',4);
/*!40000 ALTER TABLE `engine4_core_menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_modules`
--

DROP TABLE IF EXISTS `engine4_core_modules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_modules` (
  `name` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL,
  `description` text collate utf8_unicode_ci,
  `version` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL default '0',
  `type` enum('core','standard','extra') character set latin1 collate latin1_general_ci NOT NULL default 'extra',
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_modules`
--

LOCK TABLES `engine4_core_modules` WRITE;
/*!40000 ALTER TABLE `engine4_core_modules` DISABLE KEYS */;
INSERT INTO `engine4_core_modules` VALUES ('activity','Activity','Activity','4.0.0',1,'core'),('album','Albums','Albums','4.0.0',1,'extra'),('announcement','Announcements','Announcements','4.0.0',1,'standard'),('authorization','Authorization','Authorization','4.0.0',1,'core'),('blog','Blogs','Blogs','4.0.0',1,'extra'),('chat','Chat','Chat','4.0.0',1,'extra'),('classified','Classifieds','Classifieds','4.0.0',1,'extra'),('core','Core','The Alpha and the Omega.','4.0.0',1,'core'),('event','Events','Events','4.0.0',1,'extra'),('fields','Fields','Fields','4.0.0',1,'core'),('group','Groups','Groups','4.0.0',1,'extra'),('invite','Invites','Invites','4.0.0',1,'standard'),('messages','Messages','Messages','4.0.0',1,'standard'),('music','Music','Music','4.0.0',1,'extra'),('network','Networks','Networks','4.0.0',1,'standard'),('storage','Storage','Storage','4.0.0',1,'core'),('user','Users','Users','4.0.0',1,'core'),('video','Videos','Videos','4.0.0',1,'extra');
/*!40000 ALTER TABLE `engine4_core_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_pages`
--

DROP TABLE IF EXISTS `engine4_core_pages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_pages` (
  `page_id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(128) character set latin1 collate latin1_general_ci default NULL,
  `displayname` varchar(128) collate utf8_unicode_ci NOT NULL default '',
  `url` varchar(128) collate utf8_unicode_ci default NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `description` text collate utf8_unicode_ci NOT NULL,
  `keywords` text collate utf8_unicode_ci NOT NULL,
  `custom` tinyint(1) NOT NULL default '1',
  `fragment` tinyint(1) NOT NULL default '0',
  `layout` varchar(32) collate utf8_unicode_ci NOT NULL default '',
  `view_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`page_id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_pages`
--

LOCK TABLES `engine4_core_pages` WRITE;
/*!40000 ALTER TABLE `engine4_core_pages` DISABLE KEYS */;
INSERT INTO `engine4_core_pages` VALUES (1,'header','Site Header',NULL,'','','',0,1,'',0),(2,'footer','Site Footer',NULL,'','','',0,1,'',0),(3,'core_index_index','Home Page',NULL,'Home Page','This is the home page.','',0,0,'',0),(4,'user_index_home','Member Home Page',NULL,'Member Home Page','This is the home page for members.','',0,0,'',0),(5,'user_profile_index','Member Profile',NULL,'Member Profile','This is a member\'s profile.','',0,0,'',0),(6,'event_profile_index','Event Profile',NULL,'Event Profile','This is the profile for an event.','',1,0,'',0),(7,'group_profile_index','Group Profile',NULL,'Group Profile','This is the profile for an group.','',1,0,'',0);
/*!40000 ALTER TABLE `engine4_core_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_referrers`
--

DROP TABLE IF EXISTS `engine4_core_referrers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_referrers` (
  `host` varchar(64) collate utf8_unicode_ci NOT NULL,
  `path` varchar(64) collate utf8_unicode_ci NOT NULL,
  `query` varchar(128) collate utf8_unicode_ci NOT NULL,
  `value` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`host`,`path`,`query`),
  KEY `value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_referrers`
--

LOCK TABLES `engine4_core_referrers` WRITE;
/*!40000 ALTER TABLE `engine4_core_referrers` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_referrers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_reports`
--

DROP TABLE IF EXISTS `engine4_core_reports`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_reports` (
  `report_id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `category` varchar(16) collate utf8_unicode_ci NOT NULL,
  `description` text collate utf8_unicode_ci NOT NULL,
  `subject_type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `subject_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  `read` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`report_id`),
  KEY `category` (`category`),
  KEY `user_id` (`user_id`),
  KEY `read` (`read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_reports`
--

LOCK TABLES `engine4_core_reports` WRITE;
/*!40000 ALTER TABLE `engine4_core_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_routes`
--

DROP TABLE IF EXISTS `engine4_core_routes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_routes` (
  `name` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `config` text collate utf8_unicode_ci NOT NULL,
  `order` smallint(6) NOT NULL default '1',
  PRIMARY KEY  (`name`),
  KEY `order` (`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_routes`
--

LOCK TABLES `engine4_core_routes` WRITE;
/*!40000 ALTER TABLE `engine4_core_routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_search`
--

DROP TABLE IF EXISTS `engine4_core_search`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_search` (
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `id` int(11) unsigned NOT NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `keywords` varchar(255) collate utf8_unicode_ci NOT NULL,
  `hidden` varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`type`,`id`),
  FULLTEXT KEY `LOOKUP` (`title`,`description`,`keywords`,`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_search`
--

LOCK TABLES `engine4_core_search` WRITE;
/*!40000 ALTER TABLE `engine4_core_search` DISABLE KEYS */;
INSERT INTO `engine4_core_search` VALUES ('user',2,'dinesh mangal','','','');
/*!40000 ALTER TABLE `engine4_core_search` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_session`
--

DROP TABLE IF EXISTS `engine4_core_session`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_session` (
  `id` char(32) collate utf8_unicode_ci NOT NULL default '',
  `modified` int(11) default NULL,
  `lifetime` int(11) default NULL,
  `data` text collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_session`
--

LOCK TABLES `engine4_core_session` WRITE;
/*!40000 ALTER TABLE `engine4_core_session` DISABLE KEYS */;
INSERT INTO `engine4_core_session` VALUES ('0kim246foab9t35qq7q6hjq91p97cmah',1278306895,86400,''),('a11bh9jtgubesk3mjrfgsc9gr3rohvij',1278054699,86400,''),('bnkjaa0n0v2cf6a52hagg9mcpu5h2i1f',1278306851,86400,''),('bqlm2cnmu7aoppovssjjht87flnpqe0t',1278054904,86400,'User_AuthController|a:1:{s:4:\"data\";N;}__ZF|a:1:{s:33:\"Zend_Form_Element_Hash_salt_token\";a:1:{s:3:\"ENT\";i:1278055039;}}Zend_Auth|a:1:{s:7:\"storage\";i:2;}'),('c34sq9p1tmsfhbtm9qnn5o903jqomifh',1278056366,86400,''),('f50iolk2er7pltrolam9380ejtqq6shg',1278054512,86400,''),('fbvfjkg2dm0cq4mgqr4jq3p8e15orl9e',1278054873,86400,''),('gdgcec4tsps30lep9juh8b8ah30dmjb1',1278051782,86400,''),('grfjr1cuqbk902ikmobnk6403o199g6s',1278054833,86400,'Zend_Auth|a:1:{s:7:\"storage\";s:21:\"admin@bigsteptech.com\";}'),('jv2nkncjb4kv087oik05clitlldt88cb',1278056209,86400,''),('k9fnqliera73clcbcusm5ajc5vc7p7l4',1278054573,86400,''),('mfnsim2dt697d9pp5ac6mj8efeo7p0p4',1278051852,86400,''),('sk2nna3kb83ruvlvn9i81tmif5804sgd',1278054793,86400,''),('vf4joi24etrb40v1bvvrn3up7g0avjcs',1278306851,86400,''),('vktn51bt8c6o6258fl87ea1sd4urhtkc',1278056479,86400,'Zend_Auth|a:1:{s:7:\"storage\";s:21:\"admin@bigsteptech.com\";}');
/*!40000 ALTER TABLE `engine4_core_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_settings`
--

DROP TABLE IF EXISTS `engine4_core_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_settings` (
  `name` varchar(255) character set latin1 collate latin1_general_ci NOT NULL,
  `value` varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_settings`
--

LOCK TABLES `engine4_core_settings` WRITE;
/*!40000 ALTER TABLE `engine4_core_settings` DISABLE KEYS */;
INSERT INTO `engine4_core_settings` VALUES ('activity.content','everyone'),('activity.disallowed','N'),('activity.filter','1'),('activity.length','15'),('activity.liveupdate','120000'),('activity.notifications.template','Hello %title%,\n\n%body%\n\n--Site Admin'),('activity.publish','1'),('activity.userdelete','1'),('activity.userlength','5'),('authorization.defaultlevel','4'),('chat.chat.enabled','1'),('chat.general.delay','5000'),('chat.im.enabled','1'),('chat.im.privacy','friends'),('classified.currency','$'),('core.admin.mode','none'),('core.admin.password',''),('core.admin.reauthenticate','0'),('core.admin.timeout','600'),('core.application.comet','0'),('core.application.tasks','1'),('core.comet.delay','1000'),('core.comet.enabled','1'),('core.comet.mode','short'),('core.comet.reconnect','2000'),('core.doctype','XHTML1_STRICT'),('core.email.from','email@domain.com'),('core.facebook.enable','none'),('core.facebook.key',''),('core.facebook.secret',''),('core.general.commenthtml',''),('core.general.notificationupdate','120000'),('core.general.portal','1'),('core.general.profile','1'),('core.general.quota','0'),('core.general.search','1'),('core.general.site.title','My Community'),('core.license.email','email@domain.com'),('core.license.key','7295-6161-6292-0216'),('core.license.statistics','0'),('core.locale.locale','auto'),('core.locale.timezone','US/Pacific'),('core.mail.count','25'),('core.mail.enabled','1'),('core.mail.queueing','1'),('core.secret','3051256c53388d4bacc77145517fe1c79494dc4a'),('core.site.creation','2010-07-02 06:21:54'),('core.site.title','Social Network'),('core.spam.censor',''),('core.spam.comment','0'),('core.spam.contact','0'),('core.spam.invite','0'),('core.spam.ipbans',''),('core.spam.login','0'),('core.spam.signup','0'),('core.tasks.interval','60'),('core.tasks.key','7fffffff'),('core.tasks.last','1278306851'),('core.tasks.mode','curl'),('core.tasks.pid',''),('core.tasks.timeout','900'),('core.thumbnails.icon.height','48'),('core.thumbnails.icon.mode','crop'),('core.thumbnails.icon.width','48'),('core.thumbnails.main.height','720'),('core.thumbnails.main.mode','resize'),('core.thumbnails.main.width','720'),('core.thumbnails.normal.height','160'),('core.thumbnails.normal.mode','resize'),('core.thumbnails.normal.width','140'),('core.thumbnails.profile.height','400'),('core.thumbnails.profile.mode','resize'),('core.thumbnails.profile.width','200'),('invite.allowCustomMessage','1'),('invite.fromEmail',''),('invite.fromName',''),('invite.message','You are being invited to join our social network.'),('invite.subject','Join Us'),('user.friends.direction','1'),('user.friends.eligible','2'),('user.friends.lists','1'),('user.friends.verification','1'),('user.signup.approve','1'),('user.signup.checkemail','1'),('user.signup.inviteonly','0'),('user.signup.random','0'),('user.signup.terms','1'),('user.signup.verifyemail','0'),('video.ffmpeg.path','/usr/local/bin/ffmpeg'),('video.jobs','2');
/*!40000 ALTER TABLE `engine4_core_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_statistics`
--

DROP TABLE IF EXISTS `engine4_core_statistics`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_statistics` (
  `type` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `date` datetime NOT NULL,
  `value` int(11) NOT NULL default '0',
  PRIMARY KEY  (`type`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_statistics`
--

LOCK TABLES `engine4_core_statistics` WRITE;
/*!40000 ALTER TABLE `engine4_core_statistics` DISABLE KEYS */;
INSERT INTO `engine4_core_statistics` VALUES ('core.views','2010-07-02 00:00:00',44),('core.views','2010-07-05 00:00:00',3),('user.creations','2010-07-02 00:00:00',1),('user.logins','2010-07-02 00:00:00',2);
/*!40000 ALTER TABLE `engine4_core_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_status`
--

DROP TABLE IF EXISTS `engine4_core_status`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_status` (
  `status_id` int(11) unsigned NOT NULL auto_increment,
  `resource_type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `resource_id` int(11) unsigned NOT NULL,
  `body` text NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY  (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_status`
--

LOCK TABLES `engine4_core_status` WRITE;
/*!40000 ALTER TABLE `engine4_core_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_styles`
--

DROP TABLE IF EXISTS `engine4_core_styles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_styles` (
  `type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `id` int(11) unsigned NOT NULL,
  `style` text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_styles`
--

LOCK TABLES `engine4_core_styles` WRITE;
/*!40000 ALTER TABLE `engine4_core_styles` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_styles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_tagmaps`
--

DROP TABLE IF EXISTS `engine4_core_tagmaps`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_tagmaps` (
  `tagmap_id` int(11) unsigned NOT NULL auto_increment,
  `resource_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `resource_id` int(11) unsigned NOT NULL,
  `tagger_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `tagger_id` int(11) unsigned NOT NULL,
  `tag_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `tag_id` int(11) unsigned NOT NULL,
  `extra` text collate utf8_unicode_ci,
  PRIMARY KEY  (`tagmap_id`),
  KEY `resource_type` (`resource_type`,`resource_id`),
  KEY `tagger_type` (`tagger_type`,`tagger_id`),
  KEY `tag_type` (`tag_type`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_tagmaps`
--

LOCK TABLES `engine4_core_tagmaps` WRITE;
/*!40000 ALTER TABLE `engine4_core_tagmaps` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_tagmaps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_tags`
--

DROP TABLE IF EXISTS `engine4_core_tags`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_tags` (
  `tag_id` int(11) unsigned NOT NULL auto_increment,
  `text` varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`tag_id`),
  UNIQUE KEY `text` (`text`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_tags`
--

LOCK TABLES `engine4_core_tags` WRITE;
/*!40000 ALTER TABLE `engine4_core_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_core_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_tasks`
--

DROP TABLE IF EXISTS `engine4_core_tasks`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_tasks` (
  `task_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `system` tinyint(1) NOT NULL default '0',
  `plugin` varchar(128) character set latin1 collate latin1_general_ci NOT NULL,
  `timeout` int(11) unsigned NOT NULL,
  `enabled` tinyint(4) NOT NULL default '1',
  `executing` tinyint(1) NOT NULL default '0',
  `executing_id` int(11) unsigned NOT NULL default '0',
  `started_last` int(11) NOT NULL default '0',
  `started_count` int(11) unsigned NOT NULL default '0',
  `completed_last` int(11) NOT NULL default '0',
  `completed_count` int(11) unsigned NOT NULL default '0',
  `failure_last` int(11) NOT NULL default '0',
  `failure_count` int(11) unsigned NOT NULL default '0',
  `success_last` int(11) NOT NULL default '0',
  `success_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`task_id`),
  UNIQUE KEY `plugin` (`plugin`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_tasks`
--

LOCK TABLES `engine4_core_tasks` WRITE;
/*!40000 ALTER TABLE `engine4_core_tasks` DISABLE KEYS */;
INSERT INTO `engine4_core_tasks` VALUES (1,'Background Mailer',1,'Core_Plugin_Task_Mail',60,1,0,0,1278306851,10,1278306851,10,0,0,1278306851,10),(2,'Statistics',1,'Core_Plugin_Task_Statistics',43200,1,0,0,1278306851,2,1278306851,2,0,0,1278306851,2),(3,'Member Data Maintenance',1,'User_Plugin_Task_Cleanup',60,1,0,0,1278306851,10,1278306851,10,0,0,1278306851,10),(4,'Background Video Encoder',0,'Video_Plugin_Task_Encode',300,1,0,0,1278306851,3,1278306851,3,0,0,1278306851,3);
/*!40000 ALTER TABLE `engine4_core_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_core_themes`
--

DROP TABLE IF EXISTS `engine4_core_themes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_core_themes` (
  `theme_id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `active` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`theme_id`),
  UNIQUE KEY `name` (`name`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_core_themes`
--

LOCK TABLES `engine4_core_themes` WRITE;
/*!40000 ALTER TABLE `engine4_core_themes` DISABLE KEYS */;
INSERT INTO `engine4_core_themes` VALUES (1,'default','Default Theme','',1),(2,'midnight','Midnight','',0);
/*!40000 ALTER TABLE `engine4_core_themes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_event_albums`
--

DROP TABLE IF EXISTS `engine4_event_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_event_albums` (
  `album_id` int(11) unsigned NOT NULL auto_increment,
  `event_id` int(11) unsigned NOT NULL,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `search` tinyint(1) NOT NULL default '1',
  `photo_id` int(11) unsigned NOT NULL default '0',
  `view_count` int(11) unsigned NOT NULL default '0',
  `comment_count` int(11) unsigned NOT NULL default '0',
  `collectible_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`album_id`),
  KEY `event_id` (`event_id`),
  KEY `search` (`search`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_event_albums`
--

LOCK TABLES `engine4_event_albums` WRITE;
/*!40000 ALTER TABLE `engine4_event_albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_event_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_event_categories`
--

DROP TABLE IF EXISTS `engine4_event_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_event_categories` (
  `category_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_event_categories`
--

LOCK TABLES `engine4_event_categories` WRITE;
/*!40000 ALTER TABLE `engine4_event_categories` DISABLE KEYS */;
INSERT INTO `engine4_event_categories` VALUES (1,'Arts'),(2,'Business'),(3,'Conferences'),(4,'Festivals'),(5,'Food'),(6,'Fundraisers'),(7,'Galleries'),(8,'Health'),(9,'Just For Fun'),(10,'Kids'),(11,'Learning'),(12,'Literary'),(13,'Movies'),(14,'Museums'),(15,'Neighborhood'),(16,'Networking'),(17,'Nightlife'),(18,'On Campus'),(19,'Organizations'),(20,'Outdoors'),(21,'Pets'),(22,'Politics'),(23,'Sales'),(24,'Science'),(25,'Spirituality'),(26,'Sports'),(27,'Technology'),(28,'Theatre'),(29,'Other');
/*!40000 ALTER TABLE `engine4_event_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_event_events`
--

DROP TABLE IF EXISTS `engine4_event_events`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_event_events` (
  `event_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` varchar(512) collate utf8_unicode_ci NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `parent_type` varchar(64) collate utf8_unicode_ci NOT NULL,
  `parent_id` int(11) unsigned NOT NULL,
  `search` tinyint(1) NOT NULL default '1',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `host` varchar(115) collate utf8_unicode_ci NOT NULL,
  `location` varchar(115) collate utf8_unicode_ci NOT NULL,
  `view_count` int(11) unsigned NOT NULL default '0',
  `member_count` int(11) unsigned NOT NULL default '0',
  `approval` tinyint(1) NOT NULL default '0',
  `invite` tinyint(1) NOT NULL default '0',
  `photo_id` int(11) unsigned NOT NULL,
  `category_id` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`event_id`),
  KEY `user_id` (`user_id`),
  KEY `parent_type` (`parent_type`,`parent_id`),
  KEY `starttime` (`starttime`),
  KEY `search` (`search`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_event_events`
--

LOCK TABLES `engine4_event_events` WRITE;
/*!40000 ALTER TABLE `engine4_event_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_event_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_event_membership`
--

DROP TABLE IF EXISTS `engine4_event_membership`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_event_membership` (
  `resource_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL default '0',
  `resource_approved` tinyint(1) NOT NULL default '0',
  `user_approved` tinyint(1) NOT NULL default '0',
  `message` text collate utf8_unicode_ci,
  `rsvp` tinyint(3) NOT NULL default '1',
  `title` text collate utf8_unicode_ci,
  PRIMARY KEY  (`resource_id`,`user_id`),
  KEY `REVERSE` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_event_membership`
--

LOCK TABLES `engine4_event_membership` WRITE;
/*!40000 ALTER TABLE `engine4_event_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_event_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_event_photos`
--

DROP TABLE IF EXISTS `engine4_event_photos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_event_photos` (
  `photo_id` int(11) unsigned NOT NULL auto_increment,
  `album_id` int(11) unsigned NOT NULL,
  `event_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `collection_id` int(11) unsigned NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY  (`photo_id`),
  KEY `album_id` (`album_id`),
  KEY `event_id` (`event_id`),
  KEY `collection_id` (`collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_event_photos`
--

LOCK TABLES `engine4_event_photos` WRITE;
/*!40000 ALTER TABLE `engine4_event_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_event_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_event_posts`
--

DROP TABLE IF EXISTS `engine4_event_posts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_event_posts` (
  `post_id` int(11) unsigned NOT NULL auto_increment,
  `topic_id` int(11) unsigned NOT NULL,
  `event_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY  (`post_id`),
  KEY `topic_id` (`topic_id`),
  KEY `event_id` (`event_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_event_posts`
--

LOCK TABLES `engine4_event_posts` WRITE;
/*!40000 ALTER TABLE `engine4_event_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_event_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_event_topics`
--

DROP TABLE IF EXISTS `engine4_event_topics`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_event_topics` (
  `topic_id` int(11) unsigned NOT NULL auto_increment,
  `event_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `sticky` tinyint(1) NOT NULL default '0',
  `closed` tinyint(1) NOT NULL default '0',
  `post_count` int(11) unsigned NOT NULL default '0',
  `lastpost_id` int(11) unsigned NOT NULL,
  `lastposter_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`topic_id`),
  KEY `event_id` (`event_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_event_topics`
--

LOCK TABLES `engine4_event_topics` WRITE;
/*!40000 ALTER TABLE `engine4_event_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_event_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_albums`
--

DROP TABLE IF EXISTS `engine4_group_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_albums` (
  `album_id` int(11) unsigned NOT NULL auto_increment,
  `group_id` int(11) unsigned NOT NULL,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `search` tinyint(1) NOT NULL default '1',
  `photo_id` int(11) unsigned NOT NULL default '0',
  `view_count` int(11) unsigned NOT NULL default '0',
  `comment_count` int(11) unsigned NOT NULL default '0',
  `collectible_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`album_id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_albums`
--

LOCK TABLES `engine4_group_albums` WRITE;
/*!40000 ALTER TABLE `engine4_group_albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_categories`
--

DROP TABLE IF EXISTS `engine4_group_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_categories` (
  `category_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_categories`
--

LOCK TABLES `engine4_group_categories` WRITE;
/*!40000 ALTER TABLE `engine4_group_categories` DISABLE KEYS */;
INSERT INTO `engine4_group_categories` VALUES (1,'Animals'),(2,'Business & Finance'),(3,'Computers & Internet'),(4,'Cultures & Community'),(5,'Dating & Relationships'),(6,'Entertainment & Arts'),(7,'Family & Home'),(8,'Games'),(9,'Government & Politics'),(10,'Health & Wellness'),(11,'Hobbies & Crafts'),(12,'Music'),(13,'Recreation & Sports'),(14,'Regional'),(15,'Religion & Beliefs'),(16,'Schools & Education'),(17,'Science');
/*!40000 ALTER TABLE `engine4_group_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_groups`
--

DROP TABLE IF EXISTS `engine4_group_groups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_groups` (
  `group_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL,
  `description` text collate utf8_unicode_ci NOT NULL,
  `category_id` int(11) unsigned NOT NULL default '0',
  `search` tinyint(1) NOT NULL default '1',
  `invite` tinyint(1) NOT NULL default '1',
  `approval` tinyint(1) NOT NULL default '0',
  `photo_id` int(11) unsigned NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `member_count` smallint(6) unsigned NOT NULL,
  `view_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `search` (`search`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_groups`
--

LOCK TABLES `engine4_group_groups` WRITE;
/*!40000 ALTER TABLE `engine4_group_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_listitems`
--

DROP TABLE IF EXISTS `engine4_group_listitems`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_listitems` (
  `listitem_id` int(11) unsigned NOT NULL auto_increment,
  `list_id` int(11) unsigned NOT NULL,
  `child_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`listitem_id`),
  KEY `list_id` (`list_id`),
  KEY `child_id` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_listitems`
--

LOCK TABLES `engine4_group_listitems` WRITE;
/*!40000 ALTER TABLE `engine4_group_listitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_listitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_lists`
--

DROP TABLE IF EXISTS `engine4_group_lists`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_lists` (
  `list_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL default '',
  `owner_id` int(11) unsigned NOT NULL,
  `child_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`list_id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_lists`
--

LOCK TABLES `engine4_group_lists` WRITE;
/*!40000 ALTER TABLE `engine4_group_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_membership`
--

DROP TABLE IF EXISTS `engine4_group_membership`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_membership` (
  `resource_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL default '0',
  `resource_approved` tinyint(1) NOT NULL default '0',
  `user_approved` tinyint(1) NOT NULL default '0',
  `message` text collate utf8_unicode_ci,
  `title` text collate utf8_unicode_ci,
  PRIMARY KEY  (`resource_id`,`user_id`),
  KEY `REVERSE` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_membership`
--

LOCK TABLES `engine4_group_membership` WRITE;
/*!40000 ALTER TABLE `engine4_group_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_photos`
--

DROP TABLE IF EXISTS `engine4_group_photos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_photos` (
  `photo_id` int(11) unsigned NOT NULL auto_increment,
  `album_id` int(11) unsigned NOT NULL,
  `group_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(128) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `collection_id` int(11) unsigned NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY  (`photo_id`),
  KEY `album_id` (`album_id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_photos`
--

LOCK TABLES `engine4_group_photos` WRITE;
/*!40000 ALTER TABLE `engine4_group_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_posts`
--

DROP TABLE IF EXISTS `engine4_group_posts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_posts` (
  `post_id` int(11) unsigned NOT NULL auto_increment,
  `topic_id` int(11) unsigned NOT NULL,
  `group_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY  (`post_id`),
  KEY `topic_id` (`topic_id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_posts`
--

LOCK TABLES `engine4_group_posts` WRITE;
/*!40000 ALTER TABLE `engine4_group_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_group_topics`
--

DROP TABLE IF EXISTS `engine4_group_topics`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_group_topics` (
  `topic_id` int(11) unsigned NOT NULL auto_increment,
  `group_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `sticky` tinyint(1) NOT NULL default '0',
  `closed` tinyint(1) NOT NULL default '0',
  `post_count` int(11) unsigned NOT NULL default '0',
  `lastpost_id` int(11) unsigned NOT NULL,
  `lastposter_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`topic_id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_group_topics`
--

LOCK TABLES `engine4_group_topics` WRITE;
/*!40000 ALTER TABLE `engine4_group_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_group_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_invites`
--

DROP TABLE IF EXISTS `engine4_invites`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_invites` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `recipient` varchar(255) collate utf8_unicode_ci NOT NULL,
  `code` varchar(255) character set latin1 collate latin1_general_ci NOT NULL,
  `timestamp` datetime NOT NULL,
  `message` text collate utf8_unicode_ci NOT NULL,
  `new_user_id` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `user_id` (`user_id`),
  KEY `recipient` (`recipient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_invites`
--

LOCK TABLES `engine4_invites` WRITE;
/*!40000 ALTER TABLE `engine4_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_messages_conversations`
--

DROP TABLE IF EXISTS `engine4_messages_conversations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_messages_conversations` (
  `conversation_id` int(11) unsigned NOT NULL auto_increment,
  `recipients` int(11) unsigned NOT NULL,
  `modified` datetime NOT NULL,
  `locked` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_messages_conversations`
--

LOCK TABLES `engine4_messages_conversations` WRITE;
/*!40000 ALTER TABLE `engine4_messages_conversations` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_messages_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_messages_messages`
--

DROP TABLE IF EXISTS `engine4_messages_messages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_messages_messages` (
  `message_id` int(11) unsigned NOT NULL auto_increment,
  `conversation_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `body` text collate utf8_unicode_ci NOT NULL,
  `date` datetime NOT NULL,
  `attachment_type` varchar(24) character set latin1 collate latin1_general_ci default '',
  `attachment_id` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`message_id`),
  UNIQUE KEY `CONVERSATIONS` (`conversation_id`,`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_messages_messages`
--

LOCK TABLES `engine4_messages_messages` WRITE;
/*!40000 ALTER TABLE `engine4_messages_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_messages_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_messages_recipients`
--

DROP TABLE IF EXISTS `engine4_messages_recipients`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_messages_recipients` (
  `user_id` int(11) unsigned NOT NULL,
  `conversation_id` int(11) unsigned NOT NULL,
  `inbox_message_id` int(11) unsigned default NULL,
  `inbox_updated` datetime default NULL,
  `inbox_read` tinyint(1) default NULL,
  `inbox_deleted` tinyint(1) default NULL,
  `outbox_message_id` int(11) unsigned default NULL,
  `outbox_updated` datetime default NULL,
  `outbox_deleted` tinyint(1) default NULL,
  PRIMARY KEY  (`user_id`,`conversation_id`),
  KEY `INBOX_UPDATED` (`user_id`,`conversation_id`,`inbox_updated`),
  KEY `OUTBOX_UPDATED` (`user_id`,`conversation_id`,`outbox_updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_messages_recipients`
--

LOCK TABLES `engine4_messages_recipients` WRITE;
/*!40000 ALTER TABLE `engine4_messages_recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_messages_recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_music_playlist_songs`
--

DROP TABLE IF EXISTS `engine4_music_playlist_songs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_music_playlist_songs` (
  `song_id` int(11) unsigned NOT NULL auto_increment,
  `playlist_id` int(11) unsigned NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `title` varchar(60) collate utf8_unicode_ci NOT NULL,
  `play_count` int(11) unsigned NOT NULL default '0',
  `order` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`song_id`),
  KEY `playlist_id` (`playlist_id`,`file_id`),
  KEY `play_count` (`play_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_music_playlist_songs`
--

LOCK TABLES `engine4_music_playlist_songs` WRITE;
/*!40000 ALTER TABLE `engine4_music_playlist_songs` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_music_playlist_songs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_music_playlists`
--

DROP TABLE IF EXISTS `engine4_music_playlists`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_music_playlists` (
  `playlist_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(63) collate utf8_unicode_ci NOT NULL default '',
  `description` text collate utf8_unicode_ci NOT NULL,
  `photo_id` int(11) unsigned NOT NULL default '0',
  `owner_type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `owner_id` int(11) unsigned NOT NULL,
  `search` tinyint(1) NOT NULL default '1',
  `profile` tinyint(1) NOT NULL default '0',
  `composer` tinyint(1) NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `play_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`playlist_id`),
  KEY `creation_date` (`creation_date`),
  KEY `play_count` (`play_count`),
  KEY `owner_id` (`owner_type`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_music_playlists`
--

LOCK TABLES `engine4_music_playlists` WRITE;
/*!40000 ALTER TABLE `engine4_music_playlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_music_playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_network_membership`
--

DROP TABLE IF EXISTS `engine4_network_membership`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_network_membership` (
  `resource_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL default '0',
  `resource_approved` tinyint(1) NOT NULL default '0',
  `user_approved` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`resource_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_network_membership`
--

LOCK TABLES `engine4_network_membership` WRITE;
/*!40000 ALTER TABLE `engine4_network_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_network_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_network_networks`
--

DROP TABLE IF EXISTS `engine4_network_networks`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_network_networks` (
  `network_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL,
  `field_id` int(11) unsigned NOT NULL default '0',
  `pattern` text collate utf8_unicode_ci,
  `member_count` int(11) unsigned NOT NULL default '0',
  `hide` tinyint(1) NOT NULL default '0',
  `assignment` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`network_id`),
  KEY `assignment` (`assignment`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_network_networks`
--

LOCK TABLES `engine4_network_networks` WRITE;
/*!40000 ALTER TABLE `engine4_network_networks` DISABLE KEYS */;
INSERT INTO `engine4_network_networks` VALUES (1,'North America','',0,NULL,0,0,0),(2,'South America','',0,NULL,0,0,0),(3,'Europe','',0,NULL,0,0,0),(4,'Asia','',0,NULL,0,0,0),(5,'Africa','',0,NULL,0,0,0),(6,'Australia','',0,NULL,0,0,0),(7,'Antarctica','',0,NULL,0,0,0);
/*!40000 ALTER TABLE `engine4_network_networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_storage_chunks`
--

DROP TABLE IF EXISTS `engine4_storage_chunks`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_storage_chunks` (
  `chunk_id` bigint(20) unsigned NOT NULL auto_increment,
  `file_id` int(11) unsigned NOT NULL,
  `data` blob NOT NULL,
  PRIMARY KEY  (`chunk_id`),
  KEY `file_id` (`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_storage_chunks`
--

LOCK TABLES `engine4_storage_chunks` WRITE;
/*!40000 ALTER TABLE `engine4_storage_chunks` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_storage_chunks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_storage_files`
--

DROP TABLE IF EXISTS `engine4_storage_files`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_storage_files` (
  `file_id` int(11) unsigned NOT NULL auto_increment,
  `parent_file_id` int(11) unsigned default NULL,
  `type` varchar(16) character set latin1 collate latin1_general_ci default NULL,
  `parent_type` varchar(32) character set latin1 collate latin1_general_ci NOT NULL,
  `parent_id` int(11) unsigned default NULL,
  `user_id` int(11) unsigned default NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `storage_type` varchar(32) collate utf8_unicode_ci NOT NULL,
  `storage_path` varchar(255) collate utf8_unicode_ci NOT NULL,
  `extension` varchar(8) collate utf8_unicode_ci NOT NULL,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `mime_major` varchar(64) collate utf8_unicode_ci NOT NULL,
  `mime_minor` varchar(64) collate utf8_unicode_ci NOT NULL,
  `size` bigint(20) unsigned NOT NULL,
  `hash` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  PRIMARY KEY  (`file_id`),
  UNIQUE KEY `parent_file_id` (`parent_file_id`,`type`),
  KEY `PARENT` (`parent_type`,`parent_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_storage_files`
--

LOCK TABLES `engine4_storage_files` WRITE;
/*!40000 ALTER TABLE `engine4_storage_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_storage_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_block`
--

DROP TABLE IF EXISTS `engine4_user_block`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_block` (
  `user_id` int(11) unsigned NOT NULL,
  `blocked_user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`user_id`,`blocked_user_id`),
  KEY `REVERSE` (`blocked_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_block`
--

LOCK TABLES `engine4_user_block` WRITE;
/*!40000 ALTER TABLE `engine4_user_block` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_user_block` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_facebook`
--

DROP TABLE IF EXISTS `engine4_user_facebook`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_facebook` (
  `user_id` int(11) unsigned NOT NULL,
  `facebook_uid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY  (`user_id`),
  UNIQUE KEY `facebook_uid` (`facebook_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_facebook`
--

LOCK TABLES `engine4_user_facebook` WRITE;
/*!40000 ALTER TABLE `engine4_user_facebook` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_user_facebook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_fields_maps`
--

DROP TABLE IF EXISTS `engine4_user_fields_maps`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_fields_maps` (
  `field_id` int(11) unsigned NOT NULL,
  `option_id` int(11) unsigned NOT NULL,
  `child_id` int(11) unsigned NOT NULL,
  `order` smallint(6) NOT NULL,
  PRIMARY KEY  (`field_id`,`option_id`,`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_fields_maps`
--

LOCK TABLES `engine4_user_fields_maps` WRITE;
/*!40000 ALTER TABLE `engine4_user_fields_maps` DISABLE KEYS */;
INSERT INTO `engine4_user_fields_maps` VALUES (0,0,1,1),(1,1,2,2),(1,1,3,3),(1,1,4,4),(1,1,5,5),(1,1,6,6),(1,1,7,7),(1,1,8,8),(1,1,9,9),(1,1,10,10),(1,1,11,11),(1,1,12,12),(1,1,13,13);
/*!40000 ALTER TABLE `engine4_user_fields_maps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_fields_meta`
--

DROP TABLE IF EXISTS `engine4_user_fields_meta`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_fields_meta` (
  `field_id` int(11) unsigned NOT NULL auto_increment,
  `type` varchar(24) character set latin1 collate latin1_general_ci NOT NULL,
  `label` varchar(64) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `alias` varchar(32) character set latin1 collate latin1_general_ci NOT NULL default '',
  `required` tinyint(1) NOT NULL default '0',
  `display` tinyint(1) unsigned NOT NULL,
  `publish` tinyint(1) unsigned NOT NULL default '0',
  `search` tinyint(1) unsigned NOT NULL default '0',
  `order` smallint(3) unsigned NOT NULL default '999',
  `config` text collate utf8_unicode_ci,
  `validators` text collate utf8_unicode_ci,
  `filters` text collate utf8_unicode_ci,
  `style` text collate utf8_unicode_ci,
  `error` text collate utf8_unicode_ci,
  PRIMARY KEY  (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_fields_meta`
--

LOCK TABLES `engine4_user_fields_meta` WRITE;
/*!40000 ALTER TABLE `engine4_user_fields_meta` DISABLE KEYS */;
INSERT INTO `engine4_user_fields_meta` VALUES (1,'profile_type','Profile Type','','profile_type',1,0,0,2,999,'',NULL,NULL,NULL,NULL),(2,'heading','Personal Information','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL),(3,'first_name','First Name','','first_name',1,1,0,2,999,'','[[\"StringLength\",false,[1,32]]]',NULL,NULL,NULL),(4,'last_name','Last Name','','last_name',1,1,0,2,999,'','[[\"StringLength\",false,[1,32]]]',NULL,NULL,NULL),(5,'gender','Gender','','gender',0,1,0,1,999,'',NULL,NULL,NULL,NULL),(6,'birthdate','Birthday','','birthdate',0,1,0,1,999,'',NULL,NULL,NULL,NULL),(7,'heading','Contact Information','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL),(8,'website','Website','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL),(9,'twitter','Twitter','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL),(10,'facebook','Facebook','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL),(11,'aim','AIM','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL),(12,'heading','Personal Details','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL),(13,'about_me','About Me','','',0,1,0,0,999,'',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `engine4_user_fields_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_fields_options`
--

DROP TABLE IF EXISTS `engine4_user_fields_options`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_fields_options` (
  `option_id` int(11) unsigned NOT NULL auto_increment,
  `field_id` int(11) unsigned NOT NULL,
  `label` varchar(255) collate utf8_unicode_ci NOT NULL,
  `order` smallint(6) NOT NULL default '999',
  PRIMARY KEY  (`option_id`),
  KEY `field_id` (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_fields_options`
--

LOCK TABLES `engine4_user_fields_options` WRITE;
/*!40000 ALTER TABLE `engine4_user_fields_options` DISABLE KEYS */;
INSERT INTO `engine4_user_fields_options` VALUES (1,1,'Regular Member',1),(2,5,'Male',1),(3,5,'Female',2);
/*!40000 ALTER TABLE `engine4_user_fields_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_fields_search`
--

DROP TABLE IF EXISTS `engine4_user_fields_search`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_fields_search` (
  `item_id` int(11) unsigned NOT NULL,
  `profile_type` smallint(11) unsigned default NULL,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `gender` smallint(6) unsigned default NULL,
  `birthdate` date default NULL,
  PRIMARY KEY  (`item_id`),
  KEY `profile_type` (`profile_type`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `gender` (`gender`),
  KEY `birthdate` (`birthdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_fields_search`
--

LOCK TABLES `engine4_user_fields_search` WRITE;
/*!40000 ALTER TABLE `engine4_user_fields_search` DISABLE KEYS */;
INSERT INTO `engine4_user_fields_search` VALUES (2,1,'dinesh','mangal',NULL,NULL);
/*!40000 ALTER TABLE `engine4_user_fields_search` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_fields_values`
--

DROP TABLE IF EXISTS `engine4_user_fields_values`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_fields_values` (
  `item_id` int(11) unsigned NOT NULL,
  `field_id` int(11) unsigned NOT NULL,
  `index` smallint(3) unsigned NOT NULL default '0',
  `value` text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`item_id`,`field_id`,`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_fields_values`
--

LOCK TABLES `engine4_user_fields_values` WRITE;
/*!40000 ALTER TABLE `engine4_user_fields_values` DISABLE KEYS */;
INSERT INTO `engine4_user_fields_values` VALUES (2,1,0,'1'),(2,3,0,'dinesh'),(2,4,0,'mangal');
/*!40000 ALTER TABLE `engine4_user_fields_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_forgot`
--

DROP TABLE IF EXISTS `engine4_user_forgot`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_forgot` (
  `user_id` int(11) unsigned NOT NULL,
  `code` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY  (`user_id`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_forgot`
--

LOCK TABLES `engine4_user_forgot` WRITE;
/*!40000 ALTER TABLE `engine4_user_forgot` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_user_forgot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_listitems`
--

DROP TABLE IF EXISTS `engine4_user_listitems`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_listitems` (
  `listitem_id` int(11) unsigned NOT NULL auto_increment,
  `list_id` int(11) unsigned NOT NULL,
  `child_id` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`listitem_id`),
  KEY `list_id` (`list_id`),
  KEY `child_id` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_listitems`
--

LOCK TABLES `engine4_user_listitems` WRITE;
/*!40000 ALTER TABLE `engine4_user_listitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_user_listitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_lists`
--

DROP TABLE IF EXISTS `engine4_user_lists`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_lists` (
  `list_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(64) collate utf8_unicode_ci NOT NULL default '',
  `owner_id` int(11) unsigned NOT NULL,
  `child_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`list_id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_lists`
--

LOCK TABLES `engine4_user_lists` WRITE;
/*!40000 ALTER TABLE `engine4_user_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_user_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_membership`
--

DROP TABLE IF EXISTS `engine4_user_membership`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_membership` (
  `resource_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL default '0',
  `resource_approved` tinyint(1) NOT NULL default '0',
  `user_approved` tinyint(1) NOT NULL default '0',
  `message` text collate utf8_unicode_ci,
  `description` text collate utf8_unicode_ci,
  PRIMARY KEY  (`resource_id`,`user_id`),
  KEY `REVERSE` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_membership`
--

LOCK TABLES `engine4_user_membership` WRITE;
/*!40000 ALTER TABLE `engine4_user_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_user_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_online`
--

DROP TABLE IF EXISTS `engine4_user_online`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_online` (
  `ip` bigint(11) NOT NULL,
  `user_id` int(11) unsigned NOT NULL default '0',
  `active` datetime NOT NULL,
  PRIMARY KEY  (`ip`,`user_id`),
  KEY `LOOKUP` (`active`)
) ENGINE=MEMORY DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_online`
--

LOCK TABLES `engine4_user_online` WRITE;
/*!40000 ALTER TABLE `engine4_user_online` DISABLE KEYS */;
INSERT INTO `engine4_user_online` VALUES (135353724,0,'2010-07-05 05:14:11'),(996041582,0,'2010-07-05 05:14:10'),(2046160069,0,'2010-07-05 05:14:55');
/*!40000 ALTER TABLE `engine4_user_online` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_signup`
--

DROP TABLE IF EXISTS `engine4_user_signup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_signup` (
  `signup_id` int(11) unsigned NOT NULL auto_increment,
  `class` varchar(128) character set latin1 collate latin1_general_ci NOT NULL,
  `order` smallint(6) NOT NULL default '999',
  `enable` smallint(1) NOT NULL default '0',
  PRIMARY KEY  (`signup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_signup`
--

LOCK TABLES `engine4_user_signup` WRITE;
/*!40000 ALTER TABLE `engine4_user_signup` DISABLE KEYS */;
INSERT INTO `engine4_user_signup` VALUES (1,'User_Plugin_Signup_Account',1,1),(2,'User_Plugin_Signup_Fields',2,1),(3,'User_Plugin_Signup_Photo',3,1),(4,'User_Plugin_Signup_Invite',4,0);
/*!40000 ALTER TABLE `engine4_user_signup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_user_verify`
--

DROP TABLE IF EXISTS `engine4_user_verify`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_user_verify` (
  `user_id` int(11) unsigned NOT NULL,
  `code` varchar(64) character set latin1 collate latin1_general_ci NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY  (`user_id`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_user_verify`
--

LOCK TABLES `engine4_user_verify` WRITE;
/*!40000 ALTER TABLE `engine4_user_verify` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_user_verify` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_users`
--

DROP TABLE IF EXISTS `engine4_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_users` (
  `user_id` int(11) unsigned NOT NULL auto_increment,
  `email` varchar(128) collate utf8_unicode_ci NOT NULL,
  `username` varchar(128) collate utf8_unicode_ci NOT NULL,
  `displayname` varchar(128) collate utf8_unicode_ci NOT NULL default '',
  `photo_id` int(11) unsigned NOT NULL default '0',
  `status` text collate utf8_unicode_ci,
  `status_date` datetime default NULL,
  `password` char(32) character set latin1 collate latin1_general_ci NOT NULL,
  `salt` char(64) character set latin1 collate latin1_general_ci NOT NULL,
  `locale` varchar(16) character set latin1 collate latin1_general_ci NOT NULL default 'auto',
  `language` varchar(8) character set latin1 collate latin1_general_ci NOT NULL default 'en_US',
  `timezone` varchar(64) character set latin1 collate latin1_general_ci NOT NULL default 'America/Los_Angeles',
  `search` tinyint(1) NOT NULL default '1',
  `show_profileviewers` tinyint(1) NOT NULL default '1',
  `level_id` int(11) unsigned NOT NULL,
  `invites_used` int(11) unsigned NOT NULL default '0',
  `extra_invites` int(11) unsigned NOT NULL default '0',
  `enabled` tinyint(1) NOT NULL default '1',
  `verified` tinyint(1) NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `creation_ip` bigint(11) NOT NULL,
  `modified_date` datetime NOT NULL,
  `lastlogin_date` datetime default NULL,
  `lastlogin_ip` int(11) default NULL,
  `update_date` int(11) default NULL,
  `member_count` smallint(5) unsigned NOT NULL default '0',
  `view_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`user_id`),
  UNIQUE KEY `EMAIL` (`email`),
  UNIQUE KEY `USERNAME` (`username`),
  KEY `MEMBER_COUNT` (`member_count`),
  KEY `CREATION_DATE` (`creation_date`),
  KEY `search` (`search`),
  KEY `enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_users`
--

LOCK TABLES `engine4_users` WRITE;
/*!40000 ALTER TABLE `engine4_users` DISABLE KEYS */;
INSERT INTO `engine4_users` VALUES (1,'admin@bigsteptech.com','admin','admin',0,NULL,NULL,'dc3b000274ca76f8cc1c47aa405fa9f4','9847193','auto','en_US','America/Los_Angeles',1,1,1,0,0,1,1,'2010-07-02 06:22:22',996188345,'0000-00-00 00:00:00','2010-07-02 07:13:40',121245,NULL,0,0),(2,'mangal.dinesh@gmail.com','mangal','dinesh mangal',0,NULL,NULL,'2446e5b87bc48d27369adb826ebc75b6','2875045','auto','en','US/Pacific',1,1,4,0,0,1,1,'2010-07-02 07:12:26',2046160069,'2010-07-02 07:12:26',NULL,NULL,NULL,0,0);
/*!40000 ALTER TABLE `engine4_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_video_categories`
--

DROP TABLE IF EXISTS `engine4_video_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_video_categories` (
  `category_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `category_name` varchar(128) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_video_categories`
--

LOCK TABLES `engine4_video_categories` WRITE;
/*!40000 ALTER TABLE `engine4_video_categories` DISABLE KEYS */;
INSERT INTO `engine4_video_categories` VALUES (1,0,'Autos & Vehicles'),(2,0,'Comedy'),(3,0,'Education'),(4,0,'Entertainment'),(5,0,'Film & Animation'),(6,0,'Gaming'),(7,0,'Howto & Style'),(8,0,'Music'),(9,0,'News & Politics'),(10,0,'Nonprofits & Activism'),(11,0,'People & Blogs'),(12,0,'Pets & Animals'),(13,0,'Science & Technology'),(14,0,'Sports'),(15,0,'Travel & Events');
/*!40000 ALTER TABLE `engine4_video_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_video_ratings`
--

DROP TABLE IF EXISTS `engine4_video_ratings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_video_ratings` (
  `video_id` int(10) unsigned NOT NULL,
  `user_id` int(9) unsigned NOT NULL,
  `rating` tinyint(1) unsigned default NULL,
  PRIMARY KEY  (`video_id`,`user_id`),
  KEY `INDEX` (`video_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_video_ratings`
--

LOCK TABLES `engine4_video_ratings` WRITE;
/*!40000 ALTER TABLE `engine4_video_ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_video_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine4_video_videos`
--

DROP TABLE IF EXISTS `engine4_video_videos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `engine4_video_videos` (
  `video_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(100) collate utf8_unicode_ci NOT NULL,
  `description` text collate utf8_unicode_ci NOT NULL,
  `search` tinyint(1) NOT NULL default '1',
  `owner_type` varchar(128) character set latin1 collate latin1_general_ci NOT NULL,
  `owner_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `view_count` int(11) unsigned NOT NULL default '0',
  `type` tinyint(1) NOT NULL,
  `code` varchar(150) collate utf8_unicode_ci NOT NULL,
  `photo_id` int(11) unsigned default NULL,
  `rating` float NOT NULL,
  `category_id` int(11) unsigned NOT NULL default '0',
  `status` tinyint(1) NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `duration` int(9) unsigned NOT NULL,
  PRIMARY KEY  (`video_id`),
  KEY `owner_id` (`owner_id`,`owner_type`),
  KEY `search` (`search`),
  KEY `creation_date` (`creation_date`),
  KEY `view_count` (`creation_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `engine4_video_videos`
--

LOCK TABLES `engine4_video_videos` WRITE;
/*!40000 ALTER TABLE `engine4_video_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine4_video_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'feeeddback'
--
DELIMITER ;;
DELIMITER ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-07-09  6:17:23
