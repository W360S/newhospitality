<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Style.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Model_Style extends Engine_Db_Table_Row
{
  protected $_searchTriggers = false;

  protected function _insert()
  {
    $this->style = $this->filterStyles($this->style);
  }

  protected function _update()
  {
    $this->style = $this->filterStyles($this->style);
  }

  public function filterStyles($style)
  {
    // Process
    $style = strip_tags($style);

    $forbiddenStuff = array(
      '-moz-binding',
      'expression',
      'javascript:',
      'behaviour:',
      'vbscript:',
      'mocha:',
      'livescript:',
    );

    $style = str_replace($forbiddenStuff, '', $style);

    return $style;
  }
}