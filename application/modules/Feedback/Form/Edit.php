<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Edit.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_Form_Edit extends Engine_Form
{
  public $_error = array();

  public function init()
  {
    $this->setTitle('Edit Feedback')
      ->setDescription('Edit your Feedback below.')
      ->setAttrib('name', 'feedback_create');

    $this->addElement('Text', 'feedback_title', array(
      'label' => 'Feedback Title*',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
    )));

    $this->addElement('Textarea', 'feedback_description', array(
      'label' => 'Description*',
      'required' => true,
      'filters' => array(
        'StripTags',
        new Engine_Filter_HtmlSpecialChars(),
        new Engine_Filter_EnableLinks(),
        new Engine_Filter_Censor(),
      ),
    ));
    
    $categories = Engine_Api::_()->feedback()->getCategories();
    if (count($categories)!=0){
      $categories_prepared[0]= "";
      foreach ($categories as $category){
        $categories_prepared[$category->category_id]= $category->category_name;
      }

      $this->addElement('Select', 'category_id', array(
            'label' => 'Category',
            'multiOptions' => $categories_prepared
          ));
    }

    $feedback_severity = Engine_Api::_()->getApi('settings', 'core')->feedback_severity;
    if($feedback_severity) {
		  $severities = Engine_Api::_()->feedback()->getSeverities();
		    if (count($severities)!=0) {
		      $severities_prepared[0]= "";
		      foreach ($severities as $severity) {
		        $severities_prepared[$severity->severity_id]= $severity->severity_name;
		      }
		
		      $this->addElement('Select', 'severity_id', array(
		            'label' => 'Severity',
		            'multiOptions' => $severities_prepared
		      ));
	    }
    }
    
    $feedback_default_visibility = Engine_Api::_()->getApi('settings', 'core')->feedback_default_visibility;
    if($feedback_default_visibility == 'public') {
	    $this->addElement('Select', 'feedback_private', array(
	      'label' => 'Feedback Visibility',
	      'multiOptions' => array('public'=>"Public", 'private'=>"Private" ),
	      'description' => 'Only public feedback will be visible to others.'
	    ));
	    $this->feedback_private->getDecorator('Description')->setOption('placement', 'append');
    }
	  
    $this->addElement('Button', 'submit', array(
      'label' => 'Save Change',
      'type' => 'submit',
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formButtonCancel.tpl',
        'class'      => 'form element'
    )))));

  }

}
?>
