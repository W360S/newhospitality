<h3 class="pt-title-right"><?php echo $this->translate('top views');?></h3>
<?php if( count($this->data)): ?>
<ul class="pt-list-views">
<?php $dem = 0;  foreach($this->data as $item): $dem++;  ?>
<li>

<?php if($item->photo_id): ?>
<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt="" class='img_product' /></a>
<?php else: ?>
<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" class='img_product'/></a>
<?php endif; ?>

<h2><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a></h2>
<span><?php if($item->credit == 0): ?>
			  <?php echo $this->translate('Free'); ?>
<?php else: ?>
    <?php  echo $item->credit; ?></p>
			
<?php endif; ?>
</span>
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

</li>
<?php endforeach; ?>
</ul>
<?php endif; ?>