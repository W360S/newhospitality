<?php
class Experts_Form_Admin_Experts_Edit extends Engine_Form{
	
    public function init(){
        $this->setTitle('Edit experts')
      //->setAttrib('name', 'experts_edit')
      ->setMethod('post');
    $user = Engine_Api::_()->user()->getViewer();
    $user_level = Engine_Api::_()->user()->getViewer()->level_id;
    
    $this->addElement('MultiCheckbox', 'categories', array(
      'label' => 'Cateories of experts',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    /*
    $this->addElement('Text', 'name', array(
      'label' => 'Experts name',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    */
    $this->addElement('Text', 'occupation', array(
      'label' => 'Occupation',
      'allowEmpty' => false,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    $this->addElement('Text', 'experience', array(
      'label' => 'Experience',
      'allowEmpty' => false,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '2'))
    )));
    
    $this->addElement('Text', 'company', array(
      'label' => 'Company',
      'allowEmpty' => false,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    $this->addElement('Textarea', 'description', array(
      'label' => 'Description',
      'allowEmpty' => false,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags'
        //,
        //new Engine_Filter_StringLength(array('max' => '63'))
    )));
    /*
    //$this->tags->getDecorator("Description")->setOption("placement", "append");    
    // Old Photo
	$this->addElement('Image', 'image', array(
      'label' => 'Current Photo',
      'ignore' => true,
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formEditImage.tpl',
        'class'      => 'form element',
        'testing' => 'testing'
      )))
    ));
    $this->addElement('File', 'photo', array(
      'label' => 'Edit Photo',
		//'required' => true,
    ));
    $this->photo->addValidator('Extension', false, 'jpg,png,gif');
    */
    // Old Attachment
	$this->addElement('Text', 'Attachment', array(
      'label' => 'Current Attachment',
      'ignore' => true,
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formEditAttachment.tpl',
        'class'      => 'form element',
        'testing' => 'testing'
      )))
    ));
    $this->addElement('File', 'file', array(
      'label' => 'Edit Profile Attachment',
	));
    $this->file->addValidator('Extension', false, 'jpg,png,gif,pdf,doc,docx,rar,zip');
    
   
    // Buttons
    $this->addElement('Button', 'submit', array(
      'label' => 'Save Changes',
      'type' => 'submit',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));

    $this->addElement('Cancel', 'cancel', array(
      'label' => 'cancel',
      'link' => true,
      'prependText' => ' or ',
      'decorators' => array(
        'ViewHelper',
      ),
    ));

    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons', array(
      'decorators' => array(
        'FormElements',
        'DivDivDivWrapper',
      ),
    ));
    }
}