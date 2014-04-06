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
  
$poll_display_array = array_keys($this->poll_display);
$suggestion_msg = count($poll_display_array);
$poll_sugg_str =  implode(",", $poll_display_array);
?>

<script type="text/javascript">
	var poll_suggestion_display = "<?php echo $suggestion_msg; ?>";
	display_sugg += ',' + '<?php echo $poll_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->poll_info as $poll_dis):?>
		<div id="poll_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
					<?php echo $this->htmlLink($poll_dis->getHref(), $this->itemPhoto($poll_dis->getOwner(), 'thumb.icon', $poll_dis->getOwner()->username)); ?>
				</div>
				<div class="item_details">
					<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $poll_dis->poll_id . ', \'poll_'.$div_id.'\', \'poll\', \'poll\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($poll_dis->getHref(),  Engine_Api::_()->suggestion()->truncateTitle($poll_dis->getTitle()), array('title' => $poll_dis->getTitle())); ?></b>
					<div class="item_members">
						<?php echo $this->translate('Posted by %s ', $this->htmlLink($poll_dis->getOwner(), $poll_dis->getOwner()->getTitle()));
						?><div><?php
						echo $this->timestamp($poll_dis->creation_date);
						echo $this->translate(array(' - %s vote', ' - %s votes', $poll_dis->voteCount()), $this->locale()->toNumber($poll_dis->voteCount()));
						echo $this->translate(array(' - %s view', ' - %s views', $poll_dis->views), $this->locale()->toNumber($poll_dis->views));
						?></div>
						<?php echo $this->htmlLink($poll_dis->getHref(), $this->translate('Vote on Poll'), array('class' => 'buttonlink notification_type_poll_suggestion')); ?>
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