<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Website.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
* @author     John
 */
class Fields_Form_Element_Website extends Engine_Form_Element_Text
{
  public function init()
  {
    $this->addFilter('PregReplace', array('/\s*[a-zA-Z0-9]{2,5}:\/\//', ''));
    //$this->addValidator('Hostname', true);
  }
}