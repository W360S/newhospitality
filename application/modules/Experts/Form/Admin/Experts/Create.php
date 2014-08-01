<?php
class Experts_Form_Admin_Experts_Create extends Engine_Form{
	
    public function init(){
        $this->setTitle('Add new a experts')
      ->setAttrib('name', 'experts_create')
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
    
    // init to
    $this->addElement('Text', 'to',array(
        'label'=>'Choose users',
        'autocomplete'=>'off'));

    Engine_Form::addDefaultDecorators($this->to);

    // Init to Values
    $this->addElement('Hidden', 'toValues', array(
      'required' => true,
      'allowEmpty' => false,
      'order' => 2,
      'validators' => array(
        'NotEmpty'
      ),
      'filters' => array(
        'HtmlEntities'
      ),
    ));
    Engine_Form::addDefaultDecorators($this->toValues);
    
    
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
        // dunghd fix bug limit description length at 2011/25/01
        //,
        //new Engine_Filter_StringLength(array('max' => '63'))
    )));

    //$this->tags->getDecorator("Description")->setOption("placement", "append");    
    // Photo
	/*
    $this->addElement('File', 'photo', array(
      'label' => 'Upload Photo',
		//'required' => true,
    ));
    $this->photo->addValidator('Extension', false, 'jpg,png,gif');
    */
    $this->addElement('File', 'file', array(
      'label' => 'Profile Attachment',
		//'required' => true,
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