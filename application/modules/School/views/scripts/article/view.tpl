<style type="text/css">
.subsection ul li img{float:left; margin-right: 10px;}
.subsection ul li.comments_artical{background-color: #F2FAFF; border: 1px solid #D6E5EF;margin-bottom: 5px;}
#global_wrapper {background:none;}
#content{padding: 20px 0;}
#breadcrumb {
    padding-top: 20px;
    padding-bottom: 0px;
}
#global_content .layout_middle {
    padding-right: 0px;
}
</style>

<?php 
    $school= $this->school;
    $artical= $this->artical;
    $paginators= $this->paginator;
    
    $user_id= $this->user_id;
    $rated= $this->rated;
    $rating_count= $this->rating_count;
    $tt_rating= $this->tt_rating;
   
?>

<script type="text/javascript">
  var pre_rate = <?php echo $artical->rating;?>;
  var rated = '<?php echo $rated;?>';
  var artical_id = <?php echo $artical->artical_id;?>;
  var total_votes = <?php echo $rating_count;?>;
  var viewer = <?php echo $user_id;?>;
  var tt_rating= <?php echo $tt_rating;?>;
  
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
          $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big');
        } else {
          $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big_disabled');
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
    //$('rating_text').innerHTML = " <?php echo $this->translate(array('%s rating', '%s ratings', $this->rating_count),$this->locale()->toNumber($this->rating_count)) ?>";
    if (pre_rate != 0){
      set_rating();
    }
    else {
      for(var x=1; x<=5; x++) {
        $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big_disabled');
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
      $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big');
    }

    for(var x=parseInt(rating)+1; x<=5; x++) {
      $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big_disabled');
    }

    var remainder = Math.round(rating)-rating;
    if (remainder <= 0.5 && remainder !=0){
      var last = parseInt(rating)+1;
      $('rate_'+last).set('class', 'rating_star_big_generic rating_star_big_half');
    }
  }
  
  function rate(rating) {
    $('rating_text').innerHTML = "<?php echo $this->translate('Thanks for rating!');?>";
    for(var x=1; x<=5; x++) {
      $('rate_'+x).set('onclick', '');
    }
    (new Request.JSON({
      'format': 'json',
      'url' : '<?php echo $this->url(array('module' => 'school', 'controller' => 'article', 'action' => 'rate'), 'default', true) ?>',
      'data' : {
        'format' : 'json',
        'rating' : rating,
        'artical_id': artical_id
      },
      'onRequest' : function(){
        rated = 1;
        total_votes = total_votes+1;
        pre_rate = (tt_rating+rating)/total_votes;
        set_rating();
      },
      'onSuccess' : function(responseJSON, responseText)
      {
        //$('rating_text').innerHTML = responseJSON[0].total+" ratings";
        if(responseJSON[0].total==1){
        	$('rating_text').innerHTML = responseJSON[0].total+" rating";
        }else{
          $('rating_text').innerHTML = responseJSON[0].total+" ratings";
        }
      }
    })).send();
    
  }  
  en4.core.runonce.add(set_rating);
</script>
<div id="banner-school">
    <div class="section">
        <?php echo $this->content()->renderWidget('school.banner');?>
    </div>
</div>
<div id="breadcrumb">
        <div class="section">
            <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate('Home');?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/school'?>"><?php echo $this->translate('Education School');?></a>  <span>&gt;</span> <?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $school->school_id), $school->name) ?><span>&gt;</span> <strong><?php echo $artical->title;?></strong>
        </div>
    </div>
<div id="content">
    <div class="section school-detail-entry">
    <div class="layout_left">
        <?php echo $this->content()->renderWidget('school.lastest-article');?>
        <?php echo $this->content()->renderWidget('school.advertising');?>
    </div>
    <div class="layout_middle">
        <div class="school_main_manage">
            <div class="subsection">
                <h2><?php echo $artical->title;?></h2>
                <div class="content-entry">
					<?php echo $this->itemPhoto($this->user($artical->user_id), 'thumb.icon', "Image", array('class'=>'img-avatar'));?>
					<ul>
						<li><?php echo $this->user($artical->user_id);?></li>
						<li><?php echo $this->translate('Posted date:');?> <span><?php echo date('d F Y H:i', strtotime($artical->created));?></span></li>
						<li><?php echo $this->translate('Viewed: '). $artical->view_count;?> <span class="bd_list"> | </span> <a class="share smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/school_artical/id/<?php echo $artical->artical_id ?>/format/smoothbox" class="share"><?php echo $this->translate('Share');?></a></li>
					</ul>
				</div>
                <h3 style="padding-left: 20px; padding-top: 15px;"><?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $school->school_id), $school->name) ?></h3>
                <div class="detail-article" style="padding: 15px 20px 0 20px;">
						<div class="school-address">
							<a href="<?php echo $this->baseUrl('/school/inform/').$school->school_id ?>"><?php echo $this->itemPhoto($school, 'thumb.normal', $school->name, array('class'=>'img-school'));?></a>
							<ul>
								<li><?php echo $this->translate('Address: ');?><?php echo $school->address;?></li>
								<li><span><?php echo $this->translate('Country: ');?><?php echo $this->country($school->country_id)->name;?></span></li>
								<li><span><?php echo $this->translate('Phone: ');?><?php echo $school->phone;?></span></li>
							
							</ul>
						</div>
						<div class="school-contact">
							<ul>
								<li><span><?php echo $this->translate('Website: ');?></span><?php echo $school->website;?></li>
								<li><span><?php echo $this->translate('Email: ');?></span><?php echo $school->email;?></li>								
							</ul>
                            
						</div>
						<br />
                </div>
                <div class="detail-article-entry">
						<p style="clear: both;"></p>
                        <p><?php echo $artical->content;?></p>
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
                        <ul>
                            <li>
                                <div id="video_rating" class="rating" onmouseout="rating_out();">
                                    <span id="rate_1" class="rating_star_big_generic" <?php if (!$rated && $user_id):?>onclick="rate(1);"<?php endif; ?> onmouseover="rating_over(1);"></span>
                                    <span id="rate_2" class="rating_star_big_generic" <?php if (!$rated && $user_id):?>onclick="rate(2);"<?php endif; ?> onmouseover="rating_over(2);"></span>
                                    <span id="rate_3" class="rating_star_big_generic" <?php if (!$rated && $user_id):?>onclick="rate(3);"<?php endif; ?> onmouseover="rating_over(3);"></span>
                                    <span id="rate_4" class="rating_star_big_generic" <?php if (!$rated && $user_id):?>onclick="rate(4);"<?php endif; ?> onmouseover="rating_over(4);"></span>
                                    <span id="rate_5" class="rating_star_big_generic" <?php if (!$rated && $user_id):?>onclick="rate(5);"<?php endif; ?> onmouseover="rating_over(5);"></span>
                                    <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate');?></span>
                                </div>
                            </li>
                        </ul>
                </div>	
                
            	<div class="container_comment">
					<table cellspacing="0" cellpadding="0" border="0">
                    <?php //if(count($paginators)){?>
                    <?php foreach($paginators as $paginator){?>
                        <tr>
							<td class="box_comment">
								<div class="frame_img">
                                <?php 
    								$user= Engine_Api::_()->getDbtable('users', 'user')->find($paginator->owner_id)->current();
                                    
                                    ?>
                                    <a href="<?php echo $this->baseUrl().'/profile/'.$this->user($paginator->owner_id)->username;?>">
                                    <?php echo $this->itemPhoto($user, 'thumb.icon');?><span><?php echo $this->user($paginator->owner_id)->username;?> </span></a>
                                    
								</div>
								<div class="content_comment">
									<?php if($user_id==$paginator->owner_id || $user_id==$artical->user_id){?>
									   <a class="bt_function_comment bt_delete_comment" href="javascript:void(0);" onclick="delete_comment('<?php echo $paginator->comment_id;?>', '<?php echo $artical->artical_id;?>');" ><?php echo $this->translate('delete');?></a>
                                    <?php } ?>
									<p><?php echo $paginator->body;?></p>
                                    <p class="post-at"><em><?php echo $this->translate('Post at: ');?> <?php echo date('d F Y H:i', strtotime($paginator->created));?></em></p>
								</div>
							</td>
						</tr>
                    <?php }
                        //}
                    ?>
	
					</table>
                    <?php echo $this->paginationControl($paginators);?>
                    <ul>
                        <div id="loading" style="display: none;">
                            <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
                            <?php echo $this->translate("Loading ...") ?>
                        </div>
                    </ul>
                    <?php if(!empty($user_id)){?>
                    <form method="post" action="<?php echo $this->url();?>" id="post_comment">
    					<div class="input">
    						<textarea cols="40" rows="3" name="text_artical"></textarea>
    					</div>
                        <input name="artical" type="hidden" value="<?php echo $artical->artical_id;?>" id="artical"/>
    					<div class="submit">
    						<input type="submit" class="bt-post-comment" value="<?php echo $this->translate('Post Comment');?>" />
    					</div>
                    </form>
                    <?php } ?>
				</div>
            </div> 
        </div>
    </div>
    </div>
</div>
<script type="text/javascript">
function delete_comment(comment_id, artical_id){
    var url="<?php echo $this->baseUrl().'/school/article/delete-comment'?>";
    if(confirm("Do you really want to delete this comment?")){
        $('loading').style.display="block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'comment_id': comment_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            $('loading').style.display="none";
            
            if(responseHTML==1){
                //tam thoi cho redirect ve trang nay
                window.location.href= "<?php echo $this->baseUrl().'/school/articles/'?>"+artical_id;
            }
            
        }
    }).send();
	}
}
window.addEvent('domready', function(){
    jQuery("#post_comment").validate({
        messages:{
            "text_artical":{
                required: "<strong style='color: red'>"+"<?php echo $this->translate('Comment is not empty')?>" + "</strong>"
            }
        },
        rules: {
            "text_artical":{
                required: true
            }
        }
    });
});
</script>