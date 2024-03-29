<style>

.pt-comment-text .pt-textarea {width:100% !important;}
.button {-moz-border-bottom-colors: none; -moz-border-left-colors: none;-moz-border-right-colors: none;-moz-border-top-colors: none;background-color: #50C1E9;
    background-image: url("/application/modules/Core/externals/images/buttonbg.png?c=34");background-position: 0 1px;
    background-repeat: repeat-x;border-bottom-color: #50809B; border-bottom-left-radius: 3px; border-bottom-right-radius: 3px;
    border-bottom-style: solid;border-bottom-width: 0px;border-image-outset: 0 0 0 0;border-image-repeat: stretch stretch;border-image-slice: 100% 100% 100% 100%;
    border-image-source: none; border-image-width: 1 1 1 1; border-left-color-ltr-source: physical;border-left-color-rtl-source: physical;
    border-left-color-value: #50809B; border-left-style-ltr-source: physical;border-left-style-rtl-source: physical; border-left-style-value: solid;
    border-left-width-ltr-source: physical; border-left-width-rtl-source: physical;border-left-width-value: 1px;border-right-color-ltr-source: physical;
    border-right-color-rtl-source: physical;border-right-color-value: #50809B;border-right-style-ltr-source: physical;
    border-right-style-rtl-source: physical;border-right-style-value: solid;border-right-width-ltr-source: physical;border-right-width-rtl-source: physical;
    border-right-width-value: 1px; border-top-color: #50809B;border-top-left-radius: 3px;border-top-right-radius: 3px;border-top-style: solid;
    border-top-width: 0px;color: #FFFFFF;font-size: 13px;font-weight: 700;padding-bottom: 8px;padding-left: 8px;padding-right: 10px;padding-top: 8px;
}
.button:hover {background-color: #2F95B9;}
.pt-content-user-post p{padding-left:10px;}


.pt-like-how a { height: 8px !important;}


a.pt-like-how {
    background-attachment: scroll;
    background-clip: border-box;
    background-color: rgba(0, 0, 0, 0);
    background-image: url(/application/themes/newhospitality/images/front/pt-sprite.png?c=34);
    background-origin: padding-box;
    background-position: -207px -489px;
    background-repeat: no-repeat;
    background-size: auto auto;
    display: inline-block;
    height: 8px;
    width: 21px;
}


</style>
<script type="text/javascript">
  var pre_rate = "<?php echo $this->book->rating;?>";
  var rated = "<?php echo $this->rated;?>";
  var book_id = "<?php echo $this->book->book_id;?>";
  var total_votes = <?php echo $this->rating_count;?>;
  var viewer = "<?php echo $this->viewer_id;?>";
  var tt_rating= <?php echo $this->tt_rating;?>;
  
 
</script>

<script type="text/javascript">
  function ajaxLike(book_id, cnt)
  {  
	(new Request.JSON({
	      'format': 'json',
	      'url' : '<?php echo $this->url(array('module' => 'library', 'controller' => 'index', 'action' => 'like'), 'default', true) ?>',
	      'data' : {
		'format' : 'json',
		'book_id': book_id
	      },
	      'onRequest' : function(){
		
	      },
	      'onSuccess' : function(responseJSON, responseText)
	      {
	        var last = cnt+1;
		$('like_book').innerHTML = responseJSON[0].total;
	      }
	    })).send();
  }

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
    
    jQuery('#search_featured_experts').click(function() {
        var url = "<?php echo $this->baseUrl().'/experts/ajax-request/selected-experts?cats='; ?>";
        var cats = jQuery("input[name='expertcategory']:checked");
        var str_cats = "";
        var cnt = 1;
        if(cats.length < 1) { 
			alert("Please select category"); return false;
		} else {
		    jQuery.each(cats, function() {
		      if(cnt < cats.length) {
                str_cats += jQuery(this).val()+",";
                cnt ++;
              } else {
                str_cats += jQuery(this).val();
              }
            });
        }
        url = url + str_cats;
       
        jQuery.ajax({
          url: url,
          cache: false,
          success: function(html){
            jQuery("#widget_experts").slideToggle();
            jQuery("#widget_experts").hide();
            jQuery("#featured-experts").html(html);
          }
        });
        
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
		<div class="wd-content-content-sprite pt-to-send">
			<div class="wd-content-event">
				<div class="pt-content-event pt-content-book-details">
					<div class="pt-reply-how">
						<ul class="pt-menu-event pt-menu-libraries">
							<li>
								Thư viện
							</li>
							<li>
								<a href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'index','cat_id'=>$book->category_ids),'default',true); ?>"><?php echo $book->category; ?></a>
							</li>
							<li>
								<span><?php echo $book->title; ?></span>
							</li>
						</ul>
						<div class="pt-content-info-book-details">
							<?php if($book->photo_id): ?>
							    <?php 
								echo $this->itemPhoto($book, 'thumb.normal pt-img-book',null);
							    ?>
							<?php else: ?>
							    <img alt="Image" class="pt-img-book" src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" width="80" height="122"/>
							<?php endif; ?>
							<div class="pt-how-book-details">
								<h2><?php echo $book->title; ?></h2>
								<p><?php echo $this->translate('Category'); ?>:</strong> <a href="<?php echo $this->url(array('module'=>'library','controller'=>'index','action'=>'index','cat_id'=>$book->category_ids),'default',true); ?>"><?php echo $book->category; ?></a></p>
								<p><?php echo $this->translate('Author'); ?>:</strong> <?php echo $book->author; ?></p>
								
								<p class="pt-text">
								<?php echo $book->description; ?>
								</p>

                                                                <div class="pt-info-coupon">
									
									<div>
									
										
										<?php  if($book->credit == 0): ?>
										<span><?php echo $this->translate('free'); ?></span>
										<?php else: ?>
										 <span><?php  echo $book->credit. $this->translate(' Coupon'); ?></span>
										    
										<?php endif; ?>
										<?php if(!in_array($book->book_id, $my_books)):?>
										<?php echo $this->htmlLink(array('route' => 'default', 'module' => 'library', 'controller' => 'book-shelf', 'action' => 'download','fid'=>substr(base64_encode($user_id.Zend_Session::getId()),0,7) .substr(base64_encode($book->book_id . rand(1000000,9999999)),0,8) . base64_encode($book->url),'code'=>substr(md5(microtime()), 0, 10) . ".pdf"),$this->translate('Download'), array(
										    'class' => 'download_book smoothbox buttonlink  pt-download'
										)) ?>
										<?php else:?>
                                                                                <? /*
											<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'book-shelf', 'action'=>'index'), 'default', true); ?>">
												Đi đến Tủ sách của tôi
											</a>
                                                                                */ ?>
                                                                                <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'library', 'controller' => 'book-shelf', 'action' => 'download','fid'=>substr(base64_encode($user_id.Zend_Session::getId()),0,7) .substr(base64_encode($book->book_id . rand(1000000,9999999)),0,8) . base64_encode($book->url),'code'=>substr(md5(microtime()), 0, 10) . ".pdf"),$this->translate('Download'), array(
										    'class' => 'download_book smoothbox buttonlink  pt-download'
										)) ?>
										<?php endif;?>
										<?php echo $this->htmlLink(Array('module'=> 'activity', 'controller' => 'index', 'action' => 'share', 'route' => 'default', 'type' => 'library_book', 'id' => $book->book_id, 'format' => 'smoothbox'), $this->translate("Share"), array('class' => 'smoothbox pt-share')); ?>

										<a style="padding-left: 0x !important;" class="pt-like-how" href="javascript:void(0);"  onclick="javascript:ajaxLike(<?php echo $book->book_id; ?>,<?php echo $book->cnt_like; ?>)"></a>
										<span title="<?php echo $book->like_name; ?>" style="border:0px;" id="like_book" class="like_book"><?php echo $book->cnt_like; ?></span>
										
										<div  class="pt-none"></div>
									</div>
									
								</div>
								
							</div>
							<div class="pt-user-post-comment">
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
							</div>
							
						</div>
						<div class="pt-to-send-left pt-to-send-left-fix">
							<div class="pt-to-send-content">
								<div class="pt-comment-text pt-block">
									 <form id="comment_create" method="post" action="<?php echo $this->url(array()) ?>">
									<div class="pt-textarea">
										<textarea name="description" id="description" cols="1" rows=""></textarea>
										 <input type="hidden" id='book_id' name="book_id" value="<?php echo $book->book_id; ?>" />
										 <div id="error_content" style="color: red"></div>
									</div>
									<div class="pt-submit-comment">
										<input type="submit" class="button" value="<?php echo $this->translate('send'); ?>" />
    										<input type="reset" class="button" value="<?php echo $this->translate('cancel'); ?>" />
									</div>
									</form>
								</div>
								<?php if( $paginator->getTotalItemCount() ): ?>
								<?php foreach ($paginator as $item):?>
								<div class="pt-block">
									<span class="pt-avatar">
										
										<?php if(!empty($item->photo)): ?>
											    <span class="pt-avatar"><img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png"></span>
										<?php else: ?>
										<?php echo $this->itemPhoto($item, 'thumb.icon', "Image"); ?>
										<?php endif; ?>

										<div style="padding-left: 57px;" class="pt-how-info-user-post">
											<h3><?php echo $this->translate("by")?> <a href="<?php echo $this->baseUrl("/")."profile/".$item->username; ?>"> <?php echo $item->username; ?> </a></h3>
											<p><span></span>Post at: - <?php echo $item->created_date; ?></p>
										</div>
									</span>
									<div class="pt-content-user-post">
										<p><?php echo $item->content; ?></p>
									</div>
									
								</div>
								<?php endforeach; ?>
								<div>
								      <?php echo $pagination_control; ?>
								    </div>
								<?php endif; ?>
								
							</div>
						</div>
						<div class="pt-reply-right">
							<div class="pt-block">
								<?php echo $this->content()->renderWidget('library.top-views');  ?>
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

<div id="hidden_load_div_book" style="display:none"></div>

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