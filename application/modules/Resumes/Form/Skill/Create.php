<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Resume

 * @author     huynhnv
 */
class Resumes_Form_Skill_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'resume_skill_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));

    //degree level
    $this->addElement('Select', 'language_id', array(
      'label' => 'Language Proficiency',
      'allowEmpty' => false,
      //'required' => true,
      'multiOptions' => array(
        '0'=> 'Please select...'
      ),
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
    
    // School name
    $this->addElement('Select', 'group_skill_id', array(
      'label' => 'Language Level',
      'allowEmpty' => false,
      //'required' => true,
      
      'multiOptions' => array(
        '0'=> 'Please select...'
      ),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));
    
    
    // Buttons Save
    $this->addElement('Button', 'save', array(
      'label' => 'Save',
      'onclick'=> "javascript:saveResumeLanguage('save');",
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    
   
  }
}