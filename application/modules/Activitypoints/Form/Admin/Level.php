<?php

class Activitypoints_Form_Admin_Level extends Engine_Form
{


  public function init()
  {
    $this
      ->setTitle('Member Level Settings')
      ->setDescription('ACTIVITYPOINTS_FORM_ADMIN_LEVEL_DESCRIPTION');

    $this->loadDefaultDecorators();
    $this->getDecorator('Description')->setOptions(array('tag' => 'h4', 'placement' => 'PREPEND'));

    // prepare user levels
    $table = Engine_Api::_()->getDbtable('levels', 'authorization');
    $select = $table->select();
    $user_levels = $table->fetchAll($select);
    
    foreach ($user_levels as $user_level){
      $levels_prepared[$user_level->level_id]= $user_level->getTitle();
    }
    
    // category field
    $this->addElement('Select', 'level_id', array(
          'label' => 'Member Level',
          'multiOptions' => $levels_prepared,
          'onchange' => 'javascript:fetchLevelSettings(this.value);',
          'ignore' => true
        ));
    
    $this->addElement('Radio', 'use', array(
      'label' => '100016629',
      'description' => '100016630',
      'multiOptions' => array(
        1 => '100016631',
        0 => '100016632',
      ),
      'value' => 0,
    ));

    $this->addElement('Radio', 'allow_transfer', array(
      'label' => '100016633',
      'description' => '100016634',
      'multiOptions' => array(
        1 => '100016635',
        0 => '100016636',
      ),
      'value' => 0,
    ));

    $this->addElement('text', 'max_transfer', array(
      'label' => '100016638',
      'description' => '100016637', // + 100016639 (enter 0 to allow unlimited transfers)
      'value' => 0,
    ));

    $this->addElement('text', 'max_receive', array(
      'label' => '100016638',
      'description' => 'ACTIVITYPOINTS_LEVEL_LIMIT_RECEIVE', // + 100016639 (enter 0 to allow unlimited transfers)
      'value' => 0,
    ));
    
    
    $this->addElement('Button', 'submit', array(
      'label' => 'Save Settings',
      'type' => 'submit',
      'ignore' => true
    ));

  }
}