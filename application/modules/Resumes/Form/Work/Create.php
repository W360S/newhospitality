<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Resume

 * @author     huynhnv
 */
class Resumes_Form_Work_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'resume_work_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));

    //year experience
    $this->addElement('Text', 'num_year', array(
      'label' => 'Years Of Experience (*)',
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
    
    // Title
    $this->addElement('Text', 'title', array(
      'label' => 'Job Title (*)',
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
    //Job level
    $this->addElement('Select', 'level_id', array(
      'label' => 'Job Level',
      'multiOptions' => array(
      ),
    ));
    // Category
    $this->addElement('Select', 'category_id', array(
      'label' => 'Category',
      'multiOptions' => array(
      ),
    ));
    // Company Name
    $this->addElement('Text', 'company_name', array(
      'label' => 'Company Name (*)',
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
     // Country
    $this->addElement('Select', 'country_id', array(
      'label' => 'Country',
      'onchange'=>'javascript:list_city();',
      'multiOptions' => array(
      ),
    ));
     // Province/city
    $this->addElement('Select', 'city_id', array(
      'label' => 'Province/City',
      'multiOptions' => array(
      ),
    ));
    $this->getElement('city_id')->setRegisterInArrayValidator(false);
    // Start date
    $start = new Engine_Form_Element_Date('starttime');

    $start->setLabel("Start Date");
    $this->addElement($start);

    // End date
    $end = new Engine_Form_Element_Date('endtime');
    $end->setLabel("End Date");
    $this->addElement($end);
    // Responsibilities and Achievements
    $this->addElement('Textarea', 'description', array(
      'label' => 'Responsibilities and Achievements',
      'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    // Buttons Save
    $this->addElement('Button', 'save', array(
      'label' => 'Save',
      'onclick'=> "javascript:saveResumeWork('save');",
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    
    // Buttons Back
    $this->addElement('Cancel', 'cancel', array(
      'label' => 'Back',
      'onclick'=> 'javascript:back_resume_info();',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    // Buttons Next
    $this->addElement('Button', 'submit', array(
      'label' => 'Next',
      //'type' => 'submit',
      'onclick'=> "javascript:saveResumeWork('next');",
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