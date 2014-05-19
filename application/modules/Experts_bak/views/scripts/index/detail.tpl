<style>
.wd-content-left { width:204px; float:left; padding-top:20px;}
.pt-subpage  .wd-center  {width:1188px !important}
.pt-comment-text .pt-submit-comment { margin-left:0px !important;}
.pt-comment-text .pt-textarea {width:528px !important;}
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
						<div class="pt-content-questions">
								<?php
								    // rating
								    $rated = $this->rated;
								    $viewer_id = $this->viewer_id;
								    $rating_count = $this->rating_count;
								    
								    $data = $this->data;
								    $categories = $this->categories;
								    $answers = $this->answers;
								    //Zend_Debug::dump($answers);exit;
								    $related_old_questions = $this->related_old_questions;
								    $related_new_questions = $this->related_new_questions;
								    $asked_by = $this->asked_by;
								    
								?>
								<div class="pt-content-questions-title">
									<span class="pt-avatar">
									<?php if($asked_by->photo_id): ?>
										<?php echo $this->itemPhoto($asked_by, 'thumb.normal', "Image"); ?>
									    <?php else: ?>
										<img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_profile.png">
									    <?php endif; ?>
									</span>
									<h3><a href="<?php echo $this->baseUrl("/")."profile/".$data->username; ?>"><?php echo $data->username; ?></a></h3>
									<span class="pt-times"> - <?php echo date("Y-m-d",strtotime($data->created_date)); ?></span>
									<div class="pt-link-group pt-link-group-01">
										<a href="#" class="pt-editing">Editing</a>
										<div class="pt-toggle-layout pt-toggle-layout-01">
											<div class="pt-icon-arrow"><span></span></div>
											<div class="pt-toggle-layout-content">
												<ul class="pt-edit">
													<li>
														<a href="#" class="icon-01">Báo cáo</a>
													</li>
													<li>
														<a href="#"  class="icon-02">Chia sẻ</a>
													</li>
												</ul>
											</div>
										</div>
									</div>
								</div>
								<div class="pt-content-questions-content">
									<div class="pt-like-how">
										<a href="#"></a>
										<span class="pt-number-like">1</span>
									</div>
									<div class="pt-content-questions-how">
										<h2><?php echo $data->title ?></h2>
										Danh mục: <?php echo $data->category; ?>
										<p><?php echo $data->content; ?></p>
										
									</div>
								</div>
							</div>
							 <div class="pt-reply-left-01">
								<div class="pt-title-reply">
									<h3>Câu trả lời (<?php echo count($answers); ?>)</h3>
								</div>
								<div class="pt-comment-text">
									<form name="upload" method="post" action="<?php echo $this->baseUrl().'/experts/my-experts/detail/question_id/'.$data->question_id; ?>"  enctype="multipart/form-data" id="questions_add_detail">
									<div class="pt-textarea">
										<textarea id="description"  name="description" title="Viết bình luận..." placeholder="Write a comment ..." value="Write a comment ..." data-reactid="" aria-owns="" aria-haspopup="true" aria-expanded="false" aria-label="Write a comment ..." style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 45px;"></textarea>
									</div>
									<div href="#" class="pt-up-img"><input type="file" id="file" name="file" aria-label=""></div>
									<div class="pt-submit-comment">
										<input type="hidden" id="question_id" value="<?php echo $data->question_id; ?>" name="question_id">
										<button type="submit" title="" class="button">Đăng</button>
										<button type="cancel" title="" class="button">Hủy</button>
									</div>
									</form>
								</div>
								<?php if(count($answers)): ?>
								<ul class="pt-reply-list-01">
									<?php  foreach($answers as $item):  ?>
									<li>
										<div class="pt-content-questions">
											<div class="pt-content-questions-title">
												<span class="pt-avatar">
												<?php if($item->photo_id): ?>
												    <?php echo $this->itemPhoto($item, 'thumb.icon', "Image"); ?>
												<?php else: ?>
												    <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png">
												<?php endif; ?>
												</span>
												<h3><a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"><?php echo $item->username; ?></a>
												<span style="font-size: 0.8em;"><?php  echo $this->translate(array('%s Year experience', '%s Years experience', intval($this->expert($item->userid)->experience)), intval($this->expert($item->userid)->experience)) ?></span>
												</h3>
												<span class="pt-times">Trả lời lúc: - <?php echo date("Y-m-d h:i:s",strtotime($item->created_date)); ?></span>
												<div class="pt-link-group pt-link-group-01">
													<a href="#" class="pt-editing">Editing</a>
													<div class="pt-toggle-layout pt-toggle-layout-01">
														<div class="pt-icon-arrow"><span></span></div>
														<div class="pt-toggle-layout-content">
															<ul class="pt-edit">
																<li>
																	<a href="#" class="icon-01">Báo cáo</a>
																</li>
																<li>
																	<a href="#"  class="icon-02">Chia sẻ</a>
																</li>
															</ul>
														</div>
													</div>
												</div>
											</div>
											<div class="pt-content-questions-content">
												<div class="pt-like-how">
													<a href="#"></a>
													<span class="pt-number-like">1</span>
												</div>
												<div class="pt-content-questions-how">
													<?php if($item->attach_id): ?>
														<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$item->storage_path; ?>"><?php $size = round($item->size/1024,2); echo $item->attach_name. " (".$size." KB)"; ?></a></p>
													<?php endif; ?>
													<p><?php echo $item->content; ?></p>
												</div>
											</div>
										</div>
									</li>
									<?php endforeach; ?>
								</ul>
								<?php endif;  ?>
							</div>
							
					</div>
					<div class="pt-reply-right">
						<div class="pt-block">
							<div class="pt-contents-response">
								<p>Mauris iaculis porttitor posuere. Praesent id metus massa, ut blandit odio. Proin quis tortor orci.</p>
								<a href="#">GỬI CÂU HỎI</a>
							</div>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.my-accounts'); ?>
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
<script type="text/javascript">
  
  jQuery(document).ready(function(jQuery) {	
	
	
	jQuery(".pt-textarea").click(function () {
	  jQuery('.pt-submit-comment').css( "display", "block" ).fadeIn( 1000 );
	  return false;
	});
	jQuery(".pt-textarea").click(function () {
	  jQuery('.pt-list-click').css( "display", "block" ).fadeIn( 1000 );
	  return false;
	});
	
  });
    
    

</script>