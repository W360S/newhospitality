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

    <div class="">

        <div class="wd-content-event">
            <div class="pt-title-event">
                <ul class="pt-menu-event">
                    <li class="active">
                        <a href="<?php echo $this->baseUrl(); ?>/groups"><?php echo $this->translate('All groups') ?></a>
                    </li>							
                    <li>
                        <a href="<?php echo $this->baseUrl(); ?>/groups/manage"><?php echo $this->translate('My groups') ?></a>
                    </li>
                </ul>
                <a href="<?php echo $this->baseUrl(); ?>/groups/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New groups') ?></a>
            </div>
            <div class="pt-content-event">
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
                <div class="pt-event-tabs">
                    <div class="tabs_alt tabs_parent">
                        <ul class="pt-title" id="main_tabs">
                            <li class="tab_1 active"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Search') ?></a></li>
                            <li class="tab_2"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Categories') ?></a></li>                             
                        </ul>
                    </div>
                    <div class="tab_2 current tabs_content pt-content-tab" style="display: none;">
                        <?php echo $this->content()->renderWidget('group.my-categories'); ?>
                    </div>
                    <div class="tab_1 current tabs_content pt-content-tab" >
                        <?php echo $this->content()->renderWidget('group.manage-search'); ?>
                    </div>
                </div>
            </div>
            <div class="groups-list" style="width:68%;float:left; margin-top: 20px">
                <?php $i = 1; ?>
                <?php if (count($pages) > 0): ?>
                    <ul class="pt-list-group">
                        <?php foreach ($pages as $group): ?>
                            <li <?php if ($i == 1) echo "class='first-group'"; ?>>
                                <?php $i++; ?>
                                <a class="pt-img-group" href="<?php echo $group->getHref(); ?>">
                                    <?php echo $this->itemPhoto($group, 'thumb.normal') ?></a>
                                <a href="#" class="pt-link-group">X Rời nhóm</a>
                                <h3><a href="<?php echo $group->getHref(); ?>"><?php echo $group->getTitle(); ?></a></h3>
                                <p class="pt-info-group"><?php echo $group['member_count'] ?> thành viên trong nhóm<a href="javascript:void(0);" onclick='categorySubmit("<?php echo $group->getCategory()->category_id; ?>");'><?php echo $group->getCategory()->title; ?></a></p>
                                <p><?php echo $this->viewMore($group->getDescription()) ?></p>
                                
                            </li>
                        <?php endforeach; ?>
                    </ul>
                    <?php echo $this->paginationControl($pages, null, null, array('query' => $formValues)); ?>
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
<script type="text/javascript">
    var categorySubmit = function(category_id) {
        $('category_id').value = category_id;
        $('my_group_search_form').submit();
    }
</script>