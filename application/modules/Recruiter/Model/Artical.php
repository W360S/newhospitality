<?php
class Recruiter_Model_Artical extends Core_Model_Item_Abstract {
    public function tags()
    {
        return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('tags', 'core'));
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
        $image->open($file)
          ->resize(200, 400)
          ->write($path.'/p_'.$name)
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
        $this->save();
    
        return $this;     
    }
}