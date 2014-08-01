<script type="text/javascript">
  var pre_rate = "<?php echo $this->data->rating;?>";
  var rated = "<?php echo $this->rated;?>";
  var question_id = "<?php echo $this->data->question_id;?>";
  var total_votes = "<?php echo $this->rating_count;?>";
  var viewer = "<?php echo $this->viewer_id;?>";
  
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
    $('rating_text').innerHTML = " <?php echo $this->translate(array('%s rating', '%s ratings', $this->rating_count),$this->locale()->toNumber($this->rating_count)) ?>";
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
    $('rating_text').innerHTML = "<?php echo $this->translate(array('%s rating', '%s ratings', $this->rating_count),$this->locale()->toNumber($this->rating_count)) ?>";
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
        pre_rate = (pre_rate+rating)/total_votes;
        set_rating();
      },
      'onSuccess' : function(responseJSON, responseText)
      {
        $('rating_text').innerHTML = responseJSON[0].total+" ratings";
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
?>
<h2>
  <?php echo $this->translate("Experts Plugin") ?>
</h2>



<?php if(count($this->categories)): ?>
<div class='clear'>
  <div class='settings'>
    <form class="global_form">
    <div class="subsection">
        <ul class="list_category">
            <?php foreach($this->categories as $item): ?>
    		<li>
            <?php 
            echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-questions', 'action' => 'index','cat_id'=>$item->category_id), $item->category_name."({$item->cnt_question})", array(
            ))
            ?>
            </li>
            <?php endforeach; ?>
    	</ul>
    </div>  
    </form>
  </div>
</div>
<?php endif; ?>    
<br />

<a href="<?php echo $this->baseUrl().'/admin/experts/manage-questions'; ?>"><?php echo $this->translate('Manage Question');?></a>
<h2>
  <?php echo $this->translate("Question detail"); ?>
</h2>

<div class="list_my_questions">
    <table cellspacing="0" cellpadding="0" border="0" >
    	<tr class="form_answer">
    		<td>
    			<table>
    				<tr>
    					<td>
    						<p class="title_answer" ><h2><?php echo $data->title ?></h2></p>
    						<p class="views_rating">
                            
                            <strong><?php echo $this->translate('Category'); ?></strong> <?php echo $data->category; ?>
                            
                            <div>
                                <?php  echo $this->translate(array('%s view', '%s views', intval($data->view_count)), intval($data->view_count)); ?>
                            </div>   
                            <div id="question_rating" class="rating" onmouseout="rating_out();">
                              <span id="rate_1" <?php if (!$rated && $viewer_id):?>onclick="rate(1);"<?php endif; ?> onmouseover="rating_over(1);"></span>
                              <span id="rate_2" <?php if (!$rated && $viewer_id):?>onclick="rate(2);"<?php endif; ?> onmouseover="rating_over(2);"></span>
                              <span id="rate_3" <?php if (!$rated && $viewer_id):?>onclick="rate(3);"<?php endif; ?> onmouseover="rating_over(3);"></span>
                              <span id="rate_4" <?php if (!$rated && $viewer_id):?>onclick="rate(4);"<?php endif; ?> onmouseover="rating_over(4);"></span>
                              <span id="rate_5" <?php if (!$rated && $viewer_id):?>onclick="rate(5);"<?php endif; ?> onmouseover="rating_over(5);"></span>
                              <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate');?></span>
                            </div>
                            </p>
    					</td>
    				</tr>
    				<tr>
    					<td>
    						<p><?php echo $data->content; ?></p>
    						<?php if($data->file_id): ?>
    						<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$data->storage_path; ?>"><?php $size = round($data->size/1024,2); echo $data->name. " (".$size." KB)"; ?></a></p>
                            <?php endif; ?>
                            <?php if(!empty($data->add_detail)): ?>
                            <p class="title_answer"><strong><?php echo $this->translate('Update detail'); ?></strong></p>
                            <p><?php echo $data->add_detail; ?></p>    
                            <?php endif; ?>
    					</td>
    				</tr>
    				<tr>
    					<td class="border_none">
    						<p><strong><?php echo $this->translate('Post by'); ?>:</strong> <a href="<?php echo $this->baseUrl("/")."profile/".$data->username; ?>"><?php echo $data->username; ?></a>  at <?php echo date("Y-m-d",strtotime($data->created_date)); ?> <!-- <a class="share_it" href="#">Share it</a></p> -->
    						<p><strong><?php echo $this->translate('Experts selected'); ?>:</strong> <?php echo $data->experts; ?></p>
                            <?php if(count($answers)): ?>
                            <?php foreach($answers as $item): ?>
                            <div class="detail_expert">
    							<div class="frame_img">
    								<a href="#">
    									<?php echo $this->itemPhoto($item, 'thumb.normal', "Image"); ?>
    									<strong><?php echo $item->username; ?></strong>
    								</a>
    							</div>
    							<div class="text_expert">
    								<p>
                                       <?php echo $item->content; ?>
                                    </p>
                                    <?php if($item->attach_id): ?>
    								<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$item->storage_path; ?>"><?php $size = round($item->size/1024,2); echo $item->attach_name. " (".$size." KB)"; ?></a></p>
                                    <?php endif; ?>
    								<p><em><strong><?php echo $this->translate('Post at'); ?>:</strong> <?php echo date("Y-m-d h:i:s",strtotime($item->created_date)); ?></em></p>
    							</div>
    						</div>
    						<?php endforeach; ?>
                            <?php endif; ?>
    					</td>
    				</tr>
                    								
    			</table>
    		</td>
    	</tr>
    </table>
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
