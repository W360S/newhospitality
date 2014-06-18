<style>
.wd-content-left { width:204px; float:left; padding-top:20px;}
</style>
<?php if(isset($this->book)): ?>
<script type="text/javascript">
  var pre_rate = "<?php echo $this->book->rating;?>";
  var rated = "<?php echo $this->rated;?>";
  var book_id = "<?php echo $this->book->book_id;?>";
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
      'url' : '<?php echo $this->url(array('module' => 'library', 'controller' => 'index', 'action' => 'rate'), 'default', true) ?>',
      'data' : {
        'format' : 'json',
        'rating' : rating,
        'book_id': book_id
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

<script type="text/javascript">
  function showResponse(responseText)  {
            if(responseText.message == 'success')
            {      
                Smoothbox.open( $('hidden_load_div_book'), { mode: 'Inline' } ); 
                var pl = $$('#TB_ajaxContent > div')[0];
                pl.show(); 
                jQuery('#TB_ajaxContent div').html('You\'ve posted a new comment success, please waiting to approved...');
                window.location.href = '<?php echo $this->url();?>';
            }
            else if(responseText.message == 'content'){
                $('error_content').set('html', 'Your comment is no more than 1000 characters.');
            }
            else
            {
                  
            }     
            return false;
    } 
 window.addEvent('domready',function(){
    jQuery('#comment_create').validate({
    		messages : {
    			"description" : "<?php echo $this->translate('Sorry. Not accept content empty or content too long.'); ?>"
    		},
    		rules: {
    			"description" : {
    		      required: true,
    		      maxlength: 10000
    		    }
            }
    }); 
    var options = { 
            dataType:  'json',   
            success: showResponse,
            type : 'post'
    };     
    jQuery('#comment_create').ajaxForm(options); 
    jQuery('#ajax_comment .paginationControl a').click(function(){
        //var url = '/viethospitality/library/index/view/book_id/25/page/2';
        var url = jQuery(this).attr('href');
        if(url != '#')
        {
            var url = url.replace('view','comment');
            jQuery("#ajax_comment").html("<?php echo $this->translate('Loading...'); ?>");
            jQuery.get(url,function(data){
               jQuery("#ajax_comment").html(data);      
            });    
        }          
        return false;  
    });  
    
    
    
 });
</script>

<style>
.rating{
    clear: none;
}
.error{
    color: red;
}
</style>
<?php
    $paginator = $this->paginator; 
    $pagination_control = $this->paginationControl($this->paginator);
    $book = $this->book;
    $other_books = $this->other_books;
    
    $rated = $this->rated;
    $viewer_id = $this->viewer_id;
    $rating_count = $this->rating_count;
    $my_books= $this->my_books;
    
?>
<div id="wd-content-container">
	<div class="wd-center">
		
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
						<div class="subsection">
						<div class="detail_library">
						    
							<div class="frame_img">
							<?php if($book->photo_id): ?>
							    <?php 
								echo $this->itemPhoto($book, 'thumb.normal',null);
							    ?>
							<?php else: ?>
							    <img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" width="80" height="122"/>
							<?php endif; ?>
							<?php if(intval($book->credit) == 0): ?>
								<div class="status status_free">
									<p><?php echo $this->translate('free'); ?></p>
								</div>
							<?php else: ?>
							<div class="status">
								<p><?php  echo $this->translate(array('%s credit', '%s credits', intval($book->credit)), intval($book->credit)); ?></p>
							</div>
							<?php endif; ?>
							</div>

							<div class="container_title">
								<h3><?php echo $book->title; ?></h3>
								<p>
							    <span><strong><?php echo $this->translate('Category'); ?>:</strong> <a href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'index','cat_id'=>$book->category_ids),'default',true); ?>"><?php echo $book->category; ?></a></span>
							    <div><strong><?php echo $this->translate('Code'); ?>:</strong> <?php echo $book->isbn; ?></div>
							    <div><strong><?php echo $this->translate('Author'); ?>:</strong> <?php echo $book->author; ?></div>
							    <div id="book_rating" class="rating" onmouseout="rating_out();">
							      <span id="rate_1" <?php if (!$rated && $viewer_id):?>onclick="rate(1);"<?php endif; ?> onmouseover="rating_over(1);"></span>
							      <span id="rate_2" <?php if (!$rated && $viewer_id):?>onclick="rate(2);"<?php endif; ?> onmouseover="rating_over(2);"></span>
							      <span id="rate_3" <?php if (!$rated && $viewer_id):?>onclick="rate(3);"<?php endif; ?> onmouseover="rating_over(3);"></span>
							      <span id="rate_4" <?php if (!$rated && $viewer_id):?>onclick="rate(4);"<?php endif; ?> onmouseover="rating_over(4);"></span>
							      <span id="rate_5" <?php if (!$rated && $viewer_id):?>onclick="rate(5);"<?php endif; ?> onmouseover="rating_over(5);"></span>
							      <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate');?></span>
							    </div>
							    <?php echo $this->htmlLink(Array('module'=> 'activity', 'controller' => 'index', 'action' => 'share', 'route' => 'default', 'type' => 'library_book', 'id' => $book->book_id, 'format' => 'smoothbox'), $this->translate("Share"), array('class' => 'smoothbox library-share-link')); ?>
							    <?php echo $this->htmlLink(Array('module'=> 'core', 'controller' => 'report', 'action' => 'create', 'route' => 'default', 'subject' =>  'library_book_' . $book->book_id, 'format' => 'smoothbox'), $this->translate("Report"), array('class' => 'smoothbox library-report-link')); ?>
							    <?php  echo $this->translate(array('%s download', '%s downloads', intval($book->download_count)), intval($book->download_count)) ?> 
							    
							</p>
							<!-- check book already in your shelf-->
							<?php if(!in_array($book->book_id, $my_books)):?>
							<p class="bt_detail"><a class="bt_download smoothbox" href="<?php echo $this->url(array('module'=>'library','controller'=>'book-shelf', 'action'=>'add','book_id'=>$book->book_id),'default',true); ?>"><?php echo $this->translate('Bookshelf'); ?></a></p>
							<?php endif;?>
							</div>

							<div class="content_detail">
							 <p class="p_detail"> <?php echo $book->description; ?></p>
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
							
							<div class="container_comment">
							<?php if($paginator->getTotalItemCount()==0){?>
							<h3 class="title_port_question"><?php  echo $this->translate(" 0 Comment") ?></h3>
							<?php } else {?>
								<h3 class="title_port_question"><?php  echo $this->translate(array('%s Comment', '%s Comments', intval($paginator->getTotalItemCount())), intval($paginator->getTotalItemCount())) ?></h3>
							<?php }?>

							<div id="ajax_comment">
							    <?php if( $paginator->getTotalItemCount() ): ?>
							    <table cellspacing="0" cellpadding="0" border="0">
								<?php foreach ($paginator as $item):?>
								<tr>
									<td class="box_comment">
										<div class="frame_img">
									    <?php if(!empty($item->photo)): ?>
											    <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png">
									    <?php else: ?>
										<?php echo $this->itemPhoto($item, 'thumb.normal', "Image"); ?>
									    <?php endif; ?>
										</div>
										<div class="content_comment">
											<p><?php echo $item->content; ?></p>
											    <p><em>Post at: <?php echo $item->created_date; ?></em> <?php echo $this->translate("by")?> <a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"> <?php echo $item->username; ?> </a></p>
										</div>
									</td>
								</tr>
								<?php endforeach; ?>
							    </table>
							    <div>
							      <?php echo $pagination_control; ?>
							    </div>
							    <?php endif; ?>
							</div>
							<?php if(Engine_Api::_()->user()->getViewer()->getIdentity()){?>
							<form id="comment_create" method="post" action="<?php echo $this->url(array()) ?>">                       
								<div class="input">
								<?php echo $this->translate('Your comment'); ?>:
									<textarea name="description" id="description" cols="1" rows=""></textarea>
								<input type="hidden" id='book_id' name="book_id" value="<?php echo $book->book_id; ?>" />
								</div>
								 <div id="error_content" style="color: red"></div>
								<div class="submit">
									<input type="submit" class="bt_send_question" value="<?php echo $this->translate('send'); ?>" />
									<input type="reset" class="bt_send_question" value="<?php echo $this->translate('cancel'); ?>" />
								</div>
							</form>
							<?php } ?>
							<?php else: echo "Invalid data"; ?>
    
							<?php endif; ?>
							<div id="hidden_load_div_book" style="display:none"></div>
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