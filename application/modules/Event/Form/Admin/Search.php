<?php

class Event_Form_Admin_Search extends Engine_Form
{
  public function init()
  {
    
    $this->clearDecorators()
      ->addDecorators(array(
        'FormElements',
        array('HtmlTag', array('tag' => 'fieldset', 'class'=>'filter')),
        'Form',
      ))
      ->setMethod('get')
      //->setAttrib('onchange', 'this.submit()')
      
      ->setAttribs(array(
        'id' => 'filter_form'
      ))
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array('page'=>1)))
      ;

    //parent::init();
    
    $this->addElement('Text', 'event_search', array(
      'label' => '',
      'decorators' => array(
        'ViewHelper',
        array('Label', array('placement' => 'PREPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'input'))
        
      )
    ));
    
    $this->addElement('Select', 'category_id', array(
      'label' => 'Category:',
      'multiOptions' => array(
        '0' => 'All Categories',
      ),
      'decorators' => array(
        'ViewHelper',
        array('Label', array('placement' => 'PREPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'input'))
      ),
      'onchange' => '$(this).getParent("form").submit();',
    ));
    
    $this->addElement('Select', 'event_type', array(
      'label' => 'Event type:',
      'multiOptions' => array(
        '' => 'All  Events',
        '1' => 'Future Events',
        '2' => 'Past Events',
      ),
      'decorators' => array(
        'ViewHelper',
        array('Label', array('placement' => 'PREPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'input select_sort'))
      ),
      'onchange' => '$(this).getParent("form").submit();',
    ));
   

  }
}