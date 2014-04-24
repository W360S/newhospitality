<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    Resumes
 * 
 * @author     huynhnv
 * @status     progress
 */

 /*
 Function get city
 
 */
class Resumes_View_Helper_Level extends Zend_View_Helper_Abstract
{
    
    public function level($level_id){
        //get city
        //Zend_Controller_Action_HelperBroker::addHelper("Level");
        $table = Engine_Api::_()->getDbtable('levels', 'resumes');
        $row = $table->fetchRow($table->select()->where('level_id = ?', $level_id));
        return $row;
    }
}