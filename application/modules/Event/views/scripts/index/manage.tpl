<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: manage.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<?php
$pages = $this->paginator;
$form = $this->formFilter;
$view = $this->view;
$text = $this->text;
$category_id = $this->category_id;
$formValues = $this->formValues;
?>
<div class="content">
    <div class="wd-content-event">
        <div class="pt-title-event">
            <ul class="pt-menu-event">
                <li id="event-item-upcomming">
                    <a href="<?php echo $this->baseUrl(); ?>/events"><?php echo $this->translate('Upcoming Events') ?></a>
                </li>
                <li id="event-item-past">
                    <a href="<?php echo $this->baseUrl(); ?>/events/past"><?php echo $this->translate('Past Events') ?></a>
                </li>
                <li id="event-item-manage">
                    <a href="<?php echo $this->baseUrl(); ?>/events/manage"><?php echo $this->translate('My Events') ?></a>
                </li>
            </ul>
            <a href="<?php echo $this->baseUrl(); ?>/events/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New Event') ?></a>
        </div>
        <script>
            jQuery(document).ready(function($) {
                var events_browse_url = "/events";
                var events_past_url = "/events/past";
                var events_manage_url = "/events/manage";

                if (document.URL.indexOf(events_past_url) != -1) {
                    $("#event-item-past").addClass("active");
                } else {
                    if (document.URL.indexOf(events_manage_url) != -1) {
                        $("#event-item-manage").addClass("active");
                    } else {
                        if (document.URL.indexOf(events_browse_url) != -1) {
                            $("#event-item-upcomming").addClass("active");
                        }
                    }
                }
            });
        </script>
        <div class="pt-how-list-event">
            <?php if ($pages->count() > 1): ?>
                <?php echo $this->paginationControl($pages, null, null, array('query' => $formValues)); ?>
            <?php endif; ?>
            <?php $i = 1; ?>
            <?php if (count($pages) > 0): ?>
                <ul class='pt-list-event'>
                    <?php foreach ($pages as $event): ?>
                        <li style="width:23%;float:left;padding:7px">
                            <div class="pt-how-all">
                                <div  class="pt-how-img">
                                    <?php if ($event->photo_id): ?>
                                        <?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal', "events", array("width" => "221px"))) ?>
                                    <?php else: ?>
                                        <a href="<?php echo $event->getHref(); ?>"><img src="<?php echo $this->baseUrl(); ?>/application/modules/Event/externals/images/nophoto_event_thumb_normal.png"></a>
                                    <?php endif; ?>
                                    <div class="pt-views-comment">
                                        <a href="#" class="pt-views"><span></span><?php echo $event->view_count ?></a>
                                        <a href="#" class="pt-comment"><span></span><?php echo $event->member_count ?></a>
                                    </div>          
                                </div>
                                <div class="events_options">
                                    <?php if ($this->viewer() && $event->isOwner($this->viewer())): ?>
                                        <?php
                                        echo $this->htmlLink(array('route' => 'event_specific', 'action' => 'edit', 'controller' => 'event', 'event_id' => $event->getIdentity()), $this->translate('Edit Event'), array(
                                            'class' => 'buttonlink icon_event_edit'
                                        ))
                                        ?>
                                    <?php endif; ?>
                                    <?php if (($filter != "past") && $this->viewer()->getIdentity() && !$event->membership()->isMember($this->viewer(), null)): ?>
                                        <?php //echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $event->getIdentity()), $this->translate('Join Event'), array('class' => 'buttonlink smoothbox icon_event_join')) ?>
                                    <?php elseif ($this->viewer() && $event->isOwner($this->viewer())): ?>
                                        <?php
                                        echo $this->htmlLink(array('route' => 'event_specific', 'action' => 'delete', 'event_id' => $event->getIdentity()), $this->translate('Delete Event'), array(
                                            'class' => 'buttonlink REMsmoothbox icon_event_delete'
                                        ))
                                        ?>
                                    <?php elseif ($this->viewer() && $event->membership()->isMember($this->viewer())): ?>
                                        <?php
                                        echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'member', 'action' => 'leave', 'event_id' => $event->getIdentity()), $this->translate('Leave Event'), array(
                                            'class' => 'buttonlink smoothbox icon_event_leave'
                                        ))
                                        ?>
                                    <?php endif; ?>
                                </div>
                                <div class="pt-how-content-event">                            
                                    <h3><?php echo $this->htmlLink($event->getHref(), $event->getTitle()) ?></h3>                               
                                    <div class="events_members">
                                        <?php //echo $this->translate(array('%s guest', '%s guests', $event->membership()->getMemberCount()),$this->locale()->toNumber($event->membership()->getMemberCount())) ?>

                                        <p class="pt-times"><span></span><?php echo $event->starttime; ?></p>
                                        <p class="pt-address"><span></span><?php echo $event->location; ?></p>
                                    </div>
                                    <div class="pt-user-name">
                                        <?php
                                        $user_id = $event->user_id;
                                        $member2 = Engine_Api::_()->user()->getUser($user_id);
                                        echo $this->htmlLink($member2->getHref(), $this->itemPhoto($member2, 'thumb.icon'), array('class' => 'pt-avatar'));
                                        ?>
                                        <p><strong>Đăng bởi:</strong>
                                        <?php echo $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle()) ?> <p>
                                        <p><?php echo $event->creation_date; ?></p>
                                    </div>
                                    <div class="events_desc">
                                        <?php //print_r($event); //echo $this->viewMore($event->getDescription())  ?>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <?php $i++; ?>
                    <?php endforeach; ?>

                </ul>
                <?php if ($pages->count() > 1): ?>
                    <?php echo $this->paginationControl($pages, null, null, array('query' => $formValues)); ?>
                <?php endif; ?>
            <?php else: ?>
                <div class="tip">
                    <span>
                        <?php echo $this->translate('Nobody has created an event yet.'); ?>
                        <?php if (TRUE): // @todo check if user is allowed to create an event  ?>
                            <?php echo $this->translate('Be the first to %1$screate%2$s one!', '<a href="' . $this->url(array('action' => 'create'), 'event_general') . '">', '</a>'); ?>
                        <?php endif; ?>
                    </span>
                </div>
            <?php endif; ?>

        </div>
    </div>
</div>