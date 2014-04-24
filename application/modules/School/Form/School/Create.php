<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    School

 * @author     huynhnv
 */
class School_Form_School_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'school_create_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));
      //position
    $this->addElement('Text', 'name', array(
      'label' => 'School name',
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
    
    $this->addElement('Textarea', 'intro', array(
      'label' => 'Description',
      //'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    // Country
    $this->addElement('Select', 'country_id', array(
      'label' => 'Country',
      'multiOptions' => array(
      ),
    ));
    //contact name
    $this->addElement('Text', 'website', array(
      'label' => 'Website',
      'allowEmpty' => false,
      'required' => true,
      'maxlength' => 160,
      'validators' => array(
        //array('NotEmpty', true),
        //array('StringLength', false, array(1, 21)),
      ),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));         
    //address
    $this->addElement('Text', 'address', array(
      'label' => 'Address',
      'allowEmpty' => false,
      //'required' => true,
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
    
    //email
    $this->addElement('Text', 'email', array(
      'label' => 'Email',
      'allowEmpty' => false,
      //'required' => true,
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
    //fax        
    $this->addElement('Text', 'fax', array(
      'label' => 'Fax',
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      'validators' => array(
        //array('NotEmpty', true),
        //array('StringLength', false, array(1, 21)),
      ),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));      
    //phone 
    $this->addElement('Text', 'phone', array(
      'label' => 'Phone',
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      'validators' => array(
        //array('NotEmpty', true),
        //array('StringLength', false, array(1, 21)),
      ),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));   
    $this->addElement('File', 'photo', array(
      'label' => 'School Photo',
		//'required' => true,
      'validators' => array(
        array('Count', false, 1),
        array('Size', false, 10*1024*1024), // 10MB
        array('Extension', false, 'jpg,png,gif,jpeg'),
      ),   
    ));
    $this->photo->addValidator('Extension', false, 'jpg,png,gif,jpeg');
            
    //submit
    $this->addElement('Button', 'submit', array(
      'label' => 'Save',
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