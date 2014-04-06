<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Recipients.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Model_DbTable_Recipients extends Engine_Db_Table
{
	protected $_name = 'messages_recipients';
	protected $_rowClass = 'Suggestion_Model_Recipient';
}