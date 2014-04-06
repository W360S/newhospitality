<?php

class Experts_Form_SelectExperts extends Engine_Form
{
  public function init()
  {
    // Init form
    
    // Init email
    $this->addElement('Text', 'email', array(
      'label' => 'Email',
      'required' => true,
      'allowEmpty' => false,
      'filters' => array(
        'StringTrim',
      ),
      'validators' => array(
        'EmailAddress'
      ),
      'tabindex' => 1,
    ));

    
    // Init submit
    $this->addElement('Button', 'submit', array(
      'label' => 'Sign In',
      'type' => 'submit',
      'ignore' => true,
      'tabindex' => 5,
    ));

    // Set default action
    $this->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array(), 'user_login'));
  }
}
