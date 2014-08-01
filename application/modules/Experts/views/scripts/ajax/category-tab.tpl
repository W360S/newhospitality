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
<div style="clear:both"></div>
<div id="ajax_category-tab">
<?php 
    if( $this->paginator->getTotalItemCount() ): 
?>

<ul class="pt-reply-list">
	<?php foreach ($this->paginator as $item): 
	//var_dump($this->substring($item->content,200)); exit;
	$style='';
	if($item->cnt_answer && $item->answer_id){
		$style="background-image:url(/application/themes/newhospitality/images/front/bg-br-03.png) !important;";
	}
	
	if($item->cnt_answer && $item->answer_id ==0){
		$style="background-image:url(/application/themes/newhospitality/images/front/bg-br-04.png) !important;";
	}
	?>
	<?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
	
	<li>
		<div class="pt-vote" style="<?php echo $style; ?>">
			<a href="#" class="pt-votes"><span><?php echo intval($item->view_count); ?></span><span>Lượt xem</span></a>
			<a href="#" class="pt-replys pt-replys-no" ><span><?php echo $item->cnt_answer; ?></span><span>Trả lời</span></a>
		</div>
		<h3><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'detail', 'question_id' => $item->question_id, 'slug' => $slug), 'default', true); ?>"><?php echo $item->title; ?></a></h3>
		<?php //echo $this->substring($item->content,200); 
		$content = Engine_Api::_()->library()->truncate($item->content, 100, "...", false); 
		echo $content;
		?>
		<p class="last"><strong>Chuyên mục:</strong><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'category', 'category_id' => $this->paginator->category_id,), 'default', true); ?>"><?php echo $this->paginator->category_name; ?> </a>-<strong><?php echo $this->translate('Asked by') ?>:</strong><a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"> <?php echo $item->username; ?> </a>- <span><?php echo $this->timestamp($item->created_date); ?></span></p>
	</li>
	<?php endforeach; ?>
</ul>
<div class="pt-paging">
	<?php echo $this->paginationControl($this->paginator, null, "application/modules/Experts/views/scripts/pagination-category.tpl"); ?>
</div>
<?php else: ?>
<?php echo $this->translate("Haven't question in this category"); ?>
<?php endif; ?>

</div>