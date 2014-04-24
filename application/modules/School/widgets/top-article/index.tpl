<style type="text/css">

.layout_right a:link, .layout_right a:visited{
    color: #4C4C4C;
}
</style>
<div class="subsection">
    <h2><?php echo $this->translate('Popular Articles');?></h2>
    <div class="subcontent">
        <ul class="list_articel_school">
            <?php if($this->articles){
                foreach($this->articles as $item){?>
                <li>
                    <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
					<?php echo $this->htmlLink(array('route' => 'view-school-artical', 'id'=> $item->artical_id, 'slug'=>$slug), $item->title) ?>
					
					<p class="posted_by"><?php echo $this->translate('Posted by:')?> <?php echo $this->user($item->user_id);?></p>
					<p><?php echo substr(strip_tags($item->content), 0, 350); if (strlen($item->content)>349) echo "...";?> </p>
					<p class="rating">
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

                    <span><?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)); ?></span><span class="bd_list">|</span><span><?php  echo $this->translate(array('%s comment', '%s comments', intval($item->comment_count)), intval($item->comment_count)); ?></span></p>
				</li>
            <?php }
            }?>
        </ul>
    </div>
</div>

<script type="text/javascript">
window.addEvent('domready', function(){
	jQuery('.list_shool ul li:last-child').css('margin-right','0');
	jQuery('ul.list_articel_school li:last-child,ul.list_comments_school li:last-child,ul.list_top_school li:last-child').css('border-bottom','none');

});
</script>