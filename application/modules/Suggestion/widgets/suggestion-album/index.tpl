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
  
$album_display_array = array_keys($this->album_display);
$suggestion_msg = count($album_display_array);
$album_sugg_str =  implode(",", $album_display_array);
?>

<script type="text/javascript">
	var album_suggestion_display = "<?php echo $suggestion_msg; ?>";
	display_sugg += ',' + '<?php echo $album_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->album_info as $album_dis):?>
		<div id="album_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
					<?php echo $this->htmlLink($album_dis->getHref(), $this->itemPhoto($album_dis, 'thumb.normal')); ?>
				</div>
				<div class="item_details">
					<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $album_dis->album_id . ', \'album_'.$div_id.'\', \'album\', \'album\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($album_dis, $this->string()->chunk(substr(Engine_Api::_()->suggestion()->truncateTitle($album_dis->getTitle()), 0, 45), 10), array('title' => $album_dis->getTitle())); ?></b>
					<div class="item_members">
						<?php echo $this->translate('By ') . $this->htmlLink($album_dis->getOwner()->getHref(), $album_dis->getOwner()->getTitle());						
						echo '<div>' . $this->translate(array(' %s photo ', ' %s photos ', $album_dis->count()),$this->locale()->toNumber($album_dis->count())) . '</div>';
						echo '<div>' . $this->timestamp($album_dis->modified_date) . '</div>';
						?>
						<?php echo $this->htmlLink($album_dis->getHref(), $this->translate('View Album'), array('class' => 'buttonlink notification_type_album_suggestion')); ?>
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