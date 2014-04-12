<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Album
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: PhotoController.php 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */

/**
 * @category   Application_Extensions
 * @package    Album
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Album_UploadController extends Core_Controller_Action_Standard
{
    public function init()
	{
		if( !$this->_helper->requireAuth()->setAuthParams('album', null, 'view')->isValid() ) return;
        // album
        if( !Engine_Api::_()->core()->hasSubject() )
        {
            if(strpos($this->_getParam('subject'),"album") !== false)
            {
                if( 0 !== ($photo_id = (int) $this->_getParam('photo_id')) &&
        		null !== ($photo = Engine_Api::_()->getItem('album_photo', $photo_id)) )
        		{
        			Engine_Api::_()->core()->setSubject($photo);
        		}
        	    else if( 0 !== ($album_id = (int) $this->_getParam('album_id')) &&
        		 null !== ($album = Engine_Api::_()->getItem('album', $album_id)) )
        		 {
        		 Engine_Api::_()->core()->setSubject($album);
        		 }    
            }
            // event
    		else if(strpos($this->_getParam('subject'),"event") !== false)
            {
                if( 0 !== ($photo_id = (int) $this->_getParam('photo_id')) &&
    			null !== ($photo = Engine_Api::_()->getItem('event_photo', $photo_id)) )
    			{
    				Engine_Api::_()->core()->setSubject($photo);
    			}
    
    			else if( 0 !== ($event_id = (int) $this->_getParam('event_id')) &&
    			null !== ($event = Engine_Api::_()->getItem('event', $event_id)) )
    			{
    				Engine_Api::_()->core()->setSubject($event);
    			}
            }
            // group
            else if(strpos($this->_getParam('subject'),"group") !== false)
            {
                if( 0 !== ($photo_id = (int) $this->_getParam('photo_id')) &&
                      null !== ($photo = Engine_Api::_()->getItem('group_photo', $photo_id)) )
                  {
                    Engine_Api::_()->core()->setSubject($photo);
                  }
            
                  else if( 0 !== ($group_id = (int) $this->_getParam('group_id')) &&
                      null !== ($group = Engine_Api::_()->getItem('group', $group_id)) )
                  {
                    Engine_Api::_()->core()->setSubject($group);
                  }
            }
           
        }
	}
	
public function deleteAction()
	{
	    $this->_helper->layout->disableLayout();
        //Zend_Debug::dump($this->_getParam('subject'));exit;
        $this->_helper->viewRenderer->setNoRender();
        if( !$this->_helper->requireAuth()->setAuthParams(null, null, 'delete')->isValid() ) return;
		$viewer = Engine_Api::_()->user()->getViewer();
        if(strpos($this->_getParam('subject'),"album") !== false)
        {
            $photo = Engine_Api::_()->getItem('album_photo', $this->_getParam('photo_id'));                
        }
        // event
		else if(strpos($this->_getParam('subject'),"event") !== false)
        {
            $photo = Engine_Api::_()->getItem('event_photo', $this->_getParam('photo_id'));
        }
        // group
        else if(strpos($this->_getParam('subject'),"group") !== false)
        {
             $photo = Engine_Api::_()->getItem('group_photo', $this->_getParam('photo_id'));
        }  
             
		$db = $photo->getTable()->getAdapter();
		$db->beginTransaction();
		try
		{
		    $photo->delete();
			$db->commit();
		}

		catch( Exception $e )
		{
			$db->rollBack();
			throw $e;
		}
	}
 }