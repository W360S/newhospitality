<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    News
 * 
 * @version    1.0
 * @author     huynhnv
 * @status     done
 */

class Statistics_Form_Admin_Category extends Engine_Form
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
    $label->setLabel('Name')
      ->addValidator('NotEmpty')
      ->setRequired(true)
      ->setAttrib('class', 'text');
    
    $priority = new Zend_Form_Element_Text('priority');
    $priority->setLabel('Priority')
      ->addValidator('NotEmpty')
      ->setRequired(true)
      ->setAttrib('class', 'text');

    $id = new Zend_Form_Element_Hidden('id');
    // Photo
    $photo= new Zend_Form_Element_File('photo');
    $photo->setLabel('Icon')
      ->addValidator('NotEmpty')
      //->setRequired(true)
      ->setAttrib('class', 'file');
    $photo->addValidator('Extension', false, 'jpg,png,gif');
    $this->addElements(array(
      //$type,
      $label,
      $id,
      $priority,
      $photo
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

    // Set up elements
    //$this->removeElement('type');
    $this->label->setValue($category->name);
    $this->id->setValue($category->category_id);
    $this->priority->setValue($category->priority);
    $this->submit->setLabel('Edit Item');

    // @todo add the rest of the parameters
  }
  
}