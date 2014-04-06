<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: request-poll.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<script type="text/javascript">
var cancelSuggpoll = function(notification_id, user_id, object_id)
{
  en4.core.request.send(new Request.HTML({      	
    url : en4.core.baseUrl + 'suggestion/main/notification-cancel',
    data : {
	      format : 'html',		   
	      notification_id : notification_id,
	      object_id : object_id
    }
  }), {
    'element' : $('sugg_poll_' + user_id)
  })
};
</script>
<?php if(!empty($this->poll_object)) { ?>
<?php if($this->message != 1){ ?>
<li class="suggestions-newupdate">
	<?php	echo $this->htmlLink($this->poll_object->getHref(), $this->itemPhoto($this->poll_object->getOwner(), 'thumb.icon', $this->poll_object->getOwner()->username), array('style'=>'float:left;')); ?>
	<div>
		<div>
			<?php echo $this->sender_name . $this->translate(" has sent you a poll suggestion: ") . $this->htmlLink($this->poll_object->getHref(), $this->poll_object->getTitle()) . '.'; ?>
		</div>	
		<div id="sugg_poll_<?php echo $this->poll_object->poll_id; ?>">
			<?php	echo $this->htmlLink($this->poll_object->getHref(), "Vote on this Poll", array('class'=>'button', 'style'=>'float:left;' )); ?>
			<span style="padding-top:5px;">
				or <?php echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggpoll(\'' . $this->notification->notification_id . '\', \'' . $this->poll_object->poll_id . '\', \'' . $this->notification->object_id . '\');"> ' . $this->translate("ignore suggestion") . ' </a><br />';?>
			</span>	
		</div>	
	</div>
</li>
<?php }  }?>