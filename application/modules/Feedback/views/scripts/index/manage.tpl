<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: manage.tpl 6590 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<?php $this->headScript()->appendFile('application/modules/Feedback/externals/scripts/core.js'); ?>
<script type="text/javascript">
	var pageAction =function(page){
	    $('page').value = page;
	    $('filter_form').submit();
	}
	
	var statAction = function(stat){
	    $('page').value = 1;
	    $('stat').value = stat;
	    $('filter_form').submit();
	}
	
	var categoryAction = function(category){
	    $('page').value = 1;
	    $('category').value = category;
	    $('filter_form').submit();
	}

  var mostvotedAction = function(mostvoted){
      //$('page').value = 1;
      $('orderby_mostvoted').value = 'total_votes';
      $('filter_form_mostvoted').submit();
  } 
    
  var vote = function(viewer_id, feedback_id) {
  	if(viewer_id == 0) {
    	var browse_url = "<?php echo $this->browse_url ?>";
			window.location = browse_url;
  	}		
 	  if(viewer_id != 0) {
	   	// SENDING REQUEST TO AJAX   
	   	var request = en4.feedback.voting.createVote(viewer_id, feedback_id);    
	   
	   	// RESPONCE FROM AJAX
	   	request.addEvent('complete', function(responseJSON)	{
	    		$('feedback_voting_' + feedback_id).innerHTML = responseJSON.total;
	      	$('feedback_vote_' + feedback_id).innerHTML = responseJSON.abc;
	   	});
 		}
	}
 
  var  removevote = function(vote_id, feedback_id, viewer_Id) {
	  
  	// SENDING REQUEST TO AJAX   
  	var request = en4.feedback.voting.removeVote(vote_id, feedback_id, viewer_Id);    
   
   	// RESPONCE FROM AJAX
   	request.addEvent('complete', function(responseJSON)  { 
       $('feedback_voting_' + feedback_id).innerHTML = responseJSON.total;
        $('feedback_vote_' + feedback_id).innerHTML = responseJSON.abc;
   	});
	}
</script>

<div class="headline">
  <h2> <?php echo $this->translate("Feedback") ?> </h2>
  <div class='tabs'> <?php //echo $this->navigation($this->navigation)->render() ?> </div>
</div>

  <?php if( ($this->paginator->count() == 0) && ($this->search || $this->category || $this->stat)): ?>
	  <div class="tip">
	    <span> 
		  	<?php echo $this->translate('You do not have any feedback that match your search criteria.'); ?>
	    </span>
	  </div>
	<?php elseif($this->paginator->count() == 0): ?>  
		<div class="tip">
	    <span> 
		  	<?php echo $this->translate('You do not have any feedback.');?>
        <?php if (TRUE): // @todo check if user is allowed to create a feedback ?> 
          <?php echo $this->translate('Get started by %1$screating%2$s a new feedback.', '<a href="'.$this->url(array(), 'feedback_create').'" class="smoothbox">', '</a>'); ?>
        <?php endif; ?>
	    </span>
	  </div>
	<?php endif; ?>
  <ul class="feedbacks_browse">
    <?php foreach( $this->paginator as $feedback ): ?>
    	<?php if($feedback->featured == 1): ?>
		    	<li class="feedback_featured"> 
		    <?php else: ?>
		    	<li>
		    <?php endif; ?>	
      	<div class="feedbacks_browse_options"> <?php //echo $this->htmlLink($feedback->getHref(), $this->translate('View Feedback'), array('class' => 'buttonlink icon_feedback_viewall')) ?>
        	<?php if( $feedback->owner_id == $this->viewer_id) echo $this->htmlLink(array('route' => 'feedback_edit', 'feedback_id' => $feedback->feedback_id), $this->translate('Edit Feedback'), array('class' => 'buttonlink icon_feedback_edit')) ?>
        	<?php if($this->allow_upload == 1): ?>
        		<?php echo $this->htmlLink(array(
		                  'route' => 'feedback_extended',
		                  'controller' => 'image',
		                  'action' => 'upload',
        							'owner_id' => $feedback->owner_id,
		                  'subject' => $feedback->getGuid(),
		                ), $this->translate('Add Pictures'), array(
		                  'class' => 'buttonlink icon_feedback_image_new'
		              )) ?>
        	<?php endif; ?>
	        <?php if( $feedback->owner_id == $this->viewer_id) echo $this->htmlLink(array('route' => 'feedback_delete', 'feedback_id' => $feedback->feedback_id), $this->translate('Delete Feedback'), array(
			          'class'=>'buttonlink icon_feedback_delete'
			         )) ?>
		    </div>
		    <?php if(!empty($this->show_browse)): ?>
			    <div class="feedbacks_browse_votes">
		    		<div class="feedback_votes">
		    			<p id="feedback_voting_<?php echo $feedback->feedback_id; ?>"> 
		    				<?php echo $feedback->total_votes ;?>
		    			</p>
		    			votes
		    		</div>
		    		<div id="feedback_vote_<?php echo $feedback->feedback_id; ?>" class="vote_button">
		        	<?php if($feedback->vote_id == NULL):?>
		        		<a href="javascript:void(0);" onClick="vote('<?php echo $this->viewer_id; ?>', '<?php echo $feedback->feedback_id; ?>');"><?php echo $this->translate('Vote');?></a>
		        	<?php elseif($this->viewer_id != 0): ?>
		        		<a href="javascript:void(0);" onClick="removevote('<?php echo $feedback->vote_id; ?>',  '<?php echo $feedback->feedback_id; ?>', '<?php echo $this->viewer_id; ?>');"><?php echo $this->translate('Remove');?></a>
		        	<?php endif; ?>
		      	</div>
			    </div>
		    <?php endif; ?>
	      <div class='feedbacks_browse_info'>
	        <p class='feedbacks_browse_info_title'> 
	        	<?php //echo $this->htmlLink($feedback->getHref(), $feedback->truncate70Title()) ?> 
	        	<?php echo $feedback->truncate70Title() ?> 
	        	<span>
		          <?php if($feedback->featured == 1): ?>
		          	<?php echo $this->htmlImage('application/modules/Feedback/externals/images/feedback_goldmedal1.gif', '', array('class' => 'icon', 'title' => 'Featured')) ?>
		          <?php endif;?>
		        </span> 
	        </p>
	        <p class='feedbacks_browse_info_date'> <?php echo $this->translate('Posted by %s about %s', $feedback->getOwner()->toString(), $this->timestamp($feedback->creation_date)) ?>, <?php echo $feedback->comment_count ?> <?php echo $this->translate(' Comments');?>, <?php echo $this->translate(array('%s view', '%s Views', $feedback->views), $this->locale()->toNumber($feedback->views)) ?>, <?php echo $feedback->total_images ?><?php echo " pictures"?> </p>
	        <p>
	          <?php foreach ($this->categories as $categories): ?>
	          <?php if($feedback->category_id == $categories->category_id):?>
	          <?php echo $this->translate('Category:');?> <a href='javascript:void(0);' onclick='javascript:categoryAction(<?php echo $categories->category_id?>);'><?php echo $categories->category_name ?></a>
	          <?php break; ?>
	          <?php endif;?>
	          <?php endforeach;?>
	        </p>
	        <p class='feedbacks_browse_info_blurb'> <?php echo $this->viewMore($feedback->getDescription()) ?> </p>
	      	<?php $show_status_div = 0 ?>
			      <?php foreach ($this->show_status as $status): ?>
		          <?php if($feedback->stat_id == $status->stat_id):?>
		          	<?php $show_status_div = 1 ?>
		      			<?php break; ?>
		         <?php endif;?>
			      <?php endforeach;?>
			      <?php if($show_status_div == 1 || !empty($feedback->status_body)): ?>	   
					<div class="feedback_status_box">
	          <?php foreach ($this->show_status as $status): ?>
		          <?php if($feedback->stat_id == $status->stat_id):?>
		          <?php echo $this->translate('<b>Status:</b>');?> <a href='javascript:void(0);' onclick='javascript:statAction(<?php echo $status->stat_id?>);' class="feedback_status"  style ="background-color:<?php echo $status->stat_color ?>;"><?php echo $status->stat_name ?></a>
		          <?php break; ?>
		          <?php endif;?>
	          <?php endforeach;?>
		        <?php if(!empty($feedback->status_body)): ?>
		        	<?php if($show_status_div != 1): ?><?php echo $this->translate('<b>Status:</b>');?><?php endif; ?>
		        	<p class='feedbacks_browse_info_blurb'> <?php echo $feedback->getStatusComment() ?> </p>
		        <?php endif;?>
		      </div>
 						<?php endif;?>
	      </div>
    	</li>
    <?php endforeach; ?>
  </ul>
  <?php if( $this->paginator->count() >= 1): ?>
  	<div> <?php echo $this->paginationControl($this->paginator, null, array("pagination/feedbackpagination.tpl","feedback"), array("orderby"=>$this->orderby)); ?> </div>
  <?php endif; ?>