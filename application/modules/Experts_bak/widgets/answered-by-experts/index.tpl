<?php
    $paginator = $this->paginator;
    $pagination_control = $this->paginationControl($this->paginator);
    $category_name = $this->category_name;
    $user = $this->user;
    $user_id= $this->user_id;
?>
<div class="subsection">
<h2><?php echo "Answered by "; ?><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile', 'username'=>$user->username),'default',true); ?>"><?php echo $user->username; ?></a></h2>
<?php if( $paginator->getTotalItemCount() ): ?>
<?php //echo $pagination_control; ?>
<ul class="list_questions">
	<?php $cnt = 1; foreach($paginator as $item): ?>
    <li>
		<div class="list_number">
			<?php echo $cnt; ?>
		</div>
		<div class="content_questions">
			<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$item->question_id)); ?>" class="title"><?php echo $item->title; ?></a>
			<p>
            <?php echo $this->translate('Asked by') ?>: <a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"> <?php echo $item->username; ?> </a> at <?php echo $item->created_date; ?></a>
            - 
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
            </span></p>
		</div>
	</li>
<?php $cnt = $cnt + 1; endforeach; ?>
</ul>
<?php if($paginator->getTotalItemCount()>5):?>
    <p style="text-align: right; padding-top:10px; padding-right: 25px; padding-bottom:10px;"><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$user_id),'default',true); ?>"><strong><?php echo $this->translate('View all') ?></strong></a></p>
<?php endif;?>
<?php //echo $pagination_control; ?>
<?php else: ?>
<?php echo $this->translate("This experts haven't any answers"); ?>
<?php endif; ?>
</div>