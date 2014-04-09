<?php

class Library_Model_DbTable_Ratings extends Engine_Db_Table
{
  protected $_rowClass = "Library_Model_Rating";
  protected $_primary  = 'book_id';

}