<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: mutualfriend.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<div class="mutual_friend_popup_wrapper">
	<div class="mutual_friend_popup">
		<?php echo '<h3>' . $this->translate("Mutual Friends") . '</h3>'; ?>
		<div class="mutual_friend_popup_content">
			<?php foreach ($this->friend_obj as $friend_info) { ?>
				<div class="sugg_mutual_friend">
					<?php echo $this->htmlLink($friend_info->getHref(), $this->itemPhoto($friend_info, 'thumb.icon'), array('class' => 'user-icon', 'target' => '_parent')); ?>
					<div><?php echo $this->htmlLink($friend_info->getHref(), $friend_info->getTitle(), array('title' => $friend_info->getTitle())); ?></div>
					<div class="clr"></div>
				</div>
			<?php } ?>
		</div>
	</div>
</div>
<div style="float:right;">
	<button type='button' style="margin:10px 0 0 15px;" onclick="parent.Smoothbox.close();"><?php echo $this->translate("Close"); ?></button>
</div>