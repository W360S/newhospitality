<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Edit.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Group_Form_Post_Edit extends Engine_Form
{
  public function init()
  {
    $this
      ->setTitle('Edit Post');

    $this->addElement('textarea', 'body', array(
      'filters' => array(
        new Engine_Filter_Censor(),
        //new Engine_Filter_HtmlSpecialChars(),
      )
    ));

    $this->addElement('Button', 'submit', array(
      'type' => 'submit',
      'label' => 'Edit Post',
    ));

    $this->addElement('Cancel', 'cancel', array(
      'label' => 'Cancel',
      'onclick' => 'parent.Smoothbox.close();',
    ));
  }
}