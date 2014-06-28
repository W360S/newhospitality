<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: VoteController.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_VoteController extends Core_Controller_Action_Standard
{
  //ACTION FOR DO VOTE
  public function voteAction()
	{
		//GET DETAIL
    $feedback_id = (int) $this->_getParam('feedback_id');
    $viewer_id = (int) $this->_getParam('viewer_id');

    //DO ENTRY IN feedback_votes TABLE
    $voteTable = Engine_Api::_()->getItemTable('vote');
    
    $select  = $voteTable->select()
                     ->setIntegrityCheck(false)
                     ->from($voteTable->info('name'))
                     ->where('voter_id = ?', $viewer_id)
    					 			 ->where('feedback_id = ?', $feedback_id);						
    $rows = $voteTable->fetchAll($select)->toArray();	
    if(empty($rows)) {
    
	    $vote = $voteTable->createRow();
	    $vote->voter_id = $viewer_id;
	    $vote->feedback_id = $feedback_id;
	    $vote->total_votes++;
	    $vote->save();
	   	
	    //GET TOTAL VOTES 
	    $table   = Engine_Api::_()->getItemTable('vote');
			$select  = $table->select()
	                     ->setIntegrityCheck(false)
	                     ->from($table->info('name'), array('COUNT(*) AS count'))
	    					 			 ->where('feedback_id = ?', $feedback_id);						
	    $rows = $table->fetchAll($select)->toArray();	
	    $vote_total = $rows[0]['count'];							
	   	    
	    //ASSIGN TOTAL VOTES TO total_votes IN  feedback TABLE
	    $feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
	    $feedback->total_votes =   $vote_total;
	    $feedback->save();
	   	    
	   	//CODE FOR GET VOTE ID
			$tmTable = Engine_Api::_()->getitemTable('vote');
			$tmName =  $tmTable->info('name');     
			
			$checkVote = $tmTable->select()
								 ->setIntegrityCheck(false)
								 ->from($tmName, array('vote_id'))
								 ->where('voter_id = ?', $viewer_id)
								 ->where('feedback_id = ?', $feedback_id);
			$rows = $tmTable->fetchAll($checkVote)->toArray();	
			$vote_id =  $rows['0']['vote_id'];
			
			//ASSIGN REMOVE VOTE LINK
	   	$remove_link = '<span><a href="javascript:void(0);" onclick="removevote(\'' . $vote_id . '\', \'' . $feedback_id . '\', \'' . $viewer_id . '\');">'.$this->view->translate('Remove').'</a></span>';
	   	    
	   	$this->view->status = true;
	   	$this->view->abc = $remove_link;
	   	$this->view->total =  $vote_total;
   	
    }
    else {
    	//GET TOTAL VOTES 
	    $table   = Engine_Api::_()->getItemTable('vote');
			$select  = $table->select()
	                     ->setIntegrityCheck(false)
	                     ->from($table->info('name'), array('COUNT(*) AS count'))
	    					 			 ->where('feedback_id = ?', $feedback_id);						
	    $rows = $table->fetchAll($select)->toArray();	
	    $vote_total = $rows[0]['count'];							
	   	    
	    //ASSIGN TOTAL VOTES TO total_votes IN  feedback TABLE
	    $feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
	    $feedback->total_votes =   $vote_total;
	    $feedback->save();
	   	    
	   	//CODE FOR GET VOTE ID
			$tmTable = Engine_Api::_()->getitemTable('vote');
			$tmName =  $tmTable->info('name');     
			
			$checkVote = $tmTable->select()
								 ->setIntegrityCheck(false)
								 ->from($tmName, array('vote_id'))
								 ->where('voter_id = ?', $viewer_id)
								 ->where('feedback_id = ?', $feedback_id);
			$rows = $tmTable->fetchAll($checkVote)->toArray();	
			$vote_id =  $rows['0']['vote_id'];
			
			//ASSIGN REMOVE VOTE LINK
   	$remove_link = '<span><a href="javascript:void(0);" onclick="removevote(\'' . $vote_id . '\', \'' . $feedback_id . '\', \'' . $viewer_id . '\');">'.$this->view->translate('Remove').'</a></span>';
   	    
   	$this->view->status = true;
   	$this->view->abc = $remove_link;
   	$this->view->total =  $vote_total;
    
    }
    
    
	}
	
	//ACTION FOR REMOVE VOTE
	public function removevoteAction()
	{
		//GET DETAIL
    $vote_id = (int) $this->_getParam('vote_id');
    $feedback_id = (int) $this->_getParam('feedback_id');
    $viewer_id = (int) $this->_getParam('viewer_id');
        
    //DELETE VOTE ENTRY FROM DATABASE
    $revote = Engine_Api::_()->getItem('vote', $vote_id);
    $revote->delete();
        
    //GET TOTAL VOTES 
    $table   = Engine_Api::_()->getItemTable('vote');
		$select  = $table->select()
	                   ->setIntegrityCheck(false)
	                   ->from($table->info('name'), array('COUNT(*) AS count'))
	    				 			 ->where('feedback_id = ?', $feedback_id);						
    $rows = $table->fetchAll($select)->toArray();	
    $vote_total = $rows[0]['count'];							
   	   	    
    //ASSIGN TOTAL VOTES TO total_votes IN  feedback TABLE
    $feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
    $feedback->total_votes =   $vote_total;
    $feedback->save();  
          
		//ASSIGN VOTE LINK
   	$vote_link =  '<span><a href="javascript:void(0);" onclick="vote(\'' . $viewer_id . '\', \'' . $feedback_id . '\');">'.$this->view->translate('Vote').'</a></span>';
   	$this->view->status = true;
   	$this->view->total =   $vote_total;
   	$this->view->abc = $vote_link;
	}
}
?>