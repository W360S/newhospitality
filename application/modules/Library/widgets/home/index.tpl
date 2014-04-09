<style type="text/css">
.paging {
    padding-bottom:0px;
    padding-top:5px;
}

.paging .pages ul.paginationControl li{
    border-bottom-width:0px;
    height:auto;
    padding: 0px;
}

.layout_middle .tab .item li a {
    border: 0px !important;
    padding-right:0px !important;
}
.layout_middle .tab .item li.current a span {
    background-image: url("application/modules/Core/externals/images/sprite.png") !important;
}
</style>
<div id="ajax_book">
<?php 
    if( $this->paginator->getTotalItemCount() ): 
?>
<ul>
    <?php foreach ($this->paginator as $item): ?>
    <li>
        <img src="application/modules/Core/externals/images/img-37x35.gif" alt="Image" />
        <?php if($item->photo_id): ?>
            <img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt=""  />
        <?php else: ?>
            <img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" />
        <?php endif; ?>
        <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
	<?php if(Engine_String::strlen($item->title)>64){
        			$strings= Engine_String::substr($item->title, 0, 64) . $this->translate('... &nbsp;');
        			}
        		else{
        			$strings= $item->title;
        		}
        		?>
        <h3><a href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $strings; ?></a></h3>
        <div >
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
                                <?php  echo "&nbsp;".$this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)) ?>,
            <?php if(intval($item->credit) == 0): ?>
				<strong><?php echo $this->translate('Free'); ?></strong>, 
            <?php else: ?>
                <strong><?php echo intval($item->credit);  ?></strong><?php echo $this->translate(' credits'); ?>, 
            <?php endif; ?>
            <?php  echo $this->translate(array('%s download', '%s downloads', intval($item->download_count)), intval($item->download_count)) ?>,
            <?php  echo $this->translate(array('%s comment', '%s comments', intval($item->cnt_comment)), intval($item->cnt_comment)) ?>
                                </p>
            
            

        </div>
    </li>
    <?php endforeach; ?>
</ul>
<?php 
    if( $this->paginator->count() > 1 ): 
?>
<div class="paging">
    <?php echo $this->paginationControl($this->paginator, null, "application/modules/Library/views/scripts/pagination.tpl"); ?>
</div>
<?php endif; ?>
<?php endif; ?>
</div>
