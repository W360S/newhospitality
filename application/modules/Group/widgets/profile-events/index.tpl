<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
 * @author		 Sami          
 */
?>
<style type="text/css">
ul.profile_events{
	-moz-border-radius:3px 3px 3px 3px;
	border: 1px solid #D0E2EC;
	padding: 10px;
	
}
ul.profile_events >li{
	border-top: 1px solid #EAEAEA;
	padding: 0px 0px 10px;
	*border-bottom: none;
}
.layout_group_profile_events ul > li + li {
	margin-top: 0px;
}
div .group_album_options .buttonlink {
	padding-bottom: 5px;
}
.layout_group_profile_events{
	border:1px solid #D0E2EC;
	background-color:#F2FAFF;
	padding:10px;
	-moz-border-radius: 0px 3px 3px 3px;  
	position:relative;
}
</style>
<div class="group_album_options">
  <?php /* if( $this->paginator->getTotalItemCount() > 0 ): ?>
    <?php echo $this->htmlLink(array(
        'route' => 'event_general',
      ), $this->translate('View All Events'), array(
        'class' => 'buttonlink icon_group_photo_view'
    )) ?>
  <?php endif; */ ?>

  <?php if( $this->canAdd ): ?>
    <?php echo $this->htmlLink(array(
        'route' => 'event_general',
        'controller' => 'event',
        'action' => 'create',
        'parent_type'=> 'group',
        'subject_id' => $this->subject()->getIdentity(),
      ), $this->translate('Add Events'), array(
        'class' => 'buttonlink icon_group_photo_new'
    )) ?>
    <br />
  <?php endif; ?>

</div>

<?php if( $this->paginator->getTotalItemCount() > 0 ): ?>

  <ul class="profile_events">
<?php 
	$i=1;
?>
    <?php foreach( $this->paginator as $event ): ?>
	<li <?php if($i == 1)	echo 'class="last_li"'?>>
        	<?php $i++;?>
        <div class='groups_profile_tab_photo'>
          <?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal')) ?>
        </div>
        <div class='groups_profile_tab_info'>
          <div class="groups_profile_tab_title">
            <?php echo $this->htmlLink($event->getHref(), $this->string()->chunk($event->getTitle(), 10)) ?>
          </div>
          <span class="groups_profile_tab_members">
            <?php echo $this->translate('By');?>
            <?php echo $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle()) ?>
          </span>
          <span class="groups_profile_tab_members">
            <?php echo $this->timestamp($event->creation_date) ?>
          </span>
          <div class="groups_profile_tab_desc">
            <?php echo $event->getDescription() ?>
          </div>
        </div>
      </li>
    <?php endforeach;?>
  </ul>

<?php else: ?>

  <div class="tip">
    <span>
      <?php echo $this->translate('No events have been added to this group yet.');?>
    </span>
  </div>

<?php endif; ?>
