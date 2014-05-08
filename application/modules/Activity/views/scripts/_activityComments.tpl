<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: _activityText.tpl 9993 2013-03-25 21:51:06Z john $
 * @author     Jung
 */
?>

<?php
if (empty($this->actions)) {
    echo $this->translate("The action you are looking for does not exist.");
    return;
} else {
    $actions = $this->actions;
}
?>

<?php
$this->headScript()
        ->appendFile($this->layout()->staticBaseUrl . 'application/modules/Activity/externals/scripts/core.js')
        ->appendFile($this->layout()->staticBaseUrl . 'externals/flowplayer/flashembed-1.0.1.pack.js')
?>

<script type="text/javascript">
    var CommentLikesTooltips;
    en4.core.runonce.add(function() {
        // Add hover event to get likes
        $$('.comments_comment_likes').addEvent('mouseover', function(event) {
            var el = $(event.target);
            if (!el.retrieve('tip-loaded', false)) {
                el.store('tip-loaded', true);
                el.store('tip:title', '<?php echo $this->string()->escapeJavascript($this->translate('Loading...')) ?>');
                el.store('tip:text', '');
                var id = el.get('id').match(/\d+/)[0];
                // Load the likes
                var url = '<?php echo $this->url(array('module' => 'activity', 'controller' => 'index', 'action' => 'get-likes'), 'default', true) ?>';
                var req = new Request.JSON({
                    url: url,
                    data: {
                        format: 'json',
                        //type : 'core_comment',
                        action_id: el.getParent('li').getParent('li').getParent('li').get('id').match(/\d+/)[0],
                        comment_id: id
                    },
                    onComplete: function(responseJSON) {
                        el.store('tip:title', responseJSON.body);
                        el.store('tip:text', '');
                        CommentLikesTooltips.elementEnter(event, el); // Force it to update the text
                    }
                });
                req.send();
            }
        });
        // Add tooltips
        CommentLikesTooltips = new Tips($$('.comments_comment_likes'), {
            fixed: true,
            className: 'comments_comment_likes_tips',
            offset: {
                'x': 48,
                'y': 16
            }
        });
        // Enable links in comments
        $$('.comments_body').enableLinks();
    });
</script>


<?php if (!$this->getUpdate): ?>
    <ul class='feed' id="activity-feed">
    <?php endif ?>

    <!-- <ul class='feed' id="activity-feed"> -->

    <?php
    foreach ($actions as $action): // (goes to the end of the file)
        try { // prevents a bad feed item from destroying the entire page
            // Moved to controller, but the items are kept in memory, so it shouldn't hurt to double-check
            if (!$action->getTypeInfo()->enabled)
                continue;
            if (!$action->getSubject() || !$action->getSubject()->getIdentity())
                continue;
            if (!$action->getObject() || !$action->getObject()->getIdentity())
                continue;

            ob_start();
            ?>
            <?php if (!$this->noList): ?>
                <li id="activity-item-<?php echo $action->action_id ?>" data-activity-feed-item="<?php echo $action->action_id ?>">
                <?php endif; ?>

                <?php $this->commentForm->setActionIdentity($action->action_id) ?>
                <script type="text/javascript">
                    (function() {
                        var action_id = '<?php echo $action->action_id ?>';
                        en4.core.runonce.add(function() {
                            $('activity-comment-body-' + action_id).autogrow();
                            en4.activity.attachComment($('activity-comment-form-' + action_id));
                        });
                    })();
                </script>

                <div class="pt-user-post">
                    <a href="<?php echo $action->getSubject()->getHref() ?>">
                        <span class="pt-avatar">
                            <?php echo $this->itemPhoto($action->getSubject(), 'thumb.icon', $action->getSubject()->getTitle()) ?>
                        </span></a>
                    <div class="pt-how-info-user-post">
                        <h3><a href="<?php echo $action->getSubject()->getHref() ?>"><?php echo $action->getSubject()->getTitle() ?></a></h3>
                        <p><span></span> <?php echo $this->timestamp($action->getTimeValue(), array('notag' => 1)) ?></p>
                    </div>
                </div>

                <div class="pt-content-user-post">
                    <p><?php echo $action->getContent() ?></p>
                    <!-- <p><?php //echo $action->VHgetBodyText()  ?></p> -->
                </div>

                <!--BEGIN ATTACHMENT-->
                <?php if ($action->getTypeInfo()->attachable && $action->attachment_count > 0): // Attachments  ?>
                    <div class='feed_item_attachments'>
                        <?php if ($action->attachment_count > 0 && count($action->getAttachments()) > 0): ?>
                            <?php
                            if (count($action->getAttachments()) == 1 &&
                                    null != ( $richContent = current($action->getAttachments())->item->getRichContent())):
                                ?>                    
                                <?php echo $richContent; ?>
                            <?php else: ?>
                                <?php foreach ($action->getAttachments() as $attachment): ?>
                                    <span class='feed_attachment_<?php echo $attachment->meta->type ?>'>
                                        <?php if ($attachment->meta->mode == 0): // Silence ?>
                                        <?php elseif ($attachment->meta->mode == 1): // Thumb/text/title type actions  ?>
                                            <div>
                                                <?php
                                                if ($attachment->item->getType() == "core_link") {
                                                    $attribs = Array('target' => '_blank');
                                                } else {
                                                    $attribs = Array();
                                                }
                                                ?>
                                                <?php if ($attachment->item->getPhotoUrl()): ?>
                                                    <?php echo $this->htmlLink($attachment->item->getHref(), $this->itemPhoto($attachment->item, null, $attachment->item->getTitle()), $attribs) ?>
                                                <?php endif; ?>
                                                <div>
                                                    <div class='feed_item_link_title'>
                                                        <?php
                                                        echo $this->htmlLink($attachment->item->getHref(), $attachment->item->getTitle() ? $attachment->item->getTitle() : '', $attribs);
                                                        ?>
                                                    </div>
                                                    <div class='feed_item_link_desc'>
                                                        <?php echo $this->viewMore($attachment->item->getDescription()) ?>
                                                    </div>
                                                </div>
                                            </div>
                                        <?php elseif ($attachment->meta->mode == 2): // Thumb only type actions  ?>
                                            <div class="feed_attachment_photo">
                                                <?php echo $this->htmlLink($attachment->item->getHref(), $this->itemPhoto($attachment->item, 'thumb.normal', $attachment->item->getTitle()), array('class' => 'feed_item_thumb')) ?>
                                            </div>
                                        <?php elseif ($attachment->meta->mode == 3): // Description only type actions ?>
                                            <?php echo $this->viewMore($attachment->item->getDescription()); ?>
                                        <?php elseif ($attachment->meta->mode == 4): // Multi collectible thingy (@todo)  ?>
                                        <?php endif; ?>
                                    </span>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        <?php endif; ?>
                    </div>
                <?php endif; ?>
                <!--END ATTACHMENT-->

                <?php
                $icon_type = 'activity_icon_' . $action->type;
                list($attachment) = $action->getAttachments();
                if (is_object($attachment) && $action->attachment_count > 0 && $attachment->item):
                    $icon_type .= ' item_icon_' . $attachment->item->getType() . ' ';
                endif;
                $canComment = ( $action->getTypeInfo()->commentable &&
                        $this->viewer()->getIdentity() &&
                        Engine_Api::_()->authorization()->isAllowed($action->getObject(), null, 'comment') &&
                        !empty($this->commentForm) );
                ?>

                <!--LIKE SHARE COMMENT SECTION BEGIN-->
                <div class="pt-user-post-comment" id='comment-likes-activity-item-<?php echo $action->action_id ?>'>

                    <!--LIKE BUTTON BEGIN -->
                    <?php if ($canComment): ?>
                        <?php if ($action->likes()->isLike($this->viewer())): ?>
                            <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Unlike'), array('onclick' => 'javascript:en4.activity.unlike(' . $action->action_id . ');')) ?>
                        <?php else: ?>
                            <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Like'), array('onclick' => 'javascript:en4.activity.like(' . $action->action_id . ');')) ?>
                        <?php endif; ?>
                        <?php if (Engine_Api::_()->getApi('settings', 'core')->core_spam_comment): // Comments - likes   ?>
                            <?php
                            echo $this->htmlLink(array('route' => 'default', 'module' => 'activity', 'controller' => 'index', 'action' => 'viewcomment', 'action_id' => $action->getIdentity(), 'format' => 'smoothbox'), $this->translate('Comment'), array(
                                'class' => 'smoothbox',
                            ))
                            ?>
                        <?php else: ?>
                            <?php echo $this->htmlLink(
                                    'javascript:void(0);', 
                                    $this->translate('Comment'), 
                                    array('onclick' => 'document.getElementById("' . $this->commentForm->getAttrib('id') . '").style.display = ""; document.getElementById("' . $this->commentForm->submit->getAttrib('id') . '").style.display = "none"; document.getElementById("' . $this->commentForm->body->getAttrib('id') . '").focus();')) ?>
                            <script type="text/javascript">
                                en4.core.runonce.add(function() {
                                    document.getElementById('<?php echo $this->commentForm->body->getAttrib('id') ?>').onkeydown = function(e){

                                        var body = jQuery('#<?php echo $this->commentForm->body->getAttrib('id') ?>').val();
                                        var action_id = '<?php echo $action->action_id ?>';

                                        e = e || event;
                                        if (e.keyCode === 13) {
                                            en4.activity.comment(action_id, body);
                                            /*
                                            en4.core.request.send(new Request.JSON({
                                              url : en4.core.baseUrl + 'activity/index/comment',
                                              data : {
                                                format : 'json',
                                                action_id : action_id,
                                                body : body,
                                                subject : en4.core.subject.guid
                                              },
                                              'onSuccess': function(responseJSON, responseText){
                                                    console.log(responseJSON);
                                              }
                                              }));
                                            */
                                        }
                                        return true;
                                    }
                                });
                                    
                                
                            </script>
                        <?php endif; ?>
                        <?php if ($this->viewAllComments): ?>
                            <script type="text/javascript">
                                en4.core.runonce.add(function() {
                                    document.getElementById('<?php echo $this->commentForm->getAttrib('id') ?>').style.display = "";
                                    document.getElementById('<?php echo $this->commentForm->submit->getAttrib('id') ?>').style.display = "block";
                                    document.getElementById('<?php echo $this->commentForm->body->getAttrib('id') ?>').focus();
                                });
                            </script>
                        <?php endif ?>
                    <?php endif; ?>
                    <!--LIKE END-->

                </div> 
                <!--LIKE SHARE COMMENT SECTION END-->

                <!--COMMENT LIST BEGIN-->
                <?php if ($action->getTypeInfo()->commentable): ?>
                    <?php if ($action->comments()->getCommentCount() > 0): ?>
                        <div class='comments pt-user-comtent'>
                            <ul>
                                <?php if ($action->likes()->getLikeCount() > 0 && (count($action->likes()->getAllLikesUsers()) > 0)): ?>
                                    <li>
                                        <div></div>
                                        <div class="comments_likes">
                                            <?php if ($action->likes()->getLikeCount() <= 3 || $this->viewAllLikes): ?>
                                                <?php echo $this->translate(array('%s likes this.', '%s like this.', $action->likes()->getLikeCount()), $this->fluentList($action->likes()->getAllLikesUsers())) ?>
                                            <?php else: ?>
                                                <?php echo $this->htmlLink($action->getSubject()->getHref(array('action_id' => $action->action_id, 'show_likes' => true)), $this->translate(array('%s person likes this', '%s people like this', $action->likes()->getLikeCount()), $this->locale()->toNumber($action->likes()->getLikeCount()))) ?>
                                            <?php endif; ?>
                                        </div>
                                    </li>
                                <?php endif; ?>
                                <?php if ($action->comments()->getCommentCount() > 0): ?>
                                    <?php if ($action->comments()->getCommentCount() > 5 && !$this->viewAllComments): ?>
                                        <li>
                                            <div></div>
                                            <div class="comments_viewall">
                                                <?php if ($action->comments()->getCommentCount() > 2): ?>
                                                    <?php echo $this->htmlLink($action->getSubject()->getHref(array('action_id' => $action->action_id, 'show_comments' => true)), $this->translate(array('View all %s comment', 'View all %s comments', $action->comments()->getCommentCount()), $this->locale()->toNumber($action->comments()->getCommentCount()))) ?>
                                                <?php else: ?>
                                                    <?php echo $this->htmlLink('javascript:void(0);', $this->translate(array('View all %s comment', 'View all %s comments', $action->comments()->getCommentCount()), $this->locale()->toNumber($action->comments()->getCommentCount())), array('onclick' => 'en4.activity.viewComments(' . $action->action_id . ');')) ?>
                                                <?php endif; ?>
                                            </div>
                                        </li>
                                    <?php endif; ?>

                                    <?php $comments = $action->getComments($this->viewAllComments);
                                    $commentLikes = $action->getCommentsLikes($comments, $this->viewer());
                                    ?>

                    <?php foreach ($comments as $comment): ?>

                                        <!-- BEGIN SINGLE COMMENT -->
                                        <li id="comment-<?php echo $comment->comment_id ?>">
                                            <div class="pt-user-post">
                                                <a href="#">
                                                    <span class="pt-avatar">
                                                        <?php $poster = $this->item($comment->poster_type, $comment->poster_id) ?>
                                                        <?php $avatar = $this->itemPhoto($poster, 'thumb.icon', $poster->getTitle()) ?>
                        <?php echo $avatar ?>
                                                    </span>
                                                </a>
                                                <div class="pt-how-info-user-post">
                                                    <h3>
                                                        <a href="<?php echo $poster->getHref() ?>" class="pt-title-name"> <?php echo $poster->getTitle() ?></a>
                                                        <span class="pt-times"><?php echo $this->timestamp($comment->creation_date); ?></span>
                                                        <a href="#" class="pt-like"><span></span><?php echo $comment->likes()->getLikeCount() ?></a>
                                                        <a href="#" class="pt-reply"><span></span>Trả lời</a>
                                                    </h3>
                                                    <p><?php echo $this->viewMore($comment->body) ?></p>
                                                </div>

                                            </div>
                                        </li>
                                        <!-- END SINGLE COMMENT -->
                    <?php endforeach; ?>




                            <?php endif; ?>
                            </ul>
                            <?php if ($canComment) echo $this->commentForm->render() /*
                                  <form>
                                  <textarea rows='1'>Add a comment...</textarea>
                                  <button type='submit'>Post</button>
                                  </form>
                                 */ ?>
                        </div>
                    <?php endif; ?>
        <?php endif; ?>
                <!-- COMMENT LIST END -->

                    <?php if ($canComment) : ?>
                    <div class="pt-textarea">
                    <?php echo $this->commentForm->render() ?>
                    </div>
                <?php endif ?>

            <?php if (!$this->noList): ?>
                </li>
            <?php endif; ?>

            <?php
            ob_end_flush();
        } catch (Exception $e) {
            ob_end_clean();
            if (APPLICATION_ENV === 'development') {
                echo $e->__toString();
            }
        };
    endforeach;
    ?>

<?php if (!$this->getUpdate): ?>
    </ul>
<?php endif ?>
<!-- </ul> -->