<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Category.php 7244 2010-09-01 01:49:53Z john $
 * @author     Jung
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Event_Form_Admin_Category extends Engine_Form
{
  protected $_field;

  public function init()
  {
    $this->setMethod('post');

    /*
    $type = new Zend_Form_Element_Hidden('type');
    $type->setValue('heading');
    */

    $label = new Zend_Form_Element_Text('label');
    $label->setLabel('Category Name')
      ->addValidator('NotEmpty')
      ->setRequired(true)
      ->setAttrib('class', 'text');
      
    $priority = new Zend_Form_Element_Text('priority');
    $priority->setLabel('Priority')
      ->addValidator('NotEmpty')
      ->setRequired(true)
      ->setAttrib('class', 'text');  


    $id = new Zend_Form_Element_Hidden('id');


    $this->addElements(array(
      //$type,
      $label,
      $priority,
      $id
    ));
    // Buttons
    $this->addElement('Button', 'submit', array(
      'label' => 'Add Category',
      'type' => 'submit',
      'ignore' => true,
      'decorators' => array('ViewHelper')
    ));

    $this->addElement('Cancel', 'cancel', array(
      'label' => 'cancel',
      'link' => true,
      'prependText' => Zend_Registry::get('Zend_Translate')->_(' or '),
      'href' => '',
      'onClick'=> 'javascript:parent.Smoothbox.close();',
      'decorators' => array(
        'ViewHelper'
      )
    ));
    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
    $button_group = $this->getDisplayGroup('buttons');

   // $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
  }

  public function setField($category)
  {
    $this->_field = $category;
    //Zend_debug::dump($category->priority); exit;
    // Set up elements
    //$this->removeElement('type');
    $this->label->setValue($category->title);
    $this->id->setValue($category->category_id);
    $this->priority->setValue($category->priority);
    $this->submit->setLabel('Edit Category');

    // @todo add the rest of the parameters
  }
}