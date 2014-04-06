<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: request-forum.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<script type="text/javascript">
var cancelSuggforum = function(notification_id, user_id, object_id)
{
  en4.core.request.send(new Request.HTML({      	
    url : en4.core.baseUrl + 'suggestion/main/notification-cancel',
    data : {
	      format : 'html',		   
	      notification_id : notification_id,
	      object_id : object_id
    }
  }), {
    'element' : $('sugg_forum_' + user_id)
  })
};
</script>
<?php if(!empty($this->forum_object))  {?>
<?php if($this->message != 1){ ?>
<li class="suggestions-newupdate">
<?php	
	$photo_obj = Engine_Api::_()->getItem('user', $this->forum_object->user_id);
	echo $this->htmlLink($photo_obj->getHref(), $this->itemPhoto($photo_obj->getOwner(), 'thumb.icon'), array('style'=>'float:left;'));?>
	<div>
		<div>	
			<?php 
			$forum_name =  Engine_Api::_()->getItem('forum_forum', $this->forum_object->forum_id); 			
			echo $this->sender_name . $this->translate(" has sent you a forum suggestion: ") . $this->htmlLink($this->forum_object->getHref(), $this->forum_object->getTitle()) . $this->translate(' in ') . $this->htmlLink($forum_name->getHref(), $forum_name->getTitle()) . '.'; ?>
		</div>
		<div id="sugg_forum_<?php echo $this->forum_object->topic_id; ?>">
			<?php	echo $this->htmlLink($this->forum_object->getHref(), "View this Forum", array('class'=>'button', 'style'=>'float:left;' )); ?>
			<span style="padding-top:5px;">
				or <?php echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggforum(\'' . $this->notification->notification_id . '\', \'' . $this->forum_object->topic_id . '\', \'' . $this->notification->object_id . '\');"> ' . $this->translate("ignore suggestion") . ' </a><br />';?>
			</span>	
		</div>
	</div>
</li>
<?php } }?>