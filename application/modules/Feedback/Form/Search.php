<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Search.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_Form_Search extends Engine_Form
{
  public function init()
  {
    $this
    ->setAttribs(array(
      'id' => 'filter_form',
      'class' => 'global_form_box',
    ))
    ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()))
    ;
    
    $this->addElement('Text', 'search', array(
      'label' => 'Search Feedback',
      'onchange' => 'this.form.submit();',
    ));

   
    $this->addElement('Select', 'category', array(
      'label' => 'Category',
      'multiOptions' => array(
        '0' => 'All Categories',
      ),
      'onchange' => 'this.form.submit();',
    ));
 
    $this->addElement('Select', 'orderby', array(
      'label' => 'Browse By',
      'multiOptions' => array(
        'creation_date' => 'Most Recent',
        'total_votes' => 'Most Voted',
        'views' => 'Most Viewed',
     		'featured' => 'Featured',
      ),
      'onchange' => 'this.form.submit();',
    ));
    
    $this->addElement('Select', 'stat', array(
      'label' => 'Status',
      'multiOptions' => array(
        '0' => 'All Status',
      ),
      'onchange' => 'this.form.submit();',
    ));

    $this->addElement('Hidden', 'page', array(
      'order' => 1
    ));
  }
}
