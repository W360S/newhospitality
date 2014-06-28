<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Core.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_Plugin_Core {

    public function onUserDeleteBefore($event) {
        $payload = $event->getPayload();

        if ($payload instanceof User_Model_User) {
            // Delete feedback
            $feedbackTable = Engine_Api::_()->getDbtable('feedbacks', 'feedback');
            $feedbackSelect = $feedbackTable->select()->where('owner_id = ?', $payload->getIdentity());
            foreach ($feedbackTable->fetchAll($feedbackSelect) as $feedback) {
                $feedback_id = $feedback->feedback_id;

                //DELETE VOTES 
                $table = Engine_Api::_()->getItemTable('vote');
                $select = $table->select()
                        ->from($table->info('name'), 'vote_id')
                        ->where('feedback_id = ?', $feedback_id);
                $rows = $table->fetchAll($select)->toArray();
                if (!empty($rows)) {
                    $vote_id = $rows[0]['vote_id'];
                    $vote = Engine_Api::_()->getItem('vote', $vote_id);
                    $vote->delete();
                }

                //DELETE IMAGE 
                $table = Engine_Api::_()->getItemTable('feedback_image');
                $select = $table->select()
                        ->from($table->info('name'), 'image_id')
                        ->where('feedback_id = ?', $feedback_id);
                $rows = $table->fetchAll($select)->toArray();
                if (!empty($rows)) {
                    foreach ($rows as $key => $image_ids) {
                        $image_id = $image_ids['image_id'];
                        $image = Engine_Api::_()->getItem('feedback_image', $image_id);
                        $image->delete();
                    }
                }

                //DELETE ALBUM 
                $table = Engine_Api::_()->getItemTable('feedback_album');
                $select = $table->select()
                        ->from($table->info('name'), 'album_id')
                        ->where('feedback_id = ?', $feedback_id);
                $rows = $table->fetchAll($select)->toArray();
                if (!empty($rows)) {
                    $album_id = $rows[0]['album_id'];
                    $album = Engine_Api::_()->getItem('feedback_album', $album_id);
                    $album->delete();
                }

                //DELETE blockuser
                $table = Engine_Api::_()->getItemTable('blockuser');
                $select = $table->select()
                        ->from($table->info('name'), 'blockuser_id')
                        ->where('blockuser_id = ?', $payload->getIdentity());
                $rows = $table->fetchAll($select)->toArray();
                if (!empty($rows)) {
                    $blockuser_id = $rows[0]['blockuser_id'];
                    $blockuser = Engine_Api::_()->getItem('blockuser', $blockuser_id);
                    $blockuser->delete();
                }

                $feedback->delete();
            }
        }
    }

    public function onRenderLayoutDefault($event) {
        //$feedbackbutton_visible = Engine_Api::_()->getApi('settings', 'core')->feedbackbutton_visible;
        $feedbackbutton_visible = 1;
        if ($feedbackbutton_visible == 1) {
            $button_color1 = Engine_Api::_()->getApi('settings', 'core')->feedback_button_color1;
            $button_color1 = !empty($button_color1) ? $button_color1 : '#0267cc';
            $button_color2 = Engine_Api::_()->getApi('settings', 'core')->feedback_button_color2;
            $button_color2 = !empty($button_color2) ? $button_color2 : '#ff0000';
            $button_position = Engine_Api::_()->getApi('settings', 'core')->feedback_button_position;
            $view = $event->getPayload();
            $stylecolor = sprintf('%s', $button_color1);
            $mouseovercolor = sprintf('%s', $button_color2);

            switch ($button_position) {
                case 0:
                    $classname = sprintf('%s', 'smoothbox feedback-button');
                    break;
                case 1:
                default:
                    $classname = sprintf('%s', 'smoothbox feedback-button-left');
                    break;
            }

            $base_url_feedback = Zend_Controller_Front::getInstance()->getBaseUrl();
            $base_url_feedback = sprintf('%s', $base_url_feedback);

            if ($view instanceof Zend_View) {
                $script = <<<EOF
      
  var feedbackHandler;
  en4.core.runonce.add(function() {
    try {
      feedbackHandler = new FeedbackHandler({
        'baseUrl' : '{$base_url_feedback}',
        'enableFeedback' : true,
        'stylecolor' : '{$stylecolor}',
        'mouseovercolor' : '{$mouseovercolor}',
        'classname' : '{$classname}'
      });

        feedbackHandler.start();
      window._feedbackHandler = feedbackHandler;
    } catch( e ) {
      //if( \$type(console) ) console.log(e);
    }
  });
EOF;

                $view->headScript()
                        ->appendFile('application/modules/Feedback/externals/scripts/core_feedbackbutton.js')
                        ->appendScript($script);
            }
        }
    }

}

?>
