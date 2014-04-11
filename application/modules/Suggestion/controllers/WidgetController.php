<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: WidgetController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Suggestion_WidgetController extends Core_Controller_Action_Standard {

    // Call from "notification page" if loggden user get Blog suggestion.
    public function requestBlogAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $blog_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->blog_object = $blog_object = Engine_Api::_()->getItem('blog', $blog_id);

                // This condition for check entry that entry should not deleted by admin.
                if (count($blog_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    // Call from "notification page" if loggden user get Group suggestion.
    public function requestGroupAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $group_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->group_object = $group_object = Engine_Api::_()->getItem('group', $group_id);
                // This condition for check entry that entry should not deleted by admin.
                if (count($group_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $this->view->sender_id = $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    // Call from "notification page" if loggden user get Event suggestion.
    public function requestEventAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $event_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->event_object = $event_object = Engine_Api::_()->getItem('event', $event_id);
                if (count($event_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $this->view->sender_id = $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    // Call from "notification page" if loggden user get Album suggestion.
    public function requestAlbumAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $album_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->album_object = $album_object = Engine_Api::_()->getItem('album', $album_id);
                if (count($album_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $this->view->sender_id = $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    // Call from "notification page" if loggden user get Classified suggestion.
    public function requestClassAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $classified_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                $this->view->classified_object = $classified_object = Engine_Api::_()->getItem('classified', $classified_id);
                if (count($classified_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    // Call from "notification page" if loggden user get Video suggestion.
    public function requestVideoAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $video_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->video_object = $video_object = Engine_Api::_()->getItem('video', $video_id);
                if (count($video_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    // Call from "notification page" if loggden user get Music suggestion.
    public function requestMusicAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $music_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->music_object = $music_object = Engine_Api::_()->getItem('music_playlist', $music_id);
                if (count($music_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    // Call from "notification page" if loggden user get Photo suggestion.
    public function requestPhotoAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $this->view->photo_object = $picture_object = Engine_Api::_()->getItem('suggestion', $notification->object_id);
                $this->view->sender_id = $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                //$this->view->picture_object = $picture_object = Engine_Api::_()->getItem('picture', $picture_id);
            }
        }
    }

    // Call from "notification page" if loggden user get Friend suggestion.
    public function requestFriendAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $friend_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->friend_object = $friend_object = Engine_Api::_()->getItem('user', $friend_id);
                if (count($friend_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $this->view->sender_id = $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    public function requestAcceptAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $this->_getParam('notification');
        }
    }

    // Call from "notification page" if loggden user get poll suggestion.
    public function requestPollAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $poll_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->poll_object = $poll_object = Engine_Api::_()->getItem('poll', $poll_id);

                // This condition for check entry that entry should not deleted by admin.
                if (count($poll_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

    public function requestForumAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->notification = $notification = $this->_getParam('notification');
            $check_sugg = Engine_Api::_()->getItem('suggestion', $notification->object_id);
            if (!empty($notification) && !empty($check_sugg)) {
                // Fetch the "suggestion_id" from notification table.  	
                $forum_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->entity_id;
                $this->view->forum_object = $forum_object = Engine_Api::_()->getItem('forum_topic', $forum_id);

                // This condition for check entry that entry should not deleted by admin.
                if (count($forum_object) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $notification->object_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    if (!empty($notification->object_id)) {
                        Engine_Api::_()->getItem('suggestion', $notification->object_id)->delete();
                    }
                    $this->view->message = 1;
                } else {
                    $sender_id = Engine_Api::_()->getItem('suggestion', $notification->object_id)->sender_id;
                    $sender_name = Engine_Api::_()->getItem('user', $sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                }
            }
        }
    }

}

?>