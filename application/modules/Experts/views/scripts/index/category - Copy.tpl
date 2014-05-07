<?php
    $paginator = $this->paginator;
    $pagination_control = $this->paginationControl($this->paginator);
    $category_name = $this->category_name;
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
				<h2><?php echo $category_name; ?></h2>
                <?php if( $paginator->getTotalItemCount() ): ?>
                <?php echo $pagination_control; ?>
                <ul class="list_questions">
                	<?php $cnt = 1; foreach($paginator as $item): ?>
                    <li>
                		<div class="list_number">
                			<?php echo $cnt; ?>
                		</div>
                		<div class="content_questions">
                        <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                			<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$item->question_id, 'slug'=>$slug)); ?>" class="title"><?php echo $item->title; ?></a>
                			
                            <p>
                            <?php echo $this->timestamp($item->created_date); ?> -
                            <?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?><span> 
                            <?php if($item->rating>0):?>
                               - <?php for($x=1; $x<=$item->rating; $x++): ?><span class="rating_star"></span><?php endfor; ?><?php if((round($item->rating)-$item->rating)>0):?><span class="rating_star_half"></span><?php endif; ?>
                            <?php endif; ?>
                           - <?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->cnt_rating)), intval($item->cnt_rating)); ?>
                            </span> <em> - <?php echo $this->translate('Asked by'); ?>: </em> <a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"> <?php echo $item->username; ?></a></p>
                		</div>
                	</li>
                <?php $cnt = $cnt + 1; endforeach; ?>
                </ul>
                <?php echo $pagination_control; ?>
                <?php else: ?>
                <?php echo $this->translate("Haven't question in this category"); ?>
                <?php endif; ?>
            </div>
		</div>
       
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
