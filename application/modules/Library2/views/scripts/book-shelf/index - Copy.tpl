<?php 
    $paginator = $this->paginator;
    $user_id = $this->user_id; 
    $pagination_control = $this->paginationControl($this->paginator);
?>

<div class="section">
    <div class="layout_right">
        <div class="subsection">
            <?php
               echo $this->content()->renderWidget('library.top-views'); 
            ?>
        </div>
        
    </div>
    <div class="layout_middle">
       <div class="headline">
			<div class="breadcrumb_expert">
				<h2><a class="first" href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'index'),'default',true); ?>"><?php echo $this->translate("Library")?></a> <a href="<?php echo $this->url(array('module'=>'library','controller'=>'book-shelf','action'=>'index'),'default',true); ?>"><?php echo $this->translate('My BookShelf'); ?></a></h2>
			</div>
			<div class="clear"></div>
        </div>
		<div class="layout_middle_question">
			
			<div class="subsection">
                <?php if( $paginator->getTotalItemCount() ): ?>
                <ul class="content_library_bookshelf">
                <?php foreach ($paginator as $item):
                    $content = Engine_Api::_()->news()->truncate($item->description, 200, "...", false); 
                ?>
				
					<li class="<?php if($item->downloaded == 1){ echo $this->translate('downloaded');} ?>">
                        
						<div class="frame_img">
                            <?php if($item->photo_id): ?>
                                <a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt="" width="80" height="122" /></a>
                            <?php else: ?>
                                <a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" width="80" height="122"/></a>
                            <?php endif; ?>
                            <?php if(intval($item->credit) == 0): ?>
    							<div class="status status_free">
    								<p><?php echo $this->translate('free'); ?></p>
    							</div>
                            <?php else: ?>
                                <div class="status">
    								<p><?php  echo $this->translate(array('%s credit', '%s credits', intval($item->credit)), intval($item->credit)); ?></p>
    							</div>
                            <?php endif; ?>
						</div>
                        <div class="infor_bookshelf">
                            <h3><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><?php echo $item->title; ?></a></h3>
                             <?php echo $this->translate("Categories")?>: <a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'index','cat_id'=>$item->category_ids),'default',true); ?>"><?php echo $item->category; ?></a>
                                
                             <p><?php echo $this->translate('Code'); ?>: <?php echo $item->isbn.","; ?> <?php echo $this->translate("Author")?>: <?php echo $item->author.",";?> <?php echo $this->translate(' Created: ');?><?php echo $item->created_date;?></p>
                             <p><?php echo $content; ?></p>
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
                                <?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)) ?>
                                <?php  echo $this->translate(array('%s download', '%s downloads', intval($item->download_count)), intval($item->download_count)) ?>
                                <?php  echo $this->translate(array('%s comment', '%s comments', intval($item->cnt_comment)), intval($item->cnt_comment)) ?>
                            </p>   
						</div>
                        <div class="action_bookshelf">
                            <span>
                                <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'library', 'controller' => 'book-shelf', 'action' => 'download','fid'=>substr(base64_encode($user_id.Zend_Session::getId()),0,7) .substr(base64_encode($item->book_id . rand(1000000,9999999)),0,8) . base64_encode($item->url),'code'=>substr(md5(microtime()), 0, 10) . ".pdf"),$this->translate('Download'), array(
                                    'class' => 'download_book smoothbox buttonlink  icon_library_download'
                                )) ?> 
                            </span>
                            <?php if($item->downloaded == 0): ?>
                            <span>
                                <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'library', 'controller' => 'book-shelf', 'action' => 'remove','book_id'=>$item->book_id), $this->translate('Remove'), array(
                                    'class' => 'smoothbox buttonlink  icon_library_remove',
                                )) ?> 
                            </span>
                            <?php endif; ?>
                        </div>
						
					</li>
				
                <?php endforeach; ?>
                </ul>
                <div>
                  <?php echo $pagination_control; ?>
                </div>
                <?php else: ?>
                    <?php echo $this->translate("Haven't any books in this category"); ?>
                <?php endif; ?>
			</div>
			
		</div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
