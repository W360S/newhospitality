<?php

class Resumes_Model_Resume extends Core_Model_Item_Abstract {
    public function getUser(){
        $user_id = $this->user_id;
        
        return Engine_Api::_()->getItem('user', $user_id);
    }

    public function getHref($params = array()) {
        $slug = $this->getSlug();

        $params = array_merge(array(
            'route' => 'view-resume',
            'reset' => true,
            'id' => $this->resume_id,
            // 'slug' => $slug,
                ), $params);
        $route = $params['route'];
        $reset = $params['reset'];
        unset($params['route']);
        unset($params['reset']);
        // return Zend_Controller_Front::getInstance()->getRouter()
        //                 ->assemble($params, $route, $reset);
        return Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                            'module' => 'resumes',
                            'controller' => 'resume',
                            'action' => 'view',
                            'resume_id' => $this->resume_id
                                ), 'default');
    }
}
