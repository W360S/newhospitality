<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: request-event.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<script type="text/javascript">
var cancelSuggevent = function(notification_id, user_id, object_id)
{
  en4.core.request.send(new Request.HTML({      	
    url : en4.core.baseUrl + 'suggestion/main/notification-cancel',
    data : {
	      format : 'html',		   
	      notification_id : notification_id,
	      object_id : object_id
    }
  }), {
    'element' : $('sugg_event_' + user_id)
  })
};
</script>
<?php if(!empty($this->event_object)) { ?>
<?php if($this->message != 1){ ?>
<li class="suggestions-newupdate">
		<?php	
		$photo_obj = Engine_Api::_()->getItem('user', $this->sender_id);
		echo $this->htmlLink($photo_obj->getHref(), $this->itemPhoto($photo_obj->getOwner(), 'thumb.icon'), array('style'=>'float:left;')); ?>
	<div>
		<div>
			<?php echo $this->sender_name . $this->translate(" has sent you an event suggestion: ") . $this->htmlLink($this->event_object->getHref(), $this->event_object->getTitle()) . '.'; ?>
		</div>	
		<div id="sugg_event_<?php echo $this->event_object->event_id; ?>">
			<?php	echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'member', 'action' => 'join', 'event_id' => $this->event_object->getIdentity()), $this->translate('Join Event'), array('class' => 'smoothbox button', 'style'=>'float:left;' )); ?>	
			<span style="padding-top:5px;">
				or <?php	echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggevent(\'' . $this->notification->notification_id . '\', \'' . $this->event_object->event_id . '\', \'' . $this->notification->object_id . '\');"> ' . $this->translate("ignore suggestion") . ' </a><br />';?>
			</span>
		</div>	
	</div>
</li>
<?php }  }?>