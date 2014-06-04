<style type="text/css">
    #global_page_suggestion-index-viewfriendsuggestion #global_content .layout_middle{min-height: 1000px; width:540px; float:left; padding-top:20px; padding-left:37px; border-left:1px solid #e6e8ea}

</style>


    <div id="peo_list_box" style="" class="pt-block pt-know-friend">
        <h3 class="pt-title-right">bạn có thể biết người này</h3>
        <?php
        // If no record found then show message.
        if(isset($this->message))
        {
            echo $this->message;
        }
        else {
            $this->headScript()
              ->appendFile('application/modules/Suggestion/externals/scripts/core.js');
            
            //MAKE STRING OF CURRENT USER DISPLAY
            $suggestion_viewfriend_users_array = $this->suggestion_viewfriend_user_combind_path;
            $suggestion_count = count($this->suggestion_viewfriend_user_combind_path);
            $suggestion_viewfriend_users_str = implode(",", $suggestion_viewfriend_users_array);
            ?>
            <script type="text/javascript">
                var friend_displayed_suggestions = "<?php echo $suggestion_viewfriend_users_str; ?>";
                var suggestion_display_count = "<?php echo $suggestion_count; ?>";      
                var cancelFriSuggestion = function(entity_id, div_id)
                {
                  en4.core.request.send(new Request.HTML({          
                    url : en4.core.baseUrl + 'suggestion/main/suggestion-disable',
                    data : {
                      format : 'html',
                      entity_id : entity_id,     
                      div_id : div_id,
                      suggestion_display_count : suggestion_display_count,
                      friend_displayed_suggestions : friend_displayed_suggestions
                    }
                  }), {
                    'element' : $(div_id)
                  })
                };
            </script>
            <ul class="pt-list-right pt-list-right-fix">
                <?php
                $div_id = 1;
                $send_request_user_info_array = array();
                foreach( $this->suggestion_viewfriend_users_info as $user_info ): ?>
                    <li>
                        <?php $user_id = $user_info->getIdentity() ?>
                        <div class="pt-user-post">
                            <a href="<?php echo $user_info->getHref() ?>"><span class="pt-avatar"><?php echo $this->itemPhoto($user_info, 'thumb.icon'); ?></span></a>
                            <div class="pt-how-info-user-post">
                                <h3><a href="<?php echo $user_info->getHref() ?>"><?php echo $user_info->getTitle(); ?></a></h3>
                                <a href="<?php echo $user_info->getHref() ?>">20 bạn chung</a>
                            </div>
                            <?php   echo $this->userFriendship($user_info); ?>
                            <div style="display:none">
                                <form enctype="application/x-www-form-urlencoded" id="ajax-add-friend-110" action="/members/friends/add/user_id/110">

                                </form>
                            </div>
                        </div>
                    </li>

                    <?php /*
                    <div id="suggestion_friend_<?php echo $div_id; ?>">
                        <div class="list" > 
                            <div class="user_photo">
                                <?php
                                echo $this->htmlLink($user_info->getHref(), $this->itemPhoto($user_info, 'thumb.icon'), array('class' => 'popularmembers_thumb')); ?>
                            </div>
                            <div class="user_details">
                                <span style="float:right;">
                                <?php if(empty($this->signup_user)) {
                            echo    '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="cancelFriSuggestion(' . $user_info->user_id . ', \'suggestion_friend_'.$div_id.'\');"></a>';
                                } ?>
                                </span>
                                <p class="name"><?php echo $this->htmlLink($user_info->getHref(), Engine_Api::_()->suggestion()->truncateTitle($user_info->getTitle()), array('title' => $user_info->getTitle())) . '<br>'; ?></p>
                                <?php   echo $this->userFriendship($user_info); ?>
                            </div>
                        </div>      
                    </div>
                    */ ?>

                    <?php
                    $div_id++;
                endforeach;?>
            </ul>

        <?php } ?>
    </div>

<script type="text/javascript">
    function sendAjaxAddfriend(id, isAjax, object) {
        var form_id = '#ajax-add-friend-' + id;
        var form = jQuery(form_id);
        var url = form.attr("action");

        console.log(url);
        
        var parentObject = jQuery(object).parent();

        var item_response = new Array();

        var refresh_item = jQuery.ajax({
            type: "POST",
            url: en4.core.baseUrl + 'suggestion/main/mix-info',
            data: {
                format: 'html',
                sugg_id: id,
                widget_div_id: parentObject.parent().parent().parent().attr('id'),
                fun_name: 'friend',
                // display_suggestion: friend_suggestion_display,
                displayed_sugg: '',
                page_name: 'friend'
            },
            beforeSend: function(xhr) {
                jQuery(object).html('<img src="<?php echo $ajaxloaderimg ?>"/>');
            },
            success: function(response) {
                console.log(response);
                item_response[id] = response;
                jQuery.ajax({
                    type: "POST",
                    url: url,
                    data: form.serialize(),
                    beforeSend: function(xhr) {
                    },
                    success: function(response) {
                        parentObject.parent().html(item_response[id]);
                        
                    },
                    complete: function() {
                    }
                });
            },
        });
    }
</script>

    