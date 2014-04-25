<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Resume

 * @author     huynhnv
 */
class Resumes_Form_Education_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'resume_education_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));

    //degree level
    $this->addElement('Select', 'degree_level_id', array(
      'label' => 'Degree Level (*)',
      'allowEmpty' => false,
      'required' => true,
      'multiOptions' => array(
        '0'=> Zend_Registry::get('Zend_Translate')->_('Please select...'),
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
    $this->addElement('Text', 'school_name', array(
      'label' => 'School Name (*)',
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
    
    // Major
    $this->addElement('Text', 'major', array(
      'label' => 'Major',
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));
     // Country
    $this->addElement('Select', 'country_id', array(
      'label' => 'Country',
      //'onchange'=>'javascript:list_city();',
      'multiOptions' => array(
      ),
    ));
    
    // Start date
    $start = new Engine_Form_Element_Date('starttime');
    $start->setYearMax(date('Y')+10);
    $start->setLabel("Start Date");
    $this->addElement($start);

    // End date
    $end = new Engine_Form_Element_Date('endtime');
    $end->setYearMax(date('Y')+10);
    $end->setLabel("End Date");
    $this->addElement($end);
    // Responsibilities and Achievements
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
      'onclick'=> "javascript:saveResumeEducation('save');",
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    
    // Buttons Back
    $this->addElement('Cancel', 'cancel', array(
      'label' => 'Back',
      'onclick'=> 'javascript:back_resume_work();',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    // Buttons Next
    $this->addElement('Button', 'submit', array(
      'label' => 'Next',
      //'type' => 'submit',
      'onclick'=> "javascript:saveResumeEducation('next');",
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