<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @author     Jung
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Form_Admin_Ads_Adedit extends Engine_Form {

    public function init() {
        // Set form attributes
        $this->setTitle('Edit Advertisement');
        $this->setDescription('Follow this guide to design and create a new advertisement.');
        $this->setAttrib('id', 'form-upload');

        // Title
        $this->addElement('Text', 'name', array(
            'label' => 'Advertisement Name',
            'allowEmpty' => false,
            'required' => true,
            'validators' => array(
                array('NotEmpty', true),
                array('StringLength', false, array(1, 64)),
            ),
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_EnableLinks(),
            ),
        ));

        // Title
        $this->addElement('Text', 'title', array(
            'label' => 'Title',
            'allowEmpty' => false,
            'required' => true,
            'validators' => array(
                array('NotEmpty', true),
                array('StringLength', false, array(1, 64)),
            ),
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_EnableLinks(),
            ),
        ));

        // Title
        $this->addElement('Text', 'subtitle', array(
            'label' => 'Subtitle',
            'allowEmpty' => false,
            'required' => true,
            'validators' => array(
                array('NotEmpty', true),
                array('StringLength', false, array(1, 64)),
            ),
            'filters' => array(
                'StripTags',
                new Engine_Filter_Censor(),
                new Engine_Filter_EnableLinks(),
            ),
        ));

        $this->addElement('Textarea', 'description', array(
            'label' => 'Description',
            'allowEmpty' => false,
            'required' => true,
        ));

        $this->addElement('Textarea', 'html_code', array(
            'label' => 'Edit HTML',
//            'allowEmpty' => false,
//            'required' => true,
        ));

        // Buttons
        $this->addElement('Button', 'submit', array(
            'label' => 'Save Changes',
            'type' => 'submit',
            'ignore' => true,
            'decorators' => array('ViewHelper')
        ));

        $this->addElement('Cancel', 'cancel', array(
            'label' => 'cancel',
            'link' => true,
            'prependText' => ' or ',
            'onclick' => 'parent.Smoothbox.close();',
            'decorators' => array(
                'ViewHelper'
            )
        ));
        $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
        $button_group = $this->getDisplayGroup('buttons');
        $button_group->addDecorator('DivDivDivWrapper');
    }

}
