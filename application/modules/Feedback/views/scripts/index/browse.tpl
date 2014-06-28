<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: browse.tpl 6590 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<?php $this->headScript()->appendFile('application/modules/Feedback/externals/scripts/core.js'); ?>
<script type="text/javascript">
	var pageAction = function(page) {
    	$('page').value = page;
    	$('filter_form').submit();
  	}
  	var categoryAction = function(category) {
	    $('page').value = 1;
	    $('category').value = category;
	    $('filter_form').submit();
  	}
  	var statAction = function(stat){
	    $('page').value = 1;
	    $('stat').value = stat;
	    $('filter_form').submit();
  	}

  	var dateAction = function(start_date, end_date) {
	    $('page').value = 1;
	    $('start_date').value = start_date;
	    $('end_date').value = end_date;
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
   		request.addEvent('complete', function(responseJSON) 
   		{
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
  <h2><?php echo $this->translate("Feedback") ?></h2>
  <div class='tabs'> <?php echo $this->navigation($this->navigation)->render() ?> </div>
</div>
<?php if($this->is_msg == 1): ?>
	<ul class="form-notices">
		<li style="font-size:12px;">
			<?php echo $this->translate("Feedback has been created successfully!"); ?>
		</li>
	</ul>
<?php endif; ?>
<div class='layout_right'> <?php echo $this->form->render($this) ?><?php echo $this->formmostvoted->render($this) ?>
  <div class="quicklinks">
    <ul>
      <li> <a href='<?php echo $this->url(array(), 'feedback_create', true) ?>' class='buttonlink icon_feedback_new smoothbox'><?php echo $this->translate('Create New Feedback');?></a> </li>
    </ul>
  </div>
  
  <?php if($this->vote): ?>
  	<div class="generic_layout_container feedbacks_statistics">
  	<h4><?php echo $this->translate('Most Voted Feedbacks');?></h4>
	    <ul>
	      <?php $count = 1;?>
	      <?php foreach( $this->voteFeedback as $voteFeedback ): ?>
		      <?php if($count>3):?>
		      	<li class="feedback_more"> <a href='javascript:void(0);' onclick='javascript:mostvotedAction(<?php ?>);'><?php echo $this->translate('More &raquo;') ?></a>&nbsp; </li>
		      	<span style="clear:both;display:block;"></span>
		      	<?php break;?>
	      	<?php endif;?>
		      <li>
		        <div class='feedbacks_view_sidebar_info'>
		          <p class='feedbacks_view_sidebar_info_title'> 
		          	<?php echo $this->htmlLink($voteFeedback->getHref(), $voteFeedback->truncate20Title(),  array('target'=>'_parent', 'title' => $voteFeedback->getTitle())) ?> 
		          </p>
		          <p class='feedbacks_view_sidebar_info_date'> 
		          	<?php echo $voteFeedback->total_votes." Votes" ?> | 
		          	<?php echo $voteFeedback->comment_count.$this->translate(' Comments')?> | 
		            <?php echo $voteFeedback->views.$this->translate(' Views')?> </p>
		        </div>
		      </li>
		      <?php $count++ ; ?>
	    	<?php endforeach; ?>
	    </ul>
	  </div>
  <?php endif; ?>

</div>
<div class='layout_middle'>
  <?php if( $this->paginator->count() > 0): ?>
	  <ul class="feedbacks_browse">
	    <?php foreach( $this->paginator as $feedback ): ?> 
		    <?php if($feedback->featured == 1): ?>
		    	<li class="feedback_featured"> 
		    <?php else: ?>
		    	<li>
		    <?php endif; ?>	
		    	<div class="feedbacks_browse_votes">
		    		<div class="feedback_votes">
		    			<p id="feedback_voting_<?php echo $feedback->feedback_id; ?>"> 
		    				<?php echo $feedback->total_votes ;?>
		    			</p>
		    			votes
		    		</div>
		    		<div id="feedback_vote_<?php echo $feedback->feedback_id; ?>" class="vote_button">
		        	<?php if($feedback->vote_id == NULL):?>
		        		<a href="javascript:void(0);" onClick="vote('<?php echo $this->viewer_id; ?>', '<?php echo $feedback->feedback_id; ?>');"><?php echo $this->translate('Vote'); ?></a>
		        	<?php elseif($this->viewer_id != 0): ?>
		        		<a href="javascript:void(0);" onClick="removevote('<?php echo $feedback->vote_id; ?>',  '<?php echo $feedback->feedback_id; ?>', '<?php echo $this->viewer_id; ?>');"><?php echo $this->translate('Remove'); ?></a>
		        	<?php endif; ?>
		      	</div>
		    	</div>
		      <div class='feedbacks_browse_info'>
		        <p class='feedbacks_browse_info_title'> 
		        	<?php echo $this->htmlLink($feedback->getHref(), $feedback->truncate70Title()) ?> 
		        	<span>
			          <?php if($feedback->featured == 1): ?>
			          	<?php echo $this->htmlImage('application/modules/Feedback/externals/images/feedback_goldmedal1.gif', '', array('class' => 'icon', 'title' => 'Featured')) ?>
			          <?php endif;?>
		          </span> 
		        </p>
		        <p class='feedbacks_browse_info_date'>  
		        	<?php echo $this->translate(array('%s view', '%s views', $feedback->views), $this->locale()->toNumber($feedback->views)) ?>,
		        	<?php echo $feedback->comment_count ?> 
		        	<?php echo $this->translate(' Comments');?>, 
		        	<?php echo $feedback->total_images ?><?php echo $this->translate(' Pictures'); ?>,
		        	<?php if($feedback->owner_id != 0 || !empty($feedback->owner_id)): ?>
		        		<?php echo $this->translate('Posted by %s about %s', $feedback->getOwner()->toString(), $this->timestamp($feedback->creation_date)) ?>
		        	<?php else: ?>	 
		        		<?php echo $this->translate('Posted by Anonymous user about %s',	$this->timestamp($feedback->creation_date)) ?>
		        	<?php endif;?>	 
		        </p>
		        <p >
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
				    <?php endif; ?>  
		      </div>   
		    </li>
	  	<?php endforeach; ?>
		</ul>
  	<?php echo $this->paginationControl($this->paginator, null, array("pagination/feedbackpagination.tpl","feedback"), array("orderby"=>$this->orderby)); ?>
  <?php elseif( $this->category || $this->stat || $this->search ):?>
    <div class="tip">
      <span>
        <?php echo $this->translate('Nobody has posted a feedback  with that criteria.');?>
        <?php if (TRUE): // @todo check if user is allowed to create a feedback ?>
          <?php echo $this->translate('Be the first to %1$swrite%2$s one!', '<a href="'.$this->url(array(), 'feedback_create').'" class = "smoothbox">', '</a>'); ?>
        <?php endif; ?>
      </span>
    </div>

  <?php else:?>
    <div class="tip">
      <span>
        <?php echo $this->translate('Nobody has posted a feedback yet.'); ?>
        <?php if (TRUE): // @todo check if user is allowed to create a feedback ?>
          <?php echo $this->translate('Be the first to %1$swrite%2$s one!', '<a href="'.$this->url(array(), 'feedback_create').'" class = "smoothbox">', '</a>'); ?>
        <?php endif; ?>
      </span>
    </div>
  <?php endif; ?>
  
  
</div>
