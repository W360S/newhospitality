<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    Recruiter
 * 
 * @author     huynhnv
 * @status     progress
 */

 /*
 Function get city
 
 */
class Recruiter_View_Helper_Type extends Zend_View_Helper_Abstract
{
    public function type($type_id){
        //get type
        //Zend_Debug::dump($type_id);exit;
        $table = Engine_Api::_()->getDbtable('types', 'recruiter');
        $row = $table->fetchRow($table->select()->where('type_id = ?', $type_id));
        
        return $row;
    }
}