<div id="library_loading_book" style="display: none;">
  <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
  <?php echo $this->translate("Loading ...") ?>
</div>
<?php
    $paginator= $this->paginator;
    if( $paginator->getTotalItemCount() ): 
?>
<ul class="pt-list-library">
	<?php foreach ($paginator as $item):?>
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

		<p class="rating_span">
		<?php 
		$rating= $item->rating;
		if($rating>0): 
		for($x=1; $x<=$rating; $x++): 
		?>
		<span class="rating_star_generic rating_star"></span>
		<?php endfor; ?>

		<?php	$remainder = round($rating)-$rating; 
		if(($remainder<=0.5 && $remainder!=0)):
		?>
		<span class="rating_star_generic rating_star_half"></span>
		<?php endif; ?>


		<?php  if(($rating<=4)):
		for($i=round($rating)+1; $i<=5; $i++):
		?>
		<span class="rating_star_generic rating_star_disabled"></span> 	
		<?php endfor; ?>
		<?php   endif; ?>

		<?php else: ?>		

		<?php for($x=1; $x<=5; $x++):?>
		<span class="rating_star_generic rating_star_disabled"></span> 
		<?php endfor; ?>
		<?php  endif;?>

		<?php  echo "&nbsp;". $this->translate(array(' %s rating', ' %s ratings', intval($item->total)), intval($item->total)) ?>,
		
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