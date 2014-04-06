<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
 * @access	   John
 */
?>
<style type="text/css">
.layout_event_profile_events{
	border:1px solid #D0E2EC;
	background-color:#E9F4FA;
	padding:10px; 
	-moz-border-radius: 0px 3px 3px 3px;  
	position:relative;
	
}
ul.events_profile_tab>li{
	border-bottom:1px solid #EAEAEA;
	padding-bottom:10px;
}
</style>
<ul class="events_profile_tab">
  <?php foreach( $this->paginator as $event ): ?>
    <li>
      <div class="events_profile_tab_photo">
        <?php echo $this->htmlLink($event, $this->itemPhoto($event, 'thumb.normal')) ?>
      </div>
      <div class="events_profile_tab_info">
        <div class="events_profile_tab_title">
          <?php echo $this->htmlLink($event->getHref(), $event->getTitle()) ?>
        </div>
        <div class="events_profile_tab_title">
          <strong><?php echo $this->translate("Start: "); ?></strong><?php echo date('F d, Y \a\t h:a',strtotime($event->starttime)); ?>
        </div>
        <div class="events_profile_tab_title">
          <strong><?php echo $this->translate("End: "); ?></strong><?php echo date('F d, Y \a\t h:a',strtotime($event->endtime)); ?>
        </div>
        <div class="events_profile_tab_title">
          <strong><?php echo $this->translate("Post by: "); ?></strong><?php echo  $this->htmlLink('/profile/'.$event->getOwner()->username, $event->getOwner()->displayname) ?>
        </div>
        <div class="events_profile_tab_title">
          <strong><?php echo $this->translate("Place: "); ?></strong><?php echo $event->location ?>
        </div>
        <div class="events_profile_tab_title">
          <strong><?php echo $this->translate("Organized by: "); ?></strong><?php echo $event->host ?>
        </div>
        <div class="events_profile_tab_members">
          <?php echo $this->translate(array('%s guest', '%s guests', $event->member_count),$this->locale()->toNumber($event->member_count)) ?>
        </div>
        <div class="events_profile_tab_desc">
          <?php //echo $event->getDescription() ?>
        </div>
      </div>
    </li>
  <?php endforeach; ?>
</ul>
<div style="height:12px;">
<?php if(true):?>
  <?php echo $this->htmlLink($this->url(array('user' => Engine_Api::_()->core()->getSubject()->getIdentity()), 'event_general'), $this->translate('View All Events'), array('class' => 'buttonlink item_icon_event')) ?>
<?php endif;?>
</div>     