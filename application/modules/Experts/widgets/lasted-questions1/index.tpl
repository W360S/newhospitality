<style type="text/css">
.paging {
    padding-bottom:0px;
    padding-top:5px;
}

.paging .pages ul.paginationControl li{
    border-bottom-width:0px;
    height:auto;
    padding: 0px;
}

.layout_middle .tab .item li a {
    border: 0px !important;
    padding-right:0px !important;
}
.layout_middle .tab .item li.current a span {
    background-image: url("application/modules/Core/externals/images/sprite.png") !important;
}
</style>
<div id="ajax_lasted-tab">
<?php 
    if( $this->paginator->getTotalItemCount() ): 
?>
<ul class="pt-reply-list">
	<?php foreach ($this->paginator as $item): 
	//var_dump($this->substring($item->content,200)); exit;
	?>
	<?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
	<li>
		<div class="pt-vote">
			<a href="#" class="pt-votes"><span><?php echo intval($item->view_count); ?></span><span>Lượt xem</span></a>
			<a href="#" class="pt-replys pt-replys-no" ><span><?php echo $item->cnt_answer; ?></span><span>Trả lời</span></a>
		</div>
		<h3><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'detail', 'question_id' => $item->question_id, 'slug' => $slug), 'default', true); ?>"><?php echo $item->title; ?></a></h3>
		<p><?php //echo $this->substring($item->content,200); 
		$content = Engine_Api::_()->library()->truncate($item->content, 200, "...", false); 
		echo $content;
		?></p>
		<p class="last"><?php echo $this->translate('Asked by') ?>:</strong><a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"> <?php echo $item->username; ?> </a>-<span><?php echo $this->timestamp($item->created_date); ?></span></p>
	</li>
	<?php endforeach; ?>
</ul>
<div class="pt-paging">
	<?php echo $this->paginationControl($this->paginator, null, "application/modules/Experts/views/scripts/pagination-lasted.tpl"); ?>
</div>
<?php endif; ?>

</div>