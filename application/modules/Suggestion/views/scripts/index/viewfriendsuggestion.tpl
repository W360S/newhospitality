<style type="text/css">
    #global_page_suggestion-index-viewfriendsuggestion #global_content .layout_middle{min-height: 1000px; width:944px; float:left; padding-top:20px; padding-left:37px; border-left:1px solid #e6e8ea}

</style>
<div class="layout_left">
    <?php 
    $obj = $this->getVars();
    echo $this->content()->renderWidget('user.home-photo');
    echo $this->content()->renderWidget('user.home-overview-links');
    echo $this->content()->renderWidget('group.member-home-group');
    $this->setVars($obj);
    ?>
</div>
<div class="layout_middle">
    <ul class='requests'>
        <?php if ($this->requests->getTotalItemCount() > 0): ?>
            <?php foreach ($this->requests as $notification): ?>
                <?php
                $parts = explode('.', $notification->getTypeInfo()->handler);
                echo $this->action($parts[2], $parts[1], $parts[0], array('notification' => $notification));
                ?>
            <?php endforeach; ?>
        <?php else: ?>
            <li>
                <?php echo $this->translate("You have no requests.") ?>
            </li>
        <?php endif; ?>
    </ul>
</div>
    