<?php

class Group_View_Helper_Actions extends Zend_View_Helper_Abstract {

    public function actions() {
        
        $viewer = Engine_Api::_()->user()->getViewer();
        $subject = Engine_Api::_()->core()->getSubject();
        if ($subject->getType() !== 'group') {
            throw new Group_Model_Exception('Whoops, not a group!');
        }
        if (!$viewer->getIdentity()) {
            return false;
        }

        $row = $subject->membership()->getRow($viewer);

        // Not yet associated at all
        if (null === $row) {
            if ($subject->membership()->isResourceApprovalRequired()) {
                return array(
                    'label' => 'Request',
                    'icon' => 'application/modules/Group/externals/images/member/join.png',
                    'class' => 'smoothbox',
                    'route' => 'group_extended',
                    'params' => array(
                        'controller' => 'member',
                        'action' => 'request',
                        'group_id' => $subject->getIdentity(),
                    ),
                );
            } else {
                return array(
                    'label' => 'Join Group',
                    'icon' => 'application/modules/Group/externals/images/member/join.png',
                    'class' => 'smoothbox',
                    'route' => 'group_extended',
                    'params' => array(
                        'controller' => 'member',
                        'action' => 'join',
                        'group_id' => $subject->getIdentity()
                    ),
                );
            }
        }

        // Full member
        // @todo consider owner
        else if ($row->active) {
            if (!$subject->isOwner($viewer)) {
                return array(
                    'label' => 'Leave Group',
                    'icon' => 'application/modules/Group/externals/images/member/leave.png',
                    'class' => 'smoothbox',
                    'route' => 'group_extended',
                    'params' => array(
                        'controller' => 'member',
                        'action' => 'leave',
                        'group_id' => $subject->getIdentity()
                    ),
                );
            } else {
                return array(
                    'label' => 'Delete Group',
                    'icon' => 'application/modules/Group/externals/images/delete.png',
                    //'class' => 'smoothbox',
                    'route' => 'group_specific',
                    'params' => array(
                        'action' => 'delete',
                        'group_id' => $subject->getIdentity()
                    ),
                );
            }
        } else if (!$row->resource_approved && $row->user_approved) {
            return array(
                'label' => 'Cancel Request',
                'icon' => 'application/modules/Group/externals/images/member/cancel.png',
                'class' => 'smoothbox',
                'route' => 'group_extended',
                'params' => array(
                    'controller' => 'member',
                    'action' => 'cancel',
                    'group_id' => $subject->getIdentity()
                ),
            );
        } else if (!$row->user_approved && $row->resource_approved) {
            return array(
                
                    'label' => 'Accept Request',
                    'icon' => 'application/modules/Group/externals/images/member/accept.png',
                    'class' => 'smoothbox',
                    'route' => 'group_extended',
                    'params' => array(
                        'controller' => 'member',
                        'action' => 'accept',
                        'group_id' => $subject->getIdentity()
                    )
               
            );
        } else {
            throw new Group_Model_Exception('Wow, something really strange happened.');
        }


        return false;
    }

}
