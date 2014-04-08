<h2><?php echo $this->translate('top rating questions'); ?></h2>
<div class="question-groups-wrapper">
    <div class="question-groups">
		<?php 
            $n= count($this->data); 
            if($n): 
        ?>
            <ul class="list_questions">
            <?php $dem = 0;  foreach($this->data as $item): $dem++;  ?>
            <?php  if((($dem-1) %5 == 0) && (($dem - 1) > 1)): ?>
            </ul>
            <ul class="list_questions">
            <?php endif; ?>
                <li>
                    <div class="content_questions">
                        <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
        				<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$item->question_id, 'slug'=>$slug),'default',true); ?>" class="title"><?php echo $item->title; ?></a>
        				<p>
                        <?php echo $this->translate('Asked by'); ?>:<a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"> <?php echo $item->username; ?></a>
                        - 
                        <?php echo $this->timestamp($item->created_date); ?><br />
                        <?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?>&nbsp;
                        - 
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
                        <?php  echo "&nbsp;". $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)); ?>
                        
                         </p>
        			</div>
                </li>
            <?php endforeach; ?>    
            </ul>
          <?php endif; ?> 
	</div>
</div>