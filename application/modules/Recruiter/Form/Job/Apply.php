<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter

 * @author     huynhnv
 */
class Recruiter_Form_Job_Apply extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'recruiter_apply_job_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));
    
    //position
    $this->addElement('Text', 'title', array(
      'label' => 'Subject',
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
    
    // Country
    $this->addElement('Select', 'resume_id', array(
      'label' => 'Select a resume',
      'onchange'=> 'select_resume();',
      'multiOptions' => array(
      ),
    ));
     
    $this->addElement('Textarea', 'description', array(
      'label' => 'Cover letter',
      //'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    $this->addElement('File', 'file', array(
      'label' => Zend_Registry::get('Zend_Translate')->_('Attachment')
		//'required' => true,
    ));
    $this->file->addValidator('Extension', false, 'jpg,png,gif,pdf,doc,docx,rar,zip');
    //submit
    $this->addElement('Button', 'submit', array(
      'label' => 'Apply',
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