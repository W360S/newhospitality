<style>
.pt-comment-text #pt-textarea-description{width: 464px !important;}
.pt-comment-text .pt-submit-comment {
    margin-left: 62px !important;
}
</style>
<script type="text/javascript">
  var pre_rate = "<?php echo $this->data->rating;?>";
  var rated = "<?php echo $this->rated;?>";
  var question_id = "<?php echo $this->data->question_id;?>";
  var total_votes = <?php echo $this->rating_count;?>;
  var viewer = "<?php echo $this->viewer_id;?>";
  var tt_rating= <?php echo $this->tt_rating;?>;
  
  function rating_over(rating) {
    if (rated == 1){
      $('rating_text').innerHTML = "<?php echo $this->translate('you already rated');?>";
      //set_rating();
    }
    else if (viewer == 0){
      $('rating_text').innerHTML = "<?php echo $this->translate('please login to rate');?>";
    }
    else{
      $('rating_text').innerHTML = "<?php echo $this->translate('click to rate');?>";
      for(var x=1; x<=5; x++) {
        if(x <= rating) {
          $('rate_'+x).set('class', 'rating_star_big');
        } else {
          $('rate_'+x).set('class', 'rating_star_big_disabled');
        }
      }
    }
  }
  function rating_out() {
    if((total_votes == 0) ||(total_votes == 1)){
		$('rating_text').innerHTML = total_votes+" rating";
	}
	else{
		$('rating_text').innerHTML = total_votes+" ratings";
	}
    if (pre_rate != 0){
      set_rating();
    }
    else {
      for(var x=1; x<=5; x++) {
        $('rate_'+x).set('class', 'rating_star_big_disabled');
      }
    }
  }

  function set_rating() {
    var rating = pre_rate;
    if((total_votes == 0) ||(total_votes == 1)){
		$('rating_text').innerHTML = total_votes+" rating";
	}
	else{
		$('rating_text').innerHTML = total_votes+" ratings";
	}
    for(var x=1; x<=parseInt(rating); x++) {
      $('rate_'+x).set('class', 'rating_star_big');
    }

    for(var x=parseInt(rating)+1; x<=5; x++) {
      $('rate_'+x).set('class', 'rating_star_big_disabled');
    }

    var remainder = Math.round(rating)-rating;
    if (remainder <= 0.5 && remainder !=0){
      var last = parseInt(rating)+1;
      $('rate_'+last).set('class', 'rating_star_big_half');
    }
  }
  
  function rate(rating) {
    $('rating_text').innerHTML = "<?php echo $this->translate('Thanks for rating!');?>";
    for(var x=1; x<=5; x++) {
      $('rate_'+x).set('onclick', '');
    }
    (new Request.JSON({
      'format': 'json',
      'url' : '<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'rate'), 'default', true) ?>',
      'data' : {
        'format' : 'json',
        'rating' : rating,
        'question_id': question_id
      },
      'onRequest' : function(){
        rated = 1;
        total_votes = total_votes+1;
        pre_rate = (tt_rating+rating)/total_votes;
        
        set_rating();
      },
      'onSuccess' : function(responseJSON, responseText)
      {
        if(responseJSON[0].total==1){
        	$('rating_text').innerHTML = responseJSON[0].total+" rating";
        }else{
            $('rating_text').innerHTML = responseJSON[0].total+" ratings";
        }
      }
    })).send();
    
  }
  
  var tagAction =function(tag){
    $('tag').value = tag;
    $('filter_form').submit();
  }
  
  en4.core.runonce.add(set_rating);
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
									$view_by = $this->view_by;
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
									<span class="pt-times">Đăng lúc - <?php echo $this->timestamp($data->created_date); ?></span>
									<div class="pt-link-group pt-link-group-01">
										<div  class="pt-editing">Editing</div>
										<div class="pt-toggle-layout pt-toggle-layout-01">
											<div class="pt-icon-arrow"><span></span></div>
											<div class="pt-toggle-layout-content">
												<ul class="pt-edit">
													<li>
														<a href="<?php echo $this->baseUrl() ?>/report/create/subject/question_<?php echo $data->question_id ?>/format/smoothbox" class="icon-01 smoothbox experts-report-link"><?php echo $this->translate('Report') ?></a>
													</li>
													<li>
														<a href="<?php echo $this->baseUrl() ?>/activity/index/share/type/experts_question/id/<?php echo $data->question_id ?>/format/smoothbox" class="icon-02 smoothbox experts-share-link"><?php echo $this->translate('Share') ?></a>
													</li>
												</ul>
											</div>
										</div>
									</div>
								</div>
								<div class="pt-content-questions-content">
									<!--
									<div class="pt-like-how">
										<div href="#"></div>
										<span class="pt-number-like">1</span>
									</div>
									-->
									<div class="pt-content-questions-how">
										<h2><?php echo $data->title ?></h2>
										<div class="pt-event0management"><?php echo $data->category; ?></div>
										<div id="question_rating" class="rating" onmouseout="rating_out();">
										  <span id="rate_1" <?php if (!$rated && $viewer_id):?>onclick="rate(1);"<?php endif; ?> onmouseover="rating_over(1);"></span>
										  <span id="rate_2" <?php if (!$rated && $viewer_id):?>onclick="rate(2);"<?php endif; ?> onmouseover="rating_over(2);"></span>
										  <span id="rate_3" <?php if (!$rated && $viewer_id):?>onclick="rate(3);"<?php endif; ?> onmouseover="rating_over(3);"></span>
										  <span id="rate_4" <?php if (!$rated && $viewer_id):?>onclick="rate(4);"<?php endif; ?> onmouseover="rating_over(4);"></span>
										  <span id="rate_5" <?php if (!$rated && $viewer_id):?>onclick="rate(5);"<?php endif; ?> onmouseover="rating_over(5);"></span>
										  <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate');?></span>
										</div>
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
									<?php if($view_by->photo_id): ?>
										<?php echo $this->itemPhoto($view_by, 'thumb.normal', "Image"); ?>
									    <?php else: ?>
										<img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_profile.png">
									    <?php endif; ?>
									</span>

									<div class="pt-textarea" id="pt-textarea-description" >
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
												<?php if($data->answer_id == $item->answer_id){
													echo " - Câu trả lời hay nhất";
												} ?>
												</h3>
												<span class="pt-times">Trả lời lúc: - <?php echo $this->timestamp($item->created_date); ?></span>
												<?php if($data->userid == $viewer_id): ?>
												<div class="pt-link-group pt-link-group-01">
													<div class="pt-editing">Editing</div>
													<div class="pt-toggle-layout pt-toggle-layout-01">
														<div class="pt-icon-arrow"><span></span></div>
														<div class="pt-toggle-layout-content">
															<ul class="pt-edit">
																<li>
																	<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'best-answer', 'question_id'=>$item->question_id,'answer_id'=>$item->answer_id),'default',true); ?>" class="icon-01">Câu trả lời hay nhất</a>
																		
																</li>
																<li>
																	
																</li>
															</ul>
														</div>
													</div>
												</div>
												<?php endif; ?>
											</div>
											<div class="pt-content-questions-content">
												<!--
												<div class="pt-like-how">
													<a href="#"></a>
													<span class="pt-number-like">1</span>
												</div>
												-->
												<div class="pt-content-questions-how">
													<?php if($item->attach_id): ?>
														<p><img src="<?php echo $this->baseUrl("/").$item->storage_path; ?>"/></p>
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
							<?php echo $this->content()->renderWidget('experts.post-question'); ?>
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

	jQuery(".pt-editing").bind("click", function(){
		jQuery(this).siblings(".pt-toggle-layout").slideToggle();
	});
	


  });
    
    

</script>