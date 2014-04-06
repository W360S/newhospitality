<style type="text/css">
    .paging{float: right;}
    /*.subsection{padding-bottom: 42px;}*/
    ul.videos_browse > li {
        clear: none !important;
    }
    ul.paginationControl li {
        border-top-width:0px !important; 
    }
</style>
<?php 
$paginator = $this->paginator;
$category = $this->category;

$navigation = $this->navigation()->menu()->setContainer($this->navigation)->render();

$pages = $this->paginator;  
$form= $this->formFilter;
$formValues= $this->formValues;
$filter= $this->filter;
?>
<div class="content">
    <div class="layout_right">
        <div class="wd-content-left">
            <div class="pt-boss">
                <?php
                //$user_id=$event->user_id;
                //$member2 = Engine_Api::_()->user()->getUser($user_id);
                echo $this->htmlLink(Engine_Api::_()->user()->getViewer()->getHref(), $this->itemPhoto(Engine_Api::_()->user()->getViewer(), 'thumb.icon'), array('class' => 'pt-avatar'));
                ?>
                <div class="pt-how-info-boss">
                    <h3><?php echo Engine_Api::_()->user()->getViewer(); ?></h3>
                    <p><a href="<?php echo Engine_Api::_()->user()->getViewer()->getHref(); ?>">Trang cá nhân</a></p>
                </div>
            </div>
            <ul class="pt-menu-left">
                <li>
                    <h3>Bảng điều khiển</h3>
                </li>
                <li>
                    <?php /*
                    <a href="/index.php/news" class="pt-active" ><span class="pt-icon-menu-left pt-icon-menu-01"></span><span class="pt-menu-text">Bảng tin</span><span class="pt-number"><?php
                    $table = Engine_Api::_()->getItemTable('news_new');
                    //Zend_Debug::dump($table->info('name'), 'table');exit();
                    //$groupTable = Engine_Api::_()->getDbtable('news', 'news');

                    $select = $table->select()
                    ->from($table)
                    ->order('created DESC')
                    ->limit(24);
                    $result = $table->fetchAll($select);
                    //Zend_Debug::dump($result);exit(); 
                    if(count($result)) echo count($result); else echo '0';
                    ?></span></a>
                    */ ?>
                </li>
                <li>
                    <a href="/index.php/messages/inbox/"><span class="pt-icon-menu-left pt-icon-menu-02"></span><span class="pt-menu-text">Tin nhắn</span><span class="pt-number"><?php $viewer = Engine_Api::_()->user()->getViewer();$message_count = Engine_Api::_()->messages()->getUnreadMessageCount($viewer); if($message_count>0) echo $message_count; else echo '0';  ?></span></a>
                </li>
                <li>
                    <?php /*
                    <a href="/index.php/events"><span class="pt-icon-menu-left pt-icon-menu-03"></span><span class="pt-menu-text">Sự kiện</span><span class="pt-number"><?php 
                    $table = Engine_Api::_()->getItemTable('event');
                    //Zend_Debug::dump($table->info('name'), 'table');exit();
                    $groupTable = Engine_Api::_()->getDbtable('events', 'event');
                    $eventTableName = $groupTable->info('name');

                    $select = $groupTable->select()
                    ->from($groupTable->info('name'))
                    ->where("`{$eventTableName}`.`endtime` > FROM_UNIXTIME(?)", time())
                    // ->where("`{$eventTableName}`.`starttime` < FROM_UNIXTIME(?)", time() + (86400 * 14))
                    ->order("endtime DESC")
                    ->order("pinned DESC")
                    ->limit(1000);
                    //echo $select;
                    $result = $select->query()->fetchAll();
                    echo count($result);
                    ?></span></a>
                    */ ?>
                </li>
                <li>
                    <a href="/index.php/community"><span class="pt-icon-menu-left pt-icon-menu-04"></span><span class="pt-menu-text">Album ảnh</span></a>
                </li>

            </ul>
        </div>
        <div class="featured-groups" >
            <h2><?php echo $this->translate('Featured Group'); ?></h2>
            <div class="featured-groups-wrapper">
                <?php //echo $this->content()->renderWidget('event.feature'); ?>
                <?php  echo $this->content()->renderWidget('group.featured');?>
            </div>			   
        </div>
    </div>
    <div class="wd-content-content-sprite" style="width:75%;">
        <div class="wd-content-event">
            <!--<h2>
                <?php echo $this->translate('Event');?>
            </h2>
            <div class="tabs">
                <?php echo $navigation; ?>
            </div>-->
            <div class="pt-title-event">
                <ul class="pt-menu-event">
                    <li class="active">
                        <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events"><?php echo $this->translate('Upcoming Events') ?></a>
                    </li>
                    <li>
                        <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events/past"><?php echo $this->translate('Past Events') ?></a>
                    </li>
                    <li>
                        <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events/manage"><?php echo $this->translate('My Events') ?></a>
                    </li>
                </ul>
                <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New Event') ?></a>
            </div><!--
            <div class="pt-content-event">
                                    <div class="pt-event-tabs">
                                      <ul class="pt-title">
                                            <li><a href="#tabs-1">TÌM KIẾM</a></li>
                                            <li><a href="#tabs-2">LĨNH VỰC</a></li>
                                      </ul>
                                    <div id="tabs-1" class="pt-content-tab">
                                            <div class="pt-content-searching">
                                                            <?php  echo $this->content()->renderWidget('event.search');?>								
                                            </div>
                                      </div>
                                    <div id="tabs-2" class="pt-content-tab">
                                            <ul class="pt-list-areas">
                                                    <?php echo $this->content()->renderWidget('event.categories'); ?>
                                            </ul>
                                      </div>
                                    </div>
                                    
            </div>-->
            <div >
                <script type="text/javascript">
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


                                //alert(jQuery('#main_tabs').find("li.more_tab").attr('class').split(' '));
                                var st = $$('.tab_pulldown_contents_wrapper').getParent();
                                st.removeClass('tab_open');
                                //alert(st);
                            }
                        });

                        //jQuery('#main_tabs').find("li.more_tab").removeClass("tab_open").addClass("tab_closed");
                    }

                </script>
                <style>
                    .tab_1{
                        background: none repeat scroll 0 0 #FFFFFF;
                        border-color: #CCCCCC #CCCCCC -moz-use-text-color;
                        border-style: solid solid none;
                        border-width: 1px 1px medium;
                        color: #000000;
                        padding: 11px;
                        font-size:14px;
                        text-transform: uppercase;
                    }
                    .tab_1.active{
                        background: none repeat scroll 0 0 #4FC1E9;
                        border: 1px solid #4FC1E9;
                        color: #FFFFFF;
                        padding: 11px;
                    }
                    .tab_2{
                        background: none repeat scroll 0 0 #FFFFFF;
                        border-color: #CCCCCC #CCCCCC -moz-use-text-color;
                        border-style: solid solid none;
                        border-width: 1px 1px medium;
                        color: #000000;
                        padding: 11px;
                        font-size:14px;
                        text-transform: uppercase;
                    }
                    .tab_2.active{
                        background: none repeat scroll 0 0 #4FC1E9;
                        border: 1px solid #4FC1E9;
                        color: #FFFFFF;
                        padding: 11px;
                    }

                    .tab_1.active > a {    
                        border:none;
                        color: #fff;
                        outline: medium none;
                        padding: 5px 7px;
                        text-decoration: none;
                    }
                    .tab_2.active > a { 
                        border:none;
                        color: #fff;
                        outline: medium none;
                        padding: 5px 7px;
                        text-decoration: none;
                    }
                    .tab_1 > a {    
                        border:none;
                        border-style: none;
                    }
                    .tab_2 > a { 
                        border:none;
                        border-style: none;
                    }
                    .tabs_alt > ul > li > a{
                        border-style: none;
                    }
                    .tabs_alt > ul > li > a:hover{
                        border-style: none;
                    }
                    .tab_2.current{
                        background: none repeat scroll 0 0 #4FC1E9;
                        margin-top:-6px;
                        color: #FFFFFF;
                        padding: 30px 21px;
                        font-size:12px;
                        text-transform: none;
                    }
                    .tab_1.current{
                        background: none repeat scroll 0 0 #4FC1E9;
                        margin-top:-6px;
                        color: #FFFFFF;
                        padding: 30px 21px;
                        font-size:12px;
                        text-transform: none;
                    }

                    ul.list_category li a {
                        color: #FFFFFF;
                        line-height: 17px;
                    }

                    .subcontent .filter .select_sort {
                        color: #FFFFFF;
                        float: right;
                    }
                    .filter .input input {
                        padding: 2px;
                        width: 114px;
                    }
                    input, select {
                        padding: 9px 4%;
                    }
                    .pt-content-searching ul li .wd-adap-select {
                        margin: 0;
                        width: 100%;
                    }
                    .button:hover{
                        background:#48CFAD;
                    }
                </style>
                <div class="tabs_alt tabs_parent">
                    <ul class="item" id="main_tabs">
                        <li class="tab_1 active"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Search') ?></a></li>
                        <li class="tab_2"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Categories') ?></a></li>                             

                    </ul>
                </div>

                <div class=" tab_2 current" style="display: none;">
                    <?php echo $this->content()->renderWidget('event.categories'); ?>
                </div>
                <div class="tab_1 current" >
                    <?php  echo $this->content()->renderWidget('event.search');?>
                </div>
            </div>
            <!--
<div class="search_my_question search_library"> 
    <?php  echo $this->content()->renderWidget('event.search');?>
</div>
<div class="subsection">
    <?php echo $this->content()->renderWidget('event.categories'); ?>
</div>-->

            <div class="pt-how-list-event">
                <?php if( $pages->count() > 1 ): ?>
                <?php echo $this->paginationControl($pages, null, null, array(
                'query' => $formValues
                )); ?>
                <?php endif; ?>
                <?php 
                //$liclass = 'last_li';
                $i=1;
                ?>
                <?php if( count($pages) > 0 ): ?>
                <ul class='pt-list-event'>

                    <?php foreach( $pages as $event ): ?>
                    <li style="width:23%;float:left;padding:7px">
                        <div class="pt-how-all">
                            <div  class="pt-how-img">
                                <?php if($event->photo_id): ?>
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
                                <?php if( $this->viewer() && $event->isOwner($this->viewer()) ): ?>
                                <?php echo $this->htmlLink(array('route' => 'event_specific', 'action' => 'edit', 'controller'=>'event', 'event_id' => $event->getIdentity()), $this->translate('Edit Event'), array(
                                'class' => 'buttonlink icon_event_edit'
                                )) ?>
                                <?php endif; ?>
                                <?php if(($filter != "past") && $this->viewer()->getIdentity() && !$event->membership()->isMember($this->viewer(), null) ): ?>
                                <?php //echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $event->getIdentity()), $this->translate('Join Event'), array('class' => 'buttonlink smoothbox icon_event_join')) ?>
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
                            <div class="pt-how-content-event">                            
                                <h3><?php echo $this->htmlLink($event->getHref(), $event->getTitle()) ?></h3>                               
                                <div class="events_members">
                                    <?php //echo $this->translate(array('%s guest', '%s guests', $event->membership()->getMemberCount()),$this->locale()->toNumber($event->membership()->getMemberCount())) ?>

                                    <p class="pt-times"><span></span><?php echo $event->starttime; ?></p>
                                    <p class="pt-address"><span></span><?php echo $event->location; ?></p>
                                </div>
                                <div class="pt-user-name">
                                    <?php
                                    $user_id=$event->user_id;
                                    $member2 = Engine_Api::_()->user()->getUser($user_id);
                                    echo $this->htmlLink($member2->getHref(), $this->itemPhoto($member2, 'thumb.icon'), array('class' => 'pt-avatar'));
                                    ?>
                                    <p><strong>Đăng bởi:</strong>
                                        <?php echo $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle()) ?> <p>
                                    <p><?php echo $event->creation_date; ?></p>
                                </div>
                                <div class="events_desc">
                                    <?php //print_r($event); //echo $this->viewMore($event->getDescription()) ?>
                                </div>
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


        <div class="clear"></div>
    </div>
    <div class="clear"></div>
</div>
