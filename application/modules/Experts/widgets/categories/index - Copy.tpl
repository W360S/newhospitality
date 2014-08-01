<?php if(count($this->data)): ?>
<ul class="list_category">
<?php foreach($this->data as $item): ?>
	<li><a href="<?php echo $this->baseUrl('/').'experts/index/category/category_id/'.$item->category_id; ?>"><?php echo $item->category_name; ?>(<span><?php echo $item->cnt_question; ?></span>)</a></li>
<?php endforeach; ?>
</ul>
<?php endif; ?>
