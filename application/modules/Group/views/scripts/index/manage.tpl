<style type="text/css">
    .subcontent .filter .select_sort {
        font-weight:bold;
        padding-left:12px;
    }
    .first-group{border-top:none !important;}
</style>
<div class="content">
    <div class="layout_right" style="float:left;width:18.6%">
        <div class="wd-content-left">
            <!--<h2><?php echo $this->translate('Featured groups') ?></h2>-->
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
                            if (count($result))
                                echo count($result);
                            else
                                echo '0';
                            ?></span></a>
                </li>
                <li>
                    <a href="/index.php/messages/inbox/"><span class="pt-icon-menu-left pt-icon-menu-02"></span><span class="pt-menu-text">Tin nhắn</span><span class="pt-number"><?php $viewer = Engine_Api::_()->user()->getViewer();
                            $message_count = Engine_Api::_()->messages()->getUnreadMessageCount($viewer);
                            if ($message_count > 0) echo $message_count;
                            else echo '0'; ?></span></a>
                </li>
                <li>
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
                </li>
                <li>
                    <a href="/index.php/community"><span class="pt-icon-menu-left pt-icon-menu-04"></span><span class="pt-menu-text">Album ảnh</span></a>
                </li>

            </ul>
            <div class="subcontent">
                <div class="featured-groups-wrapper">
                    <h2>Featured Group</h2>
<?php
$nav = $this->navigation()->menu()->setContainer($this->navigation)->render();
$pages = $this->paginator;
$form = $this->formFilter;
$formValues = $this->formValues;
echo $this->content()->renderWidget('group.featured');
?>
                </div>
            </div>
        </div>
    </div>

    <div class="wd-content-content-sprite">

        <div class="wd-content-event">
            <div class="pt-title-event">
                <ul class="pt-menu-event">
                    <li class="active">
                        <a href="<?php echo $this->baseUrl() . PATH_SERVER_INDEX; ?>/groups"><?php echo $this->translate('All groups') ?></a>
                    </li>							
                    <li>
                        <a href="<?php echo $this->baseUrl() . PATH_SERVER_INDEX; ?>/groups/manage"><?php echo $this->translate('My groups') ?></a>
                    </li>
                </ul>
                <a href="<?php echo $this->baseUrl() . PATH_SERVER_INDEX; ?>/groups/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New groups') ?></a>
            </div>

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
                    ul.groups_browse > li {
                        background: none repeat scroll 0 0 #FFFFFF;
                        clear: both;
                        overflow: hidden;
                        box-shadow: 0 4px 5px -2px #B8B8B8;
                    }
                    .groups-list {
                        background: none;
                        border: none;
                        border-radius: 3px;
                        margin-top: 10px;
                        padding: 9px;
                    }
                    ul.groups_browse .groups_info {
                        overflow: hidden;
                        padding-left: 10px;
                        width: 437px;
                    }
                    .groups_browse .groups_info .groups_desc {
                        padding-bottom: 5px;
                        padding-top: 0px;
                    }
                    .subsection ul li {
                        border-bottom:medium none;
                        padding: 12px;
                    }
                    a:link, a:visited {
                        color: #30AEE9;
                        text-decoration: none;
                    }
                    h3 a:hover{
                        text-decoration: underline;
                        color: #30AEE9;
                    }
                </style>
                <div class="tabs_alt tabs_parent">
                    <ul class="item" id="main_tabs">
                        <li class="tab_1 active"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Search') ?></a></li>
                        <li class="tab_2"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Categories') ?></a></li>                             

                    </ul>
                </div>

                <div class=" tab_2 current" style="display: none;">
            <?php echo $this->content()->renderWidget('group.my-categories'); ?>
                </div>
                <div class="tab_1 current" >
            <?php echo $this->content()->renderWidget('group.manage-search'); ?>
                </div>
            </div>
            <!--	
              <h2>
<?php echo $this->translate('Groups'); ?>
              </h2>
              <div class="tabs">
<?php echo $nav; ?>
              </div>
              <div class="search_my_question search_library">
<?php echo $this->content()->renderWidget('group.search'); ?>
                  </div>
        
            </div>
            
            <div class="subsection">
                    <?php echo $this->content()->renderWidget('group.categories'); ?>
            </div>
            -->
            <div class="groups-list" style="width:68%;float:left">
<?php $i = 1; ?>
                            <?php if (count($pages) > 0): ?>
                    <ul class="groups_browse">
                                <?php foreach ($pages as $group): ?>
                            <li <?php if ($i == 1) echo "class='first-group'";
                            $i++; ?>>
                                <div class="groups_photo">
                                    <?php echo $this->htmlLink($group->getHref(), $this->itemPhoto($group, 'thumb.normal')) ?>
                                </div>
                                <div class="groups_options">
                                    <?php if ($this->viewer()->getIdentity()): ?>
                                        <?php if ($group->isOwner($this->viewer())): ?>
                                            <?php
                                            echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'edit', 'group_id' => $group->getIdentity()), $this->translate('Edit Group'), array(
                                                'class' => 'icon_group_edit'
                                            ))
                                            ?>
                                            <?php
                                            echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'delete', 'group_id' => $group->getIdentity()), $this->translate('Delete Group'), array(
                                                'class' => 'icon_group_delete'
                                            ))
                                            ?>
            <?php elseif (!$group->membership()->isMember($this->viewer(), null)): ?>
                <?php
                echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $group->getIdentity()), $this->translate('Join Group'), array(
                    'class' => 'icon_group_join'
                ))
                ?>
            <?php elseif ($group->membership()->isMember($this->viewer(), true)): ?>
                <?php
                echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'leave', 'group_id' => $group->getIdentity()), $this->translate('Leave Group'), array(
                    'class' => 'icon_group_leave smoothbox buttonlink'
                ))
                ?>
            <?php endif; ?>
                        <?php endif; ?>

                                </div>
                                <div class="groups_info">
                                    <div class="groups_title">
                                        <h3><?php echo $this->htmlLink($group->getHref(), $group->getTitle()) ?></h3>
                                    </div>
                                    <div class="groups_members">
                                <?php echo $this->translate(array('%s member in', '%s members in', $group['member_count']), $this->locale()->toNumber($group['member_count'])) ?> <a href="javascript:void(0);" onclick='categorySubmit("<?php echo $group->getCategory()->category_id; ?>");'><?php echo $group->getCategory()->title; ?></a>
                                    </div>
                                    <div class="groups_desc"><?php echo $this->viewMore($group->getDescription()) ?></div>
                                </div>
                            </li>

    <?php endforeach; ?>
                    </ul>

    <?php
    echo $this->paginationControl($pages, null, null, array(
        'query' => $formValues
    ));
    ?>

<?php else: ?>
                    <div class="tip">
                        <span>
    <?php echo $this->translate('Tip: %1$sClick here%2$s to create the first group!', "<a href='" . $this->url(array('action' => 'create'), 'group_general', true) . "'>", '</a>'); ?>
                        </span>
                    </div>
<?php endif; ?>

            </div>
            <div class="pt-content-event-right">
                <div class="pt-block" style="margin-top:20px">
<?php echo $this->content()->renderWidget('event.upcoming-events'); ?>									
                </div>
            </div>

        </div>

    </div>


</div> 
<style>
    .subsection{
        background:#fff;
        border:none;
    }
    .subsection h2 {
        border-bottom: 1px solid #E5E5E5;
        color: #262626;
        font-size: 14px;
        font-weight: normal;
        margin: 0 10px;
        overflow: hidden;
        padding: 0px 0px;
        text-transform: none;
        background:none;
    }
    .recent-groups ul{
        width:100%;
    }
    .recent-groups li h3{
        text-transform: lowercase;
    }
</style>         
<script type="text/javascript">
    var categorySubmit = function(category_id) {
        $('category_id').value = category_id;
        $('my_group_search_form').submit();
    }
</script>