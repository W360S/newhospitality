<?php
$paginator = $this->paginator;
$category = $this->category;

$navigation = $this->navigation()->menu()->setContainer($this->navigation)->render();

$pages = $this->paginator;
$form = $this->formFilter;
$formValues = $this->formValues;
$filter = $this->filter;
?>
<div class="content">
    <div class="wd-content-event">
        <div class="pt-title-event">
            <ul class="pt-menu-event">
                <li class="active">
                    <a href="<?php echo $this->baseUrl(); ?>/events"><?php echo $this->translate('Upcoming Events') ?></a>
                </li>
                <li>
                    <a href="<?php echo $this->baseUrl(); ?>/events/past"><?php echo $this->translate('Past Events') ?></a>
                </li>
                <li>
                    <a href="<?php echo $this->baseUrl(); ?>/events/manage"><?php echo $this->translate('My Events') ?></a>
                </li>
            </ul>
            <a href="<?php echo $this->baseUrl(); ?>/events/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New Event') ?></a>
        </div>
        <div class="pt-content-event">
            <script type="text/javascript">
                /*
                var tabContainerSwitch = function(element) {
                    if (element.tagName.toLowerCase() == 'a') {
                        element = element.getParent('li');
                    }
                    var myContainer = element.getParent('.tabs_parent').getParent();
                    myContainer.getChildren('div:not(.tabs_alt)').setStyle('display', 'none');
                    myContainer.getElements('ul; li').removeClass('active');
                    element.get('class').split(' ').each(function(className) {
                        className = className.trim();
                        if (className.match(/^tab_[0-9]+$/)) {
                            myContainer.getChildren('div.' + className).setStyle('display', null);
                            element.addClass('active');
                            var st = $$('.tab_pulldown_contents_wrapper').getParent();
                            st.removeClass('tab_open');
                        }
                    });

                }*/
                function openSearch(){
                    jQuery("#tabs-2").hide();
                    jQuery("#tabs-1").show();
                }

                function openCategories(){
                    jQuery("#tabs-2").show();
                    jQuery("#tabs-1").hide();
                }

            </script>
            
            <div class="tabs_alt tabs_parent pt-event-tabs">
                <ul class="pt-title" id="main_tabs">
                    <li><a href="javascript:void(0)" onclick="openSearch()">TÌM KIẾM</a></li>
                    <li><a href="javascript:void(0)" onclick="openCategories()">LĨNH VỰC</a></li>
                  </ul>
                <div id="tabs-2" class="pt-content-tab" style="display:none;">
                    <?php echo $this->content()->renderWidget('event.categories'); ?>
                </div>
                <div id="tabs-1" class="pt-content-tab">
                    <?php echo $this->content()->renderWidget('event.search'); ?>
                </div>
            </div>

            
        </div>

        <div class="pt-how-list-event">
            <?php if ($pages->count() > 1): ?>
                <?php echo $this->paginationControl($pages, null, null, array('query' => $formValues )); ?>
            <?php endif; ?>
            <?php $i = 1;?>
                <?php if (count($pages) > 0): ?>
                <ul class='pt-list-event'>

    <?php foreach ($pages as $event): ?>
                        <li style="width:23%;float:left;padding:7px">
                            <div class="pt-how-all">
                                <div  class="pt-how-img">
                                    <?php if ($event->photo_id): ?>
                                        <?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal')) ?>
                                    <?php else: ?>
                                        <a href="<?php echo $event->getHref(); ?>"><img src="<?php echo $this->baseUrl(); ?>/application/modules/Event/externals/images/nophoto_event_thumb_normal.png"></a>
                                    <?php endif; ?>
                                    <div class="pt-views-comment">
                                        <a href="#" class="pt-views"><span></span>68</a>
                                        <a href="#" class="pt-comment"><span></span>9</a>
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

