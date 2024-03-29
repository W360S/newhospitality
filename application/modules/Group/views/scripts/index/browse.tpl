<?php
$paginator = $this->paginator;
$category = $this->category;

$navigation = $this->navigation()->menu()->setContainer($this->navigation)->render();

$pages = $this->paginator;
$form = $this->formFilter;
$formValues = $this->formValues;
$filter = $this->filter;
?>
<script type="text/javascript">
    function openSearch() {
        jQuery("#tabs-2").hide();
        jQuery("#tabs-1").show();
        jQuery("#tabs-2-title").removeClass("ui-state-active");
        jQuery("#tabs-1-title").addClass("ui-state-active");
    }

    function openCategories() {
        jQuery("#tabs-2").show();
        jQuery("#tabs-1").hide();
        jQuery("#tabs-1-title").removeClass("ui-state-active");
        jQuery("#tabs-2-title").addClass("ui-state-active");
    }
</script>
<div class="wd-content-event">
    <div class="pt-title-event">
        <ul class="pt-menu-event">
            <li class="active">
                <a href="<?php echo $this->baseUrl(); ?>/groups">Tất cả nhóm</a>
            </li>
            <li>
                <a href="<?php echo $this->baseUrl(); ?>/groups/manage">Nhóm của tôi</a>
            </li>
        </ul>
        <a href="<?php echo $this->baseUrl(); ?>/groups/create" class="pt-registering-event"><span></span>Tạo nhóm mới</a>
    </div>

    <div class="pt-content-event">
        <div class="pt-event-tabs">
            <ul class="pt-title">
                <li id="tabs-1-title" class="ui-state-active"><a href="javascript:void(0)" onclick="openSearch()">TÌM KIẾM</a></li>
                <li id="tabs-2-title"><a href="javascript:void(0)" onclick="openCategories()">LĨNH VỰC</a></li>
            </ul>
            <div id="tabs-1" class="pt-content-tab">
                <?php echo $this->content()->renderWidget('group.search'); ?>
            </div>
            <div id="tabs-2" class="pt-content-tab" style="display:none;">
                <?php echo $this->content()->renderWidget('group.categories'); ?>
            </div>
        </div>

        <div class="pt-how-list-group">
            <?php $i = 1; ?>
            <?php if (count($pages) > 0): ?>
                <ul class="pt-list-group">
                    <?php foreach ($pages as $group): ?>
                        <li <?php
                        if ($i == 1) {
                            echo "class='first-group'";
                        } $i++;
                        ?>>

                            <a class="pt-img-group" href="<?php echo $group->getHref(); ?>">
                                <?php echo $this->itemPhoto($group, 'thumb.normal') ?></a>

                            <!--<a href="#" class="pt-link-group">X Rời nhóm</a>-->
                            <?php if ($this->viewer()->getIdentity()): ?>
                                <?php if ($group->isOwner($this->viewer())): ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'edit', 'group_id' => $group->getIdentity()), $this->translate('Edit Group'), array(
                                        'class' => 'buttonlink pt-link-group'
                                    ))
                                    ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'delete', 'group_id' => $group->getIdentity()), $this->translate('Delete Group'), array(
                                        'class' => 'buttonlink REMsmoothbox pt-link-group'
                                    ))
                                    ?>
                                <?php elseif (!$group->membership()->isMember($this->viewer(), null)): ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $group->getIdentity()), $this->translate('Join Group'), array(
                                        'class' => 'buttonlink smoothbox pt-link-group'
                                    ))
                                    ?>
                                <?php elseif ($group->membership()->isMember($this->viewer(), true)): ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'leave', 'group_id' => $group->getIdentity()), $this->translate('Leave Group'), array(
                                        'class' => 'buttonlink smoothbox pt-link-group'
                                    ))
                                    ?>
                                <?php endif; ?>
                            <?php endif; ?>

                            <h3><a href="<?php echo $group->getHref(); ?>"><?php echo $group->getTitle(); ?></a></h3>
                            <p class="pt-info-group"><?php echo $group['member_count'] ?> thành viên trong nhóm<a href="javascript:void(0);" onclick='categorySubmit("<?php echo $group->getCategory()->category_id; ?>");'><?php echo $group->getCategory()->title; ?></a></p>
                            <p><?php echo $this->viewMore($group->getDescription()) ?></p>

                            
                        </li>

                    <?php endforeach; ?>
                </ul>

                <?php echo $this->paginationControl($pages, null, null, array(
                    'query' => $formValues
                ));?>

            <?php else: ?>
                <div class="tip">
                    <span>
                        <?php echo $this->translate('Tip: %1$sClick here%2$s to create the first group!', "<a href='" . $this->url(array('action' => 'create'), 'group_general', true) . "'>", '</a>'); ?>
                    </span>
                </div>
            <?php endif; ?>

        </div>
    </div>        
    <script type="text/javascript">
        var categorySubmit = function(category_id) {
            $('category_id').value = category_id;
            $('group_search_form').submit();
        }

    </script>
</div>