<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: list.tpl 6590 2010-07-08 9:40:21Z SocialEngineAddOns $
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
	
	var vote = function(viewer_id, feedback_id) {  
		if(viewer_id == 0) {
	  	  	var list_url = "<?php echo $this->list_url ?>";
					window.location = list_url;
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

<div class='layout_right'>
  <div class='feedbacks_gutter'> <?php echo $this->htmlLink($this->owner->getHref(), $this->itemPhoto($this->owner), array('class' => 'feedbacks_gutter_image')) ?> <?php echo $this->htmlLink($this->owner->getHref(), $this->owner->getTitle(), array('class' => 'feedbacks_gutter_name')) ?>
    <ul class='feedbacks_gutter_options'>
      <li> <a href='<?php echo $this->url(array('user_id' => $this->owner->getIdentity()), 'feedback_view') ?>' class='buttonlink icon_feedback_viewall'><?php echo $this->translate('View All Feedback');?></a> </li>
    </ul>
    <h4><?php echo $this->translate('Search Feedback')?></h4>
    <form id='filter_form' class='global_form_box' method='POST'>
      <input type='text' id="search" name="search" value="<?php if( $this->search ) echo $this->search; ?>"/>
      <input type="hidden" id="category" name="category" value="<?php if( $this->category ) echo $this->category; ?>"/>
      <input type="hidden" id="stat" name="stat" value="<?php if( $this->stat ) echo $this->stat; ?>"/>
      <input type="hidden" id="page" name="page" value="<?php if( $this->page ) echo $this->page; ?>"/>
    </form>
    
    <?php if( count($this->userCategories) ): ?>
	    <h4><?php echo $this->translate('Categories');?></h4>
		  <div class="feedbacks_statistics">
		    <ul>
		      <li> <a href='javascript:void(0);' onclick='javascript:categoryAction(0);' <?php if ($this->category==0) echo " style='font-weight: bold;'";?>><?php echo $this->translate('All Categories');?></a> </li>
		      <?php foreach ($this->userCategories as $category): ?>
		      <li> <a href='javascript:void(0);' onclick='javascript:categoryAction(<?php echo $category->category_id?>);' <?php if( $this->category == $category->category_id ) echo " style='font-weight: bold;'";?> > <?php echo $category->category_name?> </a> </li>
		      <?php endforeach; ?>
		    </ul>
		  </div> 
    <?php endif; ?>
  </div>
</div>
<div class='layout_middle'>
  <h2><?php echo $this->translate('%1$s\'s Feedbacks', $this->htmlLink($this->owner->getHref(), $this->owner->getTitle()))?></h2>
  <?php if( $this->paginator->getTotalItemCount() > 0 ): ?>
	  <ul class='feedbacks_browse'>
    	<?php foreach ($this->paginator as $item): ?>
    		<?php if($item->featured == 1): ?>
	    		<li style=" border-top-width: 1px;padding-top:15px;" class="feedback_featured">
	    	<?php else: ?>	
	    		<li style=" border-top-width: 1px;padding-top:15px;"> 
	    	<?php endif; ?>	
	    	<?php if(!empty($this->show_browse)): ?>
	    		<div class="feedbacks_browse_votes">
		    		<div class="feedback_votes">
		    			<p id="feedback_voting_<?php echo $item->feedback_id; ?>"> 
		    				<?php echo $item->total_votes ;?>
		    			</p>
		    			<?php echo $this->translate('votes')?>
		    		</div>
		    		
		    		<div id="feedback_vote_<?php echo $item->feedback_id; ?>" class="vote_button"> 
		        	<?php if($item->vote_id == NULL):?>
		        		<a href="javascript:void(0);" onClick="vote('<?php echo $this->viewer_id; ?>', '<?php echo $item->feedback_id; ?>');"><?php echo $this->translate('Vote')?></a>
		        	<?php elseif($this->viewer_id != 0): ?>
		        		<a href="javascript:void(0);" onClick="removevote('<?php echo $item->vote_id; ?>',  '<?php echo $item->feedback_id; ?>', '<?php echo $this->viewer_id; ?>');"><?php echo $this->translate('Remove')?></a>
		        	<?php endif; ?>
		      	</div>
		    	</div>
	    	<?php endif; ?>
	      	<div class='feedbacks_browse_info'>
		        <p class='feedbacks_browse_info_title'> <?php echo $this->htmlLink($item->getHref(), $item->truncate70Title()) ?>
		          <span>
			          <?php if($item->featured == 1): ?>
			          	<?php echo $this->htmlImage('application/modules/Feedback/externals/images/feedback_goldmedal1.gif', '', array('class' => 'icon', 'title' => 'Featured')) ?>
			          <?php endif;?>
		          </span> 
		        </p>
	        	<p class='feedbacks_browse_info_date'> <?php echo $item->views." views"; ?>, <?php echo $item->comment_count." Comments";?>,  <?php echo $item->total_images.$this->translate(' Pictures') ?>, <?php echo $this->translate(' Posted  by');?> <?php echo $this->htmlLink($item->getParent(), $item->getParent()->getTitle()) ?> <?php echo $this->timestamp($item->creation_date) ?> </p>
		        <p>
		          <?php foreach ($this->categories as $categories): ?>
			          <?php if($item->category_id == $categories->category_id):?>
			          	<?php echo $this->translate('Category:');?> <a href='javascript:void(0);' onclick='javascript:categoryAction(<?php echo $categories->category_id?>);'><?php echo $categories->category_name ?></a>
			          	<?php break; ?>
			          <?php endif;?>
		          <?php endforeach;?>
		        </p>
	        	<p class="feedbacks_browse_info_blurb"> <?php echo substr(strip_tags($item->feedback_description), 0, 350); if (strlen($item->feedback_description)>349) echo "..."; ?> </p>
	      	
	      	  <?php $show_status_div = 0 ?>
			      <?php foreach ($this->show_status as $status): ?>
		          <?php if($item->stat_id == $status->stat_id):?>
		          	<?php $show_status_div = 1 ?>
		      			<?php break; ?>
		         <?php endif;?>
			      <?php endforeach;?>
			      <?php if($show_status_div == 1 || !empty($item->status_body)): ?>
	        
						<div class="feedback_status_box">
		          <?php foreach ($this->show_status as $status): ?>
			          <?php if($item->stat_id == $status->stat_id):?>
				          <?php echo $this->translate('<b>Status:</b>');?> <a href='javascript:void(0);' onclick='javascript:statAction(<?php echo $status->stat_id?>);' class="feedback_status" style ="background-color:<?php echo $status->stat_color ?>;" ><?php echo $status->stat_name ?></a>
				          <?php break; ?>
			          <?php endif;?>
		          <?php endforeach;?>
		          
			        <?php if(!empty($item->status_body)): ?>
			        	<?php if($show_status_div != 1): ?><?php echo $this->translate('<b>Status:</b>');?><?php endif; ?>
		        		<p class='feedbacks_browse_info_blurb'> <?php echo $item->getStatusComment() ?> </p>
			        <?php endif;?>
			      </div>
			      <?php endif;?>
	       	</div>
	  		</li>
  		<?php endforeach; ?>
		</ul>
  <?php elseif( $this->category || $this->search || $this->stat): ?>
  	<div class="tip"> <span> <?php echo $this->translate('%1$s has not posted any feedback with this criteria.', $this->owner->getTitle()); ?> </span> </div>
  <?php else: ?>
  	<div class="tip"> <span> <?php echo $this->translate('%1$s has not posted a feedback entry yet.', $this->owner->getTitle()); ?> </span> </div>
  <?php endif; ?>
  <div class='browse_nextlast'> <?php echo $this->paginationControl($this->paginator, null, array("pagination/feedbackpagination.tpl","feedback"), array("orderby"=>$this->orderby)); ?> </div>
</div>
