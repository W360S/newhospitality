<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Controller.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Suggestion_Widget_SuggestionFriendController extends Engine_Content_Widget_Abstract {

    public function indexAction() {
        $this->getElement()->removeDecorator('Title');
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

        if (!empty($suggestion_field_cat) && !empty($user_id)) {
            // Geting number of display suggestion which are set by admin?
            $number_of_sugg = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.friend.wid');
            //Current user Id
            
            
            $this->view->user_id = $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            // The users being currently suggested/displayed in the widget		
            $this->view->suggestion_level_array = $suggestion_combind_path_contacts_array = Engine_Api::_()->suggestion()->suggestion_path($user_id, 4, '', $number_of_sugg);




            // Find out the "Mutual Friends" which friend will display in widget.
            $mutual_friend_array = array();
            if (!empty($suggestion_combind_path_contacts_array)) {
                foreach ($suggestion_combind_path_contacts_array as $sugg_friend_id) {

                    $friendsTable = Engine_Api::_()->getDbtable('membership', 'user');
                    $friendsName = $friendsTable->info('name');
                    //Zend_Debug::dump( $friendsTable);exit;
                    $select = new Zend_Db_Select($friendsTable->getAdapter());
                    $select
                            ->from($friendsName, 'COUNT(' . $friendsName . '.user_id) AS friends_count')
                            ->join($friendsName, "`{$friendsName}`.`user_id`=`{$friendsName}_2`.user_id", null)
                            ->where("`{$friendsName}`.resource_id = ?", $sugg_friend_id) // Id of Loggedin user friend.
                            ->where("`{$friendsName}_2`.resource_id = ?", $user_id) // Loggedin user Id.
                            ->where("`{$friendsName}`.active = ?", 1)
                            ->where("`{$friendsName}_2`.active = ?", 1)
                            ->group($friendsName . '.resource_id');
                    $fetch_mutual_friend = $select->query()->fetchAll();
                    //Zend_Debug::dump($fetch_mutual_friend);exit;
                    if (!empty($fetch_mutual_friend)) {
                        $mutual_friend_array[$sugg_friend_id] = $fetch_mutual_friend[0]['friends_count'];
                    }
                }
                $this->view->mutual_friend_array = $mutual_friend_array;
                // Find the object of suggested user.
                $this->view->path_information = Engine_Api::_()->suggestion()->suggestion_users_information($suggestion_combind_path_contacts_array, '');
            } else {
                return $this->setNoRender();
            }
        } else {
            return $this->setNoRender();
        }
    }

}
