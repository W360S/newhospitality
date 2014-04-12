<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: view.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<!-- This script call in the case of ignore any suggestion. -->
<script type="text/javascript">
en4.suggestion = {

};
en4.core.setBaseUrl('<?php echo $this->url(array(), 'default', true) ?>');
	var cancelSuggestion = function(sugg_id, entity, url) 
	{
	  // SENDING REQUEST TO AJAX   
	  var request = en4.suggestion.displays.disInfo(sugg_id, entity);    
	  // RESPONCE FROM AJAX
	  request.addEvent('complete', function(responseJSON) 
	  {
	  	if(responseJSON.status)
	  	{	// Redirect to the "Suggestion Listing Page" with confirm message.
	  		window.location = en4.core.baseUrl + "suggestions/viewall?type=" + responseJSON.sugg_page;
	  	}	
	  });
	}

	en4.suggestion.displays = {
		
		disInfo : function(sugg_id, entity)
		{
		  var request = new Request.JSON({   	
		    url : en4.core.baseUrl + 'suggestion/main/suggestion-cancel',
		    data : {
		      format : 'json',		   
		      sugg_id : sugg_id,
		      entity : entity
		    }
		  });  
		  request.send();
		  return request;
		}
	}
</script>
<div class="layout_right"></div>
<div class="layout_middle">
<?php
if(empty($this->sugg_msg))
{
	foreach($this->suggestion_object as $row_mix_key => $row_mix_value):
		switch ($row_mix_key)
		{//Display group.
			case 'group':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">
						<?php echo $this->translate("You have a group suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'view all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
						<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
					</div>
					<div class="item_details">
						<b class="title"><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>

						<div class="description">
							<?php
							echo $this->translate(array('%s member', '%s members', $row_mix_value[0]->membership()->getMemberCount()),$this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
							echo $this->translate(' led by ');
							echo $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br/>';
							echo $this->translate('This group was suggested by') . ' <b>' . $this->sender_name . '</b>'; 
							 ?>
						</div>
						<div class="item_buttons">
							<?php 
							//Add group option.
							echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Group'), array('class' => 'smoothbox' )) . ' or ';
						
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'group\');"> ' . $this->translate('Ignore') . ' </a>';
					 		?>
					 		<a class="smoothbox link" href="<?php echo $this->sugg_baseUrl; ?>/activity/index/share/type/group/id/<?php echo $row_mix_value[0]['group_id']; ?>/format/smoothbox"><?php echo $this->translate('Share Group'); ?></a>
					 
						</div>
					</div>
				</div>
				<div style="clear:both"></div>
				<div id="sugg_cancel"></div>
				<?php	break; 
				
			
			//Display blog.
			 case 'blog':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">						
						<?php echo $this->translate("You have a blog suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
						<?php echo $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.profile')); ?>
					</div>
					<div class="item_details">
						<b class="title"><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
						<div class="description">

							<?php echo $this->translate('This blog was suggested by') . ' <b>' . $this->sender_name . '</b>'; ?>
						</div>
						<div class="item_buttons">
							<?php
							echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>" . $this->translate('View this Blog') . "</b>") . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'blog\');"> ' . $this->translate('Ignore') . ' </a><br />';?>	
						</div>								
					</div>
				</div>
			  <div style="clear:both"></div>
			  <div id="sugg_cancel"></div>
			  <?php break;
			
			
				
			// Display Event.
					case 'event':?>
						<div class="suggestion_view_list" id="sugg_divid">
							<div class="heading">
								<?php echo $this->translate("You have an event suggestion"); ?>								
								<span class="view_all">
									<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'view all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
								</span>
							</div>
							<div class="item_photo">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
							</div>
							<div class="item_details">
								<b class="title"><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()) ?></b>
								<div class="description">
									<?php //echo $this->dateTime($row_mix_value[0]->starttime);
									echo $this->translate(array('%s guest', '%s guests', $row_mix_value[0]->membership()->getMemberCount()),$this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
									echo $this->translate(' led by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br/>';
									echo $this->translate('This event was suggested by') . ' <b>' . $this->sender_name . '</b>';
									?>
									</div>
									<div class="item_buttons">
										<?php			
										//Event Relationship.
				  					if(($this->filter != "past") && $this->viewer()->getIdentity() && !$row_mix_value[0]->membership()->isMember($this->viewer(), null) ):
				  					echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Event'), array('class' => 'buttonlink smoothbox icon_event_join')) . ' or ';
				  					echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'event\');"> ' . $this->translate('Ignore') . ' </a>';
				  				?>
				  					<a class="smoothbox link" href="<?php echo $this->sugg_baseUrl; ?>/activity/index/share/type/event/id/<?php echo $row_mix_value[0]['event_id']; ?>/format/smoothbox" style="margin-left:10px;">Share Event</a><br><br><?php
				  				endif;
								?>
								</div>
							</div>
						</div>
					
				 <div style="clear:both"></div>
				 <div id="sugg_cancel"></div>
				 <?php
			break;
				
			// Display Album.
			case 'album':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">						
						<?php echo $this->translate("You have an album suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span> 
					</div>
					<div class="item_photo">
						<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile')); ?>
					</div>
					<div class="item_details">
						<b class="title"><?php	echo $this->htmlLink($row_mix_value[0], $this->string()->chunk(substr($row_mix_value[0]->getTitle(), 0, 45), 10)); ?></b>
						<div class="description">
							<?php 							
							echo $this->translate('By ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br>';
							echo $this->translate(array(' %s photo', ' %s photos', $row_mix_value[0]->count()),$this->locale()->toNumber($row_mix_value[0]->count())) . '<br>';
							echo $this->timestamp($row_mix_value[0]->modified_date) . '<br>'; 
							echo $this->translate('This album was suggested by') . ' <b>' . $this->sender_name . '</b>';
							?>
						</div>	
								
						<div class="item_buttons">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>" . $this->translate('View this Album') . "</b>") . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'album\');"> ' . $this->translate('Ignore') . ' </a><br />';?>
						</div>
					</div>
				</div>
				<div style="clear:both"></div>
				<div id="sugg_cancel"></div>
				<?php break;
				
			// Display Classified.
			case 'classified':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">					
						<?php echo $this->translate("You have a classified suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
						<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile')); ?>
					</div>
					<div class="item_details">					
						<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
						<div class="description">
							<?php 
							echo $this->translate('Posted ') . $this->timestamp(strtotime($row_mix_value[0]->creation_date));
							echo $this->translate(' by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br>';
							echo $this->translate('This classified was suggested by') . ' <b>' . $this->sender_name . '</b>'; 
							?>
						</div>
						<div class="item_buttons">
							<?php	echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>" . $this->translate('View this Classified') . "</b>") . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'classified\');"> ' . $this->translate('Ignore') . ' </a><br />';?>
						</div>										
					</div>
				</div>
				
				<div style="clear:both"></div>
				<div id="sugg_cancel"></div>
				<?php
			break;
				
			// Display Video.	
			case 'video':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">						
						<?php echo $this->translate("You have a video suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
						<?php if ($row_mix_value[0]->photo_id) echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile'));
				 					else echo '<img alt="" src="application/modules/Video/externals/images/video.png">'; ?>
					</div>
					<div class="item_details">
						<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
						<div class="description">
							<?php 								
								echo $this->translate('by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br>'; 
				 				echo $this->translate(array(' %s view', ' %s views', $row_mix_value[0]->view_count),$this->locale()->toNumber($row_mix_value[0]->view_count)) . '<br>';
				 				echo $this->translate('This video was suggested by') . ' <b>' . $this->sender_name . '</b>';
				 				?>
				 				
				 		</div>	
						<div class="item_buttons">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>" . $this->translate('View this Video') . "</b>") . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'video\');"> ' . $this->translate('Ignore') . ' </a><br><br>';?>
						</div>	
					</div>
				</div>
				<div style="clear:both"></div>
				<div id="sugg_cancel"></div>
				<?php
			break;
				
			// Display Music.	
			case 'music':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">
						<?php echo $this->translate("You have a music suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
						<?php if ($row_mix_value[0]->photo_id) echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile'));
				 		else echo '<img alt="" src="application/modules/Music/externals/images/nophoto_playlist_thumb_icon.png" />'; ?>
					</div>
					<div class="item_details">
						<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
						<div class="description">
							<?php 
							echo $this->translate('Created %s by ', $this->timestamp($row_mix_value[0]->creation_date)) . $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle()) . '<br>';
							echo $this->translate('This music was suggested by') . ' <b>' . $this->sender_name . '</b>';
							?>
						</div>
						<div class="item_buttons">
							<?php	echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>" . $this->translate('Listen to this Music') . "</b>") . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'music\');"> ' . $this->translate('Ignore') . ' </a><br><br>';	?>
						</div>							
					</div>
				</div>
				<div style="clear:both"></div>
				<div id="sugg_cancel"></div>
				<?php
			break;
			
			 //Display photo friend suggestion.
			case 'photo':?>
			<div class="suggestion_view_list" id="sugg_divid">
				<div class="heading">						
						<?php echo $this->translate("You have a profile photo suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . ucfirst($row_mix_key) . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">	
						<?php	echo $this->itemPhoto($row_mix_value[0], 'thumb.profile');?> 
					</div>
					<div class="item_details">
						<div class="description" style="font-size:12px;margin-bottom:10px;">
							<?php echo $this->translate('This profile photo was suggested by') . ' <b>' . $this->sender_name . '</b>'; ?>
						</div>
						<div class="item_buttons">
							<?php echo $this->htmlLink(array('route' => 'user_extended', 'module' => 'user', 'controller' => 'edit', 'action' => 'external-photo', 'photo' => 'suggestion_photo_' . $row_mix_value[0]->entity_id, 'format' => 'smoothbox'), $this->translate('View Photo Suggestion'), array('class' => 'smoothbox')) . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'photo\');"> ' . $this->translate('Ignore') . ' </a><br><br>'; ?>
						</div>
					</div>	
				 	<div style="clear:both"></div><?php	break;
			
			 //Display photo friend suggestion.
			case 'friend':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">						
						<?php echo $this->translate("You have a friend suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'view all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
						<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile'), array('class' => 'item_photo')); ?>
					</div>	
					<div class="item_details">
						<b class="title"><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
						<div class="description">
							<?php echo $this->translate('This friend was suggested by') . ' <b>' . $this->sender_name . '</b>'; ?>
						</div>
						<div class="item_buttons">
							<?php echo $this->userFriendship($row_mix_value[0]). ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'friend\');"> ' . $this->translate('Ignore') . ' </a><br />'; ?>
						</div>
					</div>
				</div>
				
				<div id="sugg_cancel"></div>
				<div style="clear:both"></div><?php
			break;
			
			//Display poll.
			 case 'poll':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">						
						<?php echo $this->translate("You have a poll suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
						<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.profile', $row_mix_value[0]->getOwner()->username)); ?>
					</div>
					<div class="item_details">
						<b class="title"><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
						<div class="description">
							<?php echo $this->translate('Posted by %s ', $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle()));
							echo $this->timestamp($row_mix_value[0]->creation_date);
							echo $this->translate(array(' - %s vote', ' - %s votes', $row_mix_value[0]->voteCount()), $this->locale()->toNumber($row_mix_value[0]->voteCount()));
							echo $this->translate(array(' - %s view', ' - %s views', $row_mix_value[0]->views), $this->locale()->toNumber($row_mix_value[0]->views));
							?><br />
							<?php echo $this->translate('This poll was suggested by') . ' <b>' . $this->sender_name . '</b>'; ?>
						</div>
						<div class="item_buttons">
							<?php
							echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>" . $this->translate('Vote on this Poll') . "</b>") . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'poll\');"> ' . $this->translate('Ignore') . ' </a><br />';?>	
						</div>								
					</div>
				</div>
			  <div style="clear:both"></div>
			  <div id="sugg_cancel"></div>
			  <?php break;
			  
			//Display forum.
			 case 'forum':?>
				<div class="suggestion_view_list" id="sugg_divid">
					<div class="heading">
						<?php echo $this->translate("You have a forum suggestion"); ?>
						<span class="view_all">
							<a href="<?php echo $this->url(array(), 'suggestions_display') ?>#<?php echo $row_mix_key; ?>"><?php echo 'View all ' . $row_mix_key . ' suggestions &raquo;' ?></a>
						</span>
					</div>
					<div class="item_photo">
					<?php $photo_obj = Engine_Api::_()->getItem('user', $row_mix_value[0]->user_id); ?>
						<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($photo_obj->getOwner(), 'thumb.profile')); ?>
					</div>
					<div class="item_details">
					<?php $forum_name =  Engine_Api::_()->getItem('forum_forum', $row_mix_value[0]->forum_id); ?>
						<b class="title"><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()) . $this->translate(' in ') . $this->htmlLink($forum_name->getHref(), $forum_name->getTitle()); ?></b>
						<?php	$category_title = Engine_Api::_()->getItem('forum_category', $forum_name->category_id)->title; ?>				
						<div class="description">
							<?php
								echo $this->translate(array('%s Reply', '%s Replies', $row_mix_value[0]->post_count), $this->locale()->toNumber($row_mix_value[0]->post_count)) . ' | ' . $this->translate(array('%s View', '%s Views', $row_mix_value[0]->view_count), $this->locale()->toNumber($row_mix_value[0]->view_count)) . '<br/>';
								echo $this->translate('Category : ') . $category_title . '<br/>';
							    echo $this->translate('This forum topic was suggested by') . ' <b>' . $this->sender_name . '</b>';								
							 ?>
						</div>
						<div class="item_buttons">
							<?php
							echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>" . $this->translate('View this Topic') . "</b>") . ' or ';
							echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $this->suggestion_id . '\', \'forum\');"> ' . $this->translate('Ignore') . ' </a><br />';?>	
						</div>								
					</div>
				</div>
			  <div style="clear:both"></div>
			  <div id="sugg_cancel"></div>
			  <?php break;
		}
	endforeach;
}
else {
	?>
<script type="text/javascript">
<!--
window.location =  en4.core.baseUrl + "suggestions/viewall";
//-->
</script>

<?php    
}
?>
</div>
<script type="text/javascript">
function openUrl(url){
	Smoothbox.open(url);
}
</script>