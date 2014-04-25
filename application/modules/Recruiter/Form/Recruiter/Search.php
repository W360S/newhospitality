<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter search advanced job

 * @author     huynhnv
 */
class Recruiter_Form_Recruiter_Search extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'recruiter_search_resume_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getBaseUrl().'/recruiter/search/search-resume')
      ;
    
    //position
    $this->addElement('Text', 'search_resume', array(
      'label' => 'Keywords: ',
      'value'=> Zend_Registry::get('Zend_Translate')->_('Enter resume title'),
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
    $this->getElement('search_resume')->removeDecorator('label');
     // Country - Province/city - location
    $this->addElement('Select', 'country_id', array(
      'label' => 'Location: ',
      'onchange'=>'javascript:list_city();',
      'multiOptions' => array(
      '0'=> 'All country'
      ),
    ));
    $this->addElement('Select', 'city_id', array(
      'label' => 'City: ',
      'multiOptions' => array(
        '0'=> 'All city'
      ),
    ));
    $this->getElement('city_id')->removeDecorator('label');
     // level
    $this->addElement('Select', 'level', array(
      'label' => 'Job Level: ',
      'multiOptions' => array(
        '0'=> 'All job level'
      ),
    ));
    $this->getElement('level')->removeDecorator('label');
    // degree level
    $this->addElement('Select', 'degree', array(
      'label' => 'Degree Level: ',
      'multiOptions' => array(
        '0'=> 'All degree level'
      ),
    ));
     // Industries
    $this->addElement('Select', 'industry', array(
      'label' => 'Career:',
      'multiOptions' => array(
      '0'=> 'All Career'
      ),
    ));
    $this->getElement('industry')->removeDecorator('label');
    // language
    $this->addElement('Select', 'language', array(
      'label' => 'Language: ',
      'multiOptions' => array(
        '0'=> 'All language'
      ),
    ));
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