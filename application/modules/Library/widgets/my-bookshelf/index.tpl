<style type="text/css">
.subsection_bookshelf{
    border: 0px !important;
}
</style>
<div class="subsection subsection_bookshelf">
<div class="bt_my_bookshelf">
    <a class="my_bookshelf" href="<?php echo $this->url(array('module'=>'library','controller'=>'book-shelf','action'=>'index'),'default',true); ?>"><?php echo $this->translate('My Bookshelf'); ?> <?php echo " (".intval($this->cnt).")"; ?></a>
</div>
</div>