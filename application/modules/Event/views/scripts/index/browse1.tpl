<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: browse.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.subcontent .filter .select_sort {
	font-weight:bold;
	padding-left:12px;
}

.events_browse li.last_li{border-top:none;}

</style>
<?php
    $nav = $this->navigation;

    $pages = $this->paginator;  
    $form= $this->formFilter;
    $formValues= $this->formValues;
    $filter= $this->filter;
?>
<div class="content">
<div class="layout_right">
	
    <div class="subsection">
        <h2>Featured events</h2>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
                 <?php 
                 
                 echo $this->content()->renderWidget('event.feature'); 
                 ?>
            </div>
        </div>
    </div>
</div>
<div class="layout_middle"> 
<div class="headline">
  <h2>
    <?php echo $this->translate('Events');?>
  </h2>
  <div class="tabs">
    <?php
      // Render the menu
      echo $this->navigation()
        ->menu()
        ->setContainer($nav)
        ->render();
    ?>
  </div>
  <div class="subcontent">
			
	  		<div><?php echo $form->render($this)?> </div>  
  </div>
</div>

<?php 
	//$liclass = 'last_li';
	$i=1;
?>
<?php if( count($pages) > 0 ): ?>
    <ul class='events_browse'>
      <?php foreach( $pages as $event ): ?>
        <li <?php if($i == 1)	echo 'class="last_li"'?>>
          <div class="events_photo">
            <?php if($event->photo_id): ?>
                <?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal')) ?>
            <?php else: ?>
                <a href="<?php echo $event->getHref(); ?>"><img src="<?php echo $this->baseUrl(); ?>/application/modules/Event/externals/images/nophoto_event_thumb_normal.png"></a>
            <?php endif; ?>          
            
          </div>
          <div class="events_options">
            <?php if( $this->viewer() && $event->isOwner($this->viewer()) ): ?>
              <?php echo $this->htmlLink(array('route' => 'event_specific', 'action' => 'edit', 'controller'=>'event', 'event_id' => $event->getIdentity()), $this->translate('Edit Event'), array(
                'class' => 'buttonlink icon_event_edit'
              )) ?>
            <?php endif; ?>
            <?php if(($filter != "past") && $this->viewer()->getIdentity() && !$event->membership()->isMember($this->viewer(), null) ): ?>
              <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $event->getIdentity()), $this->translate('Join Event'), array(
                'class' => 'buttonlink smoothbox icon_event_join'
              )) ?>
              <?php elseif( $this->viewer() && $event->isOwner($this->viewer()) ): ?>
                <?php echo $this->htmlLink(array('route' => 'event_specific', 'action' => 'delete', 'event_id' => $event->getIdentity()), $this->translate('Delete Event'), array(
                  'class' => 'buttonlink REMsmoothbox icon_event_delete'
                )) ?>
            <?php elseif( $this->viewer() && $event->membership()->isMember($this->viewer()) ): ?>
              <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'leave', 'event_id' => $event->getIdentity()), $this->translate('Leave Event'), array(
                'class' => 'buttonlink smoothbox icon_event_leave'
              )) ?>
            <?php endif; ?>
          </div>
          <div class="events_info">
            <div class="events_title">
              <h3><?php echo $this->htmlLink($event->getHref(), $event->getTitle()) ?></h3>
            </div>	    
            <div class="events_members">
              <?php echo $this->translate(array('%s guest', '%s guests', $event->membership()->getMemberCount()),$this->locale()->toNumber($event->membership()->getMemberCount())) ?>
              <?php echo $this->translate('led by');?> <?php echo $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle()) ?>
            </div>
            <div class="events_desc">
              <?php echo $event->getDescription() ?>
            </div>
          </div>
        </li>
        <?php $i++;?>
      <?php endforeach; ?>
    </ul>

    <?php if( $pages->count() > 1 ): ?>
      <?php echo $this->paginationControl($pages, null, null, array(
        'query' => $formValues
      )); ?>
    <?php endif; ?>

<?php else: ?>

  <div class="tip">
    <span>
      <?php echo $this->translate('Nobody has created an event yet.');?>
      <?php if (TRUE): // @todo check if user is allowed to create an event ?>
        <?php echo $this->translate('Be the first to %1$screate%2$s one!', '<a href="'.$this->url(array('action'=>'create'), 'event_general').'">', '</a>'); ?>
      <?php endif; ?>
    </span>
  </div>

<?php endif; ?>
</div>
</div>
