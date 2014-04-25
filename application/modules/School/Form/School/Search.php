<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    School

 * @author     huynhnv
 */
class School_Form_School_Search extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'school_search_form')
      ->setMethod("GET")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));
      //position
    $this->addElement('Text', 'input_search', array(
      'label' => '',
      'value'=> 'Enter your keyword',
      'required' => true,
      'maxlength' => 160,
      'validators' => array(
        array('NotEmpty', true),
        //array('StringLength', false, array(1, 21)),
      ),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));   
   $this->getElement('input_search')->removeDecorator('label');
    // Country
    $this->addElement('Select', 'country_id', array(
      'label' => '',
      'multiOptions' => array(
      '0'=> 'Select country'
      ),
    ));
   $this->getElement('country_id')->removeDecorator('label');
    //submit
    $this->addElement('Button', 'submit', array(
      'label' => 'Search',
      'type' => 'submit',
      
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    $this->addDisplayGroup(array('submit'), 'buttons', array(
      'decorators' => array(
        'FormElements',
        'DivDivDivWrapper',
      ),
    ));
  }
}