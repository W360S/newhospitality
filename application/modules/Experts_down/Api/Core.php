<?php

/**
 * Experts_Api_Core
 * 
 * @package viethospitality
 * @author admin
 * @copyright 2010
 * @version $Id$
 * @access public
 */
/**
 * Experts_Api_Core
 * 
 * @package viethospitality
 * @author admin
 * @copyright 2010
 * @version $Id$
 * @access public
 */
class Experts_Api_Core extends Core_Api_Abstract
{
    static $title_tags = array(
        
    );
    
    static $content_tags = array(
        
    );

	function truncate($text, $length = 100, $ending = '...', $exact = true, $considerHtml = false) {
        if (is_array($ending)) {
            extract($ending);
        }
        if ($considerHtml) {
            if (mb_strlen(preg_replace('/<.*?>/', '', $text)) <= $length) {
                return $text;
            }
            $totalLength = mb_strlen($ending);
            $openTags = array();
            $truncate = '';
            preg_match_all('/(<\/?([\w+]+)[^>]*>)?([^<>]*)/', $text, $tags, PREG_SET_ORDER);
            foreach ($tags as $tag) {
                if (!preg_match('/img|br|input|hr|area|base|basefont|col|frame|isindex|link|meta|param/s', $tag[2])) {
                    if (preg_match('/<[\w]+[^>]*>/s', $tag[0])) {
                        array_unshift($openTags, $tag[2]);
                    } else if (preg_match('/<\/([\w]+)[^>]*>/s', $tag[0], $closeTag)) {
                        $pos = array_search($closeTag[1], $openTags);
                        if ($pos !== false) {
                            array_splice($openTags, $pos, 1);
                        }
                    }
                }
                $truncate .= $tag[1];

                $contentLength = mb_strlen(preg_replace('/&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};/i', ' ', $tag[3]));
                if ($contentLength + $totalLength > $length) {
                    $left = $length - $totalLength;
                    $entitiesLength = 0;
                    if (preg_match_all('/&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};/i', $tag[3], $entities, PREG_OFFSET_CAPTURE)) {
                        foreach ($entities[0] as $entity) {
                            if ($entity[1] + 1 - $entitiesLength <= $left) {
                                $left--;
                                $entitiesLength += mb_strlen($entity[0]);
                            } else {
                                break;
                            }
                        }
                    }

                    $truncate .= mb_substr($tag[3], 0, $left + $entitiesLength);
                    break;
                } else {
                    $truncate .= $tag[3];
                    $totalLength += $contentLength;
                }
                if ($totalLength >= $length) {
                    break;
                }
            }
        } else {
            if (mb_strlen($text) <= $length) {
                return $text;
            } else {
                $truncate = mb_substr($text, 0, $length - strlen($ending));
            }
        }
        if (!$exact) {
            $spacepos = mb_strrpos($truncate, ' ');
            if (isset($spacepos)) {
                if ($considerHtml) {
                    $bits = mb_substr($truncate, $spacepos);
                    preg_match_all('/<\/([a-z]+)>/', $bits, $droppedTags, PREG_SET_ORDER);
                    if (!empty($droppedTags)) {
                        foreach ($droppedTags as $closingTag) {
                            if (!in_array($closingTag[1], $openTags)) {
                                array_unshift($openTags, $closingTag[1]);
                            }
                        }
                    }
                }
                $truncate = mb_substr($truncate, 0, $spacepos);
            }
        }

        $truncate .= $ending;

        if ($considerHtml) {
            foreach ($openTags as $tag) {
                $truncate .= '</' . $tag . '>';
            }
        }

        return $truncate;
    }
    
    public function cleanTitle($html)
    {
        $chain = new Zend_Filter();
        $chain->addFilter(new Zend_Filter_StripTags(self::$title_tags));
        $chain->addFilter(new Zend_Filter_StringTrim());
        $html = $chain->filter($html);
        
        $tmp = $html;
        while (1) {
        	// Try and replace an occurence of javascript
        	$html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $html);
        	
        	// If nothing changes this iteration then break loop
        	if ($html == $tmp)
        		break;
        		
        	$tmp = $html;
        }
        
        return $html;
    } 
    
   
    public function cleanHtml($html)
    {
        $chain = new Zend_Filter();
        $chain->addFilter(new Zend_Filter_StripTags(self::$content_tags));
        $chain->addFilter(new Zend_Filter_StringTrim());
        $html = $chain->filter($html);
        
        $tmp = $html;
        while (1) {
        	// Try and replace an occurence of javascript
        	$html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $html);
        	
        	// If nothing changes this iteration then break loop
        	if ($html == $tmp)
        		break;
        		
        	$tmp = $html;
        }
        
        return $html;
    } 
    
    public function getAdminQuestionOfExpert($user_id, $keyword = null, $cat = null, $order = null, $status = null){
        $order_search = 'created_date desc';
        switch($order)
        {
           case 'created_date':
                $order_search = 'engine4_experts_questions.created_date desc';
                break;
           case 'rating':
                $order_search = 'cnt_rating desc';
                break;                 
           case 'view':
                $order_search = 'engine4_experts_questions.view_count desc';
                break;
        }
        
        $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
        $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
        $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
        $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
        $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
        $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
        
        $questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
        ->setIntegrityCheck(false)
        ->from($questionsCatName, 
              new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR '<br/>') as category, 
                                GROUP_CONCAT(Distinct(engine4_experts_categories.category_id)) as category_ids,
                                (SELECT 
                                    GROUP_CONCAT(
                                        CONCAT(
                                            '<a class=experts_selected href=# value= ',
                                            (SELECT username FROM engine4_users where user_id = engine4_experts_recipients.user_id),
                                            '>expert</a>',
                                            '(',
                                            (SELECT count(question_id) FROM engine4_experts_answers WHERE user_id = engine4_experts_recipients.user_id and question_id = engine4_experts_questionscategories.question_id),
                                            ')'
                                         )
                                         SEPARATOR ' <br/>'
                                    )
                                 FROM engine4_experts_recipients WHERE engine4_experts_recipients.question_id = engine4_experts_questionscategories.question_id
                                ) as experts,
                                (SELECT count(engine4_experts_ratings.question_id) FROM engine4_experts_ratings WHERE engine4_experts_ratings.question_id = engine4_experts_questions.question_id) as cnt_rating,
                                (SELECT username FROM engine4_users where user_id = engine4_experts_questions.status_lasted_by) as lasted_by,
                                engine4_experts_questionscategories.*, 
                                engine4_experts_questions.*,
                                engine4_experts_questions.status as question_status,
                                engine4_experts_questions.view_count as question_view_count,
                                engine4_users.*
                                ")
          )
        ->joinLeft($questionsName,'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id',array())
        ->joinLeft($categoriesName,'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id',array())
        ->joinLeft($recipientsName,'engine4_experts_recipients.question_id=engine4_experts_questionscategories.question_id',array())
        ->joinLeft($usersName,'engine4_users.user_id=engine4_experts_questions.user_id',array())
        ->where('engine4_experts_recipients.user_id = ?', $user_id)
        ->where('engine4_experts_questions.title LIKE ? or engine4_experts_questions.content LIKE ? or engine4_experts_categories.category_name LIKE ?', "%".$keyword."%")
        ->group('engine4_experts_questionscategories.question_id')
        ->order($order_search);
        
        if($status){
            $questions_select->where('engine4_experts_questions.status = ?', $status);
        }
        
        if(count($cat)){
            $questions_select->where('engine4_experts_questionscategories.category_id in (?)', $cat);
        }
        return $questions_select;
    }  
      
    public function getAdminQuestionPaginator($cat = null, $keyword=null, $order=null, $status = null)
    {
        $paginator = Zend_Paginator::factory($this->getAdminQuestionList($cat, $keyword, $order, $status));
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(5);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        return $paginator;
    }
    
    function getAdminQuestionList($cat = null, $keyword = null, $order = null, $status = null)
    {
        $order_search = 'created_date desc';
        switch($order)
        {
           case 'created_date':
                $order_search = 'engine4_experts_questions.created_date desc';
                break;
           case 'rating':
                $order_search = 'cnt_rating desc';
                break;                 
           case 'view':
                $order_search = 'engine4_experts_questions.view_count desc';
                break;
        }
        
        $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
        $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
        $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
        $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
        $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
        $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
        
        $questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
        ->setIntegrityCheck(false)
        ->from($questionsCatName, 
              new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR '<br/>') as category, 
                                GROUP_CONCAT(Distinct(engine4_experts_categories.category_id)) as category_ids,
                                (SELECT 
                                    GROUP_CONCAT(
                                        CONCAT(
                                            '<a class=experts_selected href=# value= ',
                                            (SELECT username FROM engine4_users where user_id = engine4_experts_recipients.user_id),
                                            '>expert</a>',
                                            '(',
                                            (SELECT count(question_id) FROM engine4_experts_answers WHERE user_id = engine4_experts_recipients.user_id and question_id = engine4_experts_questionscategories.question_id),
                                            ')'
                                         )
                                         SEPARATOR ' <br/>'
                                    )
                                 FROM engine4_experts_recipients WHERE engine4_experts_recipients.question_id = engine4_experts_questionscategories.question_id
                                ) as experts,
                                (SELECT count(engine4_experts_ratings.question_id) FROM engine4_experts_ratings WHERE engine4_experts_ratings.question_id = engine4_experts_questions.question_id) as cnt_rating,
                                (SELECT username FROM engine4_users where user_id = engine4_experts_questions.status_lasted_by) as lasted_by,
                                engine4_experts_questionscategories.*, 
                                engine4_experts_questions.*,
                                engine4_experts_questions.status as question_status,
                                engine4_experts_questions.view_count as question_view_count,
                                engine4_users.*
                                ")
          )
        ->joinLeft($questionsName,'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id',array())
        ->joinLeft($categoriesName,'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id',array())
        ->joinLeft($recipientsName,'engine4_experts_recipients.question_id=engine4_experts_questionscategories.question_id',array())
        ->joinLeft($usersName,'engine4_users.user_id=engine4_experts_questions.user_id',array())
        ->where('engine4_experts_questions.title LIKE ? or engine4_experts_questions.content LIKE ? or engine4_experts_categories.category_name LIKE ?', "%".$keyword."%")
        ->group('engine4_experts_questionscategories.question_id')
        ->order($order_search);
        
        if($status){
            $questions_select->where('engine4_experts_questions.status = ?', $status);
        }
        
        if(count($cat)){
            $questions_select->where('engine4_experts_questionscategories.category_id in (?)', $cat);
        }
        return $questions_select;
  }
  
  public function getExpertsPaginator()
  {
    $paginator = Zend_Paginator::factory($this->getExpertsList());
    return $paginator;
  }
  
  public function getRelatedQuestion($question_id){
    $ratingTable = Engine_Api::_()->getDbtable('ratings', 'experts');
    $questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
    $questionCatTable = Engine_Api::_()->getDbtable('questionscategories', 'experts');
    $userTable = Engine_Api::_()->getDbtable('users', 'user');
    
    $old_questions_select = $questionTable->select()
    ->setIntegrityCheck(false)
    ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating'))
    ->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
    ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
    ->joinLeft($questionCatTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_questionscategories.question_id',array())
    ->where('engine4_experts_questionscategories.category_id in (select category_id from engine4_experts_questionscategories where question_id = ?)',$question_id)
    ->where('engine4_experts_questions.status in (2,3)')
    ->where('engine4_experts_questions.question_id < ?', $question_id)
    ->group('engine4_experts_questions.question_id')
    ->order('created_date desc')
    ->limit(4);
    $old = $questionTable->fetchAll($old_questions_select);
    
    
    $new_questions_select = $questionTable->select()
    ->setIntegrityCheck(false)
    ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating'))
    ->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
    ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
    ->joinLeft($questionCatTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_questionscategories.question_id',array())
    ->where('engine4_experts_questionscategories.category_id in (select category_id from engine4_experts_questionscategories where question_id = ?)',$question_id)
    ->where('engine4_experts_questions.status in (2,3)')
    ->where('engine4_experts_questions.question_id > ?', $question_id)
    ->group('engine4_experts_questions.question_id')
    ->order('created_date desc')
    ->limit(2);
    $new = $questionTable->fetchAll($new_questions_select);
    
    return array("new"=>$new, "old"=>$old);
  }
  
  // kiem tra xem co quyen tra loi ko
  public function checkValidAnswer($user_id, $question_id){
    
    //$question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
    $recipientsTable = Engine_Api::_()->getDbtable('recipients', 'experts');
    
    $recipients_select = $recipientsTable->select()
    ->setIntegrityCheck(false)
    ->from($recipientsTable->info('name'))
    ->where('question_id = ?', $question_id)
    ->where('user_id = ?', $user_id);
    
    $recipients = $recipientsTable->fetchAll($recipients_select);
    
    $check = false;
    if( count($recipients)){
        $check = true;
    }
    
    return $check;
  }
  
  function getAnswersOfQuestion($question_id){
    
    $usersName = Engine_Api::_()->getDbtable('users','user')->info('name');
    $answersName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
    $expertsName = Engine_Api::_()->getDbtable('experts', 'experts')->info('name');
    $filesName = Engine_Api::_()->getDbtable('files', 'storage')->info('name');
    $likesName = Engine_Api::_()->getDbtable('likes', 'experts')->info('name');

    $answersName = Engine_Api::_()->getDbtable('answers', 'experts')->select()
                        ->setIntegrityCheck(false)
                        ->from($answersName,new Zend_Db_Expr('COUNT(engine4_experts_likes.answer_id) as cnt_like, engine4_experts_answers.*, engine4_users.*, engine4_users.user_id as userid, 
						engine4_storage_files.*, engine4_storage_files.file_id as attach_id,(SELECT GROUP_CONCAT((select engine4_users.displayname  from engine4_users where engine4_users.user_id =  engine4_experts_likes.user_id))) as like_name,
						engine4_storage_files.name as attach_name'))
                        ->joinLeft($filesName,'engine4_experts_answers.file_id = engine4_storage_files.file_id',array())
                        ->joinLeft($usersName,'engine4_users.user_id = engine4_experts_answers.user_id',array())
						->joinLeft($likesName,'engine4_experts_answers.answer_id = engine4_experts_likes.answer_id',array())
                        ->where('engine4_experts_answers.question_id = ?', $question_id)
						->where('engine4_experts_likes.user_id <> ?', 0)
						->group('engine4_experts_answers.answer_id')
                        ->order('engine4_experts_answers.created_date ASC');
   //Zend_Debug::dump(Engine_Api::_()->getDbtable('answers', 'experts')->fetchAll($answersName)); exit;
    return Engine_Api::_()->getDbtable('answers', 'experts')->fetchAll($answersName);   
  }
  
  function getAdminCatExpert(){
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'experts'); 
    $expertTable = Engine_Api::_()->getDbtable('experts', 'experts');
    $categoryExpertsTable = Engine_Api::_()->getDbtable('expertscategories', 'experts');
     
    $categories_select = $categoryTable->select()
      ->setIntegrityCheck(false)
      ->from($categoryTable->info('name'), new Zend_Db_Expr('engine4_experts_categories.*, count(engine4_experts_experts.expert_id) as cnt_expert'))
      ->joinLeft($categoryExpertsTable->info('name'),'engine4_experts_categories.category_id = engine4_experts_expertscategories.category_id',array())
      ->joinLeft($expertTable->info('name'),'engine4_experts_experts.expert_id = engine4_experts_expertscategories.expert_id',array())
      ->group('engine4_experts_categories.category_id')
      ->order('engine4_experts_categories.category_name asc');
    
    $data = $categoryTable->fetchAll($categories_select);    
    return $data; 
    
  }
  
  function getAdminCatQuestion(){
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'experts'); 
    $questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
    $categoryQuestionsTable = Engine_Api::_()->getDbtable('questionscategories', 'experts');
     
    $categories_select = $categoryTable->select()
      ->setIntegrityCheck(false)
      ->from($categoryTable->info('name'), new Zend_Db_Expr('engine4_experts_categories.*, count(engine4_experts_questions.question_id) as cnt_question'))
      ->joinLeft($categoryQuestionsTable->info('name'),'engine4_experts_categories.category_id = engine4_experts_questionscategories.category_id',array())
      ->joinLeft($questionTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_questionscategories.question_id',array())
      ->group('engine4_experts_categories.category_id')
      ->order('engine4_experts_categories.category_name asc');
    
    $data = $categoryTable->fetchAll($categories_select);    
    return $data; 
    
  }
  
  function getCategoriesOfQuestion($question_id){
    $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
    $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
    
    $cat_questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
                        ->setIntegrityCheck(false)
                        ->from($questionsCatName, new Zend_Db_Expr('engine4_experts_categories.category_name , engine4_experts_questionscategories.*'))
                        ->joinInner($categoriesName,'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id',array())
                        ->where('engine4_experts_questionscategories.question_id = ?', $question_id)
                        ->group('engine4_experts_questionscategories.category_id')
                        ->order('engine4_experts_categories.category_name Asc');
    return Engine_Api::_()->getDbtable('questionscategories', 'experts')->fetchAll($cat_questions_select);
                           
  }
  
  function getExpertsOfQuestion($question_id){
    $recipientName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
    $userName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
    
    $experts_selected_select = Engine_Api::_()->getDbtable('recipients', 'experts')->select()
                        ->setIntegrityCheck(false)
                        ->from($recipientName, new Zend_Db_Expr('engine4_experts_recipients.* , engine4_users.*'))
                        ->joinInner($userName,'engine4_users.user_id=engine4_experts_recipients.user_id',array())
                        ->where('engine4_experts_recipients.question_id = ?', $question_id)
                        ->order('engine4_users.username Asc');
    return Engine_Api::_()->getDbtable('recipients', 'experts')->fetchAll($experts_selected_select);
  }

  function getExpertsList($keyword = null, $cat_ids = array(), $order)
  {
    $order_search = 'created_date desc';
    switch($order)
    {
       case 'created_date':
            $order_search = 'engine4_experts_experts.created_date desc';
            break;
       case 'question':
            $order_search = 'cnt_question desc';
            break;                 
       case 'answered':
            $order_search = 'cnt_answered desc';
            break;
    }
    
    $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
    $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
    $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
    $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
    $expertsName = Engine_Api::_()->getDbtable('experts', 'experts')->info('name');
    $expertsCatName = Engine_Api::_()->getDbtable('expertscategories', 'experts')->info('name');
    
    $experts_select = Engine_Api::_()->getDbtable('expertscategories', 'experts')->select()
    ->setIntegrityCheck(false)
    ->from($expertsCatName, 
          new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR '<br/> ') as category, 
                            GROUP_CONCAT(Distinct(engine4_experts_categories.category_id)) as category_ids,
                            (SELECT Count(Distinct(question_id)) FROM engine4_experts_recipients where engine4_experts_recipients.user_id = engine4_experts_experts.user_id) as cnt_question,
                            (SELECT Count(Distinct(question_id)) FROM engine4_experts_answers where engine4_experts_answers.user_id = engine4_experts_experts.user_id) as cnt_answered,
                            engine4_experts_experts.*,
                            engine4_users.*")
           )
    ->joinLeft($expertsName,'engine4_experts_experts.expert_id = engine4_experts_expertscategories.expert_id',array())     
    ->joinLeft($recipientsName,'engine4_experts_recipients.user_id = engine4_experts_experts.user_id',array())
    ->joinLeft($usersName,'engine4_users.user_id = engine4_experts_experts.user_id',array())
    ->joinLeft($categoriesName,'engine4_experts_categories.category_id = engine4_experts_expertscategories.category_id',array())
    ->joinLeft($answerName,'engine4_experts_answers.user_id = engine4_experts_experts.user_id',array())
    ->where('engine4_users.displayname LIKE ? or engine4_users.username LIKE ? or engine4_experts_categories.category_name LIKE ?', "%".$keyword."%")
    ->group('engine4_experts_expertscategories.expert_id')
    ->order($order_search);
    
    if(count($cat_ids)){
        $experts_select->where('engine4_experts_expertscategories.category_id in (?)', $cat_ids);
    }
    
    return $experts_select;
  }
  
  public function getMyExperts($user_id){
    // get experts info of user
    //$table_experts
    $expert_table = Engine_Api::_()->getDbTable('experts', 'experts');
    $question_table = Engine_Api::_()->getDbTable('questions', 'experts');
    
    $select = $question_table->select()
                    ->setIntegrityCheck(false)
                    ->from($expert_table->info('name'), new Zend_Db_Expr('engine4_experts_experts.*, count(engine4_experts_questions.status) as cnt_question'))
                    ->joinLeft($question_table->info('name'),'engine4_experts_questions.expert_id = engine4_experts_experts.expert_id',array())
                    ->where('engine4_experts_experts.user_id = ?', $user_id)
                    ->group('engine4_experts_experts.expert_id')
                    ->order('cnt_question DESC');
    return $expert_table->fetchAll($select);
  }
  
  public function getCategoriesExperts($expert_id)
  {
    // get experts info of user
    //$table_experts
    $cat_expert_table = Engine_Api::_()->getDbTable('expertscategories', 'experts');
    $cat_table = Engine_Api::_()->getDbTable('categories', 'experts');
    
    $select = $cat_expert_table->select()
                    ->setIntegrityCheck(false)
                    ->from($cat_expert_table->info('name'), new Zend_Db_Expr('engine4_experts_expertscategories.*, engine4_experts_categories.category_name'))
                    ->join($cat_table->info('name'),'engine4_experts_expertscategories.category_id = engine4_experts_categories.category_id',array())
                    ->where('engine4_experts_expertscategories.expert_id = ?', $expert_id)
                    ->group('engine4_experts_expertscategories.category_id');
    return $cat_expert_table->fetchAll($select);
  }
  
  /**
   * Returns a collection of all the categories in the experts plugin
   *
   * @return Zend_Db_Table_Select
   */
  public function getCategories()
  {
    $table = Engine_Api::_()->getDbTable('categories', 'experts');
    
    return $table->fetchAll($table->select()->order('priority ASC'));
  }

  /**
   * Returns a category item
   *
   * @param Int category_id
   * @return Zend_Db_Table_Select
   */
  public function getCategory($category_id)
  {
    return Engine_Api::_()->getDbtable('categories', 'experts')->find($category_id)->current();
  }
  
  /**
    * Return categogies of experts
   */
   public function getCategoriesOfExperts($expert_id=null){
    if($expert_id){
        
        $table = Engine_Api::_()->getDbTable('expertscategories', 'experts');
        $select = $table->select()
        ->where('expert_id = ?', $expert_id)
        ->group("category_id");
        return $table->fetchAll($select);
    }
   }
   
   /**
    * Return ansers of experts
   */
   public function getAnswersOfExperts($expert_id=null){
    if($expert_id){
        $table = Engine_Api::_()->getDbTable('answers', 'experts');
        $select = $table->select()
        ->where('expert_id = ?', $expert_id)
        ->group('question_id');
        return  $table->fetchAll($select);
    }
   }
   
   public function getQuestion($questtion_id)
   {
        $table = Engine_Api::_()->getDbtable('questions', 'experts'); 
        $select = $table->select()
            ->where('question_id = ?', $questtion_id);
        return  $table->fetchRow($select);
   }
   
   /**
    * Return Question of experts
   */
   public function getQuestionsOfExperts($expert_id=null){
    if($expert_id){
        $table = Engine_Api::_()->getDbTable('recipients', 'experts');
        $select = $table->select()
        ->where('expert_id = ?', $expert_id);
        return  $table->fetchAll($select);
    }
   }
   
  public function getCategoryItem($id){
    return Engine_Api::_()->getDbtable('categories', 'experts')->find($id)->current();
  }
  
  public function getExpertsItem($id){
    return Engine_Api::_()->getDbtable('experts', 'experts')->find($id)->current();
  }
  
  public function getPhotosOfExperts($main_photo_id){
    if($main_photo_id){
        $table = Engine_Api::_()->getDbTable('files', 'storage');
        $select = $table->select()
        ->where('file_id = ? or parent_file_id = ?', $main_photo_id, $main_photo_id);
        return  $table->fetchAll($select);
    }
  }
  
  public function createCategoriesExperts($categpries = array(), $expert_id){
    if(count($categpries)) {
        foreach($categpries as $item){
            $row = Engine_Api::_()->getDbtable('expertscategories', 'experts')->createRow();
            $row->setFromArray(array("expert_id"=>$expert_id, "category_id"=>$item));
            $row->save();
        }
    }
  }
  
  public function createCategoriesQuestion($categories = array(), $question_id){
    if(count($categories)) {
        foreach($categories as $item){
            $row = Engine_Api::_()->getDbtable('questionscategories', 'experts')->createRow();
            $row->setFromArray(array("question_id"=>$question_id, "category_id"=>$item));
            $row->save();
        }
    }
  }
  
  public function createRecipients($experts = array(), $question_id){
    if(count($experts)) {
        foreach($experts as $item){
            //$expert_data = Engine_Api::_()->getDbtable('experts', 'experts')->find($item)->current();
            
            $table  = Engine_Api::_()->getDbTable('recipients', 'experts');
            $rName = $table->info('name');
            $select = $table->select()
                            ->from($rName)
                            ->where($rName.'.question_id = ?', $question_id)
                            ->where($rName.'.user_id = ?', $item);
            $row = $table->fetchRow($select);
            if (empty($row)) {
              // create rating
              Engine_Api::_()->getDbTable('recipients', 'experts')->insert(array(
                'question_id' => $question_id,
                'user_id' => $item
              ));
            }
            
        }
    }
  }
  /*
  public function createRecipientsQuestion($expert_id , $new_id_question){
    $row = Engine_Api::_()->getDbtable('recipients', 'experts')->createRow();
    $row->setFromArray(array("expert_id"=>$expert_id, "question_id"=>$new_id_question));
    $row->save();
  }
  */
  public function deleteCategoriesOfExperts($expert_id){
    // delete all old data 
   $table = Engine_Api::_()->getDbtable('expertscategories', 'experts');
   $where = $table->getAdapter()->quoteInto('expert_id = ?', $expert_id);
   $table->delete($where);
 }
  
  public function updateCategoriesExperts($new_categpries = array(), $expert_id){
    // update here
    if(count($new_categpries) && $expert_id){
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        try
        {
           // delete  old categories
           $this->deleteCategoriesOfExperts($expert_id);
           $db->commit(); 
           // create new data
           $this->createCategoriesExperts($new_categpries, $expert_id);
        }
        
        catch( Exception $e )
        {
            $db->rollBack();
            throw $e;
        } 
    }
  }
  
  function deleteImages($images){
    $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
    if(count($images)){
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
        
      try
      {
       foreach($images as $item){
          $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($item['file_id'])->current();
          $storage->delete();
          @unlink($path . $item['storage_path']);
       }
       $db->commit();
       //@rmdir($path.$expert_id);
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      } 
    }
  }
  
  function deleteFile($file_id){
    $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
    $db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();

    try
    {
       $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($file_id)->current();
       if($storage){
           $file_path = $path.$storage->storage_path;
           $storage->delete();
           $db->commit();
           @unlink($file_path);
       }
    }
    catch( Exception $e )
    {
      $db->rollBack();
      throw $e;
    }
  }
  
  
  // My questions
  
  // change status of question to cancel
  public function cancelQuestion($question_id, $user_id){
    
    $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
    
    // is pendding(
    // cau hoi phai co trang thai = 1
    // va thoa man 1 trong 2 dk
    // 1. do user post len
    // 2. do expert quan ly
    $check_valid_answer = $this->checkValidAnswer($user_id, $question_id);
    
    if(($question->status == 1) && ( ($question->user_id == $user_id) ||  $check_valid_answer))
    {
      // update status to cancel
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      try
      {
        $question->status = 4;
        $question->status_lasted_by = $user_id;
        $question->save();
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
    }
    else
    {
        return ;
    }
  }
  
  // change status of question to close
  public function closeQuestion($question_id, $user_id=null){
    $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
    $check_valid_answer = $this->checkValidAnswer($user_id, $question_id);
    // is answered(
    if(($question->status == 2) && ( ($question->user_id == $user_id) || $check_valid_answer  ))
    {
      // update status to cancel
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      try
      {
        $question->status = 3;
        $question->status_lasted_by = $user_id;
        $question->save();
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
    }
    else
    {
        return ;
    }
  }
  
  // change status of question to answered
  public function answeredQuestion($question_id, $experts_id){
    $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
    $check_valid_answer = $this->checkValidAnswer($user_id, $question_id);
    
    // is pendding(
    if(($question->status == 1) && $check_valid_answer)
    {
      // update status to cancel
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      try
      {
        $question->status = 2;
        $question->status_lasted_by = $user_id;
        $question->save();
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
    }
    else
    {
        return ;
    }
  }
  
  public function deleteCategoriesOfQuestion($question_id){
     $db = Engine_Db_Table::getDefaultAdapter();
     $db->beginTransaction();
     try
      {
         // delete all old data 
       $table = Engine_Api::_()->getDbtable('questionscategories', 'experts');
       $where = $table->getAdapter()->quoteInto('question_id = ?', $question_id);
       $table->delete($where);
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
   
  }
  
  public function deleteRecipients($question_id){
     $db = Engine_Db_Table::getDefaultAdapter();
     $db->beginTransaction();
     try
      {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('recipients', 'experts');
        $where = $table->getAdapter()->quoteInto('question_id = ?', $question_id);
        $table->delete($where);
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
  }
  
  public function deleteRatings($question_id){
     $db = Engine_Db_Table::getDefaultAdapter();
     $db->beginTransaction();
     try
      {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('ratings', 'experts');
        $where = $table->getAdapter()->quoteInto('question_id = ?', $question_id);
        $table->delete($where);
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
  }
  
  public function deleteAttachments($question_id){
    $table_answer = Engine_Api::_()->getDbTable('answers', 'experts');
    $select_answers = $table_answer->select()
    ->where('question_id = ?', $question_id);
    $question_results = $table_answer->fetchAll($select_answers);
    if(count($question_results)){
        foreach($question_results as $item){
            if($item->file_id)
            {
                $this->deleteFile($item->file_id);
            }
        }
    }
  }
  
  public function deleteAnswers($question_id){
     $db = Engine_Db_Table::getDefaultAdapter();
     $db->beginTransaction();
     try
      {
        // Delete experts
        $table = Engine_Api::_()->getDbtable('answers', 'experts');
        $where = $table->getAdapter()->quoteInto('question_id = ?', $question_id);
        $table->delete($where);
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
  }
  
  // delete question
  public function deleteQuestion($question_id, $user_id=null){
    $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
    $check_valid_answer = $this->checkValidAnswer($user_id, $question_id);
    // is answered(
    //if( in_array($question->status,array(1,2,3,4)) && ( ($question->user_id == $user_id) || //$check_valid_answer))
	if( $question->user_id == $user_id)
    {
      // update status to cancel
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      try
      {
        // delete question
        @$question->delete();
        
        // delete categoriesquestion
        @$this->deleteCategoriesOfQuestion($question_id);
        
        // delete recipients
        @$this->deleteRecipients($question_id);
        
        // delete acttachment of questions
        @$this->deleteAttachments($question_id);
        
        // delete answers
        @$this->deleteAnswers($question_id);
        
        // delete rating
        @$this->deleteRatings($question_id);
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
    }
    else
    {
        return ;
    }
  }
  
  // rating for question
  public function getRatings($question_id)
  {
    $table  = Engine_Api::_()->getDbTable('ratings', 'experts');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.question_id = ?', $question_id);
    $row = $table->fetchAll($select);
    return $row;
  }
  
  public function checkRated($question_id, $user_id)
  {
    $table  = Engine_Api::_()->getDbTable('ratings', 'experts');

    $rName = $table->info('name');
    $select = $table->select()
                 ->setIntegrityCheck(false)
                    ->where('question_id = ?', $question_id)
                    ->where('user_id = ?', $user_id)
                    ->limit(1);
    $row = $table->fetchAll($select);
    
    if (count($row)>0) return true;
    return false;
  }

  public function setRating($question_id, $user_id, $rating){
    $table  = Engine_Api::_()->getDbTable('ratings', 'experts');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.question_id = ?', $question_id)
                    ->where($rName.'.user_id = ?', $user_id);
    $row = $table->fetchRow($select);
    if (empty($row)) {
      // create rating
      Engine_Api::_()->getDbTable('ratings', 'experts')->insert(array(
        'question_id' => $question_id,
        'user_id' => $user_id,
        'rating' => $rating
      ));
    }
  }
  
  public function ratingCount($question_id){
    $table  = Engine_Api::_()->getDbTable('ratings', 'experts');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.question_id = ?', $question_id);
    $row = $table->fetchAll($select);
    $total = count($row);
    return $total;
  }
  
  // phan admin
  function deleteExperts($experts_id){
      $experts = Engine_Api::_()->getDbtable('experts', 'experts')->find($experts_id)->current();
      
      /*
      if($experts->photo_id){
        // Delete photo
        $images = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($experts->photo_id);
        $this->deleteImages($images);  
      }
      */
      if($experts->file_id){
        // Delete file
        @$this->deleteFile($experts->file_id); 
      }
      
      // Delete experts
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      try
      {
        // delete categories of experts
        $this->deleteCategoriesOfExperts($experts_id);
        
        // delete questions of experts
        $expertsTable = Engine_Api::_()->getDbtable('experts', 'experts');
        $recipientsTable = Engine_Api::_()->getDbtable('recipients', 'experts');
        
        $quetions_select = $expertsTable->select()
        ->setIntegrityCheck(false)
        ->from($expertsTable->info('name'), new Zend_Db_Expr('engine4_experts_recipients.question_id'))
        ->joinLeft($recipientsTable->info('name'),'engine4_experts_experts.user_id = engine4_experts_recipients.user_id',array())
        ->where('engine4_experts_experts.expert_id = ?',$experts_id);
        $question_ids = $expertsTable->fetchAll($quetions_select);
        
        //Zend_Debug::dump($question_ids[0]['question_id']);exit;
        if(!empty($question_ids[0]['question_id'])){
            
            foreach($question_ids as $item){
                @$this->adminDeleteQuestion($item->question_id);
            }
        }
        
        //$expert_item = Engine_Api::_()->getDbtable('experts', 'experts')->find($experts_id)->current();
        $experts->delete();
        
        $db->commit();
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
  }
  
  /** hoook function */
  public function deleteExpertsByUser($user_id){
    $table = Engine_Api::_()->getDbTable('experts', 'experts');
    $select = $table->select()
    ->where('user_id = ?', $user_id);
    $row = $table->fetchAll($select);
    if(count($row)){
        foreach($row as $item) {
            if($item->expert_id){
                @$this->deleteExperts($item->expert_id);
            }
        }
    }
  }
  
  public function deleteQuestionAfferUserDeleted($user_id){
    $table  = Engine_Api::_()->getDbTable('questions', 'experts');
    $rName = $table->info('name');
    
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.user_id = ?', $user_id);
    $row = $table->fetchAll($select);
    if(count($row)){
        foreach($row as $item) {
            $this->adminDeleteQuestion($row->question_id);
        }
    }
  }
  /** end hook funtion */
  
  public function adminDeleteQuestion($question_id){
    $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
    
    $db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    try
    {
        // delete categoriesquestion
        $this->deleteCategoriesOfQuestion($question_id);
        
        // delete recipients
        $this->deleteRecipients($question_id);
        
        // delete acttachment of questions
        @$this->deleteAttachments($question_id);
        
        // delete answers
        $this->deleteAnswers($question_id);
        
        // delete rating
        $this->deleteRatings($question_id);
        
        // delete question
        $question->delete();
    }
    catch( Exception $e )
    {
        $db->rollBack();
        throw $e;
    }
  }
  
  public function myQuestionsCount($user_id){
    $table  = Engine_Api::_()->getDbTable('questions', 'experts');
    $rName = $table->info('name');
    
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.user_id = ?', $user_id);
    $row = $table->fetchAll($select);
    $total = count($row);
    return $total;
  }
  
  public function myExpertCount($user_id){
    $table  = Engine_Api::_()->getDbTable('answers', 'experts');
    $rName = $table->info('name');
    
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.user_id = ?', $user_id);
    $row = $table->fetchAll($select);
    $total = count($row);
    return $total;
  }
  
  public function ExpertsCount($user_id){
    $table  = Engine_Api::_()->getDbTable('experts', 'experts');
    $rName = $table->info('name');
    
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.user_id = ?', $user_id);
    $row = $table->fetchAll($select);
    $total = count($row);
    return $total;
  }
  
  public function sendmail($from, $from_name=null, $subject, $body, $emails){
    // temporarily enable queueing if requested
    $temporary_queueing = Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing;
    if (isset($values['queueing']) && $values['queueing']) {
      Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing = 1;
    }

    $mailApi = Engine_Api::_()->getApi('mail', 'core');
    
    $mail = $mailApi->create();
    $mail
      ->setFrom($from, $from_name)
      ->setReplyTo($from, $from_name)
      ->setSubject($subject)
      ->setBodyHtml($body)
      ;
    
    foreach( $emails as $email ) {
      $mail->addTo($email);
    }

    $mailApi->send($mail);
    
    // emails have been queued (or sent); re-set queueing value to original if changed
    if (isset($values['queueing']) && $values['queueing']) {
      Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing = $temporary_queueing;
    }
  }
  
   public function setUpdatePoint($question_id){
      $update_point = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
      // Delete book
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      
      $update_point->update_point = 1;
      $update_point->save();
      
      $db->commit();
  }
  
}
