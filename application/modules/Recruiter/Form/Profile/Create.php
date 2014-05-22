<?php

/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter

 * @author     huynhnv
 */
class Recruiter_Form_Profile_Create extends Engine_Form {

    public function init() {
        $user = Engine_Api::_()->user()->getViewer();

        $this->setAttrib('id', 'recruiter_profile_form')
                ->setMethod("POST")
                ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()));

        //company name
        $this->addElement('Text', 'company_name', array(
            'label' => 'Company Name:',
            'allowEmpty' => false,
            'required' => true,
            'maxlength' => 160,
            'validators' => array(
                array('NotEmpty', true),
            //array('StringLength', false, array(1, 21)),
            ),
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_EnableLinks(),
            ),
        ));
        //company name
        $this->addElement('Text', 'company_size', array(
            'label' => 'Company Size:',
            'allowEmpty' => false,
            'required' => true,
            'maxlength' => 160,
            'validators' => array(
                array('NotEmpty', true),
            //array('StringLength', false, array(1, 21)),
            ),
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_EnableLinks(),
            ),
        ));
        $this->addElement('File', 'logo', array(
            'label' => 'Logo:',
            //'required' => true,
            'validators' => array(
                array('Count', false, 1),
                array('Size', false, 10 * 1024 * 1024), // 10MB
                array('Extension', false, 'jpg,png,gif,jpeg'),
            ),
        ));
        $this->logo->addValidator('Extension', false, 'jpg,png,gif,jpeg');
        //industry
        $this->addElement('MultiCheckbox', 'industries', array(
            'label' => 'Industries:',
            'id' => 'industry_re',
            'allowEmpty' => false,
            'required' => true,
            'filters' => array(
                new Engine_Filter_Censor(),
                'StripTags',
                new Engine_Filter_StringLength(array('max' => '63'))
        )));

        $this->addElement('Textarea', 'description', array(
            'label' => 'Company Description:',
            //'maxlength' => '512',
            'filters' => array(
                new Engine_Filter_Censor(),
            ),
        ));
        // Buttons Back
        $this->addElement('Cancel', 'cancel', array(
            'label' => 'Reset',
            'onclick' => 'javascript: reset();',
            'ignore' => true,
            'decorators' => array(
                'ViewHelper',
            ),
        ));
        // Buttons Next
        $this->addElement('Button', 'submit', array(
            'label' => 'Save',
            'type' => 'submit',
            'ignore' => true,
            'decorators' => array(
                'ViewHelper',
            ),
        ));
        $this->addDisplayGroup(array('cancel', 'submit'), 'buttons', array(
            'decorators' => array(
                'FormElements',
                'DivDivDivWrapper',
            ),
        ));
    }

}
