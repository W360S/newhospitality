<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Messages
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: view.tpl 9902 2013-02-14 02:35:41Z shaun $
 * @author     John
 */
?>

<div class="pt-message-content pt-message-content-detail">
    <div class="pt-how-link-message">
        <div class="pt-how-info-user-post">
            <h3>
                <?php if ('' != ($title = trim($this->conversation->getTitle()))): ?>
                    <?php echo $title ?>
                <?php else: ?>
                    <em>
                        <?php echo $this->translate('(No Subject)') ?>
                    </em>
                <?php endif; ?>
            </h3>
            <p>
                <?php
                // Resource
                if ($this->resource) {
                    echo $this->translate('To members of %1$s', $this->resource->toString());
                }
                // Recipients
                else {
                    $you = array_shift($this->recipients);
                    $you = $this->htmlLink($you->getHref(), ($this->viewer()->isSelf($you) ? $this->translate('You') : $you->getTitle()));
                    $them = array();
                    foreach ($this->recipients as $r) {
                        if ($r != $this->viewer()) {
                            $them[] = ($r == $this->blocker ? "<s>" : "") . $this->htmlLink($r->getHref(), $r->getTitle()) . ($r == $this->blocker ? "</s>" : "");
                        } else {
                            $them[] = $this->htmlLink($r->getHref(), $this->translate('You'));
                        }
                    }

                    if (count($them))
                        echo $this->translate('Between %1$s and %2$s', $you, $this->fluentList($them));
                    else
                        echo 'Conversation with a deleted member.';
                }
                ?>
            </p>
        </div>
        <?php
        echo $this->htmlLink(array(
            'action' => 'delete',
            'id' => null,
            'place' => 'view',
            'message_ids' => $this->conversation->conversation_id,
                ), $this->translate(''), array(
            'class' => 'pt-icon pt-icon-delete buttonlink smoothbox', //'buttonlink icon_message_delete',
        ))
        ?>
    </div>
    <ul class="pt-list-message-detail">
        <?php $i=1; ?>
        <?php foreach ($this->messages as $message): ?>
            <?php $user = $this->user($message->user_id); ?>
            <li <?php if($i%2 == 0) echo 'class="pt-odd'; ?> >
                <a href="<?php echo $user->getHref()?>"><span class="pt-avatar"><?php echo $this->itemPhoto($user, 'thumb.icon') ?></span></a>
                <div class="pt-how-info-message">
                    <?php //echo $this->htmlLink($user->getHref(), $user->getTitle()) ?> 
                    <?php //echo " - "?>
                    <?php echo $this->timestamp($message->date) ?>
                    <?php echo nl2br(html_entity_decode($message->body)) ?>
                </div>
            </li>
            <?php $i++;?>
        <?php endforeach; ?>
    </ul>
    <div class="pt-info-message">
        <?php if (!$this->locked): ?>
                <?php /*
                <div class='message_view_leftwrapper'>
                    <div class='message_view_photo'>
                        &nbsp;
                    </div>
                    <div class='message_view_from'>
                        <p>
                            &nbsp;
                        </p>
                        <p class="message_view_date">
                            &nbsp;
                        </p>
                    </div>
                </div>
                */ ?>

                <div class='message_view_info'>
                    <?php if ((!$this->blocked && !$this->viewer_blocked) || (count($this->recipients) > 1)): ?>
                        <?php echo $this->form->setAttrib('id', 'messages_form_reply')->render($this) ?>
                    <?php elseif ($this->viewer_blocked): ?>
                        <?php echo $this->translate('You can no longer respond to this message because you have blocked %1$s.', $this->viewer_blocker->getTitle()) ?>
                    <?php else: ?>
                        <?php echo $this->translate('You can no longer respond to this message because %1$s has blocked you.', $this->blocker->getTitle()) ?>
                <?php endif; ?>
                </div>
        <?php endif ?>
    </div>
</div>


<?php if (!$this->locked): ?>

    <?php
    $this->headScript()
            ->appendFile($this->layout()->staticBaseUrl . 'externals/mdetect/mdetect' . ( APPLICATION_ENV != 'development' ? '.min' : '' ) . '.js')
            ->appendFile($this->layout()->staticBaseUrl . 'application/modules/Core/externals/scripts/composer.js');
    ?>

    <script type="text/javascript">
        //<![CDATA[
        var composeInstance;
        en4.core.runonce.add(function() {
            var tel = new Element('div', {
                'id': 'compose-tray',
                'styles': {
                    'display': 'none'
                }
            }).inject($('submit'), 'before');

            var mel = new Element('div', {
                'id': 'compose-menu'
            }).inject($('submit'), 'after');

            if ('<?php
    $id = Engine_Api::_()->user()->getViewer()->level_id;
    echo Engine_Api::_()->getDbtable('permissions', 'authorization')->getAllowed('messages', $id, 'editor');
    ?>' == 'plaintext') {
                // @todo integrate this into the composer
                if (!Browser.Engine.presto && !Browser.Engine.trident && !DetectMobileQuick() && !DetectIpad()) {
                    composeInstance = new Composer('body', {
                        overText: false,
                        menuElement: mel,
                        trayElement: tel,
                        baseHref: '<?php echo $this->baseUrl() ?>',
                        hideSubmitOnBlur: false,
                        allowEmptyWithAttachment: false,
                        submitElement: 'submit',
                        type: 'message'
                    });
                }
            }
        });
        //]]>>
    </script>
    <?php foreach ($this->composePartials as $partial): ?>
        <?php echo $this->partial($partial[0], $partial[1]) ?>
    <?php endforeach; ?>

<?php endif ?>
</div>