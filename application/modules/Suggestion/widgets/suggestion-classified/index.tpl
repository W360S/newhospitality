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
  
$classified_display_array = array_keys($this->classified_display);
$suggestion_msg = count($classified_display_array);
$classified_sugg_str =  implode(",", $classified_display_array);
?>

<script type="text/javascript">
	var classified_suggestion_display = "<?php echo $suggestion_msg; ?>";
	display_sugg += ',' + '<?php echo $classified_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->classified_info as $classified_dis):?>
		<div id="classified_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
					<?php echo $this->htmlLink($classified_dis->getHref(), $this->itemPhoto($classified_dis, 'thumb.normal')); ?>
				</div>
				<div class="item_details">
					<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $classified_dis->classified_id . ', \'classified_'.$div_id.'\', \'classified\', \'classified\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($classified_dis->getHref(), Engine_Api::_()->suggestion()->truncateTitle($classified_dis->getTitle()), array('title' => $classified_dis->getTitle())); ?></b>
					<div class="item_members">
						<div>
						<?php echo $this->translate('Posted ') . $this->timestamp(strtotime($classified_dis->creation_date));
						echo $this->translate(' by ') . $this->htmlLink($classified_dis->getOwner()->getHref(), $classified_dis->getOwner()->getTitle());
						?>
						</div>
						<?php echo $this->htmlLink($classified_dis->getHref(), $this->translate('View Classified'), array('class' => 'buttonlink notification_type_classified_suggestion')); ?>
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