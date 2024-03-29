<div id="library_loading_book" style="display: none;">
  <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
  <?php echo $this->translate("Loading ...") ?>
</div>
<?php
    $paginator= $this->paginator;
    if( $paginator->getTotalItemCount() ): 
?>
<ul class="pt-list-library">
	<?php foreach ($paginator as $item):
	$arr_like_displayname = explode("&&",$item->like_name);
	$str ="";
	for($i=0; $i<count($arr_like_displayname); $i++){
	   if($i < count($arr_like_displayname) - 1){
	   $str = $str.$arr_like_displayname[$i]. ",";
	   } else {
	   $str = $str.$arr_like_displayname[$i];
	   }
	}
	?>
	<li>
		<?php if($item->photo_id): ?>
		<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt="" width="80" height="122" /></a>
		<?php else: ?>
		<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" width="80" height="122"/></a>
		<?php endif; ?>
		<?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
		<h2><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a></h2>

		<p><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'index','cat_id'=>$item->category_ids),'default',true); ?>"><?php echo $item->category; ?></a>

		</p>

		<p >
		<span title="<?php echo $str; ?>" style="float:left;margin-top:3px;"  id="<?php echo $item->book_id; ?>_like_book"><?php echo $item->cnt_like; ?></span>
		<a class="pt-like-how" href="javascript:void(0);"  onclick="javascript:ajaxLike(<?php echo $item->book_id; ?>,<?php echo $item->cnt_like; ?>)"></a>
		
		<span style="margin-top:3px;"><?php echo $item->download_count; ?></span> Lượt tải.
		</p> 
		<?php if(intval($item->credit) == 0): ?>
		<span >
			<?php echo $this->translate('free'); ?>
		</span>
		<?php else: ?>
		<span>
			<?php  echo $item->credit. $this->translate(' Coupon'); ?>
		</span>
		<?php endif; ?>
	</li>
	<?php endforeach; ?>
	
</ul>

<div class="pt-paging">
	<?php echo $this->paginationControl($this->paginator, null, "application/modules/Library/views/scripts/ajaxpagination.tpl"); ?>
</div>
<?php else: ?>
    <?php echo $this->translate("Haven't any book in this category");  ?>
<?php endif; ?>
</div>