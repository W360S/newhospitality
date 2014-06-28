<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: view.tpl 6590 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<?php $this->headScript()->appendFile('application/modules/Feedback/externals/scripts/core.js'); ?>
<script type="text/javascript">

	var categoryAction =function(category) {
	    $('category').value = category;
	    $('filter_form').submit();
	}
	var statAction =function(stat) {
	    $('stat').value = stat;
	    $('filter_form').submit();
	}
  
	var vote = function(viewer_id, feedback_id) { 

		if(viewer_id == 0) {
    	var view_url = "<?php echo $this->view_url ?>";
			window.location = view_url;
  	}		
 	  if(viewer_id != 0) {
	    // SENDING REQUEST TO AJAX   
	    var request = en4.feedback.voting.createVote(viewer_id, feedback_id);    
	   
	    // RESPONCE FROM AJAX
	    request.addEvent('complete', function(responseJSON) {
	    	$('feedback_voting').innerHTML = responseJSON.total;
	      $('feedback_vote').innerHTML = responseJSON.abc;
	    });
	 	}
 	}
 
  var  removevote = function(vote_id, feedback_id, viewer_Id) {
   	// SENDING REQUEST TO AJAX   
   	var request = en4.feedback.voting.removeVote(vote_id, feedback_id, viewer_Id);    
   
   	// RESPONCE FROM AJAX
   	request.addEvent('complete', function(responseJSON) {  
        $('feedback_voting').innerHTML = responseJSON.total;
        $('feedback_vote').innerHTML = responseJSON.abc;
   	});
 	}
</script>
<div class='layout_right'>
	
  <div class='feedbacks_gutter'> 
  	<?php if($this->feedback->owner_id != 0 || !empty($this->feedback->owner_id)): ?>
  		<?php echo $this->htmlLink($this->owner->getHref(), $this->itemPhoto($this->owner), array('class' => 'feedbacks_gutter_image')) ?> <?php echo $this->htmlLink($this->owner->getHref(), $this->owner->getTitle(), array('class' => 'feedbacks_gutter_name')) ?>
    	<ul class="feedbacks_gutter_options">
	      <li> 
	      	<?php echo $this->htmlLink($this->url(array('user_id' => $this->feedback->owner_id), 'feedback_view'), $this->translate('View All Feedback'), array('class' => 'buttonlink icon_feedback_viewall')) ?> 
	      </li>
	      <?php if ($this->feedback->owner_id == $this->viewer_id || $this->user_level == 1):?>
		      <li> 
		      	<?php echo $this->htmlLink(array('route' => 'feedback_edit', 'feedback_id' => $this->feedback->feedback_id), $this->translate('Edit Feedback'), array('class' => 'buttonlink icon_feedback_edit')) ?> 
		      </li>
		      <?php if($this->allow_upload == 1): ?>
			      <li> 
			      	<?php echo $this->htmlLink(array(
			          'route' => 'feedback_extended',
			          'controller' => 'image',
			          'action' => 'upload',
			      		'owner_id' => $this->feedback->owner_id,
			          'subject' => $this->feedback->getGuid(),
			        ), $this->translate('Add Pictures'), array(
			          'class' => 'buttonlink icon_feedback_image_new'
			        )) ?> 
						</li>
		      <?php endif; ?>
		      <li> 
		      	<?php echo $this->htmlLink(array('route' => 'feedback_delete', 'feedback_id' => $this->feedback->feedback_id), $this->translate('Delete Feedback'), array(
		        	'class'=>'buttonlink  icon_feedback_delete'
		    		)) ?> 
				  </li>
	      <?php endif; ?>
    </ul>
    <?php else: ?>
    	<div class="feedbacks_gutter_name ">
    		<span class="feedbacks_gutter_image">
    			<?php echo $this->htmlImage('application/modules/User/externals/images/nophoto_user_thumb_profile.png', '', array('class' => 'thumb_profile item_nophoto')) ?>
    		</span>	
    		<?php echo $this->feedback->anonymous_name;?> <br /> 
    		<small><?php echo $this->feedback->anonymous_email;?></small> <br /> <br />
    		<ul class="feedbacks_gutter_options">
	    		<li> 
    				<?php  echo $this->htmlLink(array('route' => 'feedback_delete', 'feedback_id' => $this->feedback->feedback_id), $this->translate('Delete Feedback'), array(
			          'class'=>'buttonlink icon_feedback_delete'
			       )) ?>
			    </li>
			  </ul>    
			 </div> 
    <?php endif; ?>
    <?php if(!empty($this->viewer_id)): ?>
    	<div class='feedbacks_gutter'>
    		<ul class="feedbacks_gutter_options">
	      	<li> 
	      		<?php echo $this->htmlLink(array('route' => 'feedback_manage', 'action' => 'manage'), $this->translate(' My Feedbacks'), array('class'=>'buttonlink  icon_feedback_viewall', 'target' => '_parent')) ?>
	      	</li>
	      </ul>
	    </div>  	 
    <?php endif; ?>
    
    <?php if(!empty($this->feedback->owner_id)):?>
	    <h4><?php echo $this->translate('Search Feedback');?></h4>
	    <form id='filter_form' class='global_form_box' method='post' action='<?php echo $this->url(array('user_id' => $this->feedback->owner_id), 'feedback_view') ?>'>
	      <input id="search" name="search" type='text' />
	      <input type="hidden" id="category" name="category" value=""/>
	      <input type="hidden" id="stat" name="stat" value=""/>
	      <input type="hidden" id="start_date" name="start_date" value="<?php if ($this->start_date) echo $this->start_date;?>"/>
	      <input type="hidden" id="end_date" name="end_date" value="<?php if ($this->end_date) echo $this->end_date;?>"/>
	    </form>
    <?php endif; ?>
    <?php if($this->feedbackUserTotal): ?>
    	 <div class="generic_layout_container feedbacks_statistics">
    		<h4><?php echo $this->translate('FEEDBACK OF SAME CATEGORY');?></h4>
	      <ul>
	        <?php $count = 1;?>
	        <?php foreach( $this->feedbackUser as $feedbackUser ): ?>
		        <?php if($count>3):?>
			        <li class="feedback_more"> <?php echo $this->htmlLink($this->url(array('user_id' => $feedbackUser->owner_id), 'feedback_view'), $this->translate('More &raquo;'), array()) ?> </li>
			        <span style="clear:both;display:block;"></span>
			        <?php break;?>
	        	<?php endif;?>
		        <li>
		          <div class='feedbacks_view_sidebar_info'>
		            <p class='feedbacks_view_sidebar_info_title'> 
		            	<?php echo $this->htmlLink($feedbackUser->getHref(), $feedbackUser->truncate20Title(),  array('target'=>'_parent', 'title' => $feedbackUser->getTitle())) ?> 
		            </p>
		            <p class='feedbacks_view_sidebar_info_date'> 
		            	<?php echo $feedbackUser->total_votes." Votes" ?> | 
		            	<?php echo $feedbackUser->comment_count.$this->translate(' Comments')?> | 
		              <?php echo $feedbackUser->views.$this->translate(' Views')?> </p>
		          </div>
		        </li>
	        	<?php $count++ ; ?>
	      	<?php endforeach; ?>
	   	  </ul>
	  	</div>
  	<?php endif; ?>
    <?php if (count($this->userCategories )):?>
	    <h4><?php echo $this->translate('Categories')?></h4>
	    <div class="feedbacks_statistics">
	      <ul>
	        <li> <a href='javascript:void(0);' onclick='javascript:categoryAction(0);'><?php echo $this->translate('All Categories')?></a></li>
	        <?php foreach ($this->userCategories as $category): ?>
	        	<li> <a href='javascript:void(0);' onclick='javascript:categoryAction(<?php echo $category->category_id?>);'><?php echo $category->category_name?></a></li>
	        <?php endforeach; ?>
	      </ul>
	    </div>
    <?php endif; ?>
  </div>
</div>

<div class='layout_middle'>
	<h2>
		<?php if($this->feedback->owner_id != 0): ?>
  		<?php echo $this->translate('%1$s\'s Feedback', $this->htmlLink($this->owner->getHref(), $this->owner->getTitle()))?>
  	<?php else:?>
  		<?php echo $this->translate('Anonymous Feedback')?>
  	<?php endif;?>	
  </h2>
  <ul class="feedbacks_detaillist">
  
    <li>
    	<?php if(!empty($this->feedback->owner_id) && !empty($this->show_browse)): ?>
	    	<div class="feedback_view_votes">
		      <div class="feedback_votes">
		  			<p id="feedback_voting"> 
		  				<?php echo $this->feedback->total_votes ;?>
		  			</p>
		  			<?php echo $this->translate(' votes');?>
		    	</div>
		    	
		    	<div id="feedback_vote" class="vote_button">
		        <?php if(empty($this->vote) || $this->vote == 0 ):?>
		        <a href="javascript:void(0);" onclick="vote('<?php echo $this->viewer_id; ?>', '<?php echo $this->feedback->feedback_id; ?>');"><?php echo $this->translate('Vote');?></a>
		        <?php elseif($this->viewer_id != 0): ?>
		        <a href="javascript:void(0);" onclick="removevote('<?php echo $this->vote; ?>',  '<?php echo $this->feedback->feedback_id; ?>', '<?php echo $this->viewer_id; ?>');"><?php echo $this->translate('Remove');?></a>
		        <?php endif; ?>
		      </div>
	    	</div>
	    	
    	<?php endif;?>
    	
      <h3> <?php echo $this->feedback->getTitle();?> </h3>
      <?php if($this->feedback->owner_id != 0 || !empty($this->feedback->owner_id)): ?>
      	<div class="feedback_detaillist_detail_date"> <?php echo $this->translate('Posted by %s about %s,', $this->feedback->getOwner()->toString(), $this->timestamp($this->feedback->creation_date)) ?>
      <?php else: ?>
      	<div class="feedback_detaillist_detail_date"> <?php echo $this->translate('Posted by Anonymous user about %s,', $this->timestamp($this->feedback->creation_date)) ?>
      <?php endif;?>
      <?php if ($this->category && (!empty($this->feedback->owner_id))):?>
      	<?php echo $this->translate('Category:');?> <a href='javascript:void(0);' onclick='javascript:categoryAction(<?php echo $this->category->category_id?>);'><?php echo $this->category->category_name ?>,</a>
      <?php elseif ($this->category && (empty($this->feedback->owner_id))): ?>  	
     		<?php echo $this->translate('Category:');?> <?php echo $this->category->category_name ?>,
      <?php endif; ?>
      <?php echo $this->translate(array('%s view', '%s views', $this->feedback->views), $this->locale()->toNumber($this->feedback->views)) ?>,
      <?php echo $this->feedback->total_images ?>
      <?php echo $this->translate(' pictures')?>
      </div>
  
      <div class="feedback_detaillist_detail_stats"> 
      	<?php echo $this->feedback->comment_count ?> 
 				<?php echo $this->translate('  Comments');?>,
 				
      	<?php echo $this->participants_total ?>
      	<?php echo $this->translate(' Participants')?>
      </div>
      <div class="feedback_detaillist_detail_body"> 
      	<?php echo $this->viewMore($this->feedback->feedback_description) ?> 
      </div>
      
      <?php if($this->feedback->total_images): ?>
	      <div class="feedback_images">
	      	<h4><?php echo $this->translate('Feedback Pictures');?></h4>
			    <?php foreach( $this->paginator as $image ): ?>
			    	<div class="feedback_img">
					    <a href="<?php echo $this->url(array('owner_id' => $image->user_id, 'album_id' => $image->album_id, 'image_id' => $image->image_id), 'feedback_image_specific') ?>">
               <?php echo $this->itemPhoto($image, 'thumb.normal') ?>
             	</a>
				    	<?php if(($this->viewer_id == $this->feedback->owner_id && $this->viewer_id != 0) || $this->user_level == 1): ?>
				    		<?php echo $this->htmlLink(array('route'=>'feedback_removeimage', 'feedback_id'=>$this->feedback->feedback_id, 'image_id' => $image->image_id, 'owner_id' => $image->user_id), $this->translate('Delete')) ?> 
				    	<?php endif; ?>
					  </div> 
			    <?php endforeach;?>
			    <div style="clear:both;"></div>
	    	</div>
    	<?php endif; ?>
    	
    	<?php if(!empty($this->stat) || !empty($this->feedback->status_body)): ?>
    	<div class="feedback_status_box">
	    	 <?php if ($this->stat):?>
	      	<?php echo $this->translate('<b>Status:</b>');?> <a href='javascript:void(0);' onclick='javascript:statAction(<?php echo $this->stat->stat_id?>);' class="feedback_status"  style ="background-color:<?php echo $this->stat->stat_color ?>;" ><?php echo $this->stat->stat_name ?></a><br />
	      <?php endif; ?>
	      <?php if(!empty($this->feedback->status_body)): ?>
	      	<?php if(empty($this->stat)): ?><?php echo $this->translate('<b>Status:</b>');?><?php endif;?>
			    <p class='feedback_detaillist_detail_body'> <?php echo $this->feedback->status_body ?> </p>
			  <?php endif;?>
    	</div>
    	<?php endif; ?>
    	<div style="clear:both;"></div>
    </li>	
    
    <li style="border-bottom:none;">
	    <?php if((!($this->can_comment ||  $this->ip_can_comment)) && ($this->feedback->owner_id != 0 || !empty($this->feedback->owner_id))): ?>
		    <p>
		      <?php echo $this->action("list", "comment", "core", array("type"=>"feedback", "id"=>$this->feedback->getIdentity())) ?>
		    </p>
			<?php endif; ?>
			<?php if(empty($this->viewer_id) && ($this->feedback->comment_count)): ?>
				<p>
		      <?php echo $this->translate('Please'); ?><a href="<?php echo $this->paramalink_url ?>" ><?php echo $this->translate(' login'); ?></a><?php echo $this->translate(' to view comments.'); ?>
		    </p>
	    <?php endif; ?>
	    <?php if($this->feedback_report == 1 && !empty($this->viewer_id)): ?>
	    	<div class="report_button">
	    		<?php echo $this->htmlLink(Array('module'=> 'core', 'controller' => 'report', 'action' => 'create', 'route' => 'default', 'subject' => $this->report->getGuid(), 'format' => 'smoothbox'), $this->translate("Inappropriate Content"), array('class' => 'buttonlink smoothbox icon_feedbacks_report')); ?>
	    	</div>	
	    <?php endif; ?>
	  </li>    
  </ul>
</div>
