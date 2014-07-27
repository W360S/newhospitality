<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Storage
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Core.php 9747 2012-07-26 02:08:08Z john $
 * @author     John Boehr <j@webligo.com>
 */

/**
 * @category   Application_Core
 * @package    Storage
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Storage_Api_Core extends Core_Api_Abstract {

    const SPACE_LIMIT_REACHED_CODE = 3999;

    public function getService($serviceIdentity = null) {
        return Engine_Api::_()->getDbtable('services', 'storage')
                        ->getService($serviceIdentity);
    }

    public function get($id, $relationship = null) {
        return Engine_Api::_()->getItemTable('storage_file')
                        ->getFile($id, $relationship);
    }

    public function lookup($id, $relationship) {
        return Engine_Api::_()->getItemTable('storage_file')
                        ->lookupFile($id, $relationship);
    }

    public function create($file, $params) {
        return Engine_Api::_()->getItemTable('storage_file')
                        ->createFile($file, $params);
    }

    public function getStorageLimits() {
        return Engine_Api::_()->getItemTable('storage_file')
                        ->getStorageLimits();
    }

    public function getDefaultService()
    {
        //return 'db';
        return 'local';
    }

    public function secure_create($file, $params) {
        $params = array_merge(array(
            'storage_type' => $this->getDefaultService()
                ), $params);

        $space_limit = (int) Engine_Api::_()->getApi('settings', 'core')->getSetting('core_general_quota', 0);

        $table = Engine_Api::_()->getDbTable('files', 'storage');
        $table_name = $table->info('name');

        // fetch user
        if (!empty($params['user_id']) &&
                null != ($user = Engine_Api::_()->getItem('user', $params['user_id']))) {
            $user_id = $user->getIdentity();
            $level_id = $user->level_id;
        } else if (null != ($user = Engine_Api::_()->user()->getViewer())) {
            $user_id = $user->getIdentity();
            $level_id = $user->level_id;
        } else {
            $user_id = null;
            $level_id = null;
        }

        // member level quota
        if (null !== $user_id && null !== $level_id) {
            $space_limit = (int) Engine_Api::_()->authorization()->getPermission($level_id, 'user', 'quota');
            $space_used = (int) $table->select()
                            ->from($table_name, new Zend_Db_Expr('SUM(size) AS space_used'))
                            ->where("user_id = ?", (int) $user_id)
                            ->query()
                            ->fetchColumn(0);
            $space_required = (is_array($file) && isset($file['tmp_name']) ? filesize($file['tmp_name']) : filesize($file));

            if ($space_limit > 0 && $space_limit < ($space_used + $space_required)) {
                throw new Engine_Exception("File creation failed. You may be over your " .
                "upload limit. Try uploading a smaller file, or delete some files to " .
                "free up space. ", self::SPACE_LIMIT_REACHED_CODE);
            }
        }


        $row = Engine_Api::_()->getDbtable('files', 'storage')->createRow();
        $row->setFromArray($params);
        $row->secure_store($file);

        return $row;
    }

}
