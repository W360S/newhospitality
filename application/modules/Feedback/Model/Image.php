<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Image.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_Model_Image extends Core_Model_Item_Collectible
{
  protected $_parent_type = 'feedback_album';

  protected $_owner_type = 'user';

  protected $_collection_type = 'feedback_album';

  public function getHref($params = array())
  { 
    $params = array_merge(array(
      	'route' => 'feedback_image_specific',
      	'reset' => true,
      	'owner_id' => $this->user_id,
      	'image_id' => $this->getIdentity(),
    		'album_id' => $this->collection_id,
    	), $params);
    $route = $params['route'];
    $reset = $params['reset'];
    unset($params['route']);
    unset($params['reset']);
    return Zend_Controller_Front::getInstance()->getRouter()
      ->assemble($params, $route, $reset);
  }

  public function getPhotoUrl($type = null)
  { 
    if( empty($this->file_id) ) {
      return null;
    }

    $file = Engine_Api::_()->getApi('storage', 'storage')->get($this->file_id, $type);
		if( !$file ) {
      return null;
    }

    return $file->map();
  }

  public function getFeedback()
  {
    return Engine_Api::_()->getItem('feedback', $this->feedback_id);
  }

  protected function _postDelete()
  {
    if( $this->_disableHooks ) return;

    try {
    	$file = Engine_Api::_()->getApi('storage', 'storage')->get($this->file_id);
      $file->remove();
      $file = Engine_Api::_()->getApi('storage', 'storage')->get($this->file_id, 'thumb.normal');
      $file->remove();

      $album = $this->getCollection();

      if( (int) $album->image_id == (int) $this->getIdentity() ) {
				$album->image_id = $this->getNextCollectible()->getIdentity();
				$album->save();
      }
    }
    catch( Exception $e )
    {
 
    }
	}
}
?>