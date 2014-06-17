<?php

class Experts_Model_Expert extends Core_Model_Item_Abstract
{
  // Properties


  // General

  public function getTable()
  {
    if( is_null($this->_table) )
    {
      $this->_table = Engine_Api::_()->getDbtable('experts', 'experts');
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
      $file = $file_data['tmp_name'];
    } else if( is_string($file_data) && file_exists($file_data) ) {
      $file = $file_data;
    } else {
      throw new User_Model_Exception('invalid argument passed to setFile');
    }
    
    $name = basename($file);
    $tmp_path = dirname($file);
    
    $path = APPLICATION_PATH . DIRECTORY_SEPARATOR . 'temporary';
    //Zend_Debug::dump($this->getIdentity()); exit;
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
  
  public function setPhotos($photo)
  {
    if( $photo instanceof Zend_Form_Element_File ) {
      $file = $photo->getFileName();
    } else if( $photo instanceof Storage_Model_File ) {
      $file = $photo->temporary();
    } else if( $photo instanceof Core_Model_Item_Abstract && !empty($photo->photo_id) ) {
      $file = Engine_Api::_()->getItem('storage_file', $photo->photo_id)->temporary();
    } else if( is_array($photo) && !empty($photo['tmp_name']) ) {
      $file = $photo['tmp_name'];
    } else if( is_string($photo) && file_exists($photo) ) {
      $file = $photo;
    } else {
      throw new User_Model_Exception('invalid argument passed to setPhoto');
    }

    $name = basename($file);
    $path = APPLICATION_PATH . DIRECTORY_SEPARATOR . 'temporary';
    
    $params = array(
      'parent_type' => $this->getType(),
      'parent_id' => $this->getIdentity()
    );
    
    // Save
    $storage = Engine_Api::_()->storage();

    // Resize image (main)
    $image = Engine_Image::factory();
    $image->open($file)
      ->resize(720, 720)
      ->write($path.'/m_'.$name)
      ->destroy();

    // Resize image (profile)
    $image = Engine_Image::factory();
    $image->open($file);

    $size = min($image->height, $image->width);
    $x = ($image->width - $size) / 2;
    $y = ($image->height - $size) / 2;

    $image->resample($x, $y, $size, $size, 200, 200)
            ->write($path . '/p_' . $name)
            ->destroy();

    // Resize image (normal)
    $image = Engine_Image::factory();
    $image->open($file)
      ->resize(140, 160)
      ->write($path.'/in_'.$name)
      ->destroy();

    // Resize image (icon)
    $image = Engine_Image::factory();
    $image->open($file);

    $size = min($image->height, $image->width);
    $x = ($image->width - $size) / 2;
    $y = ($image->height - $size) / 2;

    $image->resample($x, $y, $size, $size, 48, 48)
      ->write($path.'/is_'.$name)
      ->destroy();

    // Store
    $iMain = $storage->create($path.'/m_'.$name, $params);
    $iProfile = $storage->create($path.'/p_'.$name, $params);
    $iIconNormal = $storage->create($path.'/in_'.$name, $params);
    $iSquare = $storage->create($path.'/is_'.$name, $params);
    
    $iMain->bridge($iProfile, 'thumb.profile');
    $iMain->bridge($iIconNormal, 'thumb.normal');
    $iMain->bridge($iSquare, 'thumb.icon');
    
    // delete tmp file
    @unlink($path.'/m_'.$name);
    @unlink($path.'/p_'.$name);
    @unlink($path.'/in_'.$name);
    @unlink($path.'/is_'.$name);

    // Update row
    $this->photo_id = $iMain->file_id;
    $result = $this->save();

    return $result;     
  }
}