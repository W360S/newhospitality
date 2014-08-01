<style>
.wd-content-left { width:204px; float:left; padding-top:20px;}

</style>
<div id="wd-content-container">
	<div class="wd-center">
		<div class="wd-content-left">
			<div class="pt-block">
				<?php echo $this->content()->renderWidget('library.categories'); ?>
<?php echo $this->content()->renderWidget('core.ad-campaign', array('adcampaign_id' => 6)); ?>
			</div>
		</div>
		<div class="wd-content-content-sprite pt-fix">
			<div class="wd-content-event">
				<div class="pt-content-event">
					<div class="pt-event-tabs">
					  <div id="tabs-1" class="pt-content-tab">
						<?php echo $this->content()->renderWidget('library.search'); ?>
					  </div>
					</div>
					<div class="pt-library-how">
						<?php 
						    $paginator = $this->paginator;
						    //$breadcrumb = $this->breadcrumb;  
						    $pagination_control = $this->paginationControl($paginator, null, "application/modules/Library/views/scripts/ajaxbookshelfpagination.tpl");
						    //$category_name= $this->category_name;
						?>
						<div class="pt-title-reply">
							<h3> Tủ sách của tôi
							</h3>
						</div>

						<div id="ajax_book">
                
						<div id="library_loading_book" style="display: none;">
						  <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin: 5px; ' />
						  <?php echo $this->translate("Loading ...") ?>
						</div>
						<?php if( $paginator->getTotalItemCount() ): ?>
						<ul class="pt-list-library">
							<?php foreach ($paginator as $item):?>
							<li>
								<?php if($item->photo_id): ?>
								<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt="" width="80" height="122" /></a>
								<?php else: ?>
								<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" width="80" height="122"/></a>
								<?php endif; ?>
								<?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
								<h2><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a></h2>
				
								<p><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'index','cat_id'=>$item->category_ids),'default',true); ?>"><?php echo $item->category; ?></a>

								</p>

								<p class="rating_span">
								<?php 
								$rating= $item->rating;
								if($rating>0): 
								for($x=1; $x<=$rating; $x++): 
								?>
								<span class="rating_star_generic rating_star"></span>
								<?php endfor; ?>

								<?php	$remainder = round($rating)-$rating; 
								if(($remainder<=0.5 && $remainder!=0)):
								?>
								<span class="rating_star_generic rating_star_half"></span>
								<?php endif; ?>


								<?php  if(($rating<=4)):
								for($i=round($rating)+1; $i<=5; $i++):
								?>
								<span class="rating_star_generic rating_star_disabled"></span> 	
								<?php endfor; ?>
								<?php   endif; ?>

								<?php else: ?>		

								<?php for($x=1; $x<=5; $x++):?>
								<span class="rating_star_generic rating_star_disabled"></span> 
								<?php endfor; ?>
								<?php  endif;?>

								<?php  echo "&nbsp;". $this->translate(array(' %s rating', ' %s ratings', intval($item->total)), intval($item->total)) ?>,
								
								</p>   
								<?php if(intval($item->credit) == 0): ?>
								<span >
									<?php echo $this->translate('free'); ?>
								</span>
								<?php else: ?>
								<span>
									<?php  echo $this->translate(array('%s credit', '%s credits', intval($item->credit)), intval($item->credit)); ?>
								</span>
								<?php endif; ?>

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
						
						<div class="pt-paging">
							<?php echo $pagination_control; ?>
						</div>
						<?php else: ?>
						    <?php echo $this->translate("Haven't any book in this category");  ?>
						<?php endif; ?>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="wd-extras">
	<div class="wd-center">
		
	</div>	
</div>