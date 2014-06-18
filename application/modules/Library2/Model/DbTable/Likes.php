<?php

class Library_Model_DbTable_Likes extends Engine_Db_Table
{
  protected $_rowClass = "Library_Model_Like";
  protected $_primary  = 'like_id';
}