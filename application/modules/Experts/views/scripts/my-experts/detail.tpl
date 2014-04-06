<style>
    .error{ color: red}
    label.error{width: 100px !important;}
    .list_my_questions table.my_experts tr.form_answer td p {
        width: auto !important;
    }
</style>
<script type="text/javascript" src="<?php echo $this->baseUrl('/').'externals/tinymce/tiny_mce.js' ?>"></script> 
<script type="text/javascript"> 
    tinyMCE.init({ 
        theme : "advanced",
        mode : "textareas", 
        elements  : "description",
        plugins: 'emotions, table, fullscreen, media, preview, paste, gsynuhimgupload',
        theme_advanced_buttons1: 'undo, redo, cleanup, removeformat, pasteword, |, code, media, image, fullscreen, preview, gsynuhimgupload',
        theme_advanced_buttons2: "fontselect, fontsizeselect, bold, italic, underline, strikethrough,forecolor,backcolor, |, justifyleft, justifycenter, justifyright, justifyfull, |, bullist, numlist, |, outdent, indent, blockquote",
        theme_advanced_toolbar_location : "top",
        theme_advanced_toolbar_align : "left",
        paste_use_dialog : false,
        theme_advanced_resizing : true,
        theme_advanced_resize_horizontal : true,
        apply_source_formatting : true,
        force_br_newlines : true,
        force_p_newlines : false,   
        relative_urls : true
    });  
</script>
<script type="text/javascript">
 window.addEvent('domready',function(){
    
    jQuery('#submit_answer').click(function() {
        var content = tinyMCE.activeEditor.getContent(); // get the content
        jQuery('#description').val(content); // put it in the textarea
    });
    jQuery('#questions_answer').validate({
    		messages : {
    			"description" : "<?php echo $this->translate('This field is not empty.'); ?>",
          "maxlength" : "<?php echo $this->translate('This field is too long.'); ?>"
    		},
    		rules: {
    			"description" : {
    		      required: true
    		      
    		  },
          "maxlength" :{
            maxlength: 60000
          }
        }
    }); 
 });
</script>
<script type="text/javascript">
  en4.core.runonce.add(function(){$$('td.admin_table_short input[type=checkbox]').addEvent('click', function(){ $$('input[type=checkbox]').set('checked', $(this).get('checked', false)); })});
  
  /* Cancel selected questions */
  var cancelSelected =function(){
    
    var checkboxes = $$('input[name=questions_checbox][type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });
    
    $('cancel_ids').value = selecteditems;
    $('cancel_selected').submit();
  }
  
  /* Close selected questions */
  var closeSelected =function(){
    
    var checkboxes = $$('input[name=questions_checbox][type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });

    $('close_ids').value = selecteditems;
    $('close_selected').submit();
  }
  
  /* Close delete questions */
  var deleteSelected =function(){
    
    var checkboxes = $$('input[name=questions_checbox][type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });
    
    $('delete_ids').value = selecteditems;
    $('delete_selected').submit();
  }
</script>

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
<?php
    $data = $this->data;
    $categories = $this->categories;
    $answers = $this->answers;
    //Zend_Debug::dump($answers);exit;
    // rating
    $rated = $this->rated;
    $viewer_id = $this->viewer_id;
    $rating_count = $this->rating_count; 
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
				<h2><a class="first" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'index'),'default', true); ?>"><?php echo $this->translate('experts'); ?></a> <a href="<?php echo $this->baseUrl("/")."experts/my-experts/"; ?>"><?php echo $this->translate('Expert tool'); ?></a></h2>
			</div>
			<div class="clear"></div>
        </div>
		<div class="layout_left layout_left_expert">
			<div class="subsection">
				<?php echo $this->content()->renderWidget('experts.my-experts'); ?>
			</div>
		</div>
		<div class="layout_middle_question">
			<div class="search_my_question">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
                
			</div>	
			<div class="list_my_questions">
                <table cellspacing="0" cellpadding="0" border="0" class="my_experts">
                    <tr class="container_func">
                        <td>
                        	<?php if($data->status == 1): ?>
                                <a href="<?php echo $this->baseUrl("/")."experts/my-experts/cancel/question_id/".$data->question_id; ?>" class="smoothbox bt_cancel"><?php echo $this->translate('cancel'); ?></a>
                            <?php endif; ?>
                            
                            <?php if($data->status == 2): ?>
                                <a href="<?php echo $this->baseUrl("/")."experts/my-experts/close/question_id/".$data->question_id; ?>" class="smoothbox bt_cancel"><?php echo $this->translate('close'); ?></a>
                            <?php endif; ?>
                            
                            <?php if(in_array($data->status,array(1,3,4))): ?>
                                <a href="<?php echo $this->baseUrl("/")."experts/my-experts/delete/question_id/".$data->question_id; ?>" class="smoothbox bt_cancel"><?php echo $this->translate('delete'); ?></a>
                            <?php endif; ?>
                        </td>
                    </tr>
					<tr class="form_answer">
						<td>
							<table>
                                <tr>
                                	<td>
                                		<p class="title_answer" ><h2><?php echo $data->title; ?></h2></p>
                                		<p class="views_rating">
                                        <strong><?php echo $this->translate('Asked by'); ?>:</strong> <a href="<?php echo $this->baseUrl("/")."profile/".$data->username; ?>"><?php echo $data->username; ?></a>  at <?php echo date("Y-m-d",strtotime($data->created_date)); ?>
										
                                         <?php $count = count($categories); if($count): ?>
                                            <strong><?php echo $this->translate('in category ');?></strong> 
                                            <?php $cat = ""; $cnt = 1; 
                                            foreach($categories as $item){
                                                if($cnt < $count){
                                                    $cat = $cat.$item->category_name.", ";
                                                } else {
                                                    $cat = $cat.$item->category_name.". ";
                                                }
                                                $cnt = $cnt + 1;
                                            }
                                            echo $cat;
                                            ?>
                                          <?php endif; ?>
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
                                	</td>
                                </tr>
								<tr>
									<td>
										<p><?php echo $data->content; ?></p>
										<?php if($data->file_id): ?>
    									<p><a class="attack_file" href="<?php echo $this->baseUrl("/").$data->storage_path; ?>"><?php $size = round($data->size/1024,2); echo $data->name. " (".$size." KB)"; ?></a></p>
                                        <?php endif; ?>
                                        <?php if(!empty($data->add_detail)): ?>
                                        <p class="title_answer"><strong><?php echo "Update detail"; ?></strong></p>
                                        <p><?php echo $data->add_detail; ?></p>    
                                        <?php endif; ?>
									</td>
								</tr>
								<tr>
									<td class="border_none">
										
                                        <?php if(count($answers)): ?>
                                        <?php foreach($answers as $item): ?>
                                        <div class="detail_expert">
											<div class="frame_img">
                                                <div style="float: left;">
    												<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile','user_id'=>$item->userid),'default',true); ?>">
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
    												<em> <?php $this->translate('in') ?> <?php echo $this->expert($item->userid)->company;?></em><br />
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
												<p ><em><strong><?php echo $this->translate('Answered at'); ?></strong> <?php echo date("Y-m-d h:i:s",strtotime($item->created_date)); ?></em></p>
											</div>
										</div>
										<?php endforeach; ?>
                                        <?php endif; ?>
									</td>
								</tr>
                                <tr class="form_answer">
                					<td>
                                        <form method="post" action="<?php echo $this->url(); ?>"  enctype="multipart/form-data" id="questions_answer">
                						<table>
                							<tr>
                								<td>
                									<textarea id="description"  name="description"></textarea>
                									<p class="title_upload">Upload Attachment(Support: txt,png,pneg,jpg,jpeg,gif,doc,docx,rar Maxsize: 5Mb)</p>
                    						        <input type="file" id="file" name="file">
                                                    <input type="hidden" id="question_id" value="<?php echo $data->question_id; ?>" name="question_id">
                								</td>
                							</tr>	
                							<tr>
                								<td class="container_button">
                									<input class="bt_send_question" id="submit_answer" type="submit" value="send" />
                									<input class="bt_send_question" type="reset" value="cancel" />
                								</td>
                							</tr>										
                						</table>
                                        </form>
                					</td>
                				</tr>
                                								
							</table>
						</td>
					</tr>
                    <tr class="container_func">
    					<td>
    						<?php if($data->status == 1): ?>
                                <a href="<?php echo $this->baseUrl("/")."experts/my-experts/cancel/question_id/".$data->question_id; ?>" class="smoothbox bt_cancel"><?php echo $this->translate('cancel'); ?></a>
                            <?php endif; ?>
                            
                            <?php if($data->status == 2): ?>
                                <a href="<?php echo $this->baseUrl("/")."experts/my-experts/close/question_id/".$data->question_id; ?>" class="smoothbox bt_cancel"><?php echo $this->translate('close'); ?></a>
                            <?php endif; ?>
                            
                            <?php if(in_array($data->status,array(1,3,4))): ?>
                                <a href="<?php echo $this->baseUrl("/")."experts/my-experts/delete/question_id/".$data->question_id; ?>" class="smoothbox bt_cancel"><?php echo $this->translate('delete'); ?></a>
                            <?php endif; ?>
    					</td>
    				</tr>
				</table>
            </div>
		</div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
