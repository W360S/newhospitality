<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: FieldCurrency.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
* @author     John
 */
class Fields_View_Helper_FieldCurrency extends Fields_View_Helper_FieldAbstract
{
  public function fieldCurrency($subject, $field, $value)
  {
    $label = $this->view->locale()->toCurrency($value->value, $field->config['unit']);

    return $this->encloseInLink($subject, $field, $value->value, $label, true);
  }
}