<?php

class Experts_Model_DbTable_Recipients extends Engine_Db_Table
{
  protected $_rowClass = 'Experts_Model_Recipient';
  protected $_primary  = 'question_id';
}