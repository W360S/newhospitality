<style type="text/css">
.paging{float: right;}
/*.subsection{padding-bottom: 42px;}*/
</style>
<?php 
    $paginator = $this->paginator;
    $breadcrumb = $this->breadcrumb;  
    $pagination_control = $this->paginationControl($paginator, null, "application/modules/Library/views/scripts/ajaxpagination.tpl");
    $category_name= $this->category_name;
?>


<div class="section">
    <div class="layout_right">
        <?php
               echo $this->content()->renderWidget('library.my-bookshelf'); 
         ?>
        <div class="subsection">
            <?php
               echo $this->content()->renderWidget('library.top-views'); 
            ?>
        </div>
        <div class="subsection">
            <?php
               echo $this->content()->renderWidget('library.top-download'); 
            ?>
        </div>
    </div>
    <div class="layout_middle">
        <!--
        <div class="headline">
			<div class="breadcrumb_expert">
				<h2><a class="first" href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'index'),'default',true); ?>">Library</a> <a href="<?php echo $this->url(); ?>"><?php echo $breadcrumb; ?></a></h2>
			</div>
			<div class="clear"></div>
        </div>
		-->
		<div class="layout_middle_question">
			<div class="search_my_question search_library">
				<div class="subcontent">
					<?php  echo $this->content()->renderWidget('library.search');?>
				</div>
			</div>
            
            <div class="subsection">
				<?php
                   echo $this->content()->renderWidget('library.categories'); 
                ?>
			</div>
            
			<div class="subsection">
                <h2>
                    <a href="<?php echo $this->url(); ?>">
                    <?php if(!empty($category_name)){
                        echo $category_name->name;
                    }else{
                        echo $this->translate($breadcrumb);
                    } 
                    ?>
                    </a>
                </h2>
                
                <div id="ajax_book">
                
                <div id="library_loading_book" style="display: none;">
                  <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin: 5px; ' />
                  <?php echo $this->translate("Loading ...") ?>
                </div>
                
                <?php if( $paginator->getTotalItemCount() ): ?>
                
                <ul class="content_library">
                
                    <div class="paging"><?php echo $pagination_control; ?></div>
                    
                    <?php foreach ($paginator as $item):
                        //$content = Engine_Api::_()->news()->truncate($item->description, 400, "...", false); 
                    ?>
				
					<li>
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
						<div class="infor_book">
                        <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                            <h3><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a></h3>
                             <?php echo $this->translate('Categories'); ?>: <a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'index','cat_id'=>$item->category_ids),'default',true); ?>"><?php echo $item->category; ?></a>
                              
                             <p><?php echo $this->translate('Code'); ?>: <?php echo $item->isbn.","; ?> Author: <?php echo $item->author.",";?> <?php echo $this->translate(' Created: ');?><?php echo $item->created_date;?></p>
                             <?php echo $this->viewMore($content); ?>
							 <p class="rating_span">
                            
                                 <?php 
                                    $rating= $item->rating;
                                    
                              	    if($rating>0): 
                                    
                              		for($x=1; $x<=$rating; $x++): 
                                ?>
                              		<span class="rating_star_generic rating_star"></span>
                              	
                                 <?php 
                                    
                                    endfor;
                              		
                              		$remainder = round($rating)-$rating; 
                                      			
                              		if(($remainder<=0.5 && $remainder!=0)):
                                ?>
                                    <span class="rating_star_generic rating_star_half"></span>
                                    
                                <?php
                                
                                    endif;
                                    
                              		if(($rating<=4)):
                              			for($i=round($rating)+1; $i<=5; $i++):
                                 ?>
                    					<span class="rating_star_generic rating_star_disabled"></span> 	
                    			 <?php 
                                         endfor;
                                    endif;
                	    			
                              	else:
                              		for($x=1; $x<=5; $x++):
                                ?>
                              		    <span class="rating_star_generic rating_star_disabled"></span> 
                              	
                                  <?php 
                                    endfor;
                              	endif;
                                
                              	?>
                                
                                <?php  echo "&nbsp;". $this->translate(array(' %s rating', ' %s ratings', intval($item->total)), intval($item->total)) ?>,
                                <?php  echo $this->translate(array('%s download', '%s downloads', intval($item->download_count)), intval($item->download_count)) ?>,
                                <?php  echo $this->translate(array('%s comment', '%s comments', intval($item->cnt_comment)), intval($item->cnt_comment)) ?>,
                                <?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)) ?>
                            
                            </p>   
						</div>
                        
					</li>
				
                <?php endforeach; ?>
                
                    <div class="paging"> <?php echo $pagination_control; ?> </div>
                
                </ul>
                
                <?php else: ?>
                    <?php echo $this->translate("Haven't any book in this category");  ?>
                <?php endif; ?>
                
                </div>
			</div>
			
		</div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
