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
  
$music_display_array = array_keys($this->music_display);
$suggestion_msg = count($music_display_array);
$music_sugg_str =  implode(",", $music_display_array);
?>

<script type="text/javascript">
	var music_suggestion_display = '<?php echo $suggestion_msg; ?>';
	display_sugg += ',' + '<?php echo $music_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->music_info as $playlist):?>
		<div id="music_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
						<?php if ($playlist->photo_id) echo $this->htmlLink($playlist->getHref(), $this->itemPhoto($playlist, 'thumb.normal'));
	 							else echo '<img alt="" src="application/modules/Music/externals/images/nophoto_playlist_thumb_icon.png" />'; ?>
				</div>
				<div class="item_details">
					<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $playlist->playlist_id . ', \'music_'.$div_id.'\', \'music\', \'music\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($playlist->getHref(), Engine_Api::_()->suggestion()->truncateTitle($playlist->getTitle()), array('title' => $playlist->getTitle())); ?></b>
					<div class="item_members">
						<div>
						<?php echo $this->translate('Created %s by ', $this->timestamp($playlist->creation_date)) . $this->htmlLink($playlist->getOwner(), $playlist->getOwner()->getTitle());								
						?>
						</div>
						<?php echo $this->htmlLink($playlist->getHref(), $this->translate('Listen to Music'), array('class' => 'buttonlink notification_type_music_suggestion')); ?>
					</div>					
						<?php			
					$div_id++;
					?>							
				</div>
			</div>
		</div>
	<?php endforeach; ?>
 <div style="clear:both"></div>
</div>