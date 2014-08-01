<style type="text/css">
.layout_middle_question{padding-left: 1px;}
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
<style>
p.title_answer {
    color:#414141;
    font-size:17px;
    font-weight:bold;
    line-height:19px;
}
</style>
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
        <div class="headline">
			<div class="breadcrumb_expert">
				<h2><a class="first" href="<?php echo $this->baseUrl("/")."experts/index/"; ?>"><?php echo $this->translate("experts"); ?></a> <a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$data->question_id),'default',true); ?>"><?php echo $this->translate("View Question"); ?></a></h2>
			</div>
			<div class="clear"></div>
        </div>
		
		<div class="layout_middle_question">
			<div class="search_my_question">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
                
			</div>	
			<div class="list_my_questions">
                
                <table cellspacing="0" cellpadding="0" border="0" >
					<tr class="form_answer">
						<td>
							<table>
								<tr>
									<td>
                                        <div class="ask-by">
                                            <a title="<?php echo $data->username; ?>" href="<?php echo $this->baseUrl("/")."profile/".$data->username; ?>">
                                            <?php if($asked_by->photo_id): ?>
                                                <?php echo $this->itemPhoto($asked_by, 'thumb.normal', "Image"); ?>
                                            <?php else: ?>
                                                <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_profile.png">
                                            <?php endif; ?>
                                        </a>
                                        <p>
                                        <strong><?php echo $this->translate('Ask by')?>: </strong> <a title="<?php echo $data->username; ?>" href="<?php echo $this->baseUrl("/")."profile/".$data->username; ?>"><?php echo $data->username; ?></a>
                                        
                                        </p>
                                        </div>
                                        <div class="information-ask">
										<p class="title_answer" ><h2><?php echo $data->title ?></h2></p>
                                        <?php echo $this->translate('Posted date'); ?>: <?php echo date("Y-m-d",strtotime($data->created_date)); ?><br />
                                        <strong><?php echo $this->translate("in category"); ?>:</strong> <?php echo $data->category; ?>
										<p class="views_rating">
                                        
                                            <?php  echo $this->translate(array('%s view', '%s views', intval($data->view_count)), intval($data->view_count)); ?>
                                            <a href="<?php echo $this->baseUrl() ?>/activity/index/share/type/experts_question/id/<?php echo $data->question_id ?>/format/smoothbox" class="smoothbox experts-share-link"><?php echo $this->translate('Share') ?></a>
                                            <a href="<?php echo $this->baseUrl() ?>/report/create/subject/question_<?php echo $data->question_id ?>/format/smoothbox" class="smoothbox experts-report-link"><?php echo $this->translate('Report') ?></a>
                                         
                                        <div id="question_rating" class="rating" onmouseout="rating_out();">
                                          <span id="rate_1" <?php if (!$rated && $viewer_id):?>onclick="rate(1);"<?php endif; ?> onmouseover="rating_over(1);"></span>
                                          <span id="rate_2" <?php if (!$rated && $viewer_id):?>onclick="rate(2);"<?php endif; ?> onmouseover="rating_over(2);"></span>
                                          <span id="rate_3" <?php if (!$rated && $viewer_id):?>onclick="rate(3);"<?php endif; ?> onmouseover="rating_over(3);"></span>
                                          <span id="rate_4" <?php if (!$rated && $viewer_id):?>onclick="rate(4);"<?php endif; ?> onmouseover="rating_over(4);"></span>
                                          <span id="rate_5" <?php if (!$rated && $viewer_id):?>onclick="rate(5);"<?php endif; ?> onmouseover="rating_over(5);"></span>
                                          <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate');?></span>
                                        </div>
                                        </p>
                                        </div>
									</td>
								</tr>
								<tr>
									<td>
                                        <p><strong><?php echo $this->translate("Question")?>:</strong></p>
										<p><?php echo $data->content; ?></p>
										<?php if($data->file_id): ?>
    									<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$data->storage_path; ?>"><?php $size = round($data->size/1024,2); echo $data->name. " (".$size." KB)"; ?></a></p>
                                        <?php endif; ?>
                                        <?php if(!empty($data->add_detail)): ?>
                                        <p class="title_answer"><strong><?php echo $this->translate("Update detail"); ?></strong></p>
                                        <p><?php echo $data->add_detail; ?></p>    
                                        <?php endif; ?>
                                        <br />
                                        <!-- AddThis Button BEGIN -->
                                		<div class="addthis_toolbox addthis_default_style ">
                                		<a class="addthis_button_preferred_1"></a>
                                		<a class="addthis_button_preferred_2"></a>
                                		<a class="addthis_button_preferred_3"></a>
                                		
                                		<a class="addthis_button_compact"></a>
                                		<a class="addthis_counter addthis_bubble_style"></a>
                                		</div>
                                		<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=huynhnv"></script>
                                		<!-- AddThis Button END -->
									</td>
								</tr>
								<tr>
									<td class="border_none">
										
                                        <p><strong><?php echo $this->translate('Experts selected'); ?>:</strong> <?php echo $data->experts; ?></p>
                                        <?php if(count($answers)): ?>
                                        <?php foreach($answers as $item): ?>
                                        <div class="detail_expert">
											<div class="frame_img">
                                                <div style="float: left;">
    												<a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>">
    													<?php if($item->photo_id): ?>
                                                            <?php echo $this->itemPhoto($item, 'thumb.icon', "Image"); ?>
                                                        <?php else: ?>
                                                            <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png">
                                                        <?php endif; ?>
    											    </a>
                                                </div>
                                                <?php if($item->userid): ?>
                                                <div style="float: left; padding-left: 5px;">
                                                    <strong><a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"><?php echo $item->username; ?></a></strong>
                                                    <em><?php $this->translate('in') ?> <?php echo $this->expert($item->userid)->company;?></em><br />
                                                    <span style="font-size: 0.8em;"><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->userid),'default',true); ?>"><?php  echo $this->translate(array('%s Answer', '%s Answers', intval($this->countAnswer($item->userid))), intval($this->countAnswer($item->userid))) ?></a></span><br />
                                                    <span style="font-size: 0.8em;"><?php  echo $this->translate(array('%s Year experience', '%s Years experience', intval($this->expert($item->userid)->experience)), intval($this->expert($item->userid)->experience)) ?></span>
                                                </div>
                                                <?php endif; ?> 
                                            </div>
                                            <div style="clear: both;"></div>
											<div class="text_expert">
												<p>
                                                   <?php echo $item->content; ?>
                                                </p>
                                                <?php if($item->attach_id): ?>
            									<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$item->storage_path; ?>"><?php $size = round($item->size/1024,2); echo $item->attach_name. " (".$size." KB)"; ?></a></p>
                                                <?php endif; ?>
												<p><em><strong><?php echo $this->translate("Post at"); ?>:</strong> <?php echo date("Y-m-d h:i:s",strtotime($item->created_date)); ?></em></p>
											</div>
										</div>
										<?php endforeach; ?>
                                        <?php endif; ?>
									</td>
								</tr>
                                <?php if(count($related_new_questions) || count($related_old_questions)):  ?>
                               
								<tr>
									<td class="border_none">
										<h2 class="title_related_questions"><?php echo $this->translate("Related Questions"); ?></h2>
										<ul class="list_questions">
                                            <?php if(count($related_new_questions)):  ?>
                                            <?php foreach($related_new_questions as $item):?>
											<li>
												<div class="content_questions">
                                                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
													<a class="title" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$item->question_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a>
													<p><strong><?php echo $this->translate('Asked by: ');?></strong> <a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"><?php echo $item->username; ?></a>
                                                    <?php echo $this->translate("at"); ?> <?php echo date("Y-m-d",strtotime($data->created_date)); ?>
                                                    <span> | </span> <?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?>
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
                                                    <?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)); ?>
                                                    
                                                    </p>
												</div>
											</li>
											<?php endforeach; ?>
                                            <?php endif;  ?>
                                            
                                            <?php if(count($related_old_questions)):  ?>
                                            <?php foreach($related_old_questions as $item):?>
											<li>
												<div class="content_questions">
                                                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
													<a class="title" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$item->question_id,'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a>
													<p><strong><?php echo $this->translate("Asked by"); ?>:</strong> <a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"><?php echo $item->username; ?></a>
                                                    <?php echo $this->translate("at"); ?> <?php echo date("Y-m-d",strtotime($data->created_date)); ?>
                                                    
                                                    <span> | </span> <?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?>
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
                                                    <?php  echo $this->translate(array(' %s rating', ' %s ratings', intval($item->total)), intval($item->total)); ?>
                                                    
                                                    </p>
												</div>
											</li>
											<?php endforeach; ?>
                                            <?php endif;  ?>
										</ul>
									</td>
								</tr>
                                <?php endif;  ?>											
							</table>
						</td>
					</tr>
				</table>
            </div>
		</div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
<script type="text/javascript">
 window.addEvent('domready',function(){
    jQuery('.experts_selected').each(function() {
        var experts_name = jQuery(this).attr("value");
        var url = jQuery(this).attr('href');
        url = url.replace('#','<?php echo $this->baseUrl('/') ?>'+'experts/index/profile/username/'+experts_name);
        jQuery(this).attr("href",url);
        jQuery(this).text(experts_name);
    });
 });
</script>