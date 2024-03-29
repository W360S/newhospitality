<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Manage.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Group_Form_Filter_Manage extends Engine_Form
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
      ->setAttrib('id', 'my_group_search_form')
      //->setAttrib('onchange', 'this.submit()')
      ;

    $this->addElement('Text', 'text', array(
      'label' => 'Search:',
      'decorators' => array(
        'ViewHelper',
        array('Label', array('placement' => 'PREPEND')),
        array('HtmlTag', array('tag' => 'div', 'class'=>'input search_group'))
        
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
        array('HtmlTag', array('tag' => 'div', 'class'=>'input select_cat'))
        
      ),
      'onchange' => '$(this).getParent("form").submit();',
    ));
    $this->addElement('Select', 'view', array(
      'label' => 'View:',
      'multiOptions' => array(
        '' => 'All My Groups',
        '2' => 'Only Groups I Lead',
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