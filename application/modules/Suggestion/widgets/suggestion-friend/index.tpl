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
?>
<style type="text/css">
    .tip > span {
        margin-bottom:0;
    }
</style>
<?php
$this->headScript()->appendFile('application/modules/Suggestion/externals/scripts/core.js');
//MAKE STRING OF CURRENT USER DISPLAY
$suggestion_home_user_array = $this->suggestion_level_array;
$suggestion_message = count($this->suggestion_level_array);
$suggestion_home_array = '';
foreach ($suggestion_home_user_array as $row_friend_id) {
    $suggestion_home_array .= ',' . 'friend_' . $row_friend_id;
}
$suggestion_home_array = ltrim($suggestion_home_array, ',');
?>
<script type="text/javascript">
    var friend_suggestion_display = "<?php echo $suggestion_message; ?>";
    display_sugg += ',' + '<?php echo $suggestion_home_array; ?>';
</script>
<div class="pt-block">
    <h3 class="pt-title-right" style="font-size:14px"><?php echo $this->translate('you may know') ?><a class="all_sussgettion" style="color:#4FC1E9;" href="/suggestions/friends_suggestions">Tất cả</a></h3>
    <style>


    </style>
    <!--<div class="suggestion_friends">-->
    <ul class="pt-list-right pt-list-right-fix">
        <?php
        $div_id = 1;
        foreach ($this->path_information as $path_info):
            ?>
            <li id="suggestion_friend_<?php echo $div_id; ?>">
                <div class="pt-user-post">				
                    <a href="<?php echo $path_info->getHref() ?>">
                        <span class="pt-avatar">
                            <?php echo $this->itemPhoto($path_info, 'thumb.icon') ?>
                        </span>
                    </a>
                    <div class="pt-how-info-user-post">
                        <h3><a href="<?php echo $path_info->getHref() ?>"><?php echo $path_info->getTitle() ?></a></h3>
                        <p>
                            <?php
                            if (!empty($this->mutual_friend_array[$path_info->user_id])) :
                                echo '<a class="smoothbox" style="color:#656565" href="' . $this->url(array('module' => 'suggestion', 'controller' => 'index', 'action' => 'mutualfriend', 'sugg_friend_id' => $path_info->user_id), 'default', true) . '">' . $this->translate(array('%s bạn chung', '%s bạn chung', $this->mutual_friend_array[$path_info->user_id]), $this->locale()->toNumber($this->mutual_friend_array[$path_info->user_id])) . '</a>';
                            endif;
                            ?>
                        </p>

                    </div>
                    <?php echo $this->userFriendship($path_info, null, " pt-link-add"); ?>
                    <div style="display:none">
                        <form enctype="application/x-www-form-urlencoded" id="ajax-add-friend-<?php echo $path_info->user_id ?>" action="/members/friends/add/user_id/<?php echo $path_info->user_id ?>">

                        </form>
                    </div>			
                </div>
            </li>
            <?php
            $div_id++;
        endforeach;
        ?>
    </ul>
    <div style="clear:both"></div>
    
</div>

<?php $ajaxloaderimg = $this->baseUrl() . "/externals/smoothbox/ajax-loader.gif"; ?>
<script type="text/javascript">
    function openUrl(url) {
        Smoothbox.open(url);
    }
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
                display_suggestion: friend_suggestion_display,
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
                        var count = jQuery("div.suggestion_friends").children().length;
                        if (count == 0) {
                            //jQuery("div.suggestion_friends").parent().remove();console.log("removeed");
                        } else {
                            //parentObject.parent().parent().parent().remove();
                        }
                    },
                    complete: function() {
                    }
                });
            },
        });
    }
</script>