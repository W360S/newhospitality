<?php

class Experts_Model_Question extends Core_Model_Item_Abstract
{
  // Properties
  /*
  public function getType()
  {
    return 'question';
  }  
  */
  public function getHref()
  {
    return Zend_Controller_Front::getInstance()->getBaseUrl() . '/experts/index/detail/question_id/' . $this->question_id;
  }
  
  public function getDescription()
  {
    return strip_tags($this->content);
  }
    
  // General

  public function getTable()
  {
    if( is_null($this->_table) )
    {
      $this->_table = Engine_Api::_()->getDbtable('questions', 'experts');
    }

    return $this->_table;
  }

  public function isOwner($owner)
  {
    if( $owner instanceof Core_Model_Item_Abstract )
    {
      return ( $this->getIdentity() == $owner->getIdentity() && $this->getType() == $owner->getType() );
    }

    else if( is_array($owner) && count($owner) === 2 )
    {
      return ( $this->getIdentity() == $owner[1] && $this->getType() == $owner[0] );
    }

    else if( is_numeric($owner) )
    {
      return ( $owner == $this->getIdentity() );
    }

    return false;
  }

  public function getOwner()
  {
    return $this;
  }
  
  public function setFiles($file_data)
  {
    if($file_data instanceof Zend_Form_Element_File ) {
      $file = $file_data->getFileName();
    } else if( $file_data instanceof Storage_Model_File ) {
      $file = $file_data->temporary();
    } else if( $file_data instanceof Core_Model_Item_Abstract && !empty($file_data->file_id) ) {
      $file = Engine_Api::_()->getItem('storage_file', $file_data->file_id)->temporary();
    } else if( is_array($file_data) && !empty($file_data['tmp_name']) ) {
       $extension = $extension = ltrim(strrchr($file_data['name'], '.'), '.');
       $tmp_path = $file_data['tmp_name']."_tmp.".$extension;
       $old_path = dirname($file_data['tmp_name']);
       $new_path = $old_path.DIRECTORY_SEPARATOR.$file_data['name'];
       @copy( $file_data['tmp_name'],$tmp_path);  
       @unlink($file_data['tmp_name']);
       @copy($tmp_path, $new_path);
       @unlink($tmp_path);
       $file = $new_path;
    } else if( is_string($file_data) && file_exists($file_data) ) {
      $file = $file_data;
    } else {
      throw new User_Model_Exception('invalid argument passed to setFile');
    }
    
    $name = basename($file);
    $tmp_path = dirname($file);
       
    $path = APPLICATION_PATH . DIRECTORY_SEPARATOR . 'temporary';
    
    // Save
    $storage = Engine_Api::_()->storage();
    
    // Store
    $params = array(
      'parent_type' => $this->getType(),
      'parent_id' => $this->getIdentity()
    );
    
    $iMain = $storage->secure_create($tmp_path.DIRECTORY_SEPARATOR.$name, $params);
    
    // Update row
    $this->file_id = $iMain->file_id;
    $result = $this->save();
    return $result;
  }
  
  
}