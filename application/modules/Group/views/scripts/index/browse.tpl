<div class="content">
    <div class="headline">
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

    <div class="groups-list">
        <?php $i = 1; ?>
        <?php if (count($pages) > 0): ?>
            <ul class="groups_browse">
                <?php foreach ($pages as $group): ?>
                    <li <?php
                    if ($i == 1)
                        echo "class='first-group'";
                    $i++;
                    ?>>
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