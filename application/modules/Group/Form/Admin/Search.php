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
class Group_Form_Admin_Search extends Engine_Form
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

    $this->addElement('Text', 'group_search', array(
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
   
  }
}