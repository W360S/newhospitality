<?php
    $paginator = $this->paginator;
    $pagination_control = $this->paginationControl($this->paginator);
    $category_name = $this->category_name;
    $user = $this->user;
?>
<div class="section">
    <div class="layout_right">
        
            <?php
               echo $this->content()->renderWidget('experts.my-accounts'); 
            ?>
        
        <div class="subsection">
            <?php
               echo $this->content()->renderWidget('experts.featured-experts'); 
            ?>
        </div>
        <div class="subsection">
            <?php echo $this->content()->renderWidget('group.ad'); ?>
        </div>
    </div>
    <div class="layout_middle">
       <div >
			<div class="search_my_question">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
            </div>	
			<div class="subsection">
				<?php echo $this->content()->renderWidget('experts.categories'); ?>
            </div>
            <div class="subsection">
				<h2><?php echo "Answered by "; ?><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile', 'username'=>$user->username),'default',true); ?>"><?php echo $user->username; ?></a></h2>
                <?php if( $paginator->getTotalItemCount() ): ?>
                <?php echo $pagination_control; ?>
                <ul class="list_questions">
                	<?php $cnt = 1; foreach($paginator as $item): ?>
                    <li>
                		<div class="list_number">
                			<?php echo $cnt; ?>
                		</div>
                		<div class="content_questions">
                			<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$item->question_id)); ?>" class="title"><?php echo $item->title; ?></a>
                			<p>
                            <?php echo $this->translate('Asked by') ?>:  <a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"> <?php echo $item->username; ?> </a> at <?php echo $item->created_date; ?></a>, 
                            <?php  echo $this->translate(array('%s view', '%s views', intval($item->question_view_count)), intval($item->question_view_count)); ?><span> 
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
                            <?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)); ?>
                            </span> </p>
                		</div>
                	</li>
                <?php $cnt = $cnt + 1; endforeach; ?>
                </ul>
                <?php echo $pagination_control; ?>
                <?php else: ?>
                <?php echo $this->translate("This experts haven't any answers"); ?>
                <?php endif; ?>
            </div>
		</div>
       
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
