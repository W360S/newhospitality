<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: request-accept.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<script type="text/javascript">
en4.suggestion = {

};

en4.core.setBaseUrl('<?php echo $this->url(array(), 'default', true) ?>');

var userWidgetRequestSend = function(action, user_id, notification_id, friend_display_name)
{
    var identity = 0;
    if( action == 'confirm' )
    {
      url = '<?php echo $this->url(array('controller' => 'friends', 'action' => 'confirm'), 'user_extended', true) ?>';
      var request = en4.suggestion.accepts.notifiAccept(user_id);
      request.addEvent('complete', function(responseJSON)
			{			
				if(responseJSON.status)
				{
					//$('friend_detail_'+ notification_id).innerHTML = responseJSON.friend_detail;
					//$('friend_sub_detail_'+ notification_id).innerHTML = responseJSON.friend_sub_detail;
//				 	$('user-widget-request-' + notification_id).innerHTML = responseJSON.friend_link;
				 	$('user-widget-request-' + notification_id).innerHTML = responseJSON.friend_detail;;
                                        //BANGVN
				}
				else
				{					
					identity = 1;					
				}
			});
    }
    else if( action == 'reject' )
    {
      url = '<?php echo $this->url(array('controller' => 'friends', 'action' => 'reject'), 'user_extended', true) ?>'; 
      identity = 2;     
    }
    else
    {
      return false;
    }

    (new Request.JSON({
      'url' : url,
      'data' : {
        'user_id' : user_id,
        'format' : 'json',
        'token' : '<?php echo $this->token() ?>'
      },
      'onSuccess' : function(responseJSON)
      {
        if( !responseJSON.status )
        {
          $('user-widget-request-' + notification_id).innerHTML = responseJSON.error;
        }
        else
        {
        	if(identity == 2)
        	{
        		$('user-widget-request-' + notification_id).innerHTML = responseJSON.message;
        	}
        	// condition if there are no suggestion then show this message only.
        	if(identity == 1)
        	{
        		$('user-widget-request-' + notification_id).innerHTML = responseJSON.message;
        	}
        }
      }
    })).send();
 }
 
// This function for send request to the suggested friend.
var friendSend = function (friend_id)
{
	var request = en4.suggestion.accepts.sendRequest(friend_id);
	request.addEvent('complete', function(responseJSON) 
	{
		if(responseJSON.status)
		{
			$('userResponce_' + friend_id).innerHTML = responseJSON.responce;
		}
	});
}
 
en4.suggestion.accepts = {	
	// When click on confirm then call this function.
	notifiAccept : function(friend_id)
	{
	  var request = new Request.JSON({   	
	    url : en4.core.baseUrl + 'suggestion/index/notificationaccept',
	    data : {
	      format : 'json',    
	      friend_id : friend_id
	    }
	  });
	  request.send();
	  return request;
	},
	
	// When send request to friend-friends which are display in suggestion then call this function.
	sendRequest : function(friend_id)
	{
	  var request = new Request.JSON({   	
	    url : en4.core.baseUrl + 'suggestion/index/sendfriend',
	    data : {
	      format : 'json',    
	      friend_id : friend_id
	    }
	  });
	  request.send();
	  return request;
	}
};
</script>
<?php /*
<div id="friend_detail_<?php echo $this->notification->notification_id ?>"></div>
<div class="sugg-friend-sub-detail" id="friend_sub_detail_<?php echo $this->notification->notification_id ?>"></div>
<li id="user-widget-request-<?php echo $this->notification->notification_id ?>" class="suggestions-newupdate">
  <?php echo $this->itemPhoto($this->notification->getSubject(), 'thumb.icon'); ?>
  <div>
    <div>
      <?php echo $this->translate('%1$s has sent you a friend request.', $this->htmlLink($this->notification->getSubject()->getHref(), $this->notification->getSubject()->getTitle())); ?>
    </div>
    <div>
	<button type="submit" onclick="userWidgetRequestSend('confirm', <?php echo $this->notification->getSubject()->getIdentity() ?>, <?php echo $this->notification->notification_id ?>, '<?php echo $this->notification->getSubject()->getTitle(); ?>')">
        <?php echo $this->translate('Add Friend');?>
      </button>
      <?php echo $this->translate('or');?>
      <a href="javascript:void(0);" onclick="userWidgetRequestSend('reject', <?php echo $this->notification->getSubject()->getIdentity() ?>, <?php echo $this->notification->notification_id ?>, '<?php echo $this->notification->getSubject()->getTitle(); ?>');">
        <?php echo $this->translate('ignore request');?>
      </a>
    </div>
  </div>
</li>
 * 
 */?>
<div id="friend_detail_<?php echo $this->notification->notification_id ?>"></div>
<div class="sugg-friend-sub-detail" id="friend_sub_detail_<?php echo $this->notification->notification_id ?>"></div>
<li id="user-widget-request-<?php echo $this->notification->notification_id ?>" class="suggestions-newupdate">
    <a href="#">
        <span class="pt-avatar">
            <?php echo $this->itemPhoto($this->notification->getSubject(), 'thumb.icon'); ?>
        </span>
    </a>
    <div class="pt-how-info-request">
            <div class="pt-how-info-request-left">
                    <h3><?php echo $this->htmlLink($this->notification->getSubject()->getHref(), $this->notification->getSubject()->getTitle()) ?></h3>
                    <p>1 Bạn chung</p>
            </div>
            <div class="pt-how-info-request-right">
                    <a href="javascript:void(0)" class="pt-yes" onclick="userWidgetRequestSend('confirm', <?php echo $this->notification->getSubject()->getIdentity() ?>, <?php echo $this->notification->notification_id ?>, '<?php //echo $this->notification->getSubject()->getTitle(); ?>')">
                        <?php echo $this->translate('Add Friend');?>
                    </a>
                    <a href="javascript:void(0)" onclick="userWidgetRequestSend('reject', <?php echo $this->notification->getSubject()->getIdentity() ?>, <?php echo $this->notification->notification_id ?>, '<?php //echo $this->notification->getSubject()->getTitle(); ?>');">
                        <?php echo $this->translate('Ignore');?>
                    </a>
            </div>
    </div>
</li>