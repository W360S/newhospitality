<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: list.tpl 7244 2010-09-01 01:49:53Z john $
 * @author	   John
 */
?>
<style type="text/css">
div .group_photos_list_options .buttonlink{
	float: none;
}
.group_photos_list_options{
	position: relative;
	top: 0px;
}
ul.thumbs {
	-moz-border-radius:3px 3px 3px 3px;
	border: 1px solid #D0E2EC;
	padding: 10px;
}

</style>
<?php 
$group= $this->group;
$canUpload= $this->canUpload;
?>
<div class="content">
<div class="layout_right">

	<?php //echo $this->formFilter->setAttrib('class', 'filters')->render($this) ?>
    <div class="subsection">
        <h2>Featured groups</h2>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
                 <?php 
                 
                 $pages = $this->paginator;  
                 $form= $this->formFilter;
                 echo $this->content()->renderWidget('group.featured'); ?>
                 
            </div>
        </div>
    </div>
    <!--
    <div class="subsection">
        <?php //echo $this->content()->renderWidget('event.ad'); ?>
    </div>
    -->
</div>
<div class='layout_middle'>
<div class="headline"> 
<h2>
  <?php echo $group->__toString() ?>
  <?php echo $this->translate('&#187; Photos');?>
</h2>
</div>
<?php if( $canUpload ): ?>
  <div class="group_photos_list_options">
    <?php echo $this->htmlLink(array(
        'route' => 'group_extended',
        'controller' => 'photo',
        'action' => 'upload',
        'subject' => $this->subject()->getGuid(),
      ), $this->translate('Upload Photos'), array(
        'class' => 'buttonlink icon_group_photo_new'
    )) ?>
  </div>
<?php endif; ?> 

  <?php if( $pages->count() > 0 ): ?>
    <?php echo $this->paginationControl($pages); ?>
    <br />
  <?php endif; ?>
  <ul class="thumbs thumbs_nocaptions">
    <?php foreach( $pages as $photo ): ?>
      <li>
        <a class="thumbs_photo" href="<?php echo $photo->getHref(); ?>">
          <span style="background-image: url(<?php echo $photo->getPhotoUrl('thumb.normal'); ?>);"></span>
        </a>
      </li>
    <?php endforeach;?>
  </ul>
  <?php if( $pages->count() > 0 ): ?>
    <?php echo $this->paginationControl($pages); ?>
    <br />
  <?php endif; ?>
</div>
</div>