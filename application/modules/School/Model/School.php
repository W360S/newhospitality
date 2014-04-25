<?php
class School_Model_School extends Core_Model_Item_Abstract {
    protected $_parent_type = 'user';
    public function getType()
      {
        return 'school';
      }
      public function getHref($params = array())
  {
    //$slug = $this->getSlug();
    $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($this->getTitle());
    
    $params = array_merge(array(
      'route' => 'view-school',
      'reset' => true,
      
      'id' => $this->school_id,
      'slug' => $slug,
    ), $params);
    $route = $params['route'];
    $reset = $params['reset'];
    unset($params['route']);
    unset($params['reset']);
    return Zend_Controller_Front::getInstance()->getRouter()
      ->assemble($params, $route, $reset);
  }
   public function getTitle()
  {
    return $this->name;
  }
  public function getDescription(){
    return $this->intro;
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
        $result = $this->save();
    
        return $result;     
      }
      public function comments()
      {
        return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('comments', 'core'));
      }
    
      /**
       * Gets a proxy object for the like handler
       *
       * @return Engine_ProxyObject
       **/
      public function likes()
      {
        return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('likes', 'core'));
      }
}