<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'book-shelf', 'action'=>'index'), 'default', true); ?>"><h3 class="pt-title-right">Tủ sách của tôi</h3></a>
<h3 class="pt-title-right">chuyên mục</h3>
<ul class="pt-list-menu-left">
	<?php foreach($this->data as $item): ?>
	<li><a class="<?php if($this->cat_id == $item->category_id ){echo "current";}  ?>" href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index', 'action'=>'index', 'cat_id'=>$item->category_id, 'category_name'=> 'name'), 'default', true); ?>"><?php echo $item->name; ?> <span>[<?php echo $item->cnt_book; ?>]</span></a></li>
	<?php endforeach; ?>
</ul>