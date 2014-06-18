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
                    
			<p>Young Designers</p>
			
			<p>
			<?php 
                              	$rating= $item->rating;
                              	if($rating>0){
                              		for($x=1; $x<=$rating; $x++){?>
                              			<span class="rating_star_generic rating_star"></span>
                              		<?php }
                              		
                              		
                              		$remainder = round($rating)-$rating;  			
                              		if(($remainder<=0.5 && $remainder!=0)):?><span class="rating_star_generic rating_star_half"></span><?php endif;
                              		if(($rating<=4)){
                              			for($i=round($rating)+1; $i<=5; $i++){?>
                    					<span class="rating_star_generic rating_star_disabled"></span> 	
                    			<?php }
                              		}
                	    			
                              	}else{
                              		for($x=1; $x<=5; $x++){?>
                              		<span class="rating_star_generic rating_star_disabled"></span> 
                              	<?php }
                              	}
                               
                              	?>
                            <?php  echo $this->translate(array(' %s rating', ' %s ratings', intval($item->cnt_rating)), intval($item->cnt_rating)) ?>
			</p>
			
			<?php if(intval($item->credit) == 0): ?>
			<span>Free</span>
			<?php else: ?>
			<span><?php  echo $this->translate(array('%s credit', '%s credits', intval($item->credit)), intval($item->credit)); ?></span>
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