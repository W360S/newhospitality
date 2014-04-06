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
  
$video_display_array = array_keys($this->video_display);
$suggestion_msg = count($video_display_array);
$video_sugg_str =  implode(",", $video_display_array);
?>

<script type="text/javascript">
	var video_suggestion_display = "<?php echo $suggestion_msg; ?>";
	display_sugg += ',' + '<?php echo $video_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->video_info as $video_dis):?>
		<div id="video_suggestion_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
					<?php if ($video_dis->photo_id) echo $this->htmlLink($video_dis->getHref(), $this->itemPhoto($video_dis, 'thumb.normal'));
	 							else echo '<img alt="" src="application/modules/Video/externals/images/video.png">'; ?>
				</div>
				<div class="item_details">
					<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $video_dis->video_id . ', \'video_suggestion_'.$div_id.'\', \'video\', \'video\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($video_dis->getHref(), Engine_Api::_()->suggestion()->truncateTitle($video_dis->getTitle()), array('title' => $video_dis->getTitle())); ?></b>
					<div class="item_members">
						<?php echo $this->translate('by ') . $this->htmlLink($video_dis->getOwner()->getHref(), $video_dis->getOwner()->getTitle());
						echo '<div>' . $this->translate(array(' %s view', ' %s views', $video_dis->view_count),$this->locale()->toNumber($video_dis->view_count)) . '</div>';
						?>
						<?php echo $this->htmlLink($video_dis->getHref(), $this->translate('View Video'), array('class' => 'buttonlink notification_type_video_suggestion')); ?>
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