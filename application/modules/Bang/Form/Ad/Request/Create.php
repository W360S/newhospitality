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
class Bang_Form_Ad_Request_Create extends Engine_Form {

    public $_error = array();

    public function init() {

        $viewer = Engine_Api::_()->user()->getViewer();
        $viewer_id = $viewer->getIdentity();

        $title = Zend_Registry::get('Zend_Translate')->_('Submit your new Advertisement');

        if (!empty($viewer_id)) {
            $this->setTitle($title)
                    ->setDescription('Please send us your request for posting Advertisement')
                    ->setAttrib('name', 'bang_ad_create');
        } else {
            $description = Zend_Registry::get('Zend_Translate')->_("To be able to display your Feedback publicly, please <a href='%s' target='_parent'>login</a> first.");
            $description = sprintf($description, Zend_Controller_Front::getInstance()->getRouter()->assemble(array(), 'user_login', true));
            $this->setTitle($title);
            $this->setDescription($description);
            $this->setAttrib('name', 'bang_ad_create');
            $this->loadDefaultDecorators();
            $this->getDecorator('Description')->setOption('escape', false);
        }

        $this->addElement('Text', 'ad_title', array(
            'label' => 'Title*',
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
        )));
        
        $this->addElement('Text', 'ad_subtitle', array(
            'label' => 'Sub Title*',
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
        )));

        $this->addElement('Textarea', 'ad_description', array(
            'label' => 'Description*',
            'filters' => array(
                'StripTags',
                new Engine_Filter_HtmlSpecialChars(),
                new Engine_Filter_EnableLinks(),
                new Engine_Filter_Censor(),
            ),
        ));

        $this->addElement('Text', 'ad_email', array(
            'label' => 'Email*',
            'required' => true,
            'allowEmpty' => false,
            'validators' => array(
                array('NotEmpty', true),
                array('EmailAddress', true))
        ));
        
            $this->addElement('Text', 'ad_phone', array(
            'label' => 'Phone*',
            'required' => true,
            'allowEmpty' => false,
            'validators' => array(
                array('NotEmpty', true))
        ));

        $this->addElement('Text', 'ad_name', array(
            'label' => 'Full Name*',
            'allowEmpty' => false,
            'required' => true,
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_StringLength(array('max' => '63')),
        )));

        $this->addElement('Button', 'submit', array(
            'label' => 'Post Advertisement',
            'type' => 'submit',
            'ignore' => true,
            'decorators' => array('ViewHelper')
        ));

        $this->addElement('Cancel', 'cancel', array(
            'label' => 'cancel',
            'link' => true,
            'prependText' => ' or ',
            'href' => '',
            'onClick' => 'javascript:parent.Smoothbox.close();',
            'decorators' => array(
                'ViewHelper'
            )
        ));
        $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
        $button_group = $this->getDisplayGroup('buttons');
    }

}

?>
