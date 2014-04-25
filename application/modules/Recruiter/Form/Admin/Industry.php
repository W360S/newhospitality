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

class Recruiter_Form_Admin_Industry extends Engine_Form
{
  protected $_field;

  public function init()
  {
    $this->setMethod('post');

    /*
    $type = new Zend_Form_Element_Hidden('type');
    $type->setValue('heading');
    */

    $label = new Zend_Form_Element_Text('name');
    $label->setLabel('Industry Name')
      ->addValidator('NotEmpty')
      ->setRequired(true)
      ->setAttrib('class', 'text');


    $id = new Zend_Form_Element_Hidden('id');
    
    $this->addElements(array(
      //$type,
      $label,
      $id
    ));
    
    // Buttons
    $this->addElement('Button', 'submit', array(
      'label' => 'Add Industry',
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
    $this->name->setValue($category->name);
    $this->id->setValue($category->industry_id);
    
    $this->submit->setLabel('Edit Industry');

    // @todo add the rest of the parameters
  }
}