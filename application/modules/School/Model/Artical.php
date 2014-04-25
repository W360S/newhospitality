<?php
class School_Model_Artical extends Core_Model_Item_Abstract {
    public function getHref($params = array())
    {
        //$slug = $this->getSlug();
        $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($this->getTitle());
        
        $params = array_merge(array(
          'route' => 'view-school-artical',
          'reset' => true,
          
          'id' => $this->artical_id,
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
    return $this->title;
  }
  public function getTitleParent(){
    $article= Engine_Api::_()->getItem('school_artical', $this->artical_id);
    $school= Engine_Api::_()->getItem('school_school', $article->school_id);
    return $school->name;
  }
  public function getDescription(){
    $body= substr(strip_tags($this->content), 0, 255); 
    if (strlen($this->content)>254){
        $body .= "..."; 
    }
    return $body;
  }
  
}