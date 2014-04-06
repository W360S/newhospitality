<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Manage.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Event_Form_Filter_Manage extends Engine_Form
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
      ;
    
    $this->addElement('Text', 'text', array(
      'label' => '',
      'decorators' => array(
        'ViewHelper',
       array('Label', array('placement' => 'APPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'input'))
      ),
      'onchange' => '$(this).getParent("form").submit();',
    ));
    
    $this->addElement('Select', 'category_id', array(
      'label' => 'Category:',
      'multiOptions' => array(
        '' => 'All Categories',
      ),
      'decorators' => array(
        'ViewHelper',
        array('Label', array('placement' => 'PREPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'input'))
      ),
      'onchange' => '$(this).getParent("form").submit();',
    ));

    $this->addElement('Select', 'view', array(
      'label' => 'View:',
      'multiOptions' => array(
        '' => 'All My Events',
        '2' => 'Only Events I Lead',
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