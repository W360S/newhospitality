<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: request-video.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<script type="text/javascript">
var cancelSuggvideo = function(notification_id, user_id, object_id)
{
  en4.core.request.send(new Request.HTML({      	
    url : en4.core.baseUrl + 'suggestion/main/notification-cancel',
    data : {
	      format : 'html',		   
	      notification_id : notification_id,
	      object_id : object_id
    }
  }), {
    'element' : $('sugg_video_' + user_id)
  })
};
</script>
<?php if(!empty($this->video_object))  {?>
<?php if($this->message != 1){ ?>
<li class="suggestions-newupdate">
	<?php
	if ($this->video_object->photo_id)
	{
		echo $this->htmlLink($this->video_object->getOwner()->getHref(), $this->itemPhoto($this->video_object->getOwner(), 'thumb.icon'),  array('style'=> 'float:left;'));
	}
	else {
		echo '<img alt="" src="application/modules/Video/externals/images/video.png" style="float:left;">';
	} ?>
	<div>
    <div>
			<?php echo $this->sender_name . $this->translate(" has sent you a video suggestion: ") . $this->htmlLink($this->video_object->getHref(), $this->video_object->getTitle()) . '.'; ?>
		</div>
		<div id="sugg_video_<?php echo $this->video_object->video_id; ?>">
			<?php	echo $this->htmlLink($this->video_object->getHref(), "View this Video", array('class'=>'button', 'style'=>'float:left;' )); ?>
			<span style="padding-top:5px;">
				or <?php echo '<a class="disabled" title="' . $this->translate('Cancel this suggestion') . '" href="javascript:void(0);" onclick="cancelSuggvideo(\'' . $this->notification->notification_id . '\', \'' . $this->video_object->video_id . '\', \'' . $this->notification->object_id . '\');"> ' . $this->translate("ignore suggestion") . ' </a><br />';?>
			</span>	
		</div>	
	</div>
</li>
<?php }  }?>