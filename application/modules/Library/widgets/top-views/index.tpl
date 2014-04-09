<h2><?php echo $this->translate('top views');?></h2>
<div class="subcontent container-list-library">
    <div class="featured-groups-wrapper">
        <div class="list-library">
            <?php $n= count($this->data); if($n): ?>
            <ul>    
            <?php $dem = 0;  foreach($this->data as $item): $dem++;  ?>
            <?php  if((($dem-1) %5 == 0) && (($dem - 1) > 1)): ?>
            </ul>
            <ul>
            <?php endif; ?>
                <li>
                    <?php if($item->photo_id): ?>
                        <a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt="" class='img_product' /></a>
                    <?php else: ?>
                        <a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" class='img_product'/></a>
                    <?php endif; ?>
                    <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                    <h3><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a></h3>
                    <div>
                        <?php if(intval($item->credit) == 0): ?>
						  <p><?php echo $this->translate('Free'); ?></p>
                        <?php else: ?>
                            
    							<p><?php  echo $this->translate(array('%s credit', '%s credits', intval($item->credit)), intval($item->credit)); ?></p>
    						
                        <?php endif; ?>
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
						<p><?php  echo $this->translate(array(' %s view', ' %s views', intval($item->view_count)), intval($item->view_count)) ?></p>
					</div>
                </li>
            <?php endforeach; ?>
            </ul>
            <?php endif; ?>
			
        </div>
    </div>
</div>