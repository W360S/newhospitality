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
    }

    function openCategories() {
        jQuery("#tabs-2").show();
        jQuery("#tabs-1").hide();
    }

</script>
<div class="pt-content-event">
    <div class="pt-event-tabs">
        <ul class="pt-title">
            <li><a href="javascript:void(0)" onclick="openSearch()">TÌM KIẾM</a></li>
            <li><a href="javascript:void(0)" onclick="openCategories()">LĨNH VỰC</a></li>
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
                    if ($i == 1)
                        echo "class='first-group'";
                    $i++;
                    ?>>

                            <a class="pt-img-group" href="<?php echo $group->getHref(); ?>">
                                <?php echo $this->itemPhoto($group, 'thumb.normal') ?></a>
                            <a href="#" class="pt-link-group">X Rời nhóm</a>
                            <h3><a href="<?php echo $group->getHref(); ?>"><?php echo $group->getTitle(); ?></a></h3>
                            <p class="pt-info-group"><?php echo $group['member_count'] ?> thành viên trong nhóm<a href="javascript:void(0);" onclick='categorySubmit("<?php echo $group->getCategory()->category_id; ?>");'><?php echo $group->getCategory()->title; ?></a></p>
                            <p><?php echo $this->viewMore($group->getDescription()) ?></p>

                        <?php /*
                        <div class="groups_photo">
                        <?php echo $this->htmlLink($group->getHref(), $this->itemPhoto($group, 'thumb.normal')) ?>
                        </div>
                        <div class="groups_options">
                            <?php if ($this->viewer()->getIdentity()): ?>
                                <?php if ($group->isOwner($this->viewer())): ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'edit', 'group_id' => $group->getIdentity()), $this->translate('Edit Group'), array(
                                        'class' => 'buttonlink icon_group_edit'
                                    ))
                                    ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'delete', 'group_id' => $group->getIdentity()), $this->translate('Delete Group'), array(
                                        'class' => 'buttonlink REMsmoothbox icon_group_delete'
                                    ))
                                    ?>
                                <?php elseif (!$group->membership()->isMember($this->viewer(), null)): ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $group->getIdentity()), $this->translate('Join Group'), array(
                                        'class' => 'buttonlink smoothbox icon_group_join'
                                    ))
                                    ?>
                                <?php elseif ($group->membership()->isMember($this->viewer(), true)): ?>
                                    <?php
                                    echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'leave', 'group_id' => $group->getIdentity()), $this->translate('Leave Group'), array(
                                        'class' => 'buttonlink smoothbox icon_group_leave'
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
                        */ ?>
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
</div>        
<script type="text/javascript">
    var categorySubmit = function(category_id) {
        $('category_id').value = category_id;
        $('group_search_form').submit();
    }

</script>