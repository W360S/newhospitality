<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Create.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_Form_Create extends Engine_Form
{
  public $_error = array();

  public function init()
  {
  
  	$viewer = Engine_Api::_()->user()->getViewer();
	  $viewer_id = $viewer->getIdentity();

    $title = Zend_Registry::get('Zend_Translate')->_('Post a Feedback');

  	if(!empty($viewer_id)) {
	    $this->setTitle($title)
	      ->setDescription('Share with us your ideas, questions, problems and feedback.')
	      ->setAttrib('name', 'feedback_create');
  	}
  	else {    
  		$description = Zend_Registry::get('Zend_Translate')->_("To be able to display your Feedback publicly, please <a href='%s' target='_parent'>login</a> first.");
    	$description= sprintf($description, Zend_Controller_Front::getInstance()->getRouter()->assemble(array(), 'user_login', true));
  		$this->setTitle($title);
	    $this->setDescription($description);
    	$this->setAttrib('name', 'feedback_create');
    	$this->loadDefaultDecorators();
    	$this->getDecorator('Description')->setOption('escape', false);
  	}

    $this->addElement('Text', 'feedback_title', array(
      'label' => 'Title*',
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
	    $this->addElement('Select', 'default_visibility', array(
	      'label' => 'Feedback Visibility',
	      'multiOptions' => array('public'=>"Public", 'private'=>"Private"),
	      'description' => 'Only public feedback will be visible to others.'
	    ));
	    $this->default_visibility->getDecorator('Description')->setOption('placement', 'append');
    }

    $this->addElement('Text', 'anonymous_email', array(
      'label' => 'Email*',
      'required' => true,
      'allowEmpty' => false,
      'validators' => array(
        array('NotEmpty', true),
        array('EmailAddress', true))
    ));
    
    $this->addElement('Text', 'anonymous_name', array(
      'label' => 'Full Name*',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_StringLength(array('max' => '63')),
    )));
    
    $feedback_post = Engine_Api::_()->getApi('settings', 'core')->feedback_post;
    $feedback_option_post = Engine_Api::_()->getApi('settings', 'core')->feedback_option_post;
    if($feedback_post == 0 && $feedback_option_post == 1 && $viewer_id == 0) {
	    $this->addElement('captcha', 'captcha', array(
	        'description' => 'Please type the characters you see in the image.',
	        'captcha' => 'image',
	        'required' => true,
	        'captchaOptions' => array(
	          'wordLen' => 6,
	          'fontSize' => '30',
	          'timeout' => 300,
	          'imgDir' => APPLICATION_PATH . '/public/temporary/',
	          'imgUrl' => $this->getView()->baseUrl().'/public/temporary',
	          'font' => APPLICATION_PATH . '/application/modules/Core/externals/fonts/arial.ttf'
	        )));
	        
    }
    
    $this->addElement('Button', 'submit', array(
      'label' => 'Post Feedback',
      'type' => 'submit',
      'ignore' => true,
      'decorators' => array('ViewHelper')
    ));

    $this->addElement('Cancel', 'cancel', array(
      'label' => 'cancel',
      'link' => true,
      'prependText' => ' or ',
      'href' => '',
      'onClick'=> 'javascript:parent.Smoothbox.close();',
      'decorators' => array(
        'ViewHelper'
      )
    ));
    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
    $button_group = $this->getDisplayGroup('buttons');
    
  }

}
?>
