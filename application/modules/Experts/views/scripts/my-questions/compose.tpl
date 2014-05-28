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
			     required: "<?php echo $this->translate('Question is not empty (*)')?>",
                 maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
             },
            "description" : {
                required: "<?php echo $this->translate('Content is not empty (*)')?>"
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
		    }
        }
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
																<label><?php echo $this->translate('Choose category') ?>:</label>
																<div class="select_sort">
																	<select name="expert_category" id="expert_category">
																		<?php foreach($categories as $item): ?>
																		<option value="<?php echo $item->category_id; ?>"><?php echo $item->category_name; ?></option>
																		<?php endforeach; ?>
																	</select>
																</div>
																
															</li>
															<li>
																<label>Tiêu đề câu hỏi</label>
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
															<li style="padding-left:130px;">
																<?php echo $this->translate("(files: txt,png,jpg,gif,doc,docx,rar Maxsize: 5Mb)") ?>
															</li>
															<li class="last">
																<button type="submit" title="" class="button">Đăng câu hỏi</button>
																<button style="margin-left: 10px;" type="cancel" title="" class="button">Hủy</button>
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