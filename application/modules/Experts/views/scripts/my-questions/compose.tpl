<style style="text/css">
	.wd-content-container .wd-center {
	width: 1188px !important;
}
</style>
<style style="text/css">
.wd-content-left { width:204px; float:left; padding-top:20px;}
.panel {float:left;margin-right:3px;position:relative;z-index:99;margin-top:1px}
/*
.panel .trigger {background:#fff url(~/application/modules/Core/externals/images/arrow-17.gif) right 2px no-repeat;border:1px solid #999;cursor:pointer;height:20px;overflow:hidden;width:148px;padding-left:10px;line-height:22px; border-radius: 3px; -moz-border-radius: 3px; -webkit-border-radius: 3px}
.panel .content {background:#fff url(~/application/modules/Core/externals/images/gradient-1.gif) left bottom repeat-x;border:1px solid #DCDCDC;padding:10px;right:0;top:24px;width:138px;z-index:100; height: 205px; overflow: auto;}
*/
.panel .content .s-input{float:left;margin-bottom:6px;clear:both;width:138px}
.panel .content .s-input input{margin:0 3px 0 0;width:auto;border:none;color:#fff;font-size:0px;display:inline-block }
.panel .content .s-input label {font-weight:normal;line-height:15px; float:left;display:inline-block;width:115px}

    
#content_compose_title .s-input label, #content_compose_experts .s-input label{
padding-right:2px;
padding-top: 2px;
text-align:left;
}
.panel #content_compose_title, .panel #content_compose_experts{
width: 268px;
}

#content_compose_title div.s-input{
width: 400px;
}    

#content_compose_title div.s-input label{
width: 340px;
}

.panel #trigger_compose_title, .panel #trigger_compose_experts{
width: 280px;
}
#panel_compose_title{
z-index: 90;
}

    
</style>

<script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/custom.expert.js'?>" type="text/javascript"></script>
<script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/jquery.lib.min.js'?>" type="text/javascript"></script>
<script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/jquery.tooltip.min.js'?>" type="text/javascript"></script>
<script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/jquery.validate.js'?>" type="text/javascript"></script>
  <script type="text/javascript">    
    jQuery.noConflict();
  </script>
<script type="text/javascript">
  function showResponse(object, success, response, d)  {

        if(success == "success"){
            var result = JSON.parse(response.responseText);
            if(result.message == 'success')
            {      
                Smoothbox.open( $('hidden_load_div'), { mode: 'Inline' } ); 
                var pl = $$('#TB_ajaxContent > div')[0];
                pl.show(); 
                jQuery('#TB_ajaxContent div').html('You\'ve created a new question success.');
                window.location.href = '<?php echo $this->baseUrl() ?>/experts/my-questions';
            }
            else if(result.message == 'file'){
                alert("<?php echo $this->translate('Your file is too big!')?>");
            }
            else if(result.message == 'extension'){
                alert("<?php echo $this->translate('Check that the file is a valid format.')?>");
            }
            else
            {
                //jQuery('#hidden_load_div').html("Your question has not created yet.");     
                //jQuery('#TB_ajaxContent div').html("Your question has not created yet.");    
            }     
            return false;
        }
            
    }  

  window.addEvent('domready',function(){
    
    var options = { 
            dataType    :  'json',   
            success     : showResponse,
            type        : 'post'
    };     
     jQuery.validator.addMethod(
		    'fileSave',
		    function(value, element){
                if (jQuery.trim(value)==""){
					return true;
				}else{
                    if (valid_extensions.test(element.value)){
                        if (navigator.userAgent.indexOf("Firefox") != -1 || navigator.userAgent.indexOf("Safari") != -1){
                    		var node = document.getElementById('file');
                            var max_size= '5000000';
                            var check = node.files[0].fileSize;
                            
                            if (check > max_size)
                            {
                                alert("<?php echo $this->translate('Your file is too big!') ?>");
                                return false;
                            }else{
                                return true;
                            }
                    	}else{
                    		var myFSO = new ActiveXObject("Scripting.FileSystemObject");
                        	var filepath = document.upload.file.value;
                        	var thefile = myFSO.getFile(filepath);
                        	var size = thefile.size;
                            var max_size= '5000000';
                        	if (size > max_size)
                            {
                                alert("<?php echo $this->translate('Your file is too big!')?>");
                                return false;
                            }else{
                                return true;
                            }
                    	}
                }
                else{
                    alert("<?php echo $this->translate('Check that the file is a valid format.')?>");
                    return false;
                }
                
                fld.select();
                fld.focus();
                return false;
    		    }
      }
		);
    jQuery('#questions_create').validate({
		messages : {
			"title" : {
			     required: "<?php echo $this->translate('Title is not empty (*)')?>",
                 maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
             },
            "description" : {
                required: "<?php echo $this->translate('Description is not empty (*)')?>"
            },
            "check_select_experts" : {
                required: "<?php echo $this->translate('Please choose expert (*)')?>"
            },
            "categories_experts" : {
                required: "<?php echo $this->translate('Please choose category (*)')?>"
            }
		},
		rules: {
			"title" : {
		      required: true,
		      maxlength: 160
		    },
            "description" : {
		      required: true,
		      maxlength: 10000
		    },
            "check_select_experts" : {
		      required: true
		    },
            "categories_experts" : {
		      required: true
		    }
        }
    });
    jQuery('.compose_category').bind('click', function(){
        var category_ids = jQuery("input[name='composecategory']:checked");
        var str_category = "";
        var cat_cnt = 1;
        var str_strcategory = "";

        jQuery.each(category_ids, function() {
          if(cat_cnt < category_ids.length) {
            str_category += jQuery(this).val()+",";
            str_strcategory += jQuery(this).attr("title") + ", ";
            cat_cnt ++;
          } else {
            str_category += jQuery(this).val();
            str_strcategory += jQuery(this).attr("title");
          }
        });
        jQuery("#categories_experts").attr("value",str_category);
        jQuery("#categories_experts").attr("title",str_strcategory);
    });
    //trigger_compose_experts
    jQuery('#compose_select_cats').click(function() {
        var url = "<?php echo $this->baseUrl().'/experts/ajax-request/get-experts-from-cats?cats='; ?>";
        var check_cat = jQuery("#categories_experts").attr("value");
        var str_check_cat = jQuery("#categories_experts").attr("title");

        if(check_cat == '') {
            jQuery("#compose_select_experts").html("");
            alert("<?php echo $this->translate('Please select category')?>"); return false;
		}
        url = url + check_cat;
        
        jQuery("#trigger_compose_title").html(str_check_cat);

        jQuery.ajax({
          url: url,
          cache: false,
          success: function(html){
            jQuery("#content_compose_title").slideToggle();
            jQuery("#content_compose_title").hide();
            jQuery("#compose_select_experts").html(html);
            jQuery("#check_select_expert").next().remove();
          }
        });
    });
    
    jQuery('#trigger_compose_title').bind('click', function(){
        jQuery(this).siblings('#content_compose_title').slideDown();
    });
 });
</script>

<?php $categories = $this->categories1; $title = $desc = "" ; 
if(isset($this->title)) $title = $this->title; 
if(isset($this->description)) $desc = $this->description;

?>

<div id="wd-content-container">
<div class="wd-center">
	<div class="wd-content-left">
		<?php echo $this->content()->renderWidget('experts.categories'); ?>
	</div>
	<div class="wd-content-content-sprite pt-fix">
		<div class="wd-content-event">
			<div class="pt-content-event">
				<div class="pt-reply-how">
					<div class="pt-reply-left">
						<div class="pt-event-tabs">
							<div class="pt-to-send-left">
								<ul class="pt-menu-event pt-menu-libraries">
									<li class="active">
										<a href="#">Hỏi đáp</a>
									</li>
									<li>
										<a href="#">Gửi câu hỏi</a>
									</li>
								</ul>
								<div class="pt-to-send-content">
									<h3 class="pt-title-right">Gửi câu hỏi</h3>
									<div class="pt-content-sigup-02">
										<div class="pt-signin">
											<div class="login-checkout">
												<form name="upload" method="post" action="<?php echo $this->baseUrl().'/experts/my-questions/compose'; ?>"  enctype="multipart/form-data" id="questions_create">
													<fieldset>
														<ul>
															
															<li>
																<div class="input" id="input_compose_title">
																	<label><?php echo $this->translate('Choose category') ?>:</label>
																	<div style="" class="select_sort">
																		<div class="panel" id="panel_compose_title">
																			<div class="trigger" id="trigger_compose_title"><?php echo $this->translate('All category'); ?></div>
																			<div class="content" id="content_compose_title">
																			    <?php if(count($categories)): ?>
																				<input style="margin-bottom: 10px;" type="button" id="compose_select_cats" class="bt_send_question" value="<?php echo $this->translate('Chọn') ?>">
																				<?php foreach( $categories as $item ): ?>
																						<div class="s-input">
																							<input type="checkbox" class="compose_category" name="composecategory" value="<?php echo $item->category_id;?>" title="<?php echo $item->category_name; ?>"/>
																							<label><?php echo $item->category_name; ?></label>
																						</div>
																					<?php endforeach; ?>
																			    <?php endif; ?>
																		    
																			</div>
																		</div>
																	</div>
																	<div class="clear"></div>
																	<input style="width: 10px; float: left;" type="hidden" id="categories_experts" name="categories_experts" value="" />
																    </div>
																<div id="hidden_load_div" style="display:none"></div>
															</li>
															<li>
																<label>Chi tiết câu hỏi</label>
																<input  class="input-text" type="text" id="title" name="title" value="<?php echo $title; ?>" />
															</li>
															<li>
																<label>Nội dung</label>
																<div class="wd-adap-select wd-adap-select-01 pt-textarea">
																	<textarea style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 100px;" rows="" cols="" id="description"  name="description"><?php echo $desc ?></textarea>
																</div>
															</li>
															<li>
																
																<label>File minh họa</label>
        															<input type="file" id="file" name="file"/>
																
															</li>
															<li>
																<?php echo $this->translate("(files: txt,png,jpg,gif,doc,docx,rar Maxsize: 5Mb)") ?>
															</li>
															<li class="last">
																<button type="submit" title="" class="button">Đăng câu hỏi</button>
																<button type="submit" title="" class="button">Hủy</button>
															</li>
														</ul>
													</fieldset>
												</form>
											</div>
										</div>
									</div>
								</div>
							</div>
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