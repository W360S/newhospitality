<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Controller.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Event_Widget_UpcomingEventsController extends Engine_Content_Widget_Abstract {

    public function indexAction(){
        $table = Engine_Api::_()->getItemTable('event');
        //Zend_Debug::dump($table->info('name'), 'table');exit();
        $groupTable = Engine_Api::_()->getDbtable('events', 'event');
        $eventTableName = $groupTable->info('name');
        
        $select = $groupTable->select()
                ->from($groupTable->info('name'))
                // ->where("`{$eventTableName}`.`starttime` > FROM_UNIXTIME(?)", time());
                // ->where("`{$eventTableName}`.`starttime` < FROM_UNIXTIME(?)", time() + (86400 * 14))
                ->order("starttime DESC")
                ->order("pinned DESC")
                ->limit(5);

        $result = $select->query()->fetchAll();
        if(count($result)){
            foreach($result as $key => $item){
                $file= Engine_Api::_()->getDbtable('files', 'storage')->listPhotoFriends($item['photo_id']);
                //Zend_debug::dump($file->storage_path); exit;
                if($file){
                    $result[$key]['img_url']= $file->storage_path;
                }
            }
        }
        //Zend_Debug::dump($result);exit();
        $this->view->eventFeture = $result;
    }
    public function indexBakAction() {
        // Don't render this if not logged in
        $viewer = Engine_Api::_()->user()->getViewer();
        $eventTable = Engine_Api::_()->getItemTable('event');
        $eventTableName = $eventTable->info('name');
        $type = $this->_getParam('type');

        // Show nothing
        if ($type == '2' && !$viewer->getIdentity()) {
            //return $this->setNoRender();
        }

        // Show member upcoming events
        else if ($type == '2' || ($type == '0' && $viewer->getIdentity())) {
            $eventMembership = Engine_Api::_()->getDbtable('membership', 'event');
            $select = $eventMembership->getMembershipsOfSelect($viewer);
        }

        // Show all upcoming events
        else {
            $select = $eventTable->select()
                    ->where('search = ?', 1);
        }

        $select
                ->where("`{$eventTableName}`.`starttime` > FROM_UNIXTIME(?)", time())
                ->where("`{$eventTableName}`.`starttime` < FROM_UNIXTIME(?)", time() + (86400 * 14))
                ->order("starttime ASC");

        // Make paginator
        $this->view->paginator = $paginator = Zend_Paginator::factory($select);
        $paginator->setCurrentPageNumber($this->_getParam('page'));

        // Do not render if nothing to show and not viewer
        if ($paginator->getTotalItemCount() <= 0) {
            return $this->setNoRender();
        }
    }

}