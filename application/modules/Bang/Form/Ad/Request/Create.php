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

        /*
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
        }*/

        // Head of form section
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
        
        $this->addElement('File', 'ad_file', array(
            'label' => 'File*',
        
        ));
        
        $this->ad_file->addValidator('Extension', false, 'jpg,png,gif');

        
        $this->addElement('Text', 'ad_link', array(
            'label' => 'Link*',
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
        
        $this->addDisplayGroup(array(
                    'ad_title',
                    'ad_subtitle',
                    'ad_file',
                    'ad_link',
                    'ad_description'
            ),'ads_request_ìnfo',array('legend' => 'Nội dung quảng cáo của bạn'));

        // Ads campagn section

        $potition_options = array(
            "1" => "Cộng đồng --- 60.000 vnd / ngày",
            "2" => "Việc làm --- 50.000 vnd / ngày",
            "3" => "Thư viện --- 30.000 vnd / ngày",
            "4" => "Hỏi đáp --- 30.000 vnd / ngày",
        );
        // Position
        $this->addElement('Multiselect', 'ad_position', array(
        'label' => 'Position',
        'multiOptions' => $potition_options,
        'value' => key($potition_options),
        ));

        // Start time
        $start = new Engine_Form_Element_CalendarDateTime('ad_start');
        $start->setLabel("Start Time");
        $this->addElement($start);

        // End time
        $end = new Engine_Form_Element_CalendarDateTime('ad_end');
        $end->setLabel("End Time");
        $this->addElement($end);


        $this->addElement('Text', 'ad_total', array(
            'label' => 'Thanh tien',
//            'allowEmpty' => false,
//            'required' => true,
            'attribs'    => array('disabled' => 'disabled'),
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_StringLength(array('max' => '63')),
        )));
        
        $this->addDisplayGroup(array(
                    'ad_position',
                    'ad_start',
                    'ad_end',
                    'ad_total'
            ),'ads_campain_request_ìnfo',array('legend' => 'Tạo chiến dịch quảng cáo'));


        // User contact section
        $this->addElement('Text', 'ad_name', array(
            'label' => 'Full Name*',
            'allowEmpty' => false,
            'required' => true,
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_StringLength(array('max' => '63')),
        )));

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
        
        $this->addDisplayGroup(array(
                    'ad_name',
                    'ad_email',
                    'ad_phone'
            ),'ads_user_ìnfo',array('legend' => 'Thông tin liên lạc'));

        
        // End form
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
    }

}

?>
