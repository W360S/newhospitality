/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Authorization
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: my-upgrade-4.0.0rc1-4.0.0rc2.sql 9747 2012-07-26 02:08:08Z john $
 * @author     Jung
 */
INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `order`) VALUES
('authorization_admin_main_manage', 'authorization', 'View Member Levels', '', '{"route":"admin_default","module":"authorization","controller":"level"}', 'authorization_admin_main', '', 1),
('authorization_admin_main_level', 'authorization', 'Member Level Settings', '', '{"route":"admin_default","module":"authorization","controller":"level","action":"edit"}', 'authorization_admin_main', '', 3)
;