<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Browse.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Event_Form_Filter_Browse extends Engine_Form
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
      'label' => 'Search',
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
    $this->addElement('Select', 'order', array(
      'label' => 'List By:',
      'multiOptions' => array(
        'starttime ASC' => 'Start Time',
        'creation_date DESC' => 'Recently Created',
        'member_count DESC' => 'Most Popular',
      ),
      'decorators' => array(
        'ViewHelper',
        array('Label', array('placement' => 'PREPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'input select_sort'))
      ),
      'value' => 'creation_date DESC',
      'onchange' => '$(this).getParent("form").submit();',
    ));
    $this->addElement('Select', 'view', array(
      'label' => 'View:',
      'multiOptions' => array(
        'everyone' => 'Everyone\'s Events',
        'friends' => 'Only My Friends\' Events',
      ),
      'decorators' => array(
        'ViewHelper',
        array('Label', array('placement' => 'PREPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'select_sort'))
      ),
      'onchange' => '$(this).getParent("form").submit();',
    ));

    
  }
}