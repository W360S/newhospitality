<?php

class Recruiter_Api_Core extends Core_Api_Abstract {

    //get profil company
    public function getProfile($user_id) {
        $table = Engine_Api::_()->getDbtable('recruiters', 'recruiter');
        $row = $table->fetchRow($table->select()->where('user_id = ?', $user_id));
        return $row;
    }

    //add industries
    public function createIndustries($categories = array(), $recruiter_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('reIndustries', 'recruiter')->createRow();
                $row->setFromArray(array("recruiter_id" => $recruiter_id, "industry_id" => intval($item)));
                $row->save();
            }
        }
    }

    //get industry
    public function getIndustries($recruiter_id) {
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $row = $table->fetchAll($table->select()->where('recruiter_id = ?', $recruiter_id));
        return $row;
    }

    public function getIndustryOfProfile($profile_id = null) {
        if ($profile_id) {
            $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
            $select = $table->select()
                    ->where('recruiter_id = ?', $profile_id)
                    ->group("industry_id");
            return $table->fetchAll($select);
        }
    }

    /* profile begin */

    public function updateIndustries($new_industries = array(), $profile_id) {
        // update here
        if (count($new_industries) && $profile_id) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try {
                // delete  old categories
                $this->deleteIndustries($profile_id);
                $db->commit();
                // create new data
                $this->createIndustries($new_industries, $profile_id);
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    public function deleteIndustries($profile_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $where = $table->getAdapter()->quoteInto('recruiter_id = ?', $profile_id);
        $table->delete($where);
    }

    //delete image
    function deleteImages($images) {
        $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
        if (count($images)) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                foreach ($images as $item) {
                    $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($item['file_id'])->current();
                    $storage->delete();
                    @unlink($path . $item['storage_path']);
                }
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    function deleteProfile($profile_id) {
        $profile = Engine_Api::_()->getDbtable('recruiters', 'recruiter')->find($profile_id)->current();
        // Delete photo
        $images = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($profile->photo_id);
        $this->deleteImages($images);



        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        $result = 0;
        try {
            $profile->delete();
            $this->deleteIndustries($profile_id);
            $db->commit();
            $result = 1;
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
        return $result;
    }

    /* profile end */

    //get industries
    public function getAdminIndustries() {
        return Engine_Api::_()->getDbtable('industries', 'recruiter')->fetchAll();
    }

    public function getAdminIndustry($category_id) {
        return Engine_Api::_()->getDbtable('industries', 'recruiter')->find($category_id)->current();
    }

    public function getMeta($type) {
        $fields = Engine_Api::_()->fields()->getFieldsMeta('user');

        foreach ($fields as $field) {
            if ($field['type'] == $type) {
                return $field['field_id'];
            }
        }
    }

    public function getValue($field_id, $user_id) {
        $table = Engine_Api::_()->fields()->getTable('user', 'values');
        $select = $table->select()
                ->where('field_id =?', $field_id)
                ->where('item_id =?', $user_id);
        $value = $table->fetchRow($select);
        if ($value) {
            return $value->value;
        }
    }

    public function getOption($field_id, $option_id) {
        $table = Engine_Api::_()->fields()->getTable('user', 'options');
        $select = $table->select()
                ->where('field_id =?', $field_id)
                ->where('option_id =?', $option_id);
        $value = $table->fetchRow($select);
        if ($value) {
            return $value->label;
        }
    }

    //list danh sách industries
    public function listModuleJobIndustries() {
        return Engine_Api::_()->getDbtable('industries', 'recruiter')->fetchAll();
    }

    //list danh sách các industries mà người dùng đã được gán
    public function listAssignIndustries($user_id, $module) {
        $table = Engine_Api::_()->getDbtable('modules', 'user');
        $select = $table->select()
                ->where('name_module =?', $module)
                ->where('user_id =?', $user_id)
        ;
        $rows = $table->fetchAll($select);
        return $rows;
    }

}
