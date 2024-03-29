<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Action.php 10036 2013-03-29 23:59:42Z john $
 * @author     John
 * @todo       documentation
 */

/**
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Activity_Model_Action extends Core_Model_Item_Abstract {

    protected $_searchTriggers = false;

    const ATTACH_IGNORE = 0;
    const ATTACH_NORMAL = 1;
    const ATTACH_MULTI = 2;
    const ATTACH_DESCRIPTION = 3;
    const ATTACH_COLLECTION = 4;

    /**
     * The action subject
     *
     * @var Core_Model_Item_Abstract
     */
    protected $_subject;

    /**
     * The action object
     * 
     * @var Core_Model_Item_Abstract
     */
    protected $_object;

    /**
     * The action attachments
     * 
     * @var mixed
     */
    protected $_attachments;

    /**
     * The action likes
     * 
     * @var mixed
     */
    protected $_likes;

    /**
     * The action comments
     * 
     * @var mixed
     */
    protected $_comments;

    // General

    public function getHref($params = array()) {
        $displayable = $this->getTypeInfo()->displayable;
        if ($displayable & 2) {
            $obj = $this->getObject();
            return !$obj ? null : $obj->getHref(array(
                        'action_id' => $this->getIdentity()
            ));
        } else if ($displayable & 1) {
            $obj = $this->getSubject();
            return !$obj ? null : $obj->getHref(array(
                        'action_id' => $this->getIdentity()
            ));
        } else if ($displayable & 4) {
            return Zend_Controller_Front::getInstance()->getRouter()
                            ->assemble(array('action' => 'home', 'action_id' => $this->getIdentity()), 'user_general', true);
        } else {
            return null;
        }
    }

    /**
     * Gets an item that defines the authorization permissions, usually the item
     * itself
     *
     * @return Core_Model_Item_Abstract
     */
    public function getAuthorizationItem() {
        return $this->getObject();
    }

    public function getParent($recurseType = null) {
        return $this->getObject();
    }

    public function getOwner() {
        return $this->getSubject();
    }

    public function getDescription() {
        return $this->getContent();
    }

    /**
     * Assembles action string
     * 
     * @return string
     */
    public function getContent() {
        $model = Engine_Api::_()->getApi('core', 'activity');
        $params = array_merge(
                $this->toArray(), (array) $this->params, array(
            'subject' => $this->getSubject(),
            'object' => $this->getObject()
                )
        );
        //$content = $model->assemble($this->body, $params);
        $content = $model->assemble($this->getTypeInfo()->body, $params);
        return $content;
    }

    public function VHgetBodyText(){
        $model = Engine_Api::_()->getApi('core', 'activity');
        $params = array_merge(
                $this->toArray(), (array) $this->params, array(
            'subject' => $this->getSubject(),
            'object' => $this->getObject()
                )
        );
        //$content = $model->assemble($this->body, $params);
        $content = $model->get("bodytext",$this->getTypeInfo()->body, $params);
        return $content;
    }
    
    public function VHgetUsername(){
        
    }
    
    public function VHgetDatePost(){
        
    }

    /**
     * Magic to string {@link self::getContent()}
     * @return string
     */
    public function __toString() {
        return $this->getContent();
    }

    /**
     * Get the action subject
     * 
     * @return Core_Model_Item_Abstract
     */
    public function getSubject() {
        if (null === $this->_subject) {
            $this->_subject = Engine_Api::_()->getItem($this->subject_type, $this->subject_id);
        }

        return $this->_subject;
    }

    /**
     * Get the action object
     * 
     * @return Core_Model_Item_Abstract
     */
    public function getObject() {
        if (null === $this->_object) {
            try {
                $this->_object = Engine_Api::_()->getItem($this->object_type, $this->object_id);
            } catch (Exception $e) {
                // silence
            }
        }

        return $this->_object;
    }

    /**
     * Get the type info
     *
     * @return Engine_Db_Table_Row
     */
    public function getTypeInfo() {
        $info = Engine_Api::_()->getDbtable('actionTypes', 'activity')->getActionType($this->type);
        if (!$info) {
            //throw new Exception('Missing Action Type: ' . $this->type);
        }
        return $info;
    }

    /**
     * Get the timestamp
     * 
     * @return integer
     */
    public function getTimeValue() {
        //$current = new Zend_Date($this->date, Zend_Date::ISO_8601);
        //return $current->toValue();
        return strtotime($this->date);
    }

    public function isViewerLike() {
        if ($this->comments()->getLikeCount() <= 0) {
            return false;
        }

        return $this->comments()->isLike(Engine_Api::_()->user()->getViewer());
    }

    // Attachments

    public function attach(Core_Model_Item_Abstract $attachment, $mode = 1) {
        return Engine_Api::_()->getDbtable('actions', 'activity')->attachActivity($this, $attachment, $mode);
    }

    public function getFirstAttachment() {
        list($attachement) = $this->getAttachments();
        return $attachement;
    }

    public function getAttachments() {
        if (null !== $this->_attachments) {
            return $this->_attachments;
        }

        if ($this->attachment_count <= 0) {
            return null;
        }

        $table = Engine_Api::_()->getDbtable('attachments', 'activity');
        $select = $table->select()
                ->where('action_id = ?', $this->action_id);

        $enabledModules = Engine_Api::_()->getDbtable('modules', 'core')->getEnabledModuleNames();

        foreach ($table->fetchAll($select) as $row) {
            // if (in_array($row, $enabledModules)) {
                $item = Engine_Api::_()->getItem($row->type, $row->id);
                if ($item instanceof Core_Model_Item_Abstract) {
                    $val = new stdClass();
                    $val->meta = $row;
                    $val->item = $item;
                    $this->_attachments[] = $val;
                }
            // }else{
                // print_r("not in array()");
            // }
        }

        return $this->_attachments;
    }

    public function getLikes() {
        if (null !== $this->_likes) {
            return $this->_likes;
        }

        return $this->_likes = $this->likes()->getAllLikes();
    }

    public function getComments($commentViewAll) {
        if (null !== $this->_comments) {
            return $this->_comments;
        }

        $comments = $this->comments();
        $table = $comments->getReceiver();
        $comment_count = $comments->getCommentCount();

        if ($comment_count <= 0) {
            return;
        }

        // Always just get the last three comments
        $select = $comments->getCommentSelect();

        if ($comment_count <= 5) {
            $select->limit(5);
        } else if (!$commentViewAll) {
            $select->limit(5, $comment_count - 5);

            //$total = $table->select()->union(array($select, $select2));
            // 'SELECT * from User LIMIT 1 UNION SELECT * from User LIMIT 74,1';      
        }

        return $this->_comments = $table->fetchAll($select);
    }

    public function getCommentsLikes($comments, $viewer) {
        if (empty($comments)) {
            return array();
        }
        if (!is_object($comments[0]) ||
                !method_exists($comments[0], 'likes')) {
            return array();
        }

        $likes = $comments[0]->likes();
        $table = $likes->getReceiver();

        $ids = array();

        foreach ($comments as $c) {
            $ids[] = $c->comment_id;
        }

        $resourceType = null;
        $commentable = $this->getTypeInfo()->commentable;
        switch ($commentable) {
            // Comments linked to action item
            default: case 0: case 1:
                $resourceType = 'activity_comment';
                break;

            // Comments linked to subject
            case 2:
                $resourceType = $this->getSubject()->getType();
                break;

            // Comments linked to object
            case 3:
                $resourceType = $this->getObject()->getType();
                break;

            // Comments linked to the first attachment
            case 4:
                $attachments = $this->getAttachments();
                if (!isset($attachments[0])) {
                    return array();
                }
                return $attachments[0]->item->getType();
                break;
        }

        $select = $table
                ->select()
                ->from($table, 'resource_id')
                ->where('resource_type = ?', $resourceType)
                ->where('resource_id IN (?)', $ids)
                ->where('poster_type = ?', $viewer->getType())
                ->where('poster_id = ?', $viewer->getIdentity());

        $isLiked = array();

        $rs = $table->fetchAll($select);

        foreach ($rs as $r) {
            $isLiked[$r->resource_id] = true;
        }

        return $isLiked;
    }

    public function comments() {
        $commentable = $this->getTypeInfo()->commentable;
        switch ($commentable) {
            // Comments linked to action item
            default: case 0: case 1:
                return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('comments', 'activity'));
                break;

            // Comments linked to subject
            case 2:
                return $this->getSubject()->comments();
                break;

            // Comments linked to object
            case 3:
                return $this->getObject()->comments();
                break;

            // Comments linked to the first attachment
            case 4:
                $attachments = $this->getAttachments();
                if (!isset($attachments[0])) {
                    // We could just link them to the action item instead
                    throw new Activity_Model_Exception('No attachment to link comments to');
                }
                return $attachments[0]->item->comments();
                break;
        }

        throw new Activity_Model_Exception('Comment handler undefined');
    }

    public function likes() {
        $commentable = $this->getTypeInfo()->commentable;
        switch ($commentable) {
            // Comments linked to action item
            default: case 0: case 1:
                return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('likes', 'activity'));
                break;

            // Comments linked to subject
            case 2:
                return $this->getSubject()->likes();
                break;

            // Comments linked to object
            case 3:
                return $this->getObject()->likes();
                break;

            // Comments linked to the first attachment
            case 4:
                $attachments = $this->getAttachments();
                if (!isset($attachments[0])) {
                    // We could just link them to the action item instead
                    throw new Activity_Model_Exception('No attachment to link comments to');
                }
                return $attachments[0]->likes();
                break;
        }

        throw new Activity_Model_Exception('Likes handler undefined');
    }

    public function deleteItem() {
        // delete comments that are not linked items
        if ($this->getTypeInfo()->commentable <= 1) {
            Engine_Api::_()->getDbtable('comments', 'activity')->delete(array(
                'resource_id = ?' => $this->action_id,
            ));

            // delete all "likes"
            Engine_Api::_()->getDbtable('likes', 'activity')->delete(array(
                'resource_id = ?' => $this->action_id,
            ));
            $this->_likes = null;
        }

        // lastly, delete item
        $this->delete();
    }

    protected function _delete() {
        // Delete stream stuff
        Engine_Api::_()->getDbtable('stream', 'activity')->delete(array(
            'action_id = ?' => $this->action_id,
        ));

        // Delete attachments
        Engine_Api::_()->getDbtable('attachments', 'activity')->delete(array(
            'action_id = ?' => $this->action_id,
        ));

        parent::_delete();
    }

}
