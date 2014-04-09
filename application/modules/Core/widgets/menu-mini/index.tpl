<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<?php

function crop($text, $qty) {
    $txt = $text;
    $arr_replace = array("<p>", "</p>", "<br>", "<br />", "  ");
    $text = str_replace($arr_replace, "", $text);
    $dem = 0;
    for ($i = 0; $i < strlen($text); $i++) {
        if ($text[$i] == ' ')
            $dem++;
        if ($dem == $qty)
            break;
    }
    $text = substr($text, 0, $i);
    if ($i < strlen($txt))
        $text .= " ...";
    return $text;
}
?>

<?php if ($this->viewer->getIdentity()) : ?>
    <div id="user" style="top:10px;color:#fff" class="pt-how-right-heder">
        <ul class="pt-info-user">
            <?php
            $viewer = Engine_Api::_()->user()->getViewer();
            $count_friend_re = Engine_Api::_()->getDbtable('notifications', 'activity')->getCountFriendRequest($viewer);
            ?>
            <li>
                <a style="cursor: pointer;" class="pt-icon pt-request"><span><?php if ($count_friend_re > 0) echo $count_friend_re; ?></span></a>
                <div class="pt-toggle-layout pt-toggle-request">
                    <div class="pt-icon-arrow"><span></span></div>
                    <div class="pt-toggle-layout-content">
                        <div class="pt-request-how">
                            <div class="pt-title"><span><?php echo $this->translate('Friends require'); ?></span></div>
                            <div class="suggestion-friends">
                                <?php
                                $viewer = Engine_Api::_()->user()->getViewer();
                                $abc = Engine_Api::_()->getDbtable('notifications', 'activity')->getRequestFriendPaginator($viewer);
                                ?>
                                <ul class='requests'>
                                    <?php if ($abc->getTotalItemCount() > 0): ?>
                                        <?php foreach ($abc as $notification): ?>
                                            <?php
                                            $parts = explode('.', $notification->getTypeInfo()->handler);
                                            //print_r($parts);	 đã gửi bạn một yêu cầu kết bạn    						                
                                            echo str_replace('hoặc', ' ', str_replace('đã gửi bạn một yêu cầu kết bạn ', '</br>Đã gởi yêu cầu kết bạn', str_replace('bỏ qua yêu cầu', 'Từ chối', str_replace('ignore request', 'Cancel', str_replace(' has sent you a friend request.    ', '<br> has sent you a friend request.    ', str_replace('or      ', ' ', $this->action($parts[2], $parts[1], $parts[0], array('notification' => $notification))))))));
                                            ?>
                                        <?php endforeach; ?>
                                    <?php else: ?>
                                        <li>
                                            <?php echo $this->translate("You have no requests.") ?>
                                        </li>
                                    <?php endif; ?>											
                                </ul>
                            </div>
                            <div class="pt-more-heder"><a href="<?php echo $this->baseUrl() . PATH_SERVER_INDEX ?>/suggestions/friendrequest"><?php echo $this->translate('See all'); ?></a></div>
                        </div>
                    </div>
                </div>

            </li>
            <li>
                <a style="cursor: pointer;" class="pt-icon pt-message"><span><?php echo $this->messageCnt; ?></span></a>	
                <div class="pt-toggle-layout pt-toggle-message">
                    <div class="pt-icon-arrow"><span></span></div>
                    <div class="pt-toggle-layout-content">
                        <div class="pt-message-how">
                            <div class="pt-title"><span style="width:220px;float:left"><?php echo $this->translate('Message'); ?></span><a style="float:right;" href="<?php echo $this->baseUrl() . PATH_SERVER_INDEX ?>/messages/compose"><?php echo $this->translate('Send a message'); ?></a></div>
                            <?php $paginator = Engine_Api::_()->getItemTable('messages_conversation')->getInboxPaginator($viewer); ?>
                            <?php if ($paginator):?>
                                <div class="messages_list">
                                    <ul class="pt-message-content">
                                        <?php foreach ($paginator as $conversation): ?>
                                            <?php
                                            $message = $conversation->getInboxMessage($this->viewer());
                                            $recipient = $conversation->getRecipientInfo($this->viewer());
                                            if ($conversation->recipients > 1) {
                                                $user = $this->viewer();
                                            } else {
                                                foreach ($conversation->getRecipients() as $tmpUser) {
                                                    if ($tmpUser->getIdentity() != $this->viewer()->getIdentity()) {
                                                        $user = $tmpUser;
                                                    }
                                                }
                                            }
                                            if (!isset($user) || !$user) {
                                                $user = $this->viewer();
                                            }
                                            ?>
                                            <li<?php if (!$recipient->inbox_read): ?> class='messages_list_new'<?php endif; ?> id="message_conversation_<?php echo $conversation->conversation_id ?>">

                                                <div class="messages_list_photo">
                                                    <?php echo $this->htmlLink($user->getHref(), $this->itemPhoto($user, 'thumb.icon')) ?>
                                                </div>
                                                <div class="pt-how-info-message">
                                                    <div>
                                                        <?php if ($conversation->recipients == 1): ?>
                                                            <?php echo $this->htmlLink($user->getHref(), $user->getTitle()) ?>
                                                        <?php else: ?>
                                                            <?php echo $conversation->recipients ?> people
                                                        <?php endif; ?>
                                                    </div>


                                                    <?php
                                                    ( '' != ($title = trim($message->getTitle())) ||
                                                            '' != ($title = trim($conversation->getTitle())) ||
                                                            $title = '<em>' . $this->translate('(No Subject)') . '</em>' );
                                                    ?>
                                                    <?php echo $this->htmlLink($conversation->getHref(), crop($title, 9)) ?>
                                                    <div style="margin-top:-9px">
                                                        <?php echo $this->timestamp($message->date) ?>
                                                    </div>

                                                </div>

                                                <?php echo html_entity_decode($message->body) ?>
                                            </li>
                                        <?php endforeach; ?>
                                    </ul>
                                </div>
                                <script type="text/javascript">
                                    window.addEvent('domready', function() {
                                        $('delete').addEvent('click', function() {

                                            var selected_ids = new Array();
                                            $$('div.messages_list input[type=checkbox]').each(function(cBox) {
                                                if (cBox.checked)
                                                    selected_ids[ selected_ids.length ] = cBox.value;
                                            });
                                            var sb_url = '<?php echo $this->url(array(), 'messages_delete') ?>/' + selected_ids.join(',');
                                            if (selected_ids.length > 0)
                                                Smoothbox.open(sb_url);
                                        });
                                    });
                                </script>

                            <?php endif; ?>
                            <div class="pt-more-heder"><a href="<?php echo $this->baseUrl() . PATH_SERVER_INDEX ?>/messages/inbox"><?php echo $this->translate('See all'); ?></a></div>
                        </div>
                    </div>
                </div>		
            </li>
            <li>
                <span onclick="toggleUpdatesPulldown(event, this, '4');" style="display: inline-block;" class="pt-icon pt-jewel">
                                        <!--<a style="cursor: pointer;" class="pt-icon pt-jewel" onclick="toggleUpdatesPulldown(event, this, '4');"><span> 2</span></a>-->
                    <a href="javascript:void(0);" id="" class="pt-icon pt-jewel" onclick="toggleUpdatesPulldown(event, this, '4');"><span> <?php echo str_replace("Updates", "", $this->notificationCount); ?></span></a>	
                    <div class="pt-toggle-layout pt-toggle-jewel">
                        <div class="pt-icon-arrow"><span></span></div>
                        <div class="pt-toggle-layout-content" style="background-color: #FFFFFF;border-radius: 4px;box-shadow: 0 2px 13px 2px #B8B8B8;  overflow: hidden; padding: 5px 0;">
                            <div class="pt-message-how">
                                <div class="pt-title"><span><?php echo $this->translate('Content is updating'); ?></span></div>
                                <ul class="notifications_menu" id="notifications_menu" style="height: 200px; overflow-x: hidden; overflow-y: scroll;">
                                    <div class="notifications_loading" id="notifications_loading">
                                        <img src='application/modules/Core/externals/images/loading.gif' style='float:left; margin-right: 5px;' />
                                        <?php echo $this->translate("Loading ...") ?>
                                    </div>
                                </ul>

                            </div>
                            <div class="pt-more-heder">
                                <a  href="/index.php/activity/notifications" id="notifications_viewall_link"><?php echo $this->translate('See all'); ?></a><!--<a  href="javascript:void(0);" id="notifications_markread_link">Đánh dấu đã xem tất cả</a>--></div>
                        </div>	
                    </div>	
                </span>
            </li>
            <li>
                <a class="pt-name"><?php echo $this->viewer->getOwner()->displayname; ?><span></span></a>
                <div class="pt-toggle-layout pt-toggle-name">
                    <div class="pt-icon-arrow"><span></span></div>
                    <div class="pt-toggle-layout-content">
                        <ul class="pt-edit">
                            <li>
                                <a  href="<?php echo $this->layout()->staticBaseUrl . '/profile/' . $this->viewer->getOwner()->username; ?>">
                                    <?php echo $this->translate('Account setting'); ?></a>
                            </li>
                            <li>
                                <a href="<?php echo $this->layout()->staticBaseUrl . '/members/settings/general'; ?>"><?php echo $this->translate('Private setting'); ?></a>
                            </li>
                            <li>
                                <a href="javascript:void(0)"><?php echo $this->translate('Help'); ?></a>
                            </li>
                            <li>
                                <a href="<?php echo $this->layout()->staticBaseUrl . '/logout'; ?>"><?php echo $this->translate('Logout'); ?></a>
                            </li>
                        </ul>
                    </div>
                </div>
            </li>
        </ul>
    </div>
<?php else: ?>
    <div class="pt-login">
        <span>Bạn đã là thành viên ?</span>
        <a href="#pt-fancybox">Đăng nhập</a>
        <div class="pt-none">
            <div id="pt-fancybox" class="login-checkout">
                <form method="post" action="<?php echo $this->layout()->staticBaseUrl ?>/login" class="global_form" id="user_form_login" accept-charset="utf-8">
                    <fieldset>
                        <h3>Đăng nhập</h3>
                        <ul>
                            <li>
                                <label>Email của bạn</label>											
                                <input class="input-text required-entry validate-email" style="width:223px;padding:10px" type="text" tabindex="1" value="E-Mail" id="email" name="email" onfocus="javascript:if (this.value == 'E-Mail')
                                            this.value = ''" onblur="if (this.value == '')
                                                        this.value = 'E-Mail'">
                            </li>
                            <li>
                                <label>Mật khẩu</label>
                                <input class="input-text required-entry validate-email" style="width:223px;padding:10px" type="password" tabindex="2" value="MẬT KHẨU" id="password" name="password" onfocus="javascript:if (this.value == 'MẬT KHẨU')
                                            this.value = ''" onblur="if (this.value == '')
                                                        this.value = 'MẬT KHẨU'">
                            </li>
                            <li class="control">
                                <p>
                                    <input type="checkbox" title="" value="1" id="remember" name="remember" tabindex="4" class="checkbox">
                                    <input type="hidden" value="0" name="remember">                        						
                                    <label for="is_subscribed">ghi nhớ</label>
                                </p>
                                <a href="/user/auth/forgot" class="password">Quên mật khẩu?</a>
                            </li>
                            <li class="last">
                                <button tabindex="5" type="submit" id="submit" name="submit" title="" class="button">Đăng nhập</button>
                                <a href="#" class="facebook">facebook</a>
                            </li>
                            <input type="hidden" id="return_url" value="" name="return_url">
                        </ul>
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
<?php endif; ?>