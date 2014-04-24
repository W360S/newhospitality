<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter

 * @author     huynhnv
 */
class Recruiter_Form_Job_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'recruiter_job_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));
      //position
    $this->addElement('Text', 'position', array(
      'label' => 'Job Title:',
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
    //industry
    $this->addElement('MultiCheckbox', 'categories', array(
      'label' => 'Industry:',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    //carrer
    $this->addElement('MultiCheckbox', 'industries', array(
      'label' => 'Careers:',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    //number
    $this->addElement('Text', 'num', array(
      'label' => 'Quantity:',
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
    //year experience
    $this->addElement('Text', 'year_experience', array(
      'label' => 'Year Experience:',
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
    //degree level
   $this->addElement('Select', 'degree_id', array(
      'label' => 'Degree Level: ',
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
    // Country
    $this->addElement('Select', 'country_id', array(
      'label' => 'Place to work:',
      'onchange'=>'javascript:list_city();',
      'multiOptions' => array(
      ),
    ));
     // Province/city
    $this->addElement('Select', 'city_id', array(
      'label' => 'Province/City:',
      'multiOptions' => array(
      ),
    ));
    $this->getElement('city_id')->removeDecorator('label');
    $this->getElement('city_id')->setRegisterInArrayValidator(false);
     //types
    $this->addElement('MultiCheckbox', 'types', array(
      'label' => 'Type:',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    $this->addElement('Textarea', 'description', array(
      'label' => 'Description:',
      //'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    $this->addElement('Textarea', 'skill', array(
      'label' => 'Skill-set requirement:',
      //'maxlength' => '512',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    //salary
    $this->addElement('Text', 'salary', array(
      'label' => 'Salary:',
      //'allowEmpty' => false,
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
    // deadline
    $deadline = new Engine_Form_Element_Date('deadline');
    $deadline->setYearMin(date('Y')-1);
    $deadline->setYearMax(date('Y')+5);
    $deadline->setLabel("Deadline:");
    $this->addElement($deadline);    
    
    //contact information
    
    //contact name
    $this->addElement('Text', 'contact_name', array(
      'label' => 'Contact to:',
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
    //address
    $this->addElement('Text', 'contact_address', array(
      'label' => 'Address:',
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
    //contact via
    $this->addElement('MultiCheckbox', 'contact_via', array(
      'label' => 'Contact via:',
      //'allowEmpty' => false,
      //'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    //phone
    $this->addElement('Text', 'contact_phone', array(
      'label' => 'Phone:',
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      //'validators' => array(
        //array('NotEmpty', true),
        //array('StringLength', false, array(1, 21)),
      //),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));       
    //email  
    $this->addElement('Text', 'contact_email', array(
      'label' => 'Email:',
      'allowEmpty' => false,
      //'required' => true,
      'maxlength' => 160,
      //'validators' => array(
        //array('NotEmpty', true),
        //array('StringLength', false, array(1, 21)),
      //),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));
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