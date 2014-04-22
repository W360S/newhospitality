<?php
/**
* SocialEngine
*
* @category   Application_Core
* @package    Messages
* @copyright  Copyright 2006-2010 Weblego Developments
* @license    http://www.sacialengine.com/license/ * @version    $Id: inbox.tpl 9941 2013-02-19 20:01:02Z shaun $
* @author     John
*/
?>

<div class="pt-number-message">
    <?php echo $this->translate(array('You have %1$s new message, %2$s total', 'You have %1$s new messages, %2$s total', $this->unread),
    $this->locale()->toNumber($this->unread),
    $this->locale()->toNumber($this->paginator->getTotalItemCount())) ?>
    <?php if( count($this->paginator) ): ?>
        <a href="javascript:void(0)" id="checkall"><!-- Check All --></a>
    <?php endif; ?>
    <?php /*
    <form action="messages/search" method="GET" style="float: right;">
        <input type="text" placeholder="Search" name="query" value="<?php echo htmlspecialchars(!empty($this->queryStr) ? $this->queryStr : '', ENT_QUOTES, 'UTF-8') ?>"  />
    </form>
    */ ?>
</div>

<?php if( $this->paginator->getTotalItemCount() <= 0 ): ?>
<div class="tip">
    <span>
        <?php echo $this->translate('Tip: %1$sClick here%2$s to send your first message!', "<a href='".$this->url(array('action' => 'compose'), 'messages_general')."'>", '</a>'); ?>
    </span>
</div>
<br />
<?php else: ?>
<div class="pt-how-link-message">
    <a href="" class="pt-icon pt-icon-01"></a>
    <a href="" class="pt-icon pt-icon-02"></a>
    <?php echo $this->paginationControl($this->paginator, null, "application/modules/Messages/views/scripts/pagination/inbox.tpl"); ?>
</div>
<?php endif; ?>

<?php if( count($this->paginator) ): ?>
<div>
    <ul class="pt-list-message">
        <?php foreach( $this->paginator as $conversation ): ?>
        <?php 
        $message = $conversation->getInboxMessage($this->viewer());
        $recipient = $conversation->getRecipientInfo($this->viewer());
        $resource = "";
        $sender   = "";
        if( $conversation->hasResource() && ($resource = $conversation->getResource()) ) {
            $sender = $resource;
        } else if( $conversation->recipients > 1 ) {
            $sender = $this->viewer();
        } else {
            foreach( $conversation->getRecipients() as $tmpUser ) {
                if( $tmpUser->getIdentity() != $this->viewer()->getIdentity() ) {
                    $sender = $tmpUser;
                }
            }
        }
        if( (!isset($sender) || !$sender) && $this->viewer()->getIdentity() !== $conversation->user_id ){
            $sender = Engine_Api::_()->user()->getUser($conversation->user_id);
        }
        if( !isset($sender) || !$sender ) {
            //continue;
            $sender = new User_Model_User(array());
        }
        ?>
        <li<?php if( !$recipient->inbox_read ): ?> class='messages_list_new'<?php endif; ?> id="message_conversation_<?php echo $conversation->conversation_id ?>">
            <input type="checkbox" name="is_subscribed" title="" value="<?php echo $conversation->conversation_id ?>" id="is_subscribed" class="checkbox">
            <div class="pt-user-post">
                <a href="<?php echo $sender->getHref() ?>">
                    <span class="pt-avatar">
                        <?php echo $this->itemPhoto($sender, 'thumb.icon') ?>
                    </span>
                </a>
                <div class="pt-how-info-user-post">
                    <h3><a href="<?php echo $sender->getHref() ?>"><?php echo $sender->getTitle() ?></a></h3>
                    <p><?php echo $this->timestamp($message->date, array('notag' => 1)) ?></p>
                </div>
                
            </div>
            <div class="pt-content-message">
                <?php
                ! ( isset($message) && '' != ($title = trim($message->getTitle())) ||
                ! isset($conversation) && '' != ($title = trim($conversation->getTitle())) ||
                $title = '<em>' . $this->translate('(No Subject)') . '</em>' );
                ?>

                <h4><?php echo $this->htmlLink($conversation->getHref(), $title) ?></h4>
                <p><?php echo html_entity_decode($message->body) ?></p>
            </div>
            <?php /*
            <div class="messages_list_checkbox">
                <input class="checkbox" type="checkbox" value="<?php echo $conversation->conversation_id ?>" />
            </div>
            <div class="messages_list_photo">
                <?php echo $this->htmlLink($sender->getHref(), $this->itemPhoto($sender, 'thumb.icon')) ?>
            </div>
            <div class="messages_list_from">
                <p class="messages_list_from_name">
                    <?php if( !empty($resource) ): ?>
                    <?php echo $resource->toString() ?>
                    <?php elseif( $conversation->recipients == 1 ): ?>
                    <?php echo $this->htmlLink($sender->getHref(), $sender->getTitle()) ?>
                    <?php else: ?>
                    <?php echo $this->translate(array('%s person', '%s people', $conversation->recipients),
                    $this->locale()->toNumber($conversation->recipients)) ?>
                    <?php endif; ?>
                </p>
                <p class="messages_list_from_date">
                    <?php echo $this->timestamp($message->date) ?>
                </p>
            </div>
            <div class="messages_list_info">
                <p class="messages_list_info_title">
                    <?php
                    ! ( isset($message) && '' != ($title = trim($message->getTitle())) ||
                    ! isset($conversation) && '' != ($title = trim($conversation->getTitle())) ||
                    $title = '<em>' . $this->translate('(No Subject)') . '</em>' );
                    ?>
                    <?php echo $this->htmlLink($conversation->getHref(), $title) ?>
                </p>
                <p class="messages_list_info_body">
                    <?php echo html_entity_decode($message->body) ?>
                </p>
            </div>
             * 
             */?>
        </li>
        <?php endforeach; ?>
    </ul>
</div>

<?php /*
<button id="delete"><?php echo $this->translate('Delete Selected') ?></button>
*/ ?>

<script type="text/javascript">

$('checkall').addEvent('click', function() {
        var hasUnchecked = false;
        $$('.messages_list input[type="checkbox"]').each(function(el) {
            if (!el.get('checked')) {
                hasUnchecked = true;
            }
        });
        $$('.messages_list input[type="checkbox"]').set('checked', hasUnchecked);
    });
    $('delete').addEvent('click', function() {
        var selected_ids = new Array();
        $$('div.messages_list input[type=checkbox]').each(function(cBox) {
            if (cBox.checked)
                selected_ids[ selected_ids.length ] = cBox.value;
        });
        var sb_url = '<?php echo $this->url(array('action'=>'delete'), 'messages_general', true) ?>?place=inbox&message_ids=' + selected_ids.join(',');
                        if (selected_ids.length > 0)
                    Smoothbox.open(sb_url);
    });

</script>

<?php endif; ?>

<?php //echo $this->paginationControl($this->paginator); ?>

