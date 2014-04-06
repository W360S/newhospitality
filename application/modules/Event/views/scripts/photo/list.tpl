<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: list.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.layout_middle{
	padding:10px 0px;
}
div .event_photos_list_options .buttonlink{
	float: none;
}
ul.thumbs {
	-moz-border-radius:3px 3px 3px 3px;
	border: 1px solid #D0E2EC;
	padding: 10px;
}
</style>
<?php 
	$event= $this->event;
	$paginator= $this->paginator;
	$canUpload= $this->canUpload;
?>
<div class="content">
<?php echo $this->content()->renderWidget('event.profile-featured');?>
<div class='layout_middle'>
<div class="headline">
<h2>  
  <?php echo $event->__toString()." ".$this->translate("&#187; Photos") ?>
</h2>
</div>
<?php if($canUpload): ?>
  <div class="event_photos_list_options">
    <?php echo $this->htmlLink(array(
        'route' => 'event_extended',
        'controller' => 'photo',
        'action' => 'upload',
        'subject' => $this->subject()->getGuid(),
      ), $this->translate('Upload Photos'), array(
        'class' => 'buttonlink icon_event_photo_new'
    )) ?>
  </div>
<?php endif; ?>

  <?php if( $paginator->count() > 0 ): ?>
    <?php echo $this->paginationControl($paginator); ?>
    <br />
  <?php endif; ?>
  <ul class="thumbs thumbs_nocaptions">
    <?php foreach( $paginator as $photo ): ?>
      <li>
        <a class="thumbs_photo" href="<?php echo $photo->getHref(); ?>">
          <span style="background-image: url(<?php echo $photo->getPhotoUrl('thumb.normal'); ?>);"></span>
        </a>
      </li>
    <?php endforeach;?>
  </ul>
  <?php if( $paginator->count() > 0 ): ?>
    <br />
    <?php echo $this->paginationControl($paginator); ?>
  <?php endif; ?>
</div>
</div>
