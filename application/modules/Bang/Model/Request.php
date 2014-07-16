<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Feedback.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Bang_Model_Request extends Core_Model_Item_Abstract {

    protected $_owner_type = 'user';
    protected $_parent_type = 'user';
    // protected $_searchColumns = array('feedback_title', 'feedback_description');
    protected $_parent_is_owner = true;

    public function truncate5Title() {
        $tmpBody = strip_tags($this->ad_title);
        return ( Engine_String::strlen($tmpBody) > 5 ? Engine_String::substr($tmpBody, 0, 5) . '..' : $tmpBody );
    }

    public function truncateOwner($owner_name) {
        $tmpBody = strip_tags($owner_name);
        return ( Engine_String::strlen($tmpBody) > 9 ? Engine_String::substr($tmpBody, 0, 9) . '..' : $tmpBody );
    }
    
    public function setPhoto($photo) {
        if ($photo instanceof Zend_Form_Element_File) {
            $file = $photo->getFileName();
        } else if (is_array($photo) && !empty($photo['tmp_name'])) {
            $file = $photo['tmp_name'];
        } else if (is_string($photo) && file_exists($photo)) {
            $file = $photo;
        } else {
            throw new Group_Model_Exception('invalid argument passed to setPhoto');
        }

        $name = basename($file);
        $path = APPLICATION_PATH . DIRECTORY_SEPARATOR . 'temporary';
        $params = array(
            'parent_type' => 'request',
            'parent_id' => $this->getIdentity()
        );

        // Save
        $storage = Engine_Api::_()->storage();

        // Resize image (main)
        $image = Engine_Image::factory();
        $image->open($file)
                ->resize(720, 720)
                ->write($path . '/m_' . $name)
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
                ->write($path . '/in_' . $name)
                ->destroy();

        // Resize image (icon)
        $image = Engine_Image::factory();
        $image->open($file);

        $size = min($image->height, $image->width);
        $x = ($image->width - $size) / 2;
        $y = ($image->height - $size) / 2;

        $image->resample($x, $y, $size, $size, 48, 48)
                ->write($path . '/is_' . $name)
                ->destroy();

        // Store
        $iMain = $storage->create($path . '/m_' . $name, $params);
        $iProfile = $storage->create($path . '/p_' . $name, $params);
        $iIconNormal = $storage->create($path . '/in_' . $name, $params);
        $iSquare = $storage->create($path . '/is_' . $name, $params);

        $iMain->bridge($iProfile, 'thumb.profile');
        $iMain->bridge($iIconNormal, 'thumb.normal');
        $iMain->bridge($iSquare, 'thumb.icon');

        // Remove temp files
        @unlink($path . '/p_' . $name);
        @unlink($path . '/m_' . $name);
        @unlink($path . '/in_' . $name);
        @unlink($path . '/is_' . $name);

        // Update row
        $this->photo_id = $iMain->file_id;
        $this->save();

        return $this;
    }

}

?>