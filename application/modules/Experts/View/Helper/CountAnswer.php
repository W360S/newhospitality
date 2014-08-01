<?php 
class Experts_View_Helper_CountAnswer extends Zend_View_Helper_Abstract
{
    public function countAnswer($user_id){
        
        $table = Engine_Api::_()->getDbtable('answers', 'experts');
        $row = $table->fetchAll(
                        $table->select()
                        ->distinct()
                        ->from($table->info('name'))
                        ->where('user_id = ?', $user_id)
                        //->where('question_id =?', $question_id)
                        )
                        ;
        $answers= array();
        if(count($row)){
            foreach($row as $val){
                $answers[$val->question_id]= $val->question_id;
            }
        }
        return count($answers);
    }
}