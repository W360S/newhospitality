<?php

class Resumes_Model_Resume extends Core_Model_Item_Abstract {
    public function getUser(){
        $user_id = $this->user_id;
        
        return Engine_Api::_()->getItem('user', $user_id);
    }
}
