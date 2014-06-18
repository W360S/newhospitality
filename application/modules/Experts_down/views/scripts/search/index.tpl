<style>
.wd-content-left { width:204px; float:left; padding-top:20px;}
.pt-subpage  .wd-center  {width:1188px !important}
</style>
<div id="wd-content-container">
<div class="wd-center">
	<div class="wd-content-left">
		<?php echo $this->content()->renderWidget('experts.categories'); ?>
	</div>
	<div class="wd-content-content-sprite pt-fix">
		<div class="wd-content-event">
			<div class="pt-content-event">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
				<div class="pt-reply-how">
					<div class="pt-reply-left">
						<div class="pt-event-tabs">
							<?php
							    $paginator = $this->paginator;
							    $pagination_control = $this->paginationControl($this->paginator);
							    $category_name = $this->category_name;
							?>
							<h2><?php echo $category_name; ?></h2>
							

							<div id="ajax_search-tab">
							<?php 
							    if( $this->paginator->getTotalItemCount() ): 
							?>

							<ul class="pt-reply-list">
								<?php foreach ($this->paginator as $item): 
								//var_dump($this->substring($item->content,200)); exit;
								?>
								<?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
								
								<li>
									<div class="pt-vote">
										<a href="#" class="pt-votes"><span><?php echo intval($item->view_count); ?></span><span>Lượt xem</span></a>
										<a href="#" class="pt-replys pt-replys-no" ><span><span><?php echo $item->cnt_answer; ?></span><span>Trả lời</span></a>
									</div>
									<h3><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'detail', 'question_id' => $item->question_id, 'slug' => $slug), 'default', true); ?>"><?php echo $item->title; ?></a></h3>
									<p>
									<?php //echo $this->substring($item->content,200); 
									$content = Engine_Api::_()->library()->truncate($item->content, 200, "...", false); 
									echo $content;
									?>
									</p>
									<p class="last"><strong>Chuyên mục:</strong><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'category', 'category_id' => $this->paginator->category_id,), 'default', true); ?>"><?php echo $this->paginator->category_name; ?> </a>-<strong><?php echo $this->translate('Asked by') ?>:</strong><a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"> <?php echo $item->username; ?> </a>- <span><?php echo $this->timestamp($item->created_date); ?></span></p>
								</li>
								<?php endforeach; ?>
							</ul>
							<div class="pt-paging">
								<?php echo $this->paginationControl($this->paginator, null, "application/modules/Experts/views/scripts/pagination-search.tpl"); ?>
							</div>
							<?php else: ?>
							<?php echo $this->translate("Haven't question in this category"); ?>
							<?php endif; ?>

							</div>
						</div>
					</div>
					<div class="pt-reply-right">
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.post-question'); ?>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.my-accounts'); ?>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.lasted-questions'); ?>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.featured-experts'); ?>
						</div>
						
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