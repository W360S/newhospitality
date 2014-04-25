<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    News
 * 
 * @version    1.0
 * @author     huynhnv
 * @status     done
 */

class Recruiter_Form_Artical_Create extends Engine_Form{
	public $elementDecorators = array(
                                    'ViewHelper',
                                    'Errors',
                                    'Description',
                                    array('HtmlTag',array('tag' => 'td')),
                                    array('Label',array('tag' => 'td')),
                                    array(array('row' => 'HtmlTag'), array('tag' => 'tr')));

    public function init(){
        $this->setTitle('Write a new article')
      ->setDescription('Fill in and click save button')
      ->setAttrib('name', 'artical_create')
      ->setMethod('post');
    $user = Engine_Api::_()->user()->getViewer();
    $user_level = Engine_Api::_()->user()->getViewer()->level_id;
    
    $this->addElement('Text', 'title', array(
      'label' => 'Title',
      'allowEmpty' => false,
      'required' => true, 
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    // prepare categories
    //$categories = Engine_Api::_()->bookmark()->getCategories();
    $categories= Engine_Api::_()->getDbtable('industries', 'recruiter')->fetchAll();
    //$categories= array();
    //Zend_Debug::dump($categories);exit();
    if (count($categories)!=0){
      //$categories_prepared[0]= "";
      foreach ($categories as $category){
        $categories_prepared[$category->industry_id]= $category->name;
      }

      // category field
      $this->addElement('Select', 'category_id', array(
            'label' => 'Category',
            'multiOptions' => $categories_prepared,
            'allowEmpty' => false,
            'required'=> true
          ));
    }
    $settings = Engine_Api::_()->getApi('settings', 'core');
    $filter = new Engine_Filter_Html(); 
    
    
    $this->addElement('TinyMce', 'content', array(
    	'label'=> 'Content', 
        //'disableLoadDefaultDecorators' => true,
        'required' => true,
        'allowEmpty' => false,
        'decorators' => array('ViewHelper'),
        'filters' => array(
          $filter,
          new Engine_Filter_Censor(),
        )
    ));
    $this->addElement('Text', 'tags',array(
      'label'=>'Tags (Keywords)',  
      'autocomplete' => 'off',
      'description' => 'Separate tags with commas.',
      'filters' => array(
        new Engine_Filter_Censor(),
      ),
    ));
    //$this->tags->getDecorator("Description")->setOption("placement", "append");    
    // Photo
    $this->addElement('File', 'photo', array(
      'label' => 'Main Photo'
    ));
    $this->photo->addValidator('Extension', false, 'jpg,png,gif');  
    
    $this->addElement('Button', 'submit', array(
      'label' => 'Save',
      'type' => 'submit',
    ));
    }
}