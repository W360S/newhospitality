<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: ZipCode.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
* @author     John
 */
class Fields_Form_Element_ZipCode extends Engine_Form_Element_Text
{
  public function init()
  {
    $this->addValidator('Regex', true, array('/^(\d{5}-\d{4})|(\d{5})$/'));
    // Fix messages
    $this->getValidator('Regex')->setMessage("'%value%' is not a valid zip code.", 'regexNotMatch');
  }
}