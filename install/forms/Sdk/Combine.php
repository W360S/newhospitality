<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Install
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Combine.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Install
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Install_Form_Sdk_Combine extends Engine_Form
{
  public function init()
  {
    $this->setMethod('POST')
      ->setAction($_SERVER['REQUEST_URI'])
      ->setTitle('Combine Packages')
      ->setDescription('Please choose a file name.');

    $this->addElement('Text', 'name', array(
      'label' => 'File Name',
      'required' => true,
      'allowEmpty' => false,
    ));

    $this->addElement('Button', 'execute', array(
      'type' => 'submit',
      'label' => 'Combine Packages',
      'decorators' => array(
        'ViewHelper',
      ),
    ));

    $this->addElement('Cancel', 'cancel', array(
      'link' => true,
      'prependText' => ' or ',
      'label' => 'cancel',
      'href' => Zend_Controller_Front::getInstance()->getRouter()->assemble(array('action' => 'manage')),
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    
    $this->addDisplayGroup(array('execute', 'cancel'), 'buttons');
  }
}