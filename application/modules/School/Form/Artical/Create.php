<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    School

 * @author     huynhnv
 */
class School_Form_Artical_Create extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'artical_create_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));
      //position
    $this->addElement('Text', 'title', array(
      'label' => 'Title',
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
    
     $this->addElement('textarea', 'content', array(
      //'label'=> 'Content',
      'disableLoadDefaultDecorators' => true,
      'id'=>'tinyMCE',
      'rows'=>'21',
      'required' => true,
      //'width'=> '300px',
      'allowEmpty' => false,
      'decorators' => array(
        'ViewHelper'
      ),
      'filters' => array(
        new Engine_Filter_Censor(),
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