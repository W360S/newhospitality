<?php
/**
 * SocialEngine
 *
 * @category   Engine
 * @package    Engine_Form
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: File.php 9747 2012-07-26 02:08:08Z john $
 */

/**
 * @category   Engine
 * @package    Engine_Form
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Engine_Form_Element_File extends Zend_Form_Element_File
{
  /**
   * Load default decorators
   *
   * @return void
   */
  public function loadDefaultDecorators()
  {
    if( $this->loadDefaultDecoratorsIsDisabled() )
    {
      return;
    }

    $decorators = $this->getDecorators();
    if( empty($decorators) )
    {
      $this->addDecorator('File');
      Engine_Form::addDefaultDecorators($this);
    }
  }
}
