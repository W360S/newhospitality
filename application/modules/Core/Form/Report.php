<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Report.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Form_Report extends Engine_Form
{
  public function init()
  {
    $this
      ->setTitle('Report')
      ->setDescription('Do you want to report this?')
      ->setAction($_SERVER['REQUEST_URI'])
      ->setAttrib('class', 'global_form_popup')
      ;

    $this->addElement('Select', 'category', array(
      'label' => 'Type',
      'required' => true,
      'allowEmpty' => false,
      'multiOptions' => array(
        '' => '(select)',
        'spam' => 'Spam',
        'abuse' => 'Abuse',
        'inappropriate' => 'Inappropriate Content',
        'licensed' => 'Licensed Material',
        'other' => 'Other',
      ),
    ));

    $this->addElement('Textarea', 'description', array(
      'label' => 'Description',
      'required' => true,
      'allowEmpty' => false,
    ));

    $this->addElement('Hidden', 'subject');

    // Buttons
    $this->addElement('Button', 'submit', array(
      'label' => 'Submit Report',
      'type' => 'submit',
      'ignore' => true,
      'decorators' => array('ViewHelper')
    ));

    $this->addElement('Cancel', 'cancel', array(
      'label' => 'cancel',
      'link' => true,
      'prependText' => ' or ',
      'href' => '',
      'onclick' => 'parent.Smoothbox.close();',
      'decorators' => array(
        'ViewHelper'
      )
    ));
    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
    $button_group = $this->getDisplayGroup('buttons');

  }
}