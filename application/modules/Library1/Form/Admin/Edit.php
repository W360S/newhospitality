<?php
class Library_Form_Admin_Edit extends Engine_Form{
	
    public function init(){
        $this->setTitle('Edit book')
      ->setAttrib('name', 'library_edit')
      ->setMethod('post');
    $user = Engine_Api::_()->user()->getViewer();
    $user_level = Engine_Api::_()->user()->getViewer()->level_id;
    
    $this->addElement('MultiCheckbox', 'categories', array(
      'label' => 'Cateories of book',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    $this->addElement('Text', 'title', array(
      'label' => 'Book title',
      'allowEmpty' => false,
      'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    $this->addElement('Text', 'isbn', array(
      'label' => 'Code',
      'allowEmpty' => false,
      //'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    $this->addElement('Text', 'author', array(
      'label' => 'Author',
      'allowEmpty' => false,
      //'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    $this->addElement('Text', 'credit', array(
      'label' => 'Credit',
      'allowEmpty' => false,
      //'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    
    $this->addElement('TinyMce', 'description', array(
      'disableLoadDefaultDecorators' => true,
      'required' => true,
      'allowEmpty' => false,
      'decorators' => array(
        'ViewHelper'
      ),
      'filters' => array(
        new Engine_Filter_Censor(),
        new Engine_Filter_StringLength(array('max' => '60000'))
        )
    ));
    
    

    //$this->tags->getDecorator("Description")->setOption("placement", "append");    
    // Old Photo
	$this->addElement('Image', 'image', array(
      'label' => 'Book photo',
      'ignore' => true,
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formEditImage.tpl',
        'class'      => 'form element',
        'testing' => 'testing'
      )))
    ));
    $this->addElement('File', 'photo', array(
      'label' => 'Edit Photo',
	  'validators' => array(
        array('Count', false, 1),
        array('Size', false, 10*1024*1024), // 10MB
        array('Extension', false, 'jpg,png,gif,jpeg'),
      ),  
    ));
    $this->photo->addValidator('Extension', false, 'jpg,png,gif');
    
    // Old Attachment
	$this->addElement('Text', 'Attachment', array(
      'label' => 'Current Attachment',
      'ignore' => true,
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formAttachment.tpl',
        'class'      => 'form element',
        'testing' => 'testing'
      )))
    ));
    
    $this->addElement('File', 'url', array(
      'label' => 'Edit Attachment',
      'destination' => APPLICATION_PATH.'/public/library_book/files/',
      'multiFile' => 1,
      'validators' => array(
        array('Count', false, 1),
        array('Size', false, 10*1024*1024), // 10MB
        array('Extension', false, 'pdf,doc,hcm,rar,zip, prc'),
      ),
    ));
    
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