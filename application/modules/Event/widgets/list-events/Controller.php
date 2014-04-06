<?php
class Event_Widget_ListEventsController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
        $arr_events= Engine_Api::_()->getDbtable('events', 'event')->listAllEvents();
        //Zend_Debug::dump(($arr_events), 'ae');exit();
        if(count($arr_events)==0){
            $this->view->event = 0;
        }
        else{
            //Zend_Debug::dump($arr_events, 'arr');
            $this->view->event = 1;
            $this->view->events= $arr_events;
            foreach($arr_events as $event){
                //$file= Engine_Api::_()->getDbtable('files', 'storage')->listPhotoFriends($event->photo_id);
                $file= Engine_Api::_()->getDbtable('files', 'storage')->listPhotoFriends($event->photo_id);
                if(!$file){
                	$arr_photo[$event->user_id]= "application/modules/Core/externals/images/img-47x47.gif";
                }
                else{
                	$arr_photo[$file->file_id]= $file->storage_path;
                }
                //$arr_photo[$file->file_id]= $file->storage_path;
            }
            //Zend_Debug::dump($arr_photo, 'dd');exit();
            $this->view->photos= $arr_photo;
        }
        
    }
    
}