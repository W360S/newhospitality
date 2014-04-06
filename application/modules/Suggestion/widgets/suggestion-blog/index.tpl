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
  
$blog_display_array = array_keys($this->blog_display);
$suggestion_msg = count($blog_display_array);
$blog_sugg_str =  implode(",", $blog_display_array);
?>

<script type="text/javascript">
	var blog_suggestion_display = "<?php echo $suggestion_msg; ?>";
	display_sugg += ',' + '<?php echo $blog_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->blog_info as $blog_dis):?>
		<div id="blog_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
					<?php echo $this->htmlLink($blog_dis->getHref(), $this->itemPhoto($blog_dis->getOwner(), 'thumb.icon')); ?>
				</div>
				<div class="item_details">
					<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $blog_dis->blog_id . ', \'blog_'.$div_id.'\', \'blog\', \'blog\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($blog_dis->getHref(), Engine_Api::_()->suggestion()->truncateTitle($blog_dis->getTitle()), array('title' => $blog_dis->getTitle())); ?></b>
					<div class="item_members">
						<div>
						<?php echo $this->translate(' Posted ') . $this->timestamp(strtotime($blog_dis->creation_date));
						echo $this->translate(' by ') . $this->htmlLink($blog_dis->getOwner()->getHref(), $blog_dis->getOwner()->getTitle());
						?>
						</div>
						<?php echo $this->htmlLink($blog_dis->getHref(), $this->translate('View Blog'), array('class' => 'buttonlink notification_type_blog_suggestion')); ?>
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