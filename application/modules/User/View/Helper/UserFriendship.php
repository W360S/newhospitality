<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: UserFriendship.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class User_View_Helper_UserFriendship extends Zend_View_Helper_Abstract {

    public function userFriendship($user, $viewer = null, $class = null) {
        if (null === $viewer) {
            $viewer = Engine_Api::_()->user()->getViewer();
        }

        if (!$viewer || !$viewer->getIdentity() || $user->isSelf($viewer)) {
            return '';
        }

        $direction = (int) Engine_Api::_()->getApi('settings', 'core')->getSetting('user.friends.direction', 1);

        // Get data
        if (!$direction) {
            $row = $user->membership()->getRow($viewer);
        } else
            $row = $viewer->membership()->getRow($user);

        // Render
        // Check if friendship is allowed in the network
        $eligible = (int) Engine_Api::_()->getApi('settings', 'core')->getSetting('user.friends.eligible', 2);
        if ($eligible == 0) {
            return '';
        }

        // check admin level setting if you can befriend people in your network
        else if ($eligible == 1) {

            $networkMembershipTable = Engine_Api::_()->getDbtable('membership', 'network');
            $networkMembershipName = $networkMembershipTable->info('name');

            $select = new Zend_Db_Select($networkMembershipTable->getAdapter());
            $select
                    ->from($networkMembershipName, 'user_id')
                    ->join($networkMembershipName, "`{$networkMembershipName}`.`resource_id`=`{$networkMembershipName}_2`.resource_id", null)
                    ->where("`{$networkMembershipName}`.user_id = ?", $viewer->getIdentity())
                    ->where("`{$networkMembershipName}_2`.user_id = ?", $user->getIdentity())
            ;

            $data = $select->query()->fetch();

            if (empty($data)) {
                return '';
            }
        }

        if (!$direction) {
            // one-way mode
            if (null === $row) {
                return $this->view->htmlLink(array('route' => 'user_extended', 'controller' => 'friends', 'action' => 'add', 'user_id' => $user->user_id), $this->view->translate('Follow'), array(
                            'class' => 'buttonlink smoothbox icon_friend_add pt-link-add' . $class
                ));
            } else if ($row->resource_approved == 0) {
                return $this->view->htmlLink(array('route' => 'user_extended', 'controller' => 'friends', 'action' => 'cancel', 'user_id' => $user->user_id), $this->view->translate('Cancel Follow Request'), array(
                            'class' => 'buttonlink smoothbox icon_friend_cancel pt-link-add' . $class
                ));
            } else {
                return $this->view->htmlLink(array('route' => 'user_extended', 'controller' => 'friends', 'action' => 'remove', 'user_id' => $user->user_id), $this->view->translate('Unfollow'), array(
                            'class' => 'buttonlink smoothbox icon_friend_remove pt-link-add' . $class
                ));
            }
        } else {
            // two-way mode
            if (null === $row) {
                return $this->view->htmlLink(array('route' => 'user_extended', 'controller' => 'friends', 'action' => 'add', 'user_id' => $user->user_id), $this->view->translate('Add Friend'), array(
                            'class' => 'buttonlink icon_friend_add  pt-link-add'. $class,
                            //'onclick'=>'javascript:openUrl($(this));return false;'
                            'onclick' => 'javascript:sendAjaxAddfriend(' . $user->user_id . ',true,this);return false;'
                ));
            } else if ($row->user_approved == 0) {
                return $this->view->htmlLink(array('route' => 'user_extended', 'controller' => 'friends', 'action' => 'cancel', 'user_id' => $user->user_id), $this->view->translate('Cancel'), array(
                            'class' => 'buttonlink smoothbox icon_friend_cancel pt-link-add' . $class
                ));
            } else if ($row->resource_approved == 0) {
                return $this->view->htmlLink(array('route' => 'user_extended', 'controller' => 'friends', 'action' => 'confirm', 'user_id' => $user->user_id), $this->view->translate('Accept'), array(
                            'class' => 'buttonlink smoothbox icon_friend_add pt-link-add' . $class
                ));
            } else if ($row->active) {
                return $this->view->htmlLink(array('route' => 'user_extended', 'controller' => 'friends', 'action' => 'remove', 'user_id' => $user->user_id), $this->view->translate('Remove'), array(
                            'class' => 'buttonlink smoothbox icon_friend_remove pt-link-add' . $class
                ));
            }
        }

        return '';
    }

}
