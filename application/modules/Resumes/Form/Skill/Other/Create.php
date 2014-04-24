<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Resume

 * @author     huynhnv
 */
class Resumes_Form_Skill_Other_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'resume_other_skill_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));

    //year experience
    $this->addElement('Text', 'name', array(
      'label' => 'Skill',
      'id'=>'name_skill',
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
    
    
    $this->addElement('Textarea', 'description', array(
      'label' => 'Description',
      'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    // Buttons Save
    $this->addElement('Button', 'save_skill', array(
      'label' => 'Save',
      'onclick'=> "javascript:saveResumeSkill('save');",
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    
     // Buttons Back
    $this->addElement('Cancel', 'cancel', array(
      'label' => 'Back',
      'onclick'=> 'javascript:back_resume_education();',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    // Buttons Next
    $this->addElement('Button', 'submit', array(
      'label' => 'Next',
      //'type' => 'submit',
      'onclick'=> "javascript:saveResumeLanguage('next');",
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