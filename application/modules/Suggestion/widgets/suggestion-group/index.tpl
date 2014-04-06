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
  
$group_display_array = array_keys($this->group_display);
$suggestion_msg = count($group_display_array);
$group_sugg_str =  implode(",", $group_display_array);
?>

<script type="text/javascript">
	var group_suggestion_display = '<?php echo $suggestion_msg; ?>';
	display_sugg += ',' + '<?php echo $group_sugg_str; ?>';
</script>
<div class="suggestion_right_block">
	<?php
		$div_id = 1;
		foreach ($this->group_info as $group_dis):?>
		<div id="group_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
					<?php echo $this->htmlLink($group_dis->getHref(), $this->itemPhoto($group_dis, 'thumb.normal')); ?>
				</div>
				<div class="item_details">
					<?php 
					if(empty($this->signup_user)) {
					echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $group_dis->group_id . ', \'group_' . $div_id . '\', \'group\', \'group\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($group_dis->getHref(), Engine_Api::_()->suggestion()->truncateTitle($group_dis->getTitle()), array('title' => $group_dis->getTitle())); ?></b>
					<div class="item_members">
						<?php			
						echo $this->translate(array('%s member', '%s members', $group_dis->membership()->getMemberCount()),$this->locale()->toNumber($group_dis->membership()->getMemberCount()));
						echo $this->translate(' led by ');
						echo $this->htmlLink($group_dis->getOwner()->getHref(), $group_dis->getOwner()->getTitle());
						$div_id++; ?>
						</div>
						<div>
							<?php 
							//Add group option.
					  	if( $this->viewer()->getIdentity() ):
					   		if(!$group_dis->membership()->isMember($this->viewer(), null) ):
					    		echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $group_dis->getIdentity()), $this->translate('Join Group'), array('class' => 'buttonlink smoothbox icon_group_join', 'style' => 'clear:both;' )) ;
					   		endif; 
			  			endif; ?>
					</div>
				</div>
			</div>
		</div>
	<?php endforeach; ?>
 <div style="clear:both"></div>
</div>