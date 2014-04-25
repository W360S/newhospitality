<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter search job

 * @author     huynhnv
 */
class Recruiter_Form_Job_Search extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'recruiter_job_search_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getBaseUrl().'/recruiter/search/search-basic')
      ;
    
    //position
    $this->addElement('Text', 'search_job', array(
      'label' => 'Keyword:',
      'value'=> Zend_Registry::get('Zend_Translate')->_('Enter jobs title, position'),
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
   $this->getElement('search_job')->removeDecorator('label');
    
     // Country - Province/city - location
    $this->addElement('Select', 'country_id', array(
      'label' => 'Location:',
      'onchange'=>'javascript:list_city();',
      'multiOptions' => array(
      '0'=> 'All country'
      ),
    ));
    $this->addElement('Select', 'city_id', array(
      'label' => 'City:',
      'multiOptions' => array(
      '0'=> 'All city'
      ),
    ));
    $this->getElement('city_id')->removeDecorator('label');
     // Industries
    $this->addElement('Select', 'industry', array(
      'label' => 'Career:',
      'multiOptions' => array(
      '0'=> 'All Career'
      ),
    ));
    $this->getElement('industry')->removeDecorator('label');
    //categories= industries
    $this->addElement('Select', 'category', array(
      'label' => 'Industry:',
      'multiOptions' => array(
      '0'=> 'All Industry'
      ),
    ));
    $this->getElement('category')->removeDecorator('label');
    /*    
     // Industries
    $this->addElement('Select', 'position', array(
      'label' => 'Position',
      'multiOptions' => array(
      ),
    ));
   */
  
    //submit
    $this->addElement('Button', 'submit', array(
      'label' => 'Search',
      'type' => 'submit',
      
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
     //submit
    $this->addElement('Button', 'cancel', array(
      'label' => 'Reset',
      'onclick'=> 'reset_search();',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons', array(
      'decorators' => array(
        'FormElements',
        'DivDivDivWrapper',
      ),
    ));
  }
}