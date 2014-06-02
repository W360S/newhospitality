<?php

class Statistics_Api_Core extends Core_Api_Abstract
{
  // Select


  /**
   * Gets a paginator for blogs
   *
   * @param Core_Model_Item_Abstract $user The user to get the messages for
   * @return Zend_Paginator
   */
  public function getStatisticsPaginator()
  {
    $paginator = Zend_Paginator::factory($this->getStatisticsList());
   
    return $paginator;
  }

  
  function getStatisticsList()
  {
    $table = Engine_Api::_()->getDbtable('statistics', 'statistics');
    $rName = $table->info('name');

    $select = $table->select()
      //->setIntegrityCheck(false)
      ->from($rName);

    return $select;
  }
  
  public function getItem($id){
    return Engine_Api::_()->getDbtable('statistics', 'statistics')->find($id)->current();
  }
  
  public function getStatisticsPage($alias=null)
  {
    if($alias){
        $statistics_table = Engine_Api::_()->getDbtable('statistics', 'statistics');
        $statistics_select = $statistics_table->select()
        ->where('alias = ?', $alias);          // If post exists
        return $statistics_table->fetchRow($statistics_select);
    } else {
        return "";
    }
  }
  
  
  public function getContactsPaginator()
  {
    $paginator = Zend_Paginator::factory($this->getContactsList());
   
    return $paginator;
  }

  
  function getContactsList()
  {
    $table = Engine_Api::_()->getDbtable('contacts', 'statistics');
    $rName = $table->info('name');

    $select = $table->select()
      //->setIntegrityCheck(false)
      ->from($rName);

    return $select;
  }
  
  
  
}