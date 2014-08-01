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

</style>

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
        			$strings= Engine_String::substr($job->position, 0, 64) . $this->translate('... &nbsp;');
        			}
        		else{
        			$strings= $item->title;
        		}
        		?>
        <h3><a href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $strings; ?></a></h3>
        <div>
            <span>
                <?php if($item->rating>0):?>
                    <?php for($x=1; $x<=$item->rating; $x++): ?><span class="rating_star"></span><?php endfor; ?><?php if((round($item->rating)-$item->rating)>0):?><span class="rating_star_half"></span><?php endif; ?>
                <?php endif; ?>
            </span>
            <?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->cnt_rating)), intval($item->cnt_rating)) ?>,
            <?php if(intval($item->credit) == 0): ?>
				<strong>Free</strong> , 
            <?php else: ?>
                <strong><?php echo intval($item->credit);  ?></strong> credits, 
            <?php endif; ?>
            <?php  echo $this->translate(array('%s download', '%s downloads', intval($item->download_count)), intval($item->download_count)) ?>,
            <?php  echo $this->translate(array('%s comment', '%s comments', intval($item->cnt_comment)), intval($item->cnt_comment)) ?>

        </div>
    </li>
    <?php endforeach; ?>
</ul>
<div class="paging">
    <?php echo $this->paginationControl($this->paginator, null, "application/modules/Library/views/scripts/pagination.tpl"); ?>
</div>
<?php endif; ?>