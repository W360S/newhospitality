<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: index.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
$this->headScript()->appendFile('application/modules/Suggestion/externals/scripts/core.js');
$div_id = 1;
//Make string for mx suggestion display user.
$mix_sugg_key_array = array_keys($this->mix_display_sugg);
$mix_dis_sugg_str = implode(",", $mix_sugg_key_array);
?>

<script type="text/javascript">
	function fewPopup (sugg_id) {
		var baseurl_temp = "<?php echo $this->base_url; ?>";
		Smoothbox.open(baseurl_temp + '/suggestion/index/requestsend/few_id/' + sugg_id);
	}
	var mix_suggestion_display = "<?php echo count($this->mix_wid_dis_num); ?>";//Number of display suggestion.
  display_sugg += ',' + '<?php echo $mix_dis_sugg_str; ?>';//Widget which are display.
  en4.core.setBaseUrl('<?php echo $this->url(array(), 'default', true) ?>');
</script>
<div class="suggestion_right_block">
<?php
foreach ($this->mix_display_sugg as $row_mix_key => $row_mix_value)
{	
	$key_str = '';
	$key_str .= ',' . $row_mix_key;
	$row_widget = explode("_", $row_mix_key);
	switch ($row_widget[0])
	{//Display group.
		case 'group':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
							</div>
							<div class="item_details">
								<?php 
								if(empty($this->signup_user)) {
								echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->group_id . ', \'mix_'.$div_id.'\', \'group\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
								<div class="item_members">
									<?php
									echo $this->translate(array('%s member', '%s members', $row_mix_value[0]->membership()->getMemberCount()),$this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
									echo $this->translate(' led by ');
									echo $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
									$div_id++; ?>
									</div>
									<div>
										<?php 
										//Add group option.
								  	if( $this->viewer()->getIdentity() ):
								   		if(!$row_mix_value[0]->membership()->isMember($this->viewer(), null) ):
								    		echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Group'), array('class' => 'buttonlink smoothbox icon_group_join', 'style' => 'clear:both;' )) ;
								   		endif;
						  			endif; ?>
								</div>
							</div>
						</div>
					</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		// Display blog.
		case 'blog':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.icon')); ?>
							</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->blog_id . ', \'mix_'.$div_id.'\', \'blog\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
								<div class="item_members">
									<div>
									<?php echo $this->translate(' Posted ') . $this->timestamp(strtotime($row_mix_value[0]->creation_date));
									echo $this->translate(' by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
									?></div>
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Blog'), array('class' => 'buttonlink notification_type_blog_suggestion')); ?>
									</div>					
									<?php			
								$div_id++;
								?>				
							</div>
						</div>
					</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		// Display Event.
		case 'event':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
							</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->event_id . ', \'mix_'.$div_id.'\', \'event\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())) ?></b>
								<div class="item_members">
									<?php 
									//echo $this->dateTime($row_mix_value[0]->starttime). ' | ';
									//echo date('d-m-Y',$row_mix_value[0]->starttime). ' | ';
									echo $row_mix_value[0]->starttime . ' | ';
									echo $this->translate(array('%s guest', '%s guests', $row_mix_value[0]->membership()->getMemberCount()),$this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
									echo $this->translate(' led by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
									?>
									</div>
									<div>	
									<?php			
									//Event Relationship.
				  				if(($this->filter != "past") && $this->viewer()->getIdentity() && !$row_mix_value[0]->membership()->isMember($this->viewer(), null) ):
				  				echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Event'), array('class' => 'buttonlink smoothbox icon_event_join'));
				  				endif;
								$div_id++;
								?>
								</div>
							</div>
						</div>
					</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		// Display Album.
		case 'album':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
							</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->album_id . ', \'mix_'.$div_id.'\', \'album\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0], $this->string()->chunk(substr(Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), 0, 45), 10), array('title' => $row_mix_value[0]->getTitle())); ?></b>
								<div class="item_members">
									<?php echo $this->translate('By ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
									echo '<div>' . $this->translate(array(' %s photo', ' %s photos', $row_mix_value[0]->count()),$this->locale()->toNumber($row_mix_value[0]->count())) . '</div>';
									echo '<div>' . $this->timestamp($row_mix_value[0]->modified_date) . '</div>';
									?>
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Album'), array('class' => 'buttonlink notification_type_album_suggestion')); ?>
									</div>					
									<?php			
								$div_id++;
								?>				
							</div>
						</div>
					</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		// Display Classified.
		case 'classified':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
							</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->classified_id . ', \'mix_'.$div_id.'\', \'classified\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
								<div class="item_members">
									<div>
									<?php echo $this->translate('Posted ') . $this->timestamp(strtotime($row_mix_value[0]->creation_date));
									echo $this->translate(' by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
									?></div>
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Classified'), array('class' => 'buttonlink notification_type_classified_suggestion')); ?>
									</div>					
									<?php			
								$div_id++;
								?>				
							</div>
						</div>
					</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		// Display Video.	
		case 'video':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
								<?php if ($row_mix_value[0]->photo_id) echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal'));
				 							else echo '<img alt="" src="application/modules/Video/externals/images/video.png">'; ?>
							</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->video_id . ', \'mix_'.$div_id.'\', \'video\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
								<div class="item_members">
									<?php echo $this->translate('by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());									
									echo '<div>' . $this->translate(array(' %s view', ' %s views', $row_mix_value[0]->view_count),$this->locale()->toNumber($row_mix_value[0]->view_count)) . '</div>';
									?>
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Video'), array('class' => 'buttonlink notification_type_video_suggestion')); ?>
									</div>					
									<?php			
								$div_id++;
								?>				
							</div>
						</div>
					</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		// Display Music.	
		case 'music':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
									<?php if ($row_mix_value[0]->photo_id) echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal'));
				 							else echo '<img alt="" src="application/modules/Music/externals/images/nophoto_playlist_thumb_icon.png" />'; ?>
							</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->playlist_id . ', \'mix_'.$div_id.'\', \'music\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
								<div class="item_members">
									<div>
									<?php echo $this->translate('Created %s by ', $this->timestamp($row_mix_value[0]->creation_date)) . $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle());										
									?></div>
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('Listen to Music'), array('class' => 'buttonlink notification_type_music_suggestion')); ?>
									</div>					
									<?php			
								$div_id++;
								?>		
							</div>
							</div>
						</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		 //Display message suggestion.
		case 'messagefriend':?>
				<div id="mix_<?php echo $div_id; ?>">
					<div class="suggestion_list">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.icon'), array('class' => 'item_photo')); ?>
						<div class="item_details">
							<?php echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->user_id . ', \'mix_'.$div_id.'\', \'messagefriend\', \'mix\');"></a>';
								?>
						<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
							<div class="item_members">
								<?php
									$site_name = Engine_Api::_()->getApi('settings', 'core')->getSetting('core.general.site.title'); 
									echo $this->translate("You haven't talked on") . ' ' . $site_name . ' ' . $this->translate(" lately."); 
								?>
							</div>
							<div><a style="background-image: url('application/modules/Messages/externals/images/send.png');" class="buttonlink" href="<?php echo $this->sugg_baseUrl; ?>/messages/compose/to/<?php echo $row_mix_value[0]->user_id; ?>"><?php echo $this->translate('Send Message'); ?></a></div>
						</div></div>
						<?php			
					$div_id++;
					?>
				</div>
			 <div style="clear:both"></div><?php
		break;
		
		 //Display Few friend suggestion.
		case 'friendfewfriend':?>
				<div id="mix_<?php echo $div_id; ?>">
					<div class="suggestion_list">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.icon'), array('class' => 'item_photo')); ?>
						<div class="item_details">
								<?php echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->user_id . ', \'mix_'.$div_id.'\', \'friendfewfriend\', \'mix\');"></a>';
								?>
							<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
							<div class="item_members">
								<?php echo $this->translate('Help ') . $row_mix_value[0]->displayname . $this->translate(' find more friends.'); ?>
							</div>
							<div>							
							<?php 
							$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();							
							// Check that if friend have at least 1 suggestion then open popup else popup will not open.											
								$check_network_friend = Engine_Api::_()->suggestion()->few_friend_suggestion($user_id, $row_mix_value[0]->user_id, '', 1, '');
									echo '<a href="javascript:void(0);" onclick="fewPopup(' . $row_mix_value[0]->user_id . ');" class="buttonlink notification_type_friend_suggestion">' . $this->translate("Suggest Friends") . '</a>';
							?>
	             </div>
							</div>
						</div>
						<?php			
					$div_id++;
					?>
				</div>
			 <div style="clear:both"></div><?php
		break;
		
		 //Display photo friend suggestion.
		case 'friendphoto':?>
				<div id="mix_<?php echo $div_id; ?>">
					<div class="suggestion_list">
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.icon'), array('class' => 'item_photo')); ?>
						<div class="item_details">
								<?php echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->user_id . ', \'mix_'.$div_id.'\', \'friendphoto\', \'mix\');"></a>';
								?>
						<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
							<div class="item_members">
								<?php echo $row_mix_value[0]->getTitle() . ' ' . $this->translate('needs a profile picture.'); ?>
							</div>
							<div>
							<?php 
								echo $this->htmlLink(array('route' => 'default', 'module' => 'suggestion', 'controller' => 'index', 'action' => 'profile-picture', 'id' => $row_mix_value[0]->user_id), $this->translate('Suggest Picture'), array('class' => 'buttonlink notification_type_picture_suggestion smoothbox'));
	            ?>
	            </div>
						</div></div>
						<?php			
					$div_id++;
					?>
				</div>
			 <div style="clear:both"></div><?php
		break;
		
		 //Display photo friend suggestion.
		case 'friend':?>
			<div id="mix_<?php echo $div_id; ?>">
				<div class="suggestion_list">
					<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.icon'), array('class' => 'item_photo')); ?>
					<div class="item_details">
						<?php echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->user_id . ', \'mix_'.$div_id.'\', \'friend\', \'mix\');"></a>';
						?>
						<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
						<div><?php 
							if(!empty($this->mutual_friend_array[$row_mix_value[0]->user_id]))
							{
					 			echo '<a class="smoothbox" href="' . $this->url(array('module' => 'suggestion', 'controller' => 'index', 'action' => 'mutualfriend', 'sugg_friend_id' => $row_mix_value[0]->user_id), 'default', true) . '">' . $this->translate(array('%s mutual friend', '%s mutual friends', $this->mutual_friend_array[$row_mix_value[0]->user_id]),$this->locale()->toNumber($this->mutual_friend_array[$row_mix_value[0]->user_id])) . '</a>'; }?></div>
						<div><?php echo $this->userFriendship($row_mix_value[0]); ?></div>
					</div>
				</div>
						<?php			
					$div_id++;
					?>
				</div>
			 <div style="clear:both"></div><?php
		break;
		
		
		// Display poll.
		case 'poll':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
							<div class="item_photo">
								<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.icon', $row_mix_value[0]->getOwner()->username)); ?>
							</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->poll_id . ', \'mix_'.$div_id.'\', \'poll\', \'mix\');"></a>';
								} ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle())); ?></b>
								<div class="item_members">
									<?php echo $this->translate('Posted by %s ', $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle()));
									?><div><?php
									echo $this->timestamp($row_mix_value[0]->creation_date);
									echo $this->translate(array(' - %s vote', ' - %s votes', $row_mix_value[0]->voteCount()), $this->locale()->toNumber($row_mix_value[0]->voteCount()));
									echo $this->translate(array(' - %s view', ' - %s views', $row_mix_value[0]->views), $this->locale()->toNumber($row_mix_value[0]->views));
									?></div>
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('Vote on Poll'), array('class' => 'buttonlink notification_type_poll_suggestion')); ?>
									</div>					
									<?php			
								$div_id++;
								?>				
							</div>
						</div>
					</div>
			 <div style="clear:both"></div>
			<?php
			break;
			
		// Display forum.
		case 'forum':?>
					<div id="mix_<?php echo $div_id; ?>">
						<div class="suggestion_list">
						<div class="item_photo">
						<?php $photo_obj = Engine_Api::_()->getItem('user', $row_mix_value[0]->user_id); ?>
							<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($photo_obj->getOwner(), 'thumb.icon')); ?>
						</div>
							<div class="item_details">
								<?php if(empty($this->signup_user)) {
							echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->topic_id . ', \'mix_'.$div_id.'\', \'forum\', \'mix\');"></a>';
								} ?>
								<?php $forum_name =  Engine_Api::_()->getItem('forum_forum', $row_mix_value[0]->forum_id); ?>
								<b><?php	echo $this->htmlLink($row_mix_value[0]->getHref(),  Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));?></b>
								
								<div class="item_members">							
									<?php echo  $this->translate(' in ') . $this->htmlLink($forum_name->getHref(), Engine_Api::_()->suggestion()->truncateTitle($forum_name->getTitle()), array('title' => $forum_name->getTitle())); ?>
									<div>
										<?php echo $this->translate(array('%s Reply', '%s Replies', $row_mix_value[0]->post_count), $this->locale()->toNumber($row_mix_value[0]->post_count)) . ' | ' . $this->translate(array('%s View', '%s Views', $row_mix_value[0]->view_count), $this->locale()->toNumber($row_mix_value[0]->view_count)) . '<br/>';
										$category_title = Engine_Api::_()->getItem('forum_category', $forum_name->category_id)->title;
										echo $this->translate('Category : ') . $category_title; ?>
									</div>					
									<?php	
									$div_id++;
									?>
									<?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Forum Topic'), array('class' => 'buttonlink notification_type_forum_suggestion')); ?>				
							</div>
						</div>
					</div>
				</div>
			 <div style="clear:both"></div>
			<?php
			break;
	}
}
?>
</div>