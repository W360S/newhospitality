<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.layout_event_profile_info{
    border:1px solid #D0E2EC;
	background-color:#F2FAFF;
	padding:10px;
	-moz-border-radius: 0px 3px 3px 3px;  
	position:relative;
    margin-bottom:10px;
    margin-top: 0px !important;
}
.event_description{
    padding-bottom: 10px;
}

.event_stats_time_label{
    float: left;
    width: 50px;
    padding-bottom: 5px;
}

.event_stats_time_content{
    float: left;
    padding-bottom: 5px;
}

.event_where_label{
    float: left;
    width: 50px;
    padding-bottom: 5px;
}

.event_where_content{
    float: left;
}

.event_host_label{
    float: left;
    width: 50px;
    padding-bottom: 5px;
}
.event_host_content{
    float: left;
}

.event_led_by_label{
    float: left;
    width: 50px;
    padding-bottom: 5px;
}
.event_led_by_content{
    float: left;
}

.event_stats_info_label{
    float: left;
    width: 50px;
}
.event_stats_info_content{
    float: left;
}
</style>
<div >
  <ul>
    <?php if (!empty($this->subject()->description)):?>
    <li class="event_description">
      <?php echo nl2br($this->subject()->description);?>
    </li>
    <?php endif ?>
    <li class="event_date">
      <?php if ($this->subject()->starttime == $this->subject()->endtime): ?>
        <div class="event_stats_time_label"><?php echo $this->translate('Date')?></div> <div class="event_stats_content"><?php echo  date('D, d F Y, h:i',strtotime($this->subject()->starttime)); ?></div>
        <div class="event_stats_time_label"><?php echo $this->translate('Time')?></div> <div class="event_stats_content"><?php echo  date('D, d F Y, h:i',strtotime($this->subject()->endtime)); ?></div>
      <?php else: ?>  
        <div class="event_stats_time_content">
          <strong><?php echo $this->translate('Start:'); ?></strong> <?php echo  date('D, d F Y, h:i',strtotime($this->subject()->starttime)); ?>
          <br /><strong><?php echo $this->translate('End:'); ?></strong> <?php echo  date('D, d F Y, h:i',strtotime($this->subject()->endtime)); ?>
        </div>
      <?php endif ?>
    </li>
    
    <?php if (!empty($this->subject()->location)):?>
    <li class="event_where">
      <div class="clear"></div>  
      <div class="event_where_label"><strong><?php echo $this->translate('Place')?></strong></div>
      <div class="event_where_content"><?php echo $this->subject()->location; ?> <?php echo $this->htmlLink('http://maps.google.com/?q='.urlencode($this->subject()->location), $this->translate('Map'), array('target' => 'blank')) ?></div>
    </li>
    <?php endif;?>
    
    <?php if (!empty($this->subject()->host)):?>
    <?php if ($this->subject()->host != $this->subject()->getParent()->getTitle()):?>
    <li>
      <div class="clear"></div>
      <div class="event_host_label"><strong><?php echo $this->translate('Host');?></strong></div>
      <div class="event_host_content"><?php echo $this->subject()->host; ?></div>
    </li>
   <?php endif;?>
    <li>
      <div class="clear"></div> 
      <div class="event_led_by_label"><strong><?php echo $this->translate('Led by');?></strong></div>
      <div class="event_led_by_content"><?php echo $this->subject()->getParent()->__toString(); ?></div>
    </li>
    <?php endif;?>
  
    <li class="event_stats_info">
      <div class="clear"></div>
      <div class="event_stats_info_label"><strong><?php echo $this->translate('RSVPs');?></strong></div>
      <div class="event_stats_info_content">
        <ul>
          <li>
            <?php echo $this->locale()->toNumber($this->subject()->getAttendingCount()) ?>
            <span><?php echo $this->translate('attending');?></span>
          </li>
          <li>
            <?php echo $this->locale()->toNumber($this->subject()->getMaybeCount()) ?>
            <span><?php echo $this->translate('maybe attending');?></span>
          </li>
          <li>
            <?php echo $this->locale()->toNumber($this->subject()->getNotAttendingCount()) ?>
            <span><?php echo $this->translate('not attending');?></span>
          </li>
        </ul>
      </div>
      <div class="clear"></div>
    </li>
  </ul>
</div>
