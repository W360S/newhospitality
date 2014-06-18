<style style="text/css">
    div, td {
        color:#555555;
        font-size: 12px !important;
    }
    .subsection {
        -moz-border-radius:3px 3px 3px 3px;
        background-color:#E9F4FA;
        border:1px solid #D0E2EC;
        margin-bottom:10px;
        margin-top: 0px !important;
    }
    #input_compose_title{
        float: left;
        width: 100%;
        margin-bottom:14px;
        overflow:visible;
    }
    #content_compose_title .s-input label, #content_compose_experts .s-input label{
        padding-right:2px;
        padding-top: 2px;
        text-align:left;
    }
    .panel #content_compose_title, .panel #content_compose_experts{
        width: 364px;
        height: auto !important;
    }

    #content_compose_title div.s-input{
        width: 360px;
    }    

    #content_compose_title div.s-input label{
        width: 340px;
    }

    .panel #trigger_compose_title, .panel #trigger_compose_experts{
        width: 374px;
    }
    #panel_compose_title{
        z-index: 90;
    }
    
    #panel_compose_experts{
        z-index: 89;
    }
    
    .container_compose fieldset div.input {
        margin-bottom:14px;
        overflow:visible;
    }
    
    .input #compose_select_cats {
        border:medium none;
        color:#414141;
        font-weight:bold;
        height:27px;
        line-height:19px;
        margin-right:6px;
        text-transform:capitalize;
        width:65px;
    }
    .input #compose_select_cats:hover {
        background-position: 0 -27px;
        color: #FFFFFF;
        cursor: pointer;
    }
    .error{
        color: red;
    }
    label.error{
       width: 10px !important;
       float: none !important;
       padding-left: 115px;
    }
    
    .defaultSkin table.mceLayout {
       margin-left: 115px !important;  
    }
    .container_compose fieldset div.input label {
       text-align: right;
    }
    
    
    <!--[if IE 7]>
    div.div_title label.error {
        padding-left: 19px !important;
        width: 100% !important;
    }
    .subcontent .filter .input{margin-right: 1px !important;}
    <![endif]-->
</style>
<!--[if IE 7]>
	<style>
    .container_compose fieldset div.input input{padding-top:0px;}
    
	</style>
	<![endif]-->
    <!--[if IE 8]>
	<style>
    .container_compose fieldset div.input input{padding-top:0px;}
	</style>
	<![endif]-->
<!--<script type="text/javascript" src="<?php echo $this->baseUrl('/').'externals/tinymce/tiny_mce.js' ?>"></script>

<script type="text/javascript"> 

    tinyMCE.init({ 
        theme : "advanced",
        mode : "textareas", 
        elements  : "description",
        
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
-->

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
    var valid_extensions = /(.txt|.png|.jpg|.jpeg|.gif|.doc|.docx|.rar)$/i;
    //txt,png,pneg,jpg,jpeg,gif,doc,docx,rar Maxsize: 5Mb
    
    function CheckExtension(fld)
    {
        
        if (valid_extensions.test(fld.value)){
            var node = document.getElementById('file');
            var max_size= '5000000';
            var check = node.files[0].fileSize;
            
            if (check > max_size)
            {
                alert("<?php echo $this->translate('Your file is too big!')?>");
                return false;
            }else{
                return true;
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
    
 window.addEvent('domready',function(){
  
    jQuery('#submit_compose').click(function() {
        //var content = tinyMCE.activeEditor.getContent(); // get the content
        //jQuery('#description').val(content); // put it in the textarea
         
    });
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
    var options = { 
            dataType    :  'json',   
            success     : showResponse,
            type        : 'post'
    };     
    jQuery('#questions_create').ajaxForm(options); 

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
    <div class="section">
        <div class="layout_right">
            <?php
                   echo $this->content()->renderWidget('experts.my-accounts'); 
            ?>
            <div class="subsection">
                <?php echo $this->content()->renderWidget('experts.featured-experts'); ?>
        	</div>
            <div class="subsection">
                <?php echo $this->content()->renderWidget('group.ad'); ?>
            </div>
        </div>
        <div class="layout_middle">
            <div class="headline">
        		<div class="breadcrumb_expert">
        			<h2><a class="first" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'index'),'default',true); ?>"><?php echo $this->translate('Experts'); ?></a> <a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-questions','action'=>'index'),'default',true); ?>"><?php echo $this->translate('My Question'); ?></a><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-questions','action'=>'compose'),'default',true); ?>"><?php echo $this->translate('post a question'); ?></a></h2>
        		</div>
        		<div class="clear"></div>
            </div>
        	<div class="layout_left layout_left_expert">
            <!--
        		<div class="subsection">
        			<div class="bt_function_question">
        				<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-questions','action'=>'compose'),'default',true); ?>" class="create"><?php echo $this->translate('Post a Question') ?></a>
        			</div>
        		</div>
          -->
        		<div class="subsection">
        			<?php echo $this->content()->renderWidget('experts.my-questions'); ?>
        		</div>
        	</div>
        	<div class="layout_middle_question">
        		<div class="search_my_question">
        			<?php echo $this->content()->renderWidget('experts.search'); ?>
        		</div>	
        		<div class="subsection">
        			<div class="container_compose">
        				<h3 class="title_port_question"><?php echo $this->translate('Post a Question') ?></h3>
                        <form name="upload" method="post" action="<?php echo $this->baseUrl().'/experts/my-questions/compose'; ?>"  enctype="multipart/form-data" id="questions_create">
        				<fieldset>
                            <div class="input" id="input_compose_title">
                            	<label><?php echo $this->translate('Choose category') ?>:</label>
                            	<div style="" class="select_sort">
                            		<div class="panel" id="panel_compose_title">
                            			<div class="trigger" id="trigger_compose_title"><?php echo $this->translate('All category'); ?></div>
                            			<div class="content" id="content_compose_title">
                            				<?php if(count($categories)): ?>
                                                <input style="margin-bottom: 10px;" type="button" id="compose_select_cats" class="bt_send_question" value="<?php echo $this->translate('Apply') ?>">
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
                            <div class="clear"></div>
                            
        					<div class="input" >
                                <label><?php echo $this->translate('Choose experts') ?>:</label>
                                <div style="" id="compose_select_experts">
            						<select name="compose_select_experts" >
                                        <option><?php echo $this->translate('Choose experts'); ?></option>
                                    </select>
                                </div>
                                <div class="clear"></div>
                                <input style="width: 10px;" type="hidden" id="check_select_experts" name="check_select_experts" cnt="" value="" />
        					</div>
                            <div class="clear"></div>
                            <br />
                            
        					<div class="input div_title">
        						<label><?php echo $this->translate('Tell us your issue'); ?>:</label>
                                <input style="float: left;" type="text" id="title" name="title" value="<?php echo $title; ?>" />
                                <div class="clear"></div>
        					</div>
                            <br />
                            
        					<div class="input div_description">
        						<label><?php echo $this->translate('Issue Description'); ?>:</label>
                                <textarea style="" rows="" cols="" id="description"  name="description"><?php echo $desc ?></textarea>
                                <div class="clear"></div>
        					</div>
                            <div class="clear"></div>
                            <br />
                            
        					<div class="input container_upload">
        						<p class="title_upload"><?php echo $this->translate("Upload Attachment(Support: txt,png,pneg,jpg,jpeg,gif,doc,docx,rar Maxsize: 5Mb)") ?></p>
        						<input type="file" id="file" name="file"/>
        					</div>
                            
        					<div class="submit">
        						<input type="submit" value="create" class="bt_send_question" id="submit_compose" />
        						<input type="reset" value="cancel" class="bt_send_question" />
        					</div>
        				</fieldset>
                        </form>
        			</div>
        		</div>
        	</div>
        	<div class="clear"></div>
        </div>
    
    <div class="clear"></div>
    
    </div>
<div id="hidden_load_div" style="display:none"></div>