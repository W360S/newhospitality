<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Contact.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Form_Contact extends Engine_Form
{
  public function init()
  {
    $this->setTitle('Contact Us')
      ->setDescription('_CORE_CONTACT_DESCRIPTION')
      #->setDescription('Thank you for trying out the SE4 Preview! We are using this live demonstration to find and resolve bugs more quickly as we continue to develop SE4. Please note that much of the functionality and front-end layout is still rough. The basic skin you see here will be one of several default skin choices available with SE4 when the final version is released. Our team sincerely appreciates your participation and feedback. Your message will be entered into our internal bug tracking system, so please do not expect a direct reply - although we may contact you with further questions if necessary. Once again, thanks!')
      ->setAction($_SERVER['REQUEST_URI'])
      ;
    
    $this->addElement('Text', 'name', array(
      'label' => 'Name',
      'required' => true,
      'notEmpty' => true,
    ));
    
    $this->addElement('Text', 'email', array(
      'label' => 'Email Address',
      'required' => true,
      'notEmpty' => true,
      'validators' => array(
        'EmailAddress'
      )
    ));

    $this->addElement('Textarea', 'body', array(
      'label' => 'Message',
      'required' => true,
      'notEmpty' => true,
    ));

    $show_captcha = Engine_Api::_()->getApi('settings', 'core')->core_spam_contact;
    if( $show_captcha && ($show_captcha > 1 || !Engine_Api::_()->user()->getViewer()->getIdentity() ) ) {
      $this->addElement('captcha', 'captcha', Engine_Api::_()->core()->getCaptchaOptions());
    }

    $this->addElement('Button', 'submit', array(
      'label' => 'Send Message',
      'type' => 'submit',
      'ignore' => true
    ));
  }
}