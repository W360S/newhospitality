<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter

 * @author     huynhnv
 */
class Recruiter_Form_Job_Send extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'recruiter_send_email_job_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));
    //email
    $this->addElement('Text', 'email', array(
      'label' => "Your Friend's Email address",
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
    //cc email
    $this->addElement('Text', 'cc_email', array(
      'label' => "Cc",
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
    //title
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
    
   
     
    $this->addElement('Textarea', 'description', array(
      'label' => 'Message',
      //'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
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