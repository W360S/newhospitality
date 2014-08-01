<style>
.wd-content-left { width:204px; float:left; padding-top:20px;}
a.pt-like-how {
    background-attachment: scroll;
    background-clip: border-box;
    background-color: rgba(0, 0, 0, 0);
    background-image: url(/application/themes/newhospitality/images/front/pt-sprite.png?c=34);
    background-origin: padding-box;
    background-position: -207px -489px;
    background-repeat: no-repeat;
    background-size: auto auto;
    display: inline-block;
    height: 22px;
    width: 21px;
    margin-right: 11px !important;
}
a.pt-like-how:hover { background-position: -207px -512px;}
.pt-list-library li span{padding-right: 5px !important;}
</style>
<script type="text/javascript">
 function ajaxLike(book_id, cnt)
  {  
	(new Request.JSON({
	      'format': 'json',
	      'url' : '<?php echo $this->url(array('module' => 'library', 'controller' => 'index', 'action' => 'like'), 'default', true) ?>',
	      'data' : {
		'format' : 'json',
		'book_id': book_id
	      },
	      'onRequest' : function(){
		
	      },
	      'onSuccess' : function(responseJSON, responseText)
	      {
	        var last = cnt+1;
		$(book_id+'_like_book').innerHTML = responseJSON[0].total;
	      }
	    })).send();
  }
</script>
<div id="wd-content-container">
	<div class="wd-center">
		<div class="pt-how-carousel">
			<?php echo $this->content()->renderWidget('library.top-download'); ?>
		</div>
		<div class="wd-content-left">
			<div class="pt-block">
				<?php echo $this->content()->renderWidget('library.categories'); ?>
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
						    $breadcrumb = $this->breadcrumb;  
						    $pagination_control = $this->paginationControl($paginator, null, "application/modules/Library/views/scripts/ajaxpagination.tpl");
						    $category_name= $this->category_name;
						?>
						<div class="pt-title-reply">
							<h3><a href="<?php echo $this->url(); ?>">
							    <?php if(!empty($category_name)){
								echo $category_name->name;
							    }else{
								echo $this->translate($breadcrumb);
							    } 
							    ?>
							    </a>
							</h3>
						</div>

						<div id="ajax_book">
                
						<div id="library_loading_book" style="display: none;">
						  <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin: 5px; ' />
						  <?php echo $this->translate("Loading ...") ?>
						</div>
						<?php if( $paginator->getTotalItemCount() ): ?>
						<ul class="pt-list-library">
							<?php foreach ($paginator as $item):
							$arr_like_displayname = explode("&&",$item->like_name);
							$str ="";
							for($i=0; $i<count($arr_like_displayname); $i++){
							   if($i < count($arr_like_displayname) - 1){
							   $str = $str.$arr_like_displayname[$i]. ",";
							   } else {
							   $str = $str.$arr_like_displayname[$i];
							   }
							}
							?>
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

								<p >
								<span title="<?php echo $str; ?>" style="float:left;margin-top:3px;"  id="<?php echo $item->book_id; ?>_like_book"><?php echo $item->cnt_like; ?></span>
								<a class="pt-like-how" href="javascript:void(0);"  onclick="javascript:ajaxLike(<?php echo $item->book_id; ?>,<?php echo $item->cnt_like; ?>)"></a>
								
								<span style="margin-top:3px;"><?php echo $item->download_count; ?></span> Lượt tải.
								</p>   
								<?php if(intval($item->credit) == 0): ?>
								<span >
									<?php echo $this->translate('free'); ?>
								</span>
								<?php else: ?>
								<span>
									<?php  echo $item->credit. $this->translate(' Coupon'); ?>
								</span>
								<?php endif; ?>


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