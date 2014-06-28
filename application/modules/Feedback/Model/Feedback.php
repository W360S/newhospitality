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
class Feedback_Model_Feedback extends Core_Model_Item_Abstract
{
  protected $_owner_type = 'user';
  
  protected $_parent_type = 'user';

  protected $_searchColumns = array('feedback_title', 'feedback_description');

  protected $_parent_is_owner = true;

  public function getHref($params = array())
  { 
    $slug = trim(preg_replace('/-+/', '-', preg_replace('/[^a-z0-9-]+/i', '-', strtolower($this->getTitle()))), '-');
    
    $params = array_merge(array(
      'route' => 'feedback_detail_view',
      'reset' => true,
      'user_id' => $this->owner_id,
      'feedback_id' => $this->feedback_id,
      'slug' => $slug,
    ), $params);
    $route = $params['route'];
    $reset = $params['reset'];
    unset($params['route']);
    unset($params['reset']);
    return Zend_Controller_Front::getInstance()->getRouter()
      ->assemble($params, $route, $reset);
  }
  
	// RETURN FEEDBACK TITLE
  public function getTitle()
  {
    return $this->feedback_title;
  }

	//RETURN TRUNCATE FEEDBACK TITLE (5 ALPHANUMERICS)
  public function truncate5Title()
  {
    $tmpBody = strip_tags($this->feedback_title);
    return ( Engine_String::strlen($tmpBody) > 5 ? Engine_String::substr($tmpBody, 0, 5) . '..' : $tmpBody );
  }
  
	//RETURN TRUNCATE FEEDBACK TITLE (60 ALPHANUMERICS)
  public function truncate70Title()
  {
    $tmpBody = strip_tags($this->feedback_title);
    return ( Engine_String::strlen($tmpBody) > 70 ? Engine_String::substr($tmpBody, 0, 70) . '..' : $tmpBody );
  }
  
	//RETURN TRUNCATE FEEDBACK TITLE (20 ALPHANUMERICS)
  public function truncate20Title()
  {
    $tmpBody = strip_tags($this->feedback_title);
    return ( Engine_String::strlen($tmpBody) > 20 ? Engine_String::substr($tmpBody, 0, 20) . '..' : $tmpBody );
  }
  
	//RETURN TRUNCATE FEEDBACK STATUS COMMENT (160 ALPHANUMERICS)
  public function getStatusComment()
  {
    $tmpBody = strip_tags($this->status_body);
    return ( Engine_String::strlen($tmpBody) > 180 ? Engine_String::substr($tmpBody, 0, 180) . '..' : $tmpBody );
  }
  
  
	//RETURN TRUNCATE FEEDBACK OWNER NAME
  public function truncateOwner($owner_name) 
  { 
    $tmpBody = strip_tags($owner_name);
    return ( Engine_String::strlen($tmpBody) > 9 ? Engine_String::substr($tmpBody, 0, 9) . '..' : $tmpBody );
  }
  
	//RETURN TRUNCATE FEEDBACK CREATION DATE
  public function truncateDate()
  {
    $tmpBody = strip_tags($this->creation_date);
    return ( Engine_String::strlen($tmpBody) > 10 ? Engine_String::substr($tmpBody, 0, 10) . '' : $tmpBody );
  }
  
  // RETURN FEEDBACK DESCRIPTION
  public function getDescription()
  {
    $tmpBody = strip_tags($this->feedback_description);
    return ( Engine_String::strlen($tmpBody) > 255 ? Engine_String::substr($tmpBody, 0, 255) . '..' : $tmpBody );
  }
  
  public function comments()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('comments', 'core'));
  }
  
  
  public function likes()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('likes', 'core'));
  }

  public function getSingletonAlbum()
  {
    $table = Engine_Api::_()->getItemTable('feedback_album');
    $select = $table->select()
      				->where('feedback_id = ?', $this->getIdentity())
      				->order('album_id ASC')
      				->limit(1);

    $album = $table->fetchRow($select);

    if( null === $album ) {
      $album = $table->createRow();
      $album->setFromArray(array(
        'title' => $this->getTitle(),
        'feedback_id' => $this->getIdentity()
      ));
      $album->save();
    }

    return $album;
  }
  
}
?>