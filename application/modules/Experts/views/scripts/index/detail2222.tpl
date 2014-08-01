<style type="text/css">
.pt-like-how div {
    background-attachment: scroll;
    background-clip: border-box;
    background-color: rgba(0, 0, 0, 0);
    background-image: url(/application/themes/newhospitality/images/front/pt-sprite.png?c=34);
    background-origin: padding-box;
    background-position: -207px -489px;
    background-repeat: no-repeat;
    background-size: auto auto;
    display: inline-block;
    height: 19px;
    width: 19px;
    cursor:pointer;
}
.pt-like-how div:hover {
    background-position: -207px -512px;
}
span#report_share a.icon-01{
   background-attachment: scroll !important;
    background-clip: border-box !important;
    background-color: rgba(0, 0, 0, 0) !important;
    background-image: url(/application/themes/newhospitality/images/front/icon-08.png?c=34) !important;
    background-origin: padding-box !important;
    background-position: 0px 2px !important;
    background-repeat: no-repeat !important;
    background-size: auto auto !important;
    padding-left: 17px;
}
span#report_share a.icon-02{
   background-attachment: scroll !important;
    background-clip: border-box !important;
    background-color: rgba(0, 0, 0, 0) !important;
    background-image: url(/application/themes/newhospitality/images/front/icon-09.png?c=34) !important;
    background-origin: padding-box !important;
    background-position: 0px 2px !important;
    background-repeat: no-repeat !important;
    background-size: auto auto !important;
    padding-left: 17px;
}
span#im_agree a.icon-02{
   background-attachment: scroll !important;
    background-clip: border-box !important;
    background-color: rgba(0, 0, 0, 0) !important;
    background-image: url(/application/themes/newhospitality/images/front/icon-oky.png?c=34) !important;
    background-origin: padding-box !important;
    background-position: 0px 2px !important;
    background-repeat: no-repeat !important;
    background-size: auto auto !important;
    padding-left: 17px;
}

a.icon-03{
   background-attachment: scroll !important;
    background-clip: border-box !important;
    background-color: rgba(0, 0, 0, 0) !important;
    background-image: url(/application/themes/newhospitality/images/front/icon-oky.png?c=34) !important;
    background-origin: padding-box !important;
    background-position: 0px 2px !important;
    background-repeat: no-repeat !important;
    background-size: auto auto !important;
    padding-left: 22px;
}
.pt-content-questions-content{margin-top:0px !important}
</style>
<script type="text/javascript">
  

  var pre_rate = "<?php echo $this->data->rating;?>";
  var rated = "<?php echo $this->rated;?>";
  var question_id = "<?php echo $this->data->question_id;?>";
  var total_votes = <?php echo $this->rating_count;?>;
  var viewer = "<?php echo $this->viewer_id;?>";
  var viewer1 =  "<?php echo $this->viewer1;?>";
  var tt_rating= <?php echo $this->tt_rating;?>;

  function ajaxLike(answer_id, cnt)
  {  
	(new Request.JSON({
	      'format': 'json',
	      'url' : '<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'like'), 'default', true) ?>',
	      'data' : {
		'format' : 'json',
		'answer_id': answer_id
	      },
	      'onRequest' : function(){
		
	      },
	      'onSuccess' : function(responseJSON, responseText)
	      {
	        var last = cnt+1;
		$(answer_id+'-number-like').innerHTML = responseJSON[0].total;
	      }
	    })).send();
  }
  
  function ajaxQLike(question_id, cnt)
  {  
	(new Request.JSON({
	      'format': 'json',
	      'url' : '<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'qlike'), 'default', true) ?>',
	      'data' : {
		'format' : 'json',
		'question_id': question_id
	      },
	      'onRequest' : function(){
		
	      },
	      'onSuccess' : function(responseJSON, responseText)
	      {
	        var last = cnt+1;
		$('question-number-like').innerHTML = responseJSON[0].total;
	      }
	    })).send();
  } 
  
  
</script>
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
									$viewer1 = $this->viewer1;
								    $rating_count = $this->rating_count;
								    
								    $data = $this->data;
								    $categories = $this->categories;
								    $answers = $this->answers;
								    //Zend_Debug::dump($data);exit;
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
									<h3><a href="<?php echo $this->baseUrl("/")."profile/".$data->username; ?>"><?php echo $data->displayname; ?></a></h3>
									<span class="pt-times">Đăng lúc - <?php echo $this->timestamp($data->created_date); ?></span><br/>
									<span id="report_share"><a href="<?php echo $this->baseUrl() ?>/report/create/subject/question_<?php echo $data->question_id ?>/format/smoothbox" class="icon-01 smoothbox experts-report-link"><?php echo $this->translate('Report') ?></a>
									
									</span>
									
								</div>
								<div class="pt-content-questions-content">
									<div class="pt-like-how">
										<a href="javascript:void(0);"  onclick="javascript:ajaxQLike(<?php echo $data->question_id; ?>,<?php echo $data->cnt_like; ?>)"></a>
										<span title="<?php echo $data->like_name; ?>"  id="question-number-like"  class="pt-number-like"><?php echo $data->cnt_like ?></span>
									</div>
									<div class="pt-content-questions-how">
										<h2><?php echo $data->title ?></h2>
										<div class="pt-event0management"><?php echo $data->category; ?></div>
										
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
									
									<span class="pt-avatar">
									<?php if($viewer_id->photo_id): ?>
										<?php echo $this->itemPhoto($viewer_id, 'thumb.normal', "Image"); ?>
									    <?php else: ?>
										<img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_profile.png">
									    <?php endif; ?>
									</span>

									<div class="pt-textarea">
										<textarea id="description"  name="description" title="Viết bình luận..." placeholder="Viết bình luận ..." value="Write a comment ..." data-reactid="" aria-owns="" aria-haspopup="true" aria-expanded="false" aria-label="Write a comment ..." style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 45px;"></textarea>
									</div>
									<div href="#" class="pt-up-img"><input type="file" id="file" name="file" aria-label=""></div>
									<div class="pt-submit-comment">
										<input type="hidden" id="question_id" value="<?php echo $data->question_id; ?>" name="question_id">
										<button type="submit" title="" class="button">Đăng</button>
									</div>
									</form>
								</div>
								<?php if(count($answers)): ?>
								<ul class="pt-reply-list-01">
									<?php  foreach($answers as $item):  ?>
									<?php if($data->answer_id == $item->answer_id): ?>
									<li style="background-color: #FFCE54 !important;">
										<div class="pt-content-questions">
											<div class="pt-content-questions-title">
												<span class="pt-avatar">
												<?php if($item->photo_id): ?>
												    <?php echo $this->itemPhoto($item, 'thumb.icon', "Image"); ?>
												<?php else: ?>
												    <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png">
												<?php endif; ?>
												</span>
												<h3><a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"><?php echo $item->displayname; ?></a>
												<span style="font-size: 0.8em;"><?php  echo $this->translate(array('%s Year experience', '%s Years experience', intval($this->expert($item->userid)->experience)), intval($this->expert($item->userid)->experience)) ?></span>
												
													<?php echo " - Câu trả lời hay nhất"; ?>
												
												<?php  if($data->userid == $viewer_id): ?>
												<span style="float: right;" id="im_agree"><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'best-answer', 'question_id'=>$item->question_id,'answer_id'=>$item->answer_id),'default',true); ?>" class="icon-03">Tôi đồng ý</a></span>
												<?php endif; ?>
												</h3>
												<span class="pt-times">Trả lời lúc: - <?php echo $this->timestamp($item->created_date); ?></span>
												
											</div>
											<div class="pt-content-questions-content">
												<div class="pt-like-how">
													<a href="javascript:void(0);"  onclick="javascript:ajaxLike(<?php echo $item->answer_id; ?>,<?php echo $item->cnt_like; ?>)"></a>
													<span  title="<?php echo $item->like_name; ?>" id="<?php echo $item->answer_id; ?>-number-like"  class="pt-number-like"><?php echo $item->cnt_like ?></span>
												</div>
												
												<div class="pt-content-questions-how">
													<?php if($item->attach_id): ?>
														<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$item->storage_path; ?>"><?php $size = round($item->size/1024,2); echo $item->attach_name. " (".$size." KB)"; ?></a></p>
													<?php endif; ?>
													<p><?php echo nl2br($item->content); ?></p>
												</div>
											</div>
										</div>
									</li>
									<?php endif; ?>
									<?php endforeach; ?>
								
									<?php  foreach($answers as $item):  ?>
									<?php if($data->answer_id != $item->answer_id): ?>
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
												<h3><a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"><?php echo $item->displayname; ?></a>
												<span style="font-size: 0.8em;"><?php  echo $this->translate(array('%s Year experience', '%s Years experience', intval($this->expert($item->userid)->experience)), intval($this->expert($item->userid)->experience)) ?></span>
												
												<?php  if($data->userid == $viewer_id): ?>
												<span style="float: right;" id="im_agree"><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'best-answer', 'question_id'=>$item->question_id,'answer_id'=>$item->answer_id),'default',true); ?>" class="icon-03">Tôi đồng ý</a></span>
												<?php endif; ?>
												</h3>
												<span class="pt-times">Trả lời lúc: - <?php echo $this->timestamp($item->created_date); ?></span>
												
											</div>
											<div class="pt-content-questions-content">
												
												<div class="pt-like-how">
													<a href="javascript:void(0);"  onclick="javascript:ajaxLike(<?php echo $item->answer_id; ?>,<?php echo $item->cnt_like; ?>)"></a>
													<span title="<?php echo $item->like_name; ?>" id="<?php echo $item->answer_id; ?>-number-like"  class="pt-number-like"><?php echo $item->cnt_like ?></span>
												</div>
												
												<div class="pt-content-questions-how">
													<?php if($item->attach_id): ?>
														<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$item->storage_path; ?>"><?php $size = round($item->size/1024,2); echo $item->attach_name. " (".$size." KB)"; ?></a></p>
													<?php endif; ?>
													<p><?php echo nl2br($item->content); ?></p>
												</div>
											</div>
										</div>
									<?php endif; ?>
									</li>
									<?php endforeach; ?>
								</ul>
								<?php endif;  ?>
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

	jQuery('.pt-editing').bind('click', function(){
		jQuery(this).siblings('.pt-toggle-layout').slideToggle();
	});

	jQuery('#url_tab03').bind('click', function(){
		
		
	});

  });
    
    

</script>