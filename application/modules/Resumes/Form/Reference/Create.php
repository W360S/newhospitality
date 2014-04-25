<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Resume

 * @author     huynhnv
 */
class Resumes_Form_Reference_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'resume_reference_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));

    //year experience
    $this->addElement('Text', 'name', array(
      'label' => 'Name',
      //'id'=>'name_reference',
      'allowEmpty' => false,
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
    
    $this->addElement('Text', 'title', array(
      'label' => Zend_Registry::get('Zend_Translate')->_('Title '),
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));
    $this->addElement('Text', 'phone', array(
      'label' => 'Phone',
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));
    $this->addElement('Text', 'email', array(
      'label' => 'Email',
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));
    $this->addElement('Textarea', 'description', array(
      'label' => 'Related Information',
      'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    // Buttons Save
    $this->addElement('Button', 'save', array(
      'label' => 'Save',
      'onclick'=> "javascript:saveResumeReference('save');",
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    
     // Buttons Back
    $this->addElement('Cancel', 'cancel', array(
      'label' => 'Back',
      'onclick'=> 'javascript:back_resume_skill();',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    // Buttons Next
    $this->addElement('Button', 'submit', array(
      'label' => 'Preview',
      //'type' => 'submit',
      'onclick'=> "javascript:preview();",
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    $this->addDisplayGroup(array('cancel', 'submit'), 'buttons', array(
      'decorators' => array(
        'FormElements',
        'DivDivDivWrapper',
      ),
    ));
  }
}