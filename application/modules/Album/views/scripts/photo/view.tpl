<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Album
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: view.tpl 7305 2010-09-07 06:49:55Z john $
 * @author     Sami
 */
?>

<?php
$this->headScript()
        ->appendFile($this->baseUrl() . '/externals/moolasso/Lasso.js')
        ->appendFile($this->baseUrl() . '/externals/moolasso/Lasso.Crop.js')
        ->appendFile($this->baseUrl() . '/externals/autocompleter/Observer.js')
        ->appendFile($this->baseUrl() . '/externals/autocompleter/Autocompleter.js')
        ->appendFile($this->baseUrl() . '/externals/autocompleter/Autocompleter.Local.js')
        ->appendFile($this->baseUrl() . '/externals/autocompleter/Autocompleter.Request.js')
        ->appendFile($this->baseUrl() . '/externals/tagger/tagger.js');
$this->headTranslate(array(
    'Save', 'Cancel', 'delete',
));
?>

<script type="text/javascript">
    var taggerInstance;
    en4.core.runonce.add(function() {
        taggerInstance = new Tagger('media_photo_next', {
            'title': '<?php echo $this->string()->escapeJavascript($this->translate('ADD TAG')); ?>',
            'description': '<?php echo $this->string()->escapeJavascript($this->translate('Type a tag or select a name from the list.')); ?>',
            'createRequestOptions': {
                'url': '<?php echo $this->url(array('module' => 'core', 'controller' => 'tag', 'action' => 'add'), 'default', true) ?>',
                'data': {
                    'subject': '<?php echo $this->subject()->getGuid() ?>'
                }
            },
            'deleteRequestOptions': {
                'url': '<?php echo $this->url(array('module' => 'core', 'controller' => 'tag', 'action' => 'remove'), 'default', true) ?>',
                'data': {
                    'subject': '<?php echo $this->subject()->getGuid() ?>'
                }
            },
            'cropOptions': {
                'container': $('media_photo_next')
            },
            'tagListElement': 'media_tags',
            'existingTags': <?php echo $this->action('retrieve', 'tag', 'core', array('sendNow' => false)) ?>,
            'suggestParam': <?php echo ( $this->viewer()->getIdentity() ? $this->action('suggest', 'friends', 'user', array('sendNow' => false, 'includeSelf' => true)) : 'null' ) ?>,
            'guid': <?php echo ( $this->viewer()->getIdentity() ? "'" . $this->viewer()->getGuid() . "'" : 'false' ) ?>,
            'enableCreate': <?php echo ( $this->canTag ? 'true' : 'false') ?>,
            'enableDelete': <?php echo ( $this->canUntagGlobal ? 'true' : 'false') ?>
        });

        // Remove the href attrib while tagging
        var nextHref = $('media_photo_next').get('href');
        taggerInstance.addEvents({
            'onBegin': function() {
                $('media_photo_next').erase('href');
            },
            'onEnd': function() {
                $('media_photo_next').set('href', nextHref);
            }
        });

    });
</script>

<div class="pt-title-event">
    <ul class="pt-menu-event pt-menu-libraries">

        <li>
            <?php echo $this->translate('%1$s\'s Album: %2$s', $this->album->getOwner()->__toString(), $this->htmlLink($this->album, $this->album->getTitle())); ?>
        </li>
    </ul>
</div>

<?php if ("" != $this->album->getDescription()): ?>
    <p class="photo-description">
        <?php echo $this->album->getDescription() ?>
    </p>
<?php endif ?>
<div class="layout_middle">
    <div class='albums_viewmedia'>
        <?php if (!$this->message_view): ?>
            <div class="albums_viewmedia_nav">
                <div>
                    <?php
                    echo $this->translate('Photo %1$s of %2$s in %3$s', $this->locale()->toNumber($this->photo->getCollectionIndex() + 1), $this->locale()->toNumber($this->album->count()), (string) $this->album->getTitle())
                    ?>
                </div>
                <?php if ($this->album->count() > 1): ?>
                    <div>
                        <?php echo $this->htmlLink($this->photo->getPrevCollectible()->getHref(), $this->translate('Prev')) ?>
                        <?php echo $this->htmlLink($this->photo->getNextCollectible()->getHref(), $this->translate('Next')) ?>
                    </div>
                <?php endif; ?>
            </div>
        <?php endif; ?>
        <div class='albums_viewmedia_info'>
            <div class='album_viewmedia_container' id='media_photo_div'>
                <a id='media_photo_next'  href='<?php echo $this->escape($this->photo->getNextCollectible()->getHref()) ?>'>
                    <?php
                    echo $this->htmlImage($this->photo->getPhotoUrl(), $this->photo->getTitle(), array(
                        'id' => 'media_photo'
                    ));
                    ?>
                </a>
            </div>
            <br />
            <a></a>
            <?php if ($this->photo->getTitle()): ?>
                <div class="albums_viewmedia_info_title">
                    <?php echo $this->photo->getTitle(); ?>
                </div>
            <?php endif; ?>
            <?php if ($this->photo->getDescription()): ?>
                <div class="albums_viewmedia_info_caption">
                    <?php echo $this->photo->getDescription() ?>
                </div>
            <?php endif; ?>
            <div class="albums_viewmedia_info_tags" id="media_tags" style="display: none;">
                <?php echo $this->translate('Tagged:'); ?>
            </div>
            <div class="albums_viewmedia_info_date">
                <?php echo $this->translate('Added'); ?> <?php echo $this->timestamp($this->photo->modified_date) ?>
                <?php if ($this->canTag): ?>
                    - <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Add Tag'), array('onclick' => 'taggerInstance.begin();')) ?>
                <?php endif; ?>
                <?php if (!$this->message_view): ?>

                    - <?php echo $this->htmlLink(Array('module' => 'activity', 'controller' => 'index', 'action' => 'share', 'route' => 'default', 'type' => 'album_photo', 'id' => $this->photo->getIdentity(), 'format' => 'smoothbox'), $this->translate("Share"), array('class' => 'smoothbox')); ?>
                    - <?php echo $this->htmlLink(Array('module' => 'core', 'controller' => 'report', 'action' => 'create', 'route' => 'default', 'subject' => $this->photo->getGuid(), 'format' => 'smoothbox'), $this->translate("Report"), array('class' => 'smoothbox')); ?>
                    - <?php echo $this->htmlLink(array('route' => 'user_extended', 'module' => 'user', 'controller' => 'edit', 'action' => 'external-photo', 'photo' => $this->photo->getGuid(), 'format' => 'smoothbox'), $this->translate('Set Default Profile Photo'), array('class' => 'smoothbox')) ?>
                <?php endif; ?>
            </div>
        </div>

        <?php echo $this->action("list", "comment", "core", array("type" => "album_photo", "id" => $this->photo->getIdentity())); ?>
    </div>
</div>