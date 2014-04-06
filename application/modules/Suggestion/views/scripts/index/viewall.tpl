<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: viewall.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<!-- This script call in the case of ignore any suggestion. -->
<script type="text/javascript">
	en4.suggestion = {
	
	};
	en4.core.setBaseUrl('<?php echo $this->url(array(), 'default', true) ?>');
	
	var sugg_count = [];
	<?php
		foreach( $this->sugg_count as $toJsArray => $convert ) 
		{
			echo "sugg_count[ '$toJsArray' ] = $convert;";
		} 
	?>
   
	var cancelSuggestion = function(sugg_id, entity) 
	{
	  // SENDING REQUEST TO AJAX   
	  var request = en4.suggestion.displays.disInfo(sugg_id, entity);    
	  // RESPONCE FROM AJAX
	  request.addEvent('complete', function(responseJSON) 
	  { 
	  	if(responseJSON.status)
	  	{	
	  		$('sugg_' + sugg_id).innerHTML = responseJSON.suggestion_msg;		  		
	  		sugg_count[entity] = sugg_count[entity] - 1;
	  		if(sugg_count[entity] == 0 || sugg_count[entity] == 1)
	  		{
	  			$(entity + '_count_singlar').innerHTML = '<div class="suggestions_heading">You have ' + sugg_count[entity] + ' ' + entity + ' suggestion.</div>';
	  			$(entity + '_count_plural').innerHTML = '';
	  			$(entity + '_default').innerHTML = '';
	  		}
	  		else
	  		{
	  			$(entity + '_count_plural').innerHTML = '<div class="suggestions_heading">You have ' + sugg_count[entity] + ' ' + entity + 's suggestion.</div>';
	  			$(entity + '_count_singlar').innerHTML = '';
	  			$(entity + '_default').innerHTML = '';
	  		}
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
		      sugg_id : sugg_id ,
		      entity : entity
		    }
		  });  
		  request.send();
		  return request;
		}
	}
</script>

<?php
if(isset($this->type))
{
	echo '<ul class="form-notices" style="margin:0px;"><li>' . ucfirst($this->type) . $this->translate(' suggestion has been deleted.') . '</li></ul>';
}
if(empty($this->sugg_msg))
{
	$friend_indicator = 0;
	$group_indicator = 0;
	$blog_indicator = 0;
	$event_indicator = 0;
	$album_indicator = 0;
	$classified_indicator = 0;
	$video_indicator = 0;
	$music_indicator = 0;
	$photo_indicator = 0;
	$poll_indicator = 0;
	$forum_indicator = 0;
	foreach($this->sugg_display_object as $sugg_key => $row_mix_value):
		// $explode_key[0] = entity.
	  // $explode_key[1] = entity_id.
	  // $explode_key[2] = sender_id.
	  $explode_key = explode("_", $sugg_key);
	  switch ($explode_key[0])
	  {
			// Display Photo.
			case 'photo':?>
				<?php
				// Print first time suggestion only.
				if($photo_indicator == 0){
					echo '<div id="photo_count_singlar"></div>';
					echo '<div id="photo_count_plural"></div>';
					echo '<div class="suggestions_heading" id="photo_default">' . $this->translate('You have ') . $this->translate(array('%s photo', '%s photos', $this->sugg_count['photo']), $this->locale()->toNumber($this->sugg_count['photo'])) . $this->translate(' suggestion.') . '</div>';
					?><a name ="photo"></a>
					<?php	} ?> 
					<div class="suggestion_view_list">
						<div class="item_photo">
							<?php echo $this->itemPhoto($row_mix_value[0], 'thumb.rofile') . '<br>';	?> 
						</div>
						<div class="item_details">
							<div class="description">
								<?php 
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This profile photo was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This profile photo was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}	
								?>
							</div>
							<div class="item_buttons">	
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>"> 
									<?php echo $this->htmlLink(array('route' => 'user_extended', 'module' => 'user', 'controller' => 'edit', 'action' => 'external-photo', 'photo' => 'suggestion_photo_' . $row_mix_value[0]->entity_id, 'format' => 'smoothbox'), $this->translate("View Photo Suggestion"), array('class' => 'smoothbox')) . ' or ';				
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'photo\');"> ' . $this->translate('Ignore') . ' </a><br><br>';?>
							</div>
						</div>
					</div>	
						<?php

				$photo_indicator++; ?>
				</div>
				<div style="clear:both"></div>
				<?php	break;
					
	  	//Display friend suggestion.
			case 'friend':?>
				<?php 				
				if($friend_indicator == 0)
				{
					echo '<div id="friend_count_singlar"></div>';
					echo '<div id="friend_count_plural"></div>';
					echo '<div class="suggestions_heading" id="friend_default">' . $this->translate('You have ') . $this->translate(array('%s friend', '%s friends', $this->sugg_count['friend']), $this->locale()->toNumber($this->sugg_count['friend'])) . $this->translate(' suggestion.') . '</div>';					
					?><a name ="friend"></a><?php
				}?>
				<div class="suggestion_view_list" id="<?php echo 'friend_' . $row_mix_value[0]['user_id']; ?>">
					<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile'), array('class' => 'item_photo')); ?>
					<div class="item_details">
						<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
						<div class="description">
							<?php 
								$friend_indicator++;
								// We are found "Sender name" who has send same suggestion of user. 
								$sender_id_value = explode(",", $explode_key[2]);									
								$number_of_suggestion = count($sender_id_value);
								$sender_id_array = array_unique($sender_id_value);
								$sender_name = '';
								foreach($sender_id_array as $sender_id)	{
									$sender_row = Engine_Api::_()->getItem('user', $sender_id);
									$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
									$sender_name .= ', ' . $sender;
				  			}
				  			if($number_of_suggestion < 2)
				  			{
				  				echo $this->translate("This friend was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
				  			}
				  			else {
									echo $this->translate("This friend was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
				  			}	
							?>
						</div>
						<div class="item_buttons">
							<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
								<?php	echo $this->userFriendship($row_mix_value[0]) . ' or ';
								echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'friend\');"> ' . $this->translate('Ignore') . ' </a><br><br>';?>
							</div>
						</div>
					</div>
				</div>
				<div style="clear:both"></div>
				
					<?php	break;
				
				//Display group.
				case 'group':?>
					<?php 				
					if($group_indicator == 0)
					{
						echo '<div id="group_count_singlar"></div>';
						echo '<div id="group_count_plural"></div>';
						echo '<div class="suggestions_heading" id="group_default">' . $this->translate('You have ') . $this->translate(array('%s group', '%s groups', $this->sugg_count['group']), $this->locale()->toNumber($this->sugg_count['group'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="group"></a><?php }?>
					<div style="display:block;" class="suggestion_view_list" id="<?php echo 'group_' . $row_mix_value[0]['group_id']; ?>">
						<div class="item_photo">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile')); ?>
						</div>
						<div class="item_details">
							<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
							<div class="description">
								<?php
								echo $this->translate(array('%s member', '%s members', $row_mix_value[0]->membership()->getMemberCount()),$this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
								echo $this->translate(' led by ');
								echo $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br/>';
								
								?>
								<?php 
									$group_indicator++;
									// Display name which send you a suggestion.
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This group was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This group was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}	
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>" style="float:left;">
									<?php
									// Show Join group option on the page.
									if( !$row_mix_value[0]->membership()->isMember($this->viewer(), null) ){
	        				echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Group'), array('class' => 'buttonlink smoothbox icon_group_join')) . ' or ';}
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'group\');"> ' . $this->translate('Ignore') . ' </a> ';?>
									<a class="link smoothbox" href="<?php echo $this->sugg_baseUrl; ?>/activity/index/share/type/group/id/<?php echo $row_mix_value[0]['group_id']; ?>/format/smoothbox" style="margin-left:10px;"><?php echo $this->translate('Share Group'); ?></a>
								</div>	
							</div>
						</div>
					</div>
					<div style="clear:both"></div>
					<?php	break;


				
				// Display Event.
				case 'event':?>
					<?php 				
					if($event_indicator == 0)
					{
						echo '<div id="event_count_singlar"></div>';
						echo '<div id="event_count_plural"></div>';
						echo '<div class="suggestions_heading" id="event_default">' . $this->translate('You have ') . $this->translate(array('%s event', '%s events', $this->sugg_count['event']), $this->locale()->toNumber($this->sugg_count['event'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="event"></a><?php
					}?>
					<div class="suggestion_view_list" id="<?php echo 'event_' . $row_mix_value[0]['event_id']; ?>">
						<div class="item_photo">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile')); ?>
						</div>
						<div class="item_details">
							<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()) ?></b>
							
							<div class="description">
								<?php //echo $this->dateTime($row_mix_value[0]->starttime);
								echo $this->translate(array('%s guest', '%s guests', $row_mix_value[0]->membership()->getMemberCount()),$this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
								echo $this->translate(' led by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br/>';?>
								<?php 
									$event_indicator++;
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This event was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This event was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}	
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>" style="float:left;">
									<?php echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Event'), array('class' => 'buttonlink smoothbox icon_event_join')) . ' or ';
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'event\');"> ' . $this->translate('Ignore') . ' </a><br />'; ?>
								</div>
								<a class="link smoothbox" href="<?php echo $this->sugg_baseUrl; ?>/activity/index/share/type/event/id/<?php echo $row_mix_value[0]['event_id']; ?>/format/smoothbox" style="float:left;margin-left:10px;"><?php echo $this->translate('Share Event'); ?></a><br><br>
							</div>
						</div>
					</div>
					<div style="clear:both"></div>
					
					<?php break;


				
				
				
				// Display blog.
				case 'blog':?>			
					<?php
					if($blog_indicator == 0)
					{
						echo '<div id="blog_count_singlar"></div>';
						echo '<div id="blog_count_plural"></div>';
						echo '<div class="suggestions_heading" id="blog_default">' . $this->translate('You have ') . $this->translate(array('%s blog', '%s blogs', $this->sugg_count['blog']), $this->locale()->toNumber($this->sugg_count['blog'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="blog"></a><?php
					}?>
					<div class="suggestion_view_list" id="<?php echo 'blog_' . $row_mix_value[0]['blog_id']; ?>">
						<div class="item_photo">
							<?php echo $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.profile')); ?>
						</div>
						<div class="item_details">						
							<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
							<div class="description">
								<?php 
									$blog_indicator++;
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This blog was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This blog was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}	
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>View this Blog</b>") . ' or ';
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'blog\');"> ' . $this->translate('Ignore') . ' </a><br><br>'; ?>
								</div>
							</div>		
						</div>
					</div>
					<div style="clear:both"></div>
					<?php break;
					
				// Display Classified.
				case 'classified':?>
					<?php 				
					if($classified_indicator == 0)
					{
						echo '<div id="classified_count_singlar"></div>';
						echo '<div id="classified_count_plural"></div>';
						echo '<div class="suggestions_heading" id="classified_default">' . $this->translate('You have ') . $this->translate(array('%s classified', '%s classifieds', $this->sugg_count['classified']), $this->locale()->toNumber($this->sugg_count['classified'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="classified"></a><?php
					}
					?>
					<div class="suggestion_view_list" id="<?php echo 'classified_' . $row_mix_value[0]['classified_id']; ?>">
						<div class="item_photo">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile')); ?>
						</div>
						<div class="item_details">
							<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
							<div class="description">
								<?php 
								echo $this->translate('Posted ') . $this->timestamp(strtotime($row_mix_value[0]->creation_date));
								echo $this->translate(' by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br/>';?>
								<?php 
									$classified_indicator++;
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This classified was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This classified was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}	
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>View this Classified</b>") . ' or ';
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'classified\');"> ' . $this->translate('Ignore') . ' </a><br><br>'; ?>
								</div>
							</div>
						</div>
					</div>
					<div style="clear:both"></div>
					<?php	break;
					
				// Display Video.	
				case 'video':?>			
					<?php 				
					if($video_indicator == 0)
					{
						echo '<div id="video_count_singlar"></div>';
						echo '<div id="video_count_plural"></div>';
						echo '<div class="suggestions_heading" id="video_default">' . $this->translate('You have ') . $this->translate(array('%s video', '%s videos', $this->sugg_count['video']), $this->locale()->toNumber($this->sugg_count['video'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="video"></a><?php
					}?>
					<div class="suggestion_view_list" id="<?php echo 'video_' . $row_mix_value[0]['video_id']; ?>">
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
								?>
								<?php 
									$video_indicator++;
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This video was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This video was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}	
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>View this Video</b>") . ' or ';
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'video\');"> ' . $this->translate('Ignore') . ' </a><br><br>'; ?>
								</div>
							</div>					
						</div>
					</div>
					<div style="clear:both"></div>
					<?php break;
					
				// Display Music.	
				case 'music':?>
					<?php 				
					if($music_indicator == 0)
					{
						echo '<div id="music_count_singlar"></div>';
						echo '<div id="music_count_plural"></div>';
						echo '<div class="suggestions_heading" id="music_default">' . $this->translate('You have ') . $this->translate(array('%s music', '%s musics', $this->sugg_count['music']), $this->locale()->toNumber($this->sugg_count['music'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="music"></a><?php
					}
					?>
					<div class="suggestion_view_list" id="<?php echo 'music_' . $row_mix_value[0]['playlist_id']; ?>">
						<div class="item_photo">
							<?php if ($row_mix_value[0]->photo_id) echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile'));
					 		else echo '<img alt="" src="application/modules/Music/externals/images/nophoto_playlist_thumb_icon.png" />'; ?>
						</div>
						<div class="item_details">
							<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
							<div class="description">
								<?php 
								echo $this->translate('Created %s by ', $this->timestamp($row_mix_value[0]->creation_date)) . $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle()) . '<br>';				
							?>
							<?php 
								$music_indicator++;
								// We are found "Sender name" who has send same suggestion of user. 
								$sender_id_value = explode(",", $explode_key[2]);									
								$number_of_suggestion = count($sender_id_value);
								$sender_id_array = array_unique($sender_id_value);
								$sender_name = '';
								foreach($sender_id_array as $sender_id)	{
									$sender_row = Engine_Api::_()->getItem('user', $sender_id);
									$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
									$sender_name .= ', ' . $sender;
				  			}
				  			if($number_of_suggestion < 2)
				  			{
				  				echo $this->translate("This music was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
				  			}
				  			else {
									echo $this->translate("This music was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
				  			}	
							?>
						</div>
						<div class="item_buttons">
							<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
								<?php	echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>Listen to this Music</b>") . ' or ';
								echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'music\');"> ' . $this->translate('Ignore') . ' </a><br><br>';
				?></div>
						</div>						
					</div>
				</div>
				<div style="clear:both"></div>
				<?php	break;
					
				// Display Album.
				case 'album':?>
					<?php 				
					if($album_indicator == 0)
					{
						echo '<div id="album_count_singlar"></div>';
						echo '<div id="album_count_plural"></div>';
						echo '<div class="suggestions_heading" id="album_default">' . $this->translate('You have ') . $this->translate(array('%s album', '%s albums', $this->sugg_count['album']), $this->locale()->toNumber($this->sugg_count['album'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="album"></a><?php
					}
					?>
					<div class="suggestion_view_list" id="<?php echo 'album_' . $row_mix_value[0]['album_id']; ?>">
						<div class="item_photo">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.profile')); ?>
						</div>
						<div class="item_details">
							<b><?php	echo $this->htmlLink($row_mix_value[0], $this->string()->chunk(substr($row_mix_value[0]->getTitle(), 0, 45), 10)); ?></b>
							<div class="description">
								<?php 
									echo $this->translate('By ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle()) . '<br>';
									echo $this->translate(array(' %s photo', ' %s photos', $row_mix_value[0]->count()),$this->locale()->toNumber($row_mix_value[0]->count())) . '<br>';
									echo $this->timestamp($row_mix_value[0]->modified_date) . '<br>';?>
								<?php 
									$album_indicator++;
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This album was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This album was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';	
					  			}
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>View this Album</b>") . ' or ';
								echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'album\');"> ' . $this->translate('Ignore') . ' </a><br><br>';
					?></div>
							</div>						
						</div>
					</div>
					<div style="clear:both"></div>							
					<?php	break;	

				// Display poll.
				case 'poll':?>			
					<?php					
					if($poll_indicator == 0)
					{
						echo '<div id="poll_count_singlar"></div>';
						echo '<div id="poll_count_plural"></div>';
						echo '<div class="suggestions_heading" id="poll_default">' . $this->translate('You have ') . $this->translate(array('%s poll', '%s polls', $this->sugg_count['poll']), $this->locale()->toNumber($this->sugg_count['poll'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="poll"></a><?php
					}?>
					<div class="suggestion_view_list" id="<?php echo 'poll_' . $row_mix_value[0]['poll_id']; ?>">
						<div class="item_photo">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.profile', $row_mix_value[0]->getOwner()->username)); ?>
						</div>
						<div class="item_details">						
							<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()); ?></b>
							<div class="description">
								<?php 
									echo $this->translate('Posted by %s ', $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle()));
									echo $this->timestamp($row_mix_value[0]->creation_date);
									echo $this->translate(array(' - %s vote', ' - %s votes', $row_mix_value[0]->voteCount()), $this->locale()->toNumber($row_mix_value[0]->voteCount()));
									echo $this->translate(array(' - %s view', ' - %s views', $row_mix_value[0]->views), $this->locale()->toNumber($row_mix_value[0]->views)) . '<br/>';
								?>
								<?php 
									$poll_indicator++;
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This poll was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This poll was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}	
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>Vote on this Poll</b>") . ' or ';
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'poll\');"> ' . $this->translate('Ignore') . ' </a><br><br>'; ?>
								</div>
							</div>		
						</div>
					</div>
					<div style="clear:both"></div>
					<?php break;
					
				// Display forum.
				case 'forum':?>			
					<?php if($row_mix_value[0]!==null){
					if($forum_indicator == 0 && ($row_mix_value[0]!==null))
					{
						echo '<div id="forum_count_singlar"></div>';
						echo '<div id="forum_count_plural"></div>';
						echo '<div class="suggestions_heading" id="forum_default">' . $this->translate('You have ') . $this->translate(array('%s forum', '%s forums', $this->sugg_count['forum']), $this->locale()->toNumber($this->sugg_count['forum'])) . $this->translate(' suggestion.') . '</div>';
						?><a name ="forum"></a><?php
					}?>
					<div class="suggestion_view_list" id="<?php echo 'forum_' . $row_mix_value[0]['topic_id']; ?>">
					<div class="item_photo">
					<?php $photo_obj = Engine_Api::_()->getItem('user', $row_mix_value[0]->user_id); ?>
						<?php echo $this->htmlLink($photo_obj->getHref(), $this->itemPhoto($photo_obj->getOwner(), 'thumb.profile')); ?>
					</div>
						<div class="item_details">	
						<?php $forum_name =  Engine_Api::_()->getItem('forum_forum', $row_mix_value[0]->forum_id); ?>					
							<b><?php echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle()) . $this->translate(' in ') . $this->htmlLink($forum_name->getHref(), $forum_name->getTitle()); ?></b>
							<?php $category_title = Engine_Api::_()->getItem('forum_category', $forum_name->category_id)->title; ?>
							<div class="description">
								<?php
									echo $this->translate(array('%s Reply', '%s Replies', $row_mix_value[0]->post_count), $this->locale()->toNumber($row_mix_value[0]->post_count)) . ' | ' . $this->translate(array('%s View', '%s Views', $row_mix_value[0]->view_count), $this->locale()->toNumber($row_mix_value[0]->view_count)) . '<br/>';
									echo $this->translate('Category : ') . $category_title . '<br/>';
									$forum_indicator++;
									// We are found "Sender name" who has send same suggestion of user. 
									$sender_id_value = explode(",", $explode_key[2]);									
									$number_of_suggestion = count($sender_id_value);
									$sender_id_array = array_unique($sender_id_value);
									$sender_name = '';
									foreach($sender_id_array as $sender_id)	{
										$sender_row = Engine_Api::_()->getItem('user', $sender_id);
										$sender = $this->htmlLink($sender_row->getHref(), $sender_row->displayname);
										$sender_name .= ', ' . $sender;
					  			}
					  			if($number_of_suggestion < 2)
					  			{
					  				echo $this->translate("This forum topic was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b>';
					  			}
					  			else {
										echo $this->translate("This forum topic was suggested by") . ' <b>' . ltrim($sender_name, ",") . '</b> (' . $number_of_suggestion . $this->translate(" times") . ')';
					  			}									
								?>
							</div>
							<div class="item_buttons">
								<div id="<?php echo 'sugg_' . $explode_key[3] ?>">
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), "<b>View this Topic</b>") . ' or ';
									echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggestion(\'' . $explode_key[3] . '\', \'forum\');"> ' . $this->translate('Ignore') . ' </a><br><br>'; ?>
								</div>
							</div>		
						</div>
					</div>
					<div style="clear:both"></div>
					<?php } break;
	  	}
	  endforeach;
}
else { ?>

<script type="text/javascript">
function openUrl(url){
	Smoothbox.open(url);
}
</script>
<?php } ?>