<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Global.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_Form_Admin_Global extends Engine_Form
{
  public function init()
  {
    $this
    ->setTitle('Global Settings')
    ->setDescription('These settings affect all members in your community.');
    
    $this->addElement('Text', 'feedback_license_key', array(
      'label' => 'License key',
    	'description' => 'Please enter your license key that was provided to you when you purchased this plugin. If you do not know your license key, please contact the Support Team of SocialEngineAddOns from the Support section of your Account Area.(Key Format: XXXXXX-XXXXXX-XXXXXX )',
      //'allowEmpty' => false,
      //'required' => true,
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
    ),
    'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.license_key', ''),
    ));
    
    $this->addElement('Radio', 'feedback_show_browse', array(
      'label' => 'Feedback Forum',
      'description' => 'Enable the Feedback Forum on your site (Note : If you disable the Feedback Forum on your site, the visibility of all the Feedback will become private [they will only be viewable to you, and the Feedback creator], and users will not be able to select the visibility of their Feedback during creation.)',
      'multiOptions' => array(
        1 => 'Yes, enable Feedback Forum on the site.',
        0 => 'No, disable Feedback Forum on the site.'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.show.browse', 1),
    ));
    
     $this->addElement('Radio', 'feedback_default_visibility', array(
     	'label' => 'Public / private feedback',
      'description' => 'Allow logged-in users to choose to make their Feedback Public or Private. (Feedback of non logged-in users will always be private. Public Feedback will be shown in the Feedback Forum.)',
      'multiOptions' => array(
        'public'  => 'Show public/private option',
        'private' => 'Make all new feedback private'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.default.visibility', 'public'),
    ));
     
    $this->addElement('Radio', 'feedback_public', array(
    	'label' => 'Public Permissions',
      'description' => 'Select whether or not you want to let the public (visitors that are not logged-in) to view the following sections of your social network. In some cases (such as Profiles, Feedback, and Albums), if you have given them the option, your users will be able to make their pages private even though you have made them publically viewable here. For more permissions settings, please visit the General Settings page.',
      'multiOptions' => array(
        1 => 'Yes, the public can view feedbacks unless they are made private.',
        0 => 'No, visitors must sign in to view the feedbacks.'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.public', 1),
    ));
 
    $this->addElement('Radio', 'feedback_post', array(
      'label' => 'Select who can create feedback.',
      'description' => 'Select who can create feedback?',
      'multiOptions' => array(
        0 => 'Everyone (including non logged-in users)',
        1 => 'Only logged-in users'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.post', 0),
    ));
    
    $this->addElement('Radio', 'feedback_option_post', array(
      'description' => 'Require users to enter validation code when creating feedback? ',
      'multiOptions' => array(
        1 => 'Yes, make members complete the CAPTCHA form.',
        0 => 'No, do not show a CAPTCHA form.'
      ),
       'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.option.post', 0),
    ));
    
    $this->addElement('Radio', 'feedback_severity', array(
    	'label' => 'Severity options',
      'description' => 'Allow users to choose Severity for their feedback.',
      'multiOptions' => array(
        1 => ' 	Yes',
        0 => ' 	No'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.severity', 1),
    ));
    
    $this->addElement('Radio', 'feedback_allow_image', array(
    	'label' => 'Picture upload options',
      'description' => 'Allow users to upload / associate pictures to their feedback.',
      'multiOptions' => array(
        1 => ' 	Yes',
        0 => ' 	No'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.allow.image', 1),
    ));
    
    $this->addElement('Radio', 'feedback_email_notify', array(
    	'label' => 'Email Notification',
      'description' => 'Send email alerts to Admin for every new feedback creation.',
      'multiOptions' => array(
        1 => ' 	Yes',
        0 => ' 	No'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.email.notify', 1),
    ));
    
    $this->addElement('Radio', 'feedback_report', array(
    	'label' => 'Report as inappropriate',
      'description' => 'Allow logged-in users to Report feedback from public feedback as Inappropriate.',
      'multiOptions' => array(
        1 => ' 	Yes',
        0 => ' 	No'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.report', 1),
    ));
    
    $this->addElement('Radio', 'feedback_button_position', array(
    	'label' => 'Customize feedback button position',
      'description' => 'Customize the position of the feedback button',
      'multiOptions' => array(
        1 => ' 	Left side of the screen',
        0 => ' 	Right side of the screen'
      ),
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.button.position', 1),
    ));
    
    $this->addElement('Text', 'feedback_button_color1', array(
    	'label' => 'Customize feedback button color',
      'description' => 'Select the color of the feedback button. (Click on the rainbow below to choose your color.)',
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formImagerainbow1.tpl',
        'class'      => 'form element'
      )))
    ));
 
  	$this->addElement('Text', 'feedback_button_color2', array(
    	'label' => 'Customize feedback button color on mouse over',
      'description' => 'Customize the color of the feedback buttons (Click on rainbow to choose second color)',
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formImagerainbow2.tpl',
        'class'      => 'form element'
      )))
    ));
    
    $this->addElement('Text', 'feedback_page', array(
      'label' => 'Feedback Per Page',
      'description' => 'Enter the number of feedback to be shown per page on the Feedback listing pages. (Enter a value between 1 and 999.)',
      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('feedback.page', 10),
    ));

    $this->addElement('Button', 'submit', array(
      'label' => 'Save Change',
      'type' => 'submit',
      'ignore' => true
    ));
    
    $this->addElement('Hidden', 'feedbackbutton_visible', array('order' => 1));
    
	}
}
?>


