<?php

class Experts_Model_Answer extends Core_Model_Item_Abstract
{
  public function getHref() {
        return Zend_Controller_Front::getInstance()->getBaseUrl() . '/experts/index/detail/question_id/' . $this->question_id;
    }
  public function getDescription() {
        return strip_tags($this->content);
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
    
    $iMain = $storage->create($tmp_path.DIRECTORY_SEPARATOR.$name, $params);
    
    // Update row
    $this->file_id = $iMain->file_id;
    $result = $this->save();
    return $result;
  }
}