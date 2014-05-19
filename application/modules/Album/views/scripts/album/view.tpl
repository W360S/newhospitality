<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Album
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: view.tpl 7545 2010-10-04 19:38:10Z john $
 * @author     Sami
 */
?>


<?php if ('' != trim($this->album->getDescription())): ?>
    <p>
        <?php echo $this->album->getDescription() ?>
    </p>
    <br />
<?php endif ?>




<div class="generic_layout_container layout_right">
    <div class="generic_layout_container layout_resumes_check_list">
        <div class="pt-right-job"> 
            <div class="pt-block">
                <h3 class="pt-title-right">Options</h3>
                <?php if ($this->mine || $this->can_edit): ?>
                    <ul class="pt-list-cbth">
                        <li>
                            <span class="pt-text">
                                <?php
                                echo $this->htmlLink(array('route' => 'album_general', 'action' => 'upload', 'album_id' => $this->album->album_id), $this->translate('Add More Photos'), array(
                                    'class' => 'buttonlink icon_photos_new'
                                ))
                                ?>
                            </span>
                        </li>
                        <li>
                            <span class="pt-text">
                                <?php
                                echo $this->htmlLink(array('route' => 'album_specific', 'action' => 'editphotos', 'album_id' => $this->album->album_id), $this->translate('Manage Photos'), array(
                                    'class' => 'buttonlink icon_photos_manage'
                                ))
                                ?>
                            </span>
                        </li>
                        <li>
                            <span class="pt-text"><?php
                                echo $this->htmlLink(array('route' => 'album_specific', 'action' => 'edit', 'album_id' => $this->album->album_id), $this->translate('Edit Settings'), array(
                                    'class' => 'buttonlink icon_photos_settings'
                                ))
                                ?>
                            </span>
                        </li>
                        <li>
                            <span class="pt-text"><?php
                                echo $this->htmlLink(array('route' => 'album_specific', 'action' => 'delete', 'album_id' => $this->album->album_id, 'format' => 'smoothbox'), $this->translate('Delete Album'), array(
                                    'class' => 'buttonlink smoothbox icon_photos_delete'
                                ))
                                ?>
                            </span>
                        </li>
                    </ul>
                <?php endif; ?>


<!--                <li class="pt-active"><span class="pt-number-1">1</span><span class="pt-text"><a>Thong tin</a></span><span class="pt-icon-oky"></span></li>
                <li ><span class="pt-number-1">2</span><span class="pt-text"><a href="/members/edit/photo">Avatar</a></span><span class="pt-icon-oky"></span></li>-->

            </div>	
        </div>
    </div>
</div>

<div class="generic_layout_container layout_middle">
    <div class="generic_layout_container layout_core_content">
        <div class="pt-title-event">
            <ul class="pt-menu-event pt-menu-libraries">
                
                <li>
                    <span><?php echo $this->translate('%1$s\'s Album: %2$s', $this->album->getOwner()->__toString(), ( '' != trim($this->album->getTitle()) ? $this->album->getTitle() : '<em>' . $this->translate('Untitled') . '</em>')); ?></span>
                </li>
            </ul>
        </div>
        <div class="pt-content">
            <ul class="thumbs thumbs_nocaptions">
                <?php foreach ($this->paginator as $photo): ?>
                    <li>
                        <a class="thumbs_photo" href="<?php echo $photo->getHref(); ?>">
                            <span style="background-image: url(<?php echo $photo->getPhotoUrl('thumb.normal'); ?>);"></span>
                            <div style='text-align: center;'><?php echo $photo->title; ?></div>
                        </a>
                    </li>
                <?php endforeach; ?>
            </ul>
            <?php if ($this->paginator->count() > 0): ?>
                <br />
                <?php echo $this->paginationControl($this->paginator); ?>
            <?php endif; ?>

            <?php echo $this->action("list", "comment", "core", array("type" => "album", "id" => $this->album->getIdentity())); ?>
        </div>

    </div>


</div>