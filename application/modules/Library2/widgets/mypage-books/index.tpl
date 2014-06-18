<style type="text/css">
.subcontent .books .more a:link, .subcontent .books .more a:visited{
	color:#fff;
}
.subcontent .more a:hover {
	color:#059CCB;
}
</style>
<?php 
    if( count($this->data) ): 
?>
<div class="subsection">
    <h2><?php echo $this->translate('Interesting books'); ?></h2>
    <div class="subcontent" style="padding:10px">
        <div class="books">
            <ul>
                <?php foreach ($this->data as $item): ?>
                <li>
                    <?php if($item->photo_id): ?>
                        <img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt=""  />
                    <?php else: ?>
                        <img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" />
                    <?php endif; ?>
                    <h3><a href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><?php echo $item->title; ?></a></h3>
                    <div>
                        <?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)) ?>,
                        <?php  echo $this->translate(array('%s download', '%s downloads', intval($item->download_count)), intval($item->download_count)) ?>
                    </div>
                </li>
                <?php endforeach; ?>
            </ul>
            <div class="more" style="margin:0;margin-top:5px"><a href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'index'),'default',true); ?>"><?php echo $this->translate('More'); ?></a></div>
        </div>
    </div>
</div>
<?php endif; ?>