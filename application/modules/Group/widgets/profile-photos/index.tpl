<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
 * @author		 John
 */
?>
<div class="event_album_options">
    
    <?php if ($this->paginator->getTotalItemCount() > 0): ?>
        <?php
        echo $this->htmlLink(array(
            'route' => 'group_extended',
            'controller' => 'photo',
            'action' => 'list',
            'subject' => $this->subject()->getGuid(),
                ), $this->translate('View All Photos'), array(
            'class' => 'buttonlink icon_group_photo_view'
        ))
        ?>
    <?php endif; ?>

    <?php if ($this->canUpload): ?>
        <?php
        echo $this->htmlLink(array(
            'route' => 'group_extended',
            'controller' => 'photo',
            'action' => 'upload',
            'subject' => $this->subject()->getGuid(),
                ), $this->translate('Upload Photos'), array(
            'class' => 'buttonlink icon_group_photo_new'
        ))
        ?>
    <?php endif; ?>
</div>

<br />

<?php if ($this->paginator->getTotalItemCount() > 0): ?>

    <ul class="pt-list-img-up">
        <?php foreach ($this->paginator as $photo): ?>
            <li class="">
                <a class="pt-img-event" href="<?php echo $photo->getHref(); ?>"><img src="<?php echo $photo->getPhotoUrl('thumb.normal'); ?>" alt="Image"></a>
                <div class="pt-info-img">
                    <p>Đăng bởi: <?php echo $this->htmlLink($photo->getOwner()->getHref(), $photo->getOwner()->getTitle(), array('class' => 'thumbs_author')) ?></p>
                    <span><?php echo $this->timestamp($photo->creation_date) ?></span>
                </div>
            </li>

            
    <?php endforeach; ?>
    </ul>

<?php else: ?>
    <div class="tip">
        <span>
            <?php echo $this->translate('No photos have been uploaded to this group yet.'); ?>
        </span>
    </div>

<?php endif; ?>
