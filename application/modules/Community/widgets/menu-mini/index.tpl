<style type='text/css'>
	/*#search_per_page .personal_breadcrumb ul li{float: right; padding:0 10px; line-height:14px;}
	.border_left{border-left:solid 1px ;}
	.layout_middle{overflow:visible;}*/
</style>
<!-- Autocomplete -->
<?php
  $this->headScript()
    ->appendFile($this->baseUrl().'/externals/autocompleter/Observer.js')
    ->appendFile($this->baseUrl().'/externals/autocompleter/Autocompleter.js')
    ->appendFile($this->baseUrl().'/externals/autocompleter/Autocompleter.Local.js')
    ->appendFile($this->baseUrl().'/externals/autocompleter/Autocompleter.Request.js');
?>
<style type="text/css">
.calltoaction {
background-color: #F7F7F7;
border-bottom:medium #DDDDDD;
display:block;
margin:2px 0 -2px;
min-height:1px;
padding:8px;
text-align:center;
}
ul.message-autosuggestfix {
    top : 24px;
    left : 0;    
}
</style>
<script type="text/javascript">
  var maxRecipients = 10;

  en4.core.runonce.add(function() {
      //var tokens = <?php echo $this->friends ?>;
      new Autocompleter.Request.JSON('global_search_field', '<?php echo $this->url(array('module' => 'user', 'controller' => 'friends', 'action' => 'suggest'), 'default', true) ?>', {
        'minLength': 1,
        'delay' : 250,
        'width' : 185,
        'selectMode': 'pick',
        'autocompleteType': 'message',
        'multiple': false,
        'className': 'message-autosuggest message-autosuggestfix',
        'filterSubset' : true,
        'viewmore' : true,
        'tokenFormat' : 'object',
        'tokenValueKey' : 'label',
        'injectChoice': function(token){
          if(token.type == 'user'){
            var choice = new Element('li', {'class': 'autocompleter-choices', 'html': token.photo, 'id':token.label});
            new Element('div', {'html': '<a href="'+en4.core.baseUrl+ 'profile/' +token.username + '">' + this.markQueryValue(token.label) + '</a>','class': 'autocompleter-choice'}).inject(choice);
            this.addChoiceEvents(choice).inject(this.choices);
            choice.store('autocompleteChoice', token);
          }
           
        },
        onPush : function(){
          if( $('toValues').value.split(',').length >= maxRecipients ){
            $('to').disabled = true;
          }
        }
      });

      <?php if( isset($this->toUser) && $this->toUser->getIdentity() ): ?>

      var toID = <?php echo $this->toUser->getIdentity() ?>;
      var name = '<?php echo $this->toUser->getTitle() ?>';
      var myElement = new Element("span");
      myElement.id = "tospan" + toID;
      myElement.setAttribute("class", "tag");
      myElement.innerHTML = name + " <a href='javascript:void(0);' onclick='this.parentNode.destroy();removeFromToValue(\""+toID+"\");'>x</a>";
      $('toValues-element').appendChild(myElement);
      $('toValues-wrapper').setStyle('height', 'auto');
      
      <?php endif; ?>

      <?php if( isset($this->multi)): ?>

      var multi_type = '<?php echo $this->multi; ?>';
      var toIDs = '<?php echo $this->multi_ids; ?>';
      var name = '<?php echo $this->multi_name; ?>';
      var myElement = new Element("span");
      myElement.id = "tospan_"+name+"_"+toIDs;
      myElement.setAttribute("class", "tag tag_"+multi_type);
      myElement.innerHTML = name + " <a href='javascript:void(0);' onclick='this.parentNode.destroy();removeFromToValue(\""+toIDs+"\");'>x</a>";
      $('toValues-element').appendChild(myElement);
      $('toValues-wrapper').setStyle('height', 'auto');

      <?php endif; ?>

    });


  en4.core.runonce.add(function(){
    new OverText($('to'), {
      'textOverride' : '<?php echo $this->translate('Start typing...') ?>',
      'element' : 'label',
      'positionOptions' : {
        position: ( en4.orientation == 'rtl' ? 'upperRight' : 'upperLeft' ),
        edge: ( en4.orientation == 'rtl' ? 'upperRight' : 'upperLeft' ),
        offset: {
          x: ( en4.orientation == 'rtl' ? -4 : 4 ),
          y: 2
        }
      }
    });
  });
</script>
<!-- Search form -->
<script type="text/javascript">
Element.Events.keyenter = {
	base: 'keyup',
	condition: function(e){
		return e.key=='enter';
	}
};

window.addEvent('domready', function(){
	// Here we add the custom event to the input-element
	$('global_search_field').addEvent('keyenter', function(e){
	   var search = jQuery('#global_search_field').val();
       alert(search); 
	   if(search != '')
	   window.location.href = '<?php echo $this->baseUrl() ?>/search?query=' + search;
	});	
	
});

window.addEvent('domready',function(){
    jQuery('#global_search_submit').click(function(){
        jQuery('#global_search_form').submit();      
    });
});
</script>

<div id='search_per_page' style="z-index:50;">
    <?php if($this->search_check):?>
      <fieldset>
        <form id="global_search_form" action="<?php echo $this->url(array('controller' => 'search'), 'default', true) ?>" method="get">
          <input type='text' class='text suggested' name='query' id='global_search_field' size='20' maxlength='100' alt='<?php echo $this->translate('Search') ?>' />          
          <input id="global_search_submit" class="button" type="submit" value="" />
        </form>
      </fieldset>
    <?php endif;?>
    <div class="personal_breadcrumb">
		<ul>
            <?php if( $this->viewer->getIdentity()) :?>
            <!-- Update -->
            <li id='core_menu_mini_menu_update' class="update_menu">
              <span onclick="toggleUpdatesPulldown(event, this, '4','notification');" style="display: inline-block;" class="updates_pulldown">
                <div class="pulldown_contents_wrapper">
                  <div class="pulldown_contents">
                    <ul class="notifications_menu" id="notifications_menu_notification">
                      <div class="notifications_loading" id="notifications_loading_notification">
                        <img src="<?php echo $this->baseUrl() ?>/application/modules/Core/externals/images/loading.gif" style="float:left; margin-right: 5px;" />
                        <?php echo $this->translate("Loading ...") ?>
                      </div>
                    </ul>
                  </div>
                  <div class="pulldown_options view_mark">
                    <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'activity', 'controller' => 'notifications'),
                       $this->translate('View All Updates'),
                       array('id' => 'notifications_viewall_link')) ?>
                    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Mark All Read'), array(
                      'id' => 'notifications_markread_link',
                    )) ?>
                  </div>
                </div>
                <a href="javascript:void(0);" id="updates_toggle" <?php if( $this->notificationCount ):?> class="new_updates"<?php endif;?>><?php echo $this->translate(array('%s Update', '%s Updates', $this->notificationCount), $this->locale()->toNumber($this->notificationCount)) ?></a>
              </span>
            </li>
            <!-- Msg -->
            <li id='core_menu_mini_menu_update' class="update_menu">
              <span onclick="toggleUpdatesPulldown(event, this, '4','message');" style="display: inline-block;" class="updates_pulldown">
                <div class="pulldown_contents_wrapper">
                  <div class="pulldown_contents">
                    <ul class="notifications_menu" id="notifications_menu_message">
                      <div class="notifications_loading" id="notifications_loading_message">
                        <img src="<?php echo $this->baseUrl() ?>/application/modules/Core/externals/images/loading.gif" style="float:left; margin-right: 5px;" />
                        <?php echo $this->translate("Loading ...") ?>
                      </div>
                    </ul>
                  </div>
                  <div class="pulldown_options view_mark">
                    <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'activity', 'controller' => 'notifications'),
                       $this->translate('View All Updates'),
                       array('id' => 'notifications_viewall_link')) ?>
                    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Mark All Read'), array(
                      'id' => 'notifications_markread_link',
                    )) ?>
                  </div>
                </div>
                <a href="javascript:void(0);" id="updates_toggle" <?php if( $this->notificationCountMsg ):?> class="new_updates"<?php endif;?>><?php echo $this->translate(array('%s Message', '%s Messages', $this->notificationCountMsg), $this->locale()->toNumber($this->notificationCountMsg)) ?></a>
              </span>
            </li>
            <li id='core_menu_mini_menu_update' class="update_menu">
              <span onclick="toggleUpdatesPulldown(event, this, '4','friend');" style="display: inline-block;" class="updates_pulldown">
                <div class="pulldown_contents_wrapper">
                  <div class="pulldown_contents">
                    <ul class="notifications_menu" id="notifications_menu_friend">
                      <div class="notifications_loading" id="notifications_loading_friend">
                        <img src="<?php echo $this->baseUrl() ?>/application/modules/Core/externals/images/loading.gif" style="float:left; margin-right: 5px;" />
                        <?php echo $this->translate("Loading ...") ?>
                      </div>
                    </ul>
                  </div>
                  <div class="pulldown_options view_mark">
                    <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'activity', 'controller' => 'notifications'),
                       $this->translate('View All Updates'),
                       array('id' => 'notifications_viewall_link')) ?>
                    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Mark All Read'), array(
                      'id' => 'notifications_markread_link',
                    )) ?>
                  </div>
                </div>
                <a href="javascript:void(0);" id="updates_toggle" <?php if( $this->notificationCountFriend ):?> class="new_updates"<?php endif;?>><?php echo $this->translate(array('%s Friend request', '%s Friends request', $this->notificationCountFriend), $this->locale()->toNumber($this->notificationCountFriend)) ?></a>
              </span>
            </li>
            <?php endif; ?>
            <li>|</li>
			<li><a href="<?php echo $this->baseUrl().'/profile/'.$this->viewer()->username;?>">My profile</a></li>
			<li>|</li>
			<li class="hasPanel">
				<a class="item" href="<?php echo $this->baseUrl().'/userprofile/setting';?>">Setting<span></span></a>
				<div class="panel application">
					<div class="list">
						<ul>
							<li><a href="<?php echo $this->baseUrl().'/userprofile/setting#account';?>"><?php echo $this->translate('Account Settings');?></a></li>
							<li><a href="<?php echo $this->baseUrl().'/userprofile/setting#privacy';?>"><?php echo $this->translate('Privacy Settings');?></a></li>
							<li><a href="<?php echo $this->baseUrl().'/userprofile/setting#notification';?>"><?php echo $this->translate('Notification Settings');?></a></li>
							
						</ul>
					</div>
				</div>
			</li>
		</ul>
	</div>
</div>


<script type='text/javascript'>
  var notificationUpdater;

  en4.core.runonce.add(function(){
    new OverText($('global_search_field'), {
      poll: true,
      pollInterval: 500,
      positionOptions: {
        position: ( en4.orientation == 'rtl' ? 'upperRight' : 'upperLeft' ),
        edge: ( en4.orientation == 'rtl' ? 'upperRight' : 'upperLeft' ),
        offset: {
          x: ( en4.orientation == 'rtl' ? -4 : 4 ),
          y: 2
        }
      }
    });

    if($('notifications_markread_link')){
      $('notifications_markread_link').addEvent('click', function() {
        //$('notifications_markread').setStyle('display', 'none');
        en4.activity.hideNotifications('<?php echo $this->string()->escapeJavascript($this->translate("0 Updates"));?>');
      });
    }

    <?php if ($this->updateSettings && $this->viewer->getIdentity()): ?>
    notificationUpdater = new NotificationUpdateHandler({
              'delay' : <?php echo $this->updateSettings;?>
            });
    notificationUpdater.start();
    window._notificationUpdater = notificationUpdater;
    <?php endif;?>
  });


  var toggleUpdatesPulldown = function(event, element, user_id,type) {
    if( element.className=='updates_pulldown' ) {
      element.className= 'updates_pulldown_active';
      showNotifications(type);
    } else {
      element.className='updates_pulldown';
    }
  }

  var showNotifications = function(type) {
    en4.activity.updateNotifications();
    new Request.HTML({
      'url' : en4.core.baseUrl + 'activity/notifications/pulldown/type/' + type,
      'data' : {
        'format' : 'html',
        'page' : 1
      },
      'onComplete' : function(responseTree, responseElements, responseHTML, responseJavaScript) {

        if(responseHTML){
          // hide loading icon
          if($('notifications_loading_' + type)) $('notifications_loading_' + type).setStyle('display', 'none');          
          $('notifications_menu_' + type).innerHTML = responseHTML;
          $('notifications_menu_' + type).addEvent('click', function(event){
            event.stop(); //Prevents the browser from following the link.

            var current_link = event.target;
            var notification_li = $(current_link).getParent('li');

            // if this is true, then the user clicked on the li element itself
            if (notification_li.id == 'core_menu_mini_menu_update') notification_li = current_link;

            var forward_link;
            if(current_link.get('href')){
              forward_link = current_link.get('href');
            }
            else{
              forward_link = $(current_link).getElements('a:last-child').get('href');
            }

            if(notification_li.get('class')=='notifications_unread'){
              notification_li.removeClass('notifications_unread');
              en4.core.request.send(new Request.JSON({
                url : en4.core.baseUrl + 'activity/notifications/markread',
                data : {
                  format     : 'json',
                  'actionid' : notification_li.get('value')
                },
                onSuccess : window.location = forward_link
              }));
            }
            else window.location = forward_link;
          });
        }
        else $('notifications_loading_' + type).innerHTML = '<?php echo $this->string()->escapeJavascript($this->translate("You have no new updates."));?>';
      }
    }).send();
  };

</script>
