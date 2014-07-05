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
class Feedback_Api_Core extends Core_Api_Abstract {

    const IMAGE_WIDTH = 720;
    const IMAGE_HEIGHT = 720;
    const THUMB_WIDTH = 140;
    const THUMB_HEIGHT = 160;

    /**
     * Get feedback detail
     * @param int $feedback_id : feedback id
     * @return  array containing feedback detail
     */
    public function getFeedback($feedback_id) {
        $table = Engine_Api::_()->getDbtable('feedbacks', 'feedback');
        $select = $table->select()
                ->where('feedback_id = ?', $feedback_id)
                ->limit(1);
        return $table->fetchRow($select);
    }

    /**
     * Delete feedback from database
     * @param int $feedback_id : feedback id
     */
    public function deleteFeedback($feedback_id) {
        // first, delete activity feed and its comments/likes
        Engine_Api::_()->getItem('feedback', $feedback_id)->delete();
    }

    /**
     * Get feedback detail
     * @param array $params : contain desirable feedback info
     * @return  object of feedback
     */
    public function getFeedbacksPaginator($params = array()) {
        $paginator = Zend_Paginator::factory($this->getFeedbacksSelect($params));
        if (!empty($params['page'])) {
            $paginator->setCurrentPageNumber($params['page']);
        }
        if (!empty($params['limit'])) {
            $paginator->setItemCountPerPage($params['limit']);
        }
        return $paginator;
    }

    /**
     * Get feedback 
     * @param array $params : contain desirable feedback info
     * @return  array of feedback
     */
    public function getFeedbacksSelect($params = array()) {
        $table = Engine_Api::_()->getDbtable('feedbacks', 'feedback');
        $rName = $table->info('name');

        if (!empty($params['can_vote'])) {
            $voteTable = Engine_Api::_()->getItemTable('vote')->info('name');
            $viewer_id = $params['viewer_id'];
            $select = $table->select()
                    ->setIntegrityCheck(false)
                    ->from($rName)
                    ->joinLeft($voteTable, "$rName.feedback_id = $voteTable.feedback_id  AND $voteTable.voter_id = $viewer_id ", 'vote_id');
        }

        if (!empty($params['can_vote'])) {
            $select->order(!empty($params['orderby']) ? $params['orderby'] . ' DESC' : 'creation_date DESC' );
        } else {
            $select = $table->select()->order(!empty($params['orderby']) ? $params['orderby'] . ' DESC' : 'creation_date DESC' );
        }

        if (!empty($params['feedback_private'])) {
            $select->where($rName . '.feedback_private = ?', 'public');
        }

        if (!empty($params['user_id']) && is_numeric($params['user_id'])) {
            $select->where($rName . '.owner_id = ?', $params['user_id']);
        }

        if (!empty($params['user']) && $params['user'] instanceof User_Model_User) {
            $select->where($rName . '.owner_id = ?', $params['user_id']->getIdentity());
        }

        if (!empty($params['users'])) {
            $str = (string) ( is_array($params['users']) ? "'" . join("', '", $params['users']) . "'" : $params['users'] );
            $select->where($rName . '.owner_id in (?)', new Zend_Db_Expr($str));
        }

        if (!empty($params['category'])) {
            $select->where($rName . '.category_id = ?', $params['category']);
        }

        if (!empty($params['stat'])) {
            $select->where($rName . '.stat_id = ?', $params['stat']);
        }

        if (!empty($params['search'])) {
            $select->where($rName . ".feedback_title LIKE ? OR " . $rName . ".feedback_description LIKE ?", '%' . $params['search'] . '%');
        }

        if (!empty($params['visible'])) {
            $select->where($rName . ".search = ?", $params['visible']);
        }

        return $select;
    }

    //FETCH ALL AVAILABLE CATEGORY FROM DATABASE
    public function getCategories() {
        return Engine_Api::_()->getDbtable('categories', 'feedback')->fetchAll();
    }

    //FETCH ALL AVAILABLE IPs FROM DATABASE
    public function getBlockips() {
        return Engine_Api::_()->getDbtable('blockips', 'feedback')->fetchAll();
    }

    //FETCH ALL AVAILABLE SEVERITY FROM DATABASE
    public function getSeverities() {
        return Engine_Api::_()->getDbtable('severities', 'feedback')->fetchAll();
    }

    //FETCH ALL AVAILABLE STATUS FROM DATABASE
    public function getStatus() {
        return Engine_Api::_()->getDbtable('status', 'feedback')->fetchAll();
    }

    /**
     * Get category
     * @param int $category_id : category id
     * @return category text
     */
    public function getCategory($category_id) {
        return Engine_Api::_()->getDbtable('categories', 'feedback')->find($category_id)->current();
    }

    /**
     * Get ip
     * @param int $blockip_id : blockip id
     * @return blockip text
     */
    public function getBlockip($blockip_id) {
        $blockip = new Feedback_Model_Blockip($blockip_id);
        return $blockip;
    }

    /**
     * Get severity
     * @param int $severity_id : severity id
     * @return severity text
     */
    public function getSeverity($severity_id) {
        return Engine_Api::_()->getDbtable('severities', 'feedback')->find($severity_id)->current();
    }

    /**
     * Get status
     * @param int $stat_id : stat id
     * @return status text
     */
    public function getStat($stat_id) {
        return Engine_Api::_()->getDbtable('status', 'feedback')->find($stat_id)->current();
    }

    /**
     * Add new category
     * @param int $value : new category value
     */
    public function addCategory($value) {
        Engine_Api::_()->getDbtable('categories', 'feedback')
                ->delete(array(
                    'user_id = ?' => $this->getIdentity(),
                    'blocked_user_id = ?' => $user->getIdentity()
        ));
        return $this;
    }

    /**
     * Add new ip
     * @param int $value : new ip
     */
    public function addBlockip($value) {
        Engine_Api::_()->getDbtable('blockips', 'feedback')
                ->delete(array(
                    'user_id = ?' => $this->getIdentity(),
                    'blocked_user_id = ?' => $user->getIdentity()
        ));
        return $this;
    }

    /**
     * Check License key
     * @param int $key : license key
     * @param string $type : feedback
     * @return  string
     */
    public function feedback_lsettings($key, $type) {
        // Nulled by SocialEngineForum.com
        $session = new Zend_Session_Namespace();
        $session->temp_globalsettings = 1;
        return false;
        // Nulled by SocialEngineForum.com
    }

    /**
     * Add new severity
     * @param int $value : new severity value
     */
    public function addSeverity($value) {
        Engine_Api::_()->getDbtable('severities', 'feedback')
                ->delete(array(
                    'user_id = ?' => $this->getIdentity(),
                    'blocked_user_id = ?' => $user->getIdentity()
        ));
        return $this;
    }

    /**
     * Add new status
     * @param int $value : new stat value
     */
    public function addStat($value) {
        Engine_Api::_()->getDbtable('status', 'feedback')
                ->delete(array(
                    'user_id = ?' => $this->getIdentity(),
                    'blocked_user_id = ?' => $user->getIdentity()
        ));
        return $this;
    }

    public function createImage($params, $file) {
        if ($file instanceof Storage_Model_File) {
            $params['file_id'] = $file->getIdentity();
        } else {
            // Get image info and resize
            $name = basename($file['tmp_name']);
            $path = dirname($file['tmp_name']);
            $extension = ltrim(strrchr($file['name'], '.'), '.');

            $mainName = $path . '/m_' . $name . '.' . $extension;
            $thumbName = $path . '/t_' . $name . '.' . $extension;

            $image = Engine_Image::factory();
            $image->open($file['tmp_name'])
                    ->resize(self::IMAGE_WIDTH, self::IMAGE_HEIGHT)
                    ->write($mainName)
                    ->destroy();

            $image = Engine_Image::factory();
            $image->open($file['tmp_name'])
                    ->resize(self::THUMB_WIDTH, self::THUMB_HEIGHT)
                    ->write($thumbName)
                    ->destroy();

            $image_params = array(
                'parent_id' => $params['feedback_id'],
                'parent_type' => 'feedback',
            );

            $imageFile = Engine_Api::_()->storage()->create($mainName, $image_params);
            $thumbFile = Engine_Api::_()->storage()->create($thumbName, $image_params);
            $imageFile->bridge($thumbFile, 'thumb.normal');

            $params['file_id'] = $imageFile->file_id;
            $params['image_id'] = $imageFile->file_id;
        }

        $row = Engine_Api::_()->getDbtable('images', 'feedback')->createRow();
        $row->setFromArray($params);
        $row->save();
        return $row;
    }

}

?>
