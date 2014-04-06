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
  
$event_display_array = array_keys($this->event_display);
$suggestion_msg = count($event_display_array);
$event_sugg_str =  implode(",", $event_display_array);
?>

<script type="text/javascript">
	var event_suggestion_display = "<?php echo $suggestion_msg; ?>";
	display_sugg += ',' + '<?php echo $event_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->event_info as $event):?>
		<div id="event_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
					<?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal')); ?>
				</div>
				<div class="item_details">
					<?php if(empty($this->event_signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $event->event_id . ', \'event_'.$div_id.'\', \'event\', \'event\');"></a>';
					} ?>
					<b><?php	echo $this->htmlLink($event->getHref(), Engine_Api::_()->suggestion()->truncateTitle($event->getTitle()), array('title' => $event->getTitle()))?></b>
					<div class="item_members">
						<?php echo $this->dateTime($event->starttime) . ' | ';
						echo $this->translate(array('%s guest', '%s guests', $event->membership()->getMemberCount()),$this->locale()->toNumber($event->membership()->getMemberCount()));
						echo $this->translate(' led by ') . $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle());
						?>
						</div>
						<div>	
						<?php			
						//Event Relationship.
	  				if(($this->filter != "past") && $this->viewer()->getIdentity() && !$event->membership()->isMember($this->viewer(), null) ):
	  				echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $event->getIdentity()), $this->translate('Join Event'), array('class' => 'buttonlink smoothbox icon_event_join'));
	  				endif;
					$div_id++;
					?>
					</div>
				</div>
			</div>
		</div>
	<?php endforeach; ?>
 <div style="clear:both"></div>
</div>