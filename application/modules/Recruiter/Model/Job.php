<?php
class Recruiter_Model_Job extends Core_Model_Item_Abstract {
    
    public function getHref($params = array())
  {
    $slug = $this->getSlug();
    
    $params = array_merge(array(
      'route' => 'view-job',
      'reset' => true,
      
      'id' => $this->job_id,
      'slug' => $slug,
    ), $params);
    $route = $params['route'];
    $reset = $params['reset'];
    unset($params['route']);
    unset($params['reset']);
    return Zend_Controller_Front::getInstance()->getRouter()
      ->assemble($params, $route, $reset);
  }
   public function getTitle()
  {
    return $this->position;
  }
  public function getTitleParent(){
    $job= Engine_Api::_()->getItem('recruiter_job', $this->job_id);
    $table= Engine_Api::_()->getDbtable('recruiters', 'recruiter');
    $recruiter= $table->fetchRow($table->select()->where('user_id = ?', $job->user_id));
    //Zend_Debug::dump($recruiter);exit;
    return $recruiter->company_name;
  }
}
