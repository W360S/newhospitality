<?php

class Experts_Model_DbTable_Ratings extends Engine_Db_Table
{
  protected $_rowClass = "Experts_Model_Rating";
  protected $_primary  = 'question_id';
}