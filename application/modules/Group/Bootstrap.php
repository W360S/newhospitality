<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Bootstrap.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Group_Bootstrap extends Engine_Application_Bootstrap_Abstract
{
  public function __construct($application)
	 {
		parent::__construct($application);
		
		// Add view helper and action helper paths
		$this->initViewHelperPath();
		$this->initActionHelperPath();

		
	  }
}