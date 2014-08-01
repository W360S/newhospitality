
<div id="wd-content-container">
<div class="wd-center">
	<div class="wd-content-left">
		<?php echo $this->content()->renderWidget('experts.categories'); ?>
<?php echo $this->content()->renderWidget('core.ad-campaign', array('adcampaign_id' => 3)); ?>
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
							
							<div style="clear:both"></div>
							<div style="padding-top:5px;padding-left:10px">
							   <div>
							   <div style="float: left;">Chú thích:&nbsp;&nbsp;</div>
							   <div height="20px" width="20px" style="float: left; background-color: #EEEEEE;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								 <div style="float: left;">&nbsp; Câu hỏi mới&nbsp;&nbsp;</div>
							  </div>

							  <div>
								<div height="20px" width="20px" style="float: left; background-color: #48CFAD;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								 <div style="float: left;">&nbsp;Ðang trao đổi&nbsp;&nbsp;</div>
							  </div>

							  <div>
								<div height="20px" width="20px" style="float: left; background-color: #FFCE54;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								<div style="float: left;">&nbsp;Ðã giải đáp xong</div>
							  </div>
							</div>
							<div style="clear:both"></div>

							<div id="ajax_category-tab">
							<?php 
							    if( $this->paginator->getTotalItemCount() ): 
							?>

							<ul class="pt-reply-list">
								<?php foreach ($this->paginator as $item): 
								//var_dump($this->substring($item->content,200)); exit;
								$style='';
								if($item->cnt_answer && $item->answer_id){
									$style="background-image:url(/application/themes/newhospitality/images/front/bg-br-03.png) !important;";
								}
								
								if($item->cnt_answer && $item->answer_id ==0){
									$style="background-image:url(/application/themes/newhospitality/images/front/bg-br-04.png) !important;";
								}
								?>
								<?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
								
								<li>
									<div class="pt-vote" style="<?php echo $style; ?>">
										<a href="#" class="pt-votes"><span><?php echo intval($item->view_count); ?></span><span>Lượt xem</span></a>
										<a href="#" class="pt-replys pt-replys-no" ><span><span><?php echo $item->cnt_answer; ?></span><span>Trả lời</span></a>
									</div>
									<h3><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'detail', 'question_id' => $item->question_id, 'slug' => $slug), 'default', true); ?>"><?php echo $item->title; ?></a></h3>
									<?php //echo $this->substring($item->content,200); 
									$content = Engine_Api::_()->library()->truncate($item->content, 175, "...", false); 
									echo $content;
									?>
									<p class="last"><strong>Chuyên mục:</strong><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'category', 'category_id' => $this->paginator->category_id,), 'default', true); ?>"><?php echo $this->paginator->category_name; ?> </a>-<strong><?php echo $this->translate('Asked by') ?>:</strong><a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"> <?php echo $item->username; ?> </a>- <span><?php echo $this->timestamp($item->created_date); ?></span></p>
									
								</li>
								<?php endforeach; ?>
							</ul>
							<div class="pt-paging">
								<?php echo $this->paginationControl($this->paginator, null, "application/modules/Experts/views/scripts/pagination-category.tpl"); ?>
							</div>
							<?php else: ?>
							<?php echo $this->translate("Haven't question in this category"); ?>
							<?php endif; ?>
							
							</div>
							<div style="clear:both"></div>
							<div style="padding-top:5px;padding-left:10px">
							   <div>
							   <div style="float: left;">Chú thích:&nbsp;&nbsp;</div>
							   <div height="20px" width="20px" style="float: left; background-color: #EEEEEE;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								 <div style="float: left;">&nbsp; Câu hỏi mới&nbsp;&nbsp;</div>
							  </div>

							  <div>
								<div height="20px" width="20px" style="float: left; background-color: #48CFAD;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								 <div style="float: left;">&nbsp;Ðang trao đổi&nbsp;&nbsp;</div>
							  </div>

							  <div>
								<div height="20px" width="20px" style="float: left; background-color: #FFCE54;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								<div style="float: left;">&nbsp;Ðã giải đáp xong</div>
							  </div>
							</div>
							<div style="clear:both"></div>
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
							<?php echo $this->content()->renderWidget('experts.featured-experts'); ?>
<?php echo $this->content()->renderWidget('core.ad-campaign', array('adcampaign_id' => 4)); ?>
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