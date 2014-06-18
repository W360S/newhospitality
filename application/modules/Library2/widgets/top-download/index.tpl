<style>
#topdownload_library li {
width: 157px !important;
}
#topdownload_library li span {
display: inline-table !important;
}
</style>

<?php if(count($this->data)): ?>
<div class="list_carousel responsive" id="topdownload_library">
	
	<ul id="wd-foo">
		<?php $dem = 0;  foreach($this->data as $item): $dem++;  ?>
		<li>
			<?php if($item->photo_id): ?>
			<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt="" class='img_product' /></a>
			<?php else: ?>
				<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" class='img_product'/></a>
			<?php endif; ?>
			<?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
			<h2><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a></h2>
                    
			<p >
			<span style="float:left;margin-top:3px;padding-right:5px;"  id="<?php echo $item->book_id; ?>_like_book"><?php echo $item->cnt_like; ?></span>
			<a class="pt-like-how" href="javascript:void(0);"  onclick="javascript:ajaxLike(<?php echo $item->book_id; ?>,<?php echo $item->cnt_like; ?>)"></a>
			
			<span style="margin-top:3px;"><?php echo $item->download_count; ?></span> Lượt tải.
			</p> 
			
			<?php if(intval($item->credit) == 0): ?>
			<span>Free</span>
			<?php else: ?>
			<span><?php  echo $item->credit; ?> Coupon</span>
			<?php endif; ?>
		</li>
		<?php endforeach; ?>	
	</ul>
	<div class="control-div">
		<span id="wd-prev" class=""> </span>
		<span id="wd-next" class=""> </span>
	</div>
</div>
<?php endif; ?>