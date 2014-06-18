<?php if(count($this->data)): ?>
<div class="pt-block">
	<h3 class="pt-title-right"><?php echo $this->translate('Category'); ?></h3>
	<ul class="pt-list-menu-left">
		<?php foreach($this->data as $item): ?>
		<li><a href="<?php echo $this->baseUrl('/').'experts/index/category/category_id/'.$item->category_id; ?>"><?php echo $item->category_name; ?><span> [<?php echo $item->cnt_question; ?>]</span></a></li>
		<?php endforeach; ?>
	</ul>
</div>
<?php endif; ?>