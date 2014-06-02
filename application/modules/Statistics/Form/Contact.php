<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Contact.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Statistics_Form_Contact extends Engine_Form
{
  public function init()
  {
    $this->setAttrib('id', 'contact');
    $this->setAttrib('class', 'form');
    $this->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()))
      ;
    
    $elementDecorators = array(
        'ViewHelper',
        'Errors',
        //array('Description', array('tag' => 'p', 'class' => 'description')),
        array('HtmlTag', array('tag' => 'div')),
        array('Label', array('class' => 'form-label'))
    );
    $this->addElement('Text', 'name', array(
      'label' => 'Name',
      'required' => true,
      'notEmpty' => true,
    ));
    
    $this->getElement('name')->setDecorators($elementDecorators);
    $this->addElement('Text', 'email', array(
      'label' => 'Email Address',
      'required' => true,
      'notEmpty' => true,
      'validators' => array(
        'EmailAddress'
      )
    ));
    $this->getElement('email')->setDecorators($elementDecorators);
    $this->addElement('Textarea', 'body', array(
      'label' => 'Message',
      'required' => true,
      'notEmpty' => true,
    ));
    $this->getElement('body')->setDecorators($elementDecorators);
    $show_captcha = Engine_Api::_()->getApi('settings', 'core')->core_spam_contact;
    if ($show_captcha && ($show_captcha > 1 || !Engine_Api::_()->user()->getViewer()->getIdentity() ) ) {
      $this->addElement('captcha', 'captcha', array(
        'label' => 'Human Verification',
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
      'label' => 'Send',
      'type' => 'submit',
      'ignore' => true,
      'class'=>'submit'
    ));
    //$this->getElement('submit')->setDecorators($elementDecorators);

  }
}