<style type="text/css">

.check_list p.resume_info, .check_list p.resume_work, .check_list p.resume_education, .checked_resume{
    background-image: url(<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/check_suc.png'?>);
    background-repeat: no-repeat;
    background-position: 84% 50%;
    
}
.check_list p.resume_reference{
    background-color:#E4F3FB;
    font-weight:bold;
}
.check_list p.resume_reference span {
    background-position:0 -18px;
    color:#FFFFFF;
}

#error_date{
    color: red;
    clear: left;
    padding-left: 159px;
}

#breadcrumb{
	padding-top:20px;
}
#breadcrumb a:link, #breadcrumb a:visited{
	 color: #A4A9AE;
}
#breadcrumb a, #breadcrumb span, #breadcrumb strong{
	color: #008ECD;
	 font-weight: normal;
}
#breadcrumb span{
	background:url("../img/front/icon-menu-top.png") no-repeat scroll right 5px rgba(0, 0, 0, 0);
}
#breadcrumb span{
	width:9px;
	padding-left:9px;
	margin-right:9px;
}
.layout_middle .subsection {
    background-color: #FFFFFF;
    overflow: hidden;
    padding-left: 10px;
    padding-right: 10px;
}

.layout_middle .subsection h2 {
   
    border-bottom: 1px solid #E5E5E5;
    color: #262626;
    font-weight: lighter;
    height: 33px;
    line-height: 35px;
   padding-left:0px;
    background: none repeat scroll 0 0 #FFFFFF;
    padding-bottom: 5px;
    padding-top: 5px;
}
.recruiter .subsection{
	background:#fff;
}
.resume_info_main .job-form-step-1 label{
	width:215px;
	color: #777F82;
}
.pt-title-from-02 {
    margin: 30px 100px;
    overflow: hidden;
}
.pt-title-from-02 ol {
    list-style: initial;
    margin-left: 16px;
}
.button_control{
	padding:0 179px 30px;	
}

.button_control a{
	background:none repeat scroll 0 0 #50C1E9;
	font-size:12px;
	border-radius: 3px;
}
.job-form .input label{
	color: #777F82;
	 font-weight: bold;
}
.job-form .resume_date label{
	color: #777F82;
	 font-weight: bold;
}
.job-form .resume_date select{
	margin-right:0px;
}
.button_control a:hover{
	background:#2F95B9;
}
.save{
	  background: none repeat scroll 0 0 #50C1E9;
    border: 0 none;
    border-radius: 3px;
    color: #FFFFFF;
    float: left;
    margin-right: 10px;
    padding: 9px 15px;
     cursor: pointer;
}
.save:hover{
	background:#2F95B9;
	 cursor: pointer;
}
</style>
<script src="<?php echo $this->baseUrl().'/externals/viethosp/jquery_check_form.js'?>" type="text/javascript"></script>
<?php
  $this->headScript()
    
    ->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce.js')
	//->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<script type="text/javascript"> 
    tinyMCE.init({ 
        theme : "simple",
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
<?php 
    $form= $this->form;
    $resume_id= $this->resume_id;
    $languages= $this->languages;
    $group_skills= $this->group_skill;
    $references= $this->references;
?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Create resume");?></strong>
    </div>
</div>
<div id="content">
<div class="section recruiter">

<div class="layout_right">
<?php echo $this->content()->renderWidget('resumes.check-list');?>
<div class="bt_preview_job">
	<a onclick="preview();"> <?php echo $this->translate("Preview");?> </a>
</div>
</div>
<div class="layout_middle" style="width:72%; background: none repeat scroll 0 0 #FFFFFF;">
<div class="resume_info_main subsection" style="border: medium none; margin-bottom: 35px;">
    <h2><?php echo $this->translate('Reference')?></h2>
    <div id="resume_loading" style="display: none;">
      <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
      <?php echo $this->translate("Loading ...") ?>
    </div>
    <div class="pt-signin pt-from-01 pt-from-02">
    <form id="resume_reference_form" action="<?php echo $form->getAction();?>" method="post" enctype="application/x-www-form-urlencoded">
    	<div class="pt-title-from-02">
			<strong>Mô tả chi tiết:</strong>
			<ol>
				<li>Những nhận xét từ đồng nghiệp/thầy cô/bạn bè sẽ giúp nhà tuyển dụng hiểu rõ hơn về tính cách và năng lực của bạn. Nên chọn người bạn nghĩ sẽ đưa ra nhận xét tốt.</li>
				<li>Các tham khảo khác...</li>
			</ol>
		</div>
		<div style="background-color: rgb(248, 248, 248); border: 1px solid rgb(216, 216, 216); margin-left: 100px; width: 77%; padding: 10px 15px 11px 27px;">
        <fieldset class="job-form job-form-step-2">
        <h4 style="text-align: center; margin-top: -10px; margin-bottom: 10px;">Bổ sung Thông Tin Tham Khảo</h4>
			<div class="input">
                <?php echo $form->name;?>
            </div>
			<div class="input">
                <?php echo $form->title;?>
            </div>
			<div class="input">
                <?php echo $form->phone;?>
            </div>
			<div class="input">
                <?php echo $form->email;?>
            </div>
			<div class="input">
                <?php echo $form->description;?>
            </div>
			<!--
			<div class="submit">
                <input id="save" type="button" value="<?php echo $this->translate('Add');?>" class="min submit_save" onclick="saveResumeReference('save');" />
            </div>-->
        </fieldset>
         <div id="list_reference_temp">
        </div>
        <div class="button_control">
			<!--<a class="edit" id="cancel" onclick="back_resume_skill();"><?php echo $this->translate("Back");?></a>-->
			<input id="save" type="button" value="<?php echo $this->translate('Save');?>" class="save" onclick="saveResumeReference('save');" />
			<a id="submit" onclick="preview();"><?php echo $this->translate("Preview");?></a>
		</div>
		</div>
    </form>
    </div>
    <input type="hidden" value="<?php echo $resume_id ?>" id="resume_id_reference" />
    
</div>
</div>
</div>
</div>
<script type="text/javascript">

function saveResumeReference(type){
    var content = tinyMCE.activeEditor.getContent(); // get the content
    jQuery('#description').val(content);
    var resume_id= jQuery('#resume_id_reference').val();
    var name_ref= checkValid('#name', 160);

    if(name_ref==false){
        if(jQuery('#name-element').children().size()<2){
            jQuery('#name-element').append('<label class="error" for="name" generated="true"><?php echo $this->translate("Name is not empty.");?></label>');   
        }
        else{
            jQuery('#name-element label').attr('style', 'display:block');
        }
    }
    
    var valid= name_ref;
    
    if(valid){
        $('resume_loading').style.display= "block";
        var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/index' ?>";
        new Request({
        url: url,
        method: "post",
        data : {
            'type': type,
    		'resume_id': resume_id,
    		'name': $('name').value,
            'title': $('title').value,
            'phone': $('phone').value,
            'email': $('email').value,
            'description': jQuery('#description').val()
    	},
        onSuccess : function(responseHTML)
        {
            // inform error date
            //alert(responseHTML);
            $('resume_loading').style.display= "none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/list-reference' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    //alert(responseHTML);
                    $('resume_reference_list').set('html', responseHTML);
                    
                    $('resume_reference_form').reset();
                }
            }).send();
                
            }
        
        }
    }).send();
    }
    
    
}
function preview(){
    var resume_id_back= jQuery('#resume_id_reference').val();
    var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/index/preview/resume_id/' ?>"+ resume_id_back;
    window.location.href= url;
}
function back_resume_skill(){
    
    var resume_id_back= jQuery('#resume_id_reference').val();
    
    var url="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/index/resume_id/'?>"+ resume_id_back;
    window.location.href= url;
}
function edit_reference(ref_id){
    document.documentElement.scrollTop = 200;
    //load data into form
    var name_ref= $('name_refer_'+ref_id).value;
    var title_ref= $('title_refer_'+ref_id).value;
    var phone_ref= $('phone_refer_'+ref_id).value;
    var email_ref= $('email_refer_'+ref_id).value;
    var des_ref= $('description_refer_'+ref_id).get('html');
    //alert(title_ref);
    //populate data
    $('name').set('value', name_ref);
    $('title').set('value', title_ref);
    $('phone').set('value', phone_ref);
    $('email').set('value', email_ref);
    jQuery('#description').html(des_ref);
    tinyMCE.activeEditor.setContent(des_ref);
    //change action at button save and submit
    $('save').destroy();
    var save_new= new Element('input', {'id': "save", 'onclick': "javascript:edit_ref('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Save');?>"});
    save_new.inject('refer_id', 'before');
    //fix ie
    save_new.onclick= function(){javascript:edit_ref('save');return false;};
    
    
    $('refer_id').set('value', ref_id);
}
function edit_ref(type){
    var content = tinyMCE.activeEditor.getContent(); // get the content
    jQuery('#description').val(content);
    var refer_id= $('refer_id').value;
    //alert(type);
    var resume_id= jQuery('#resume_id_reference').val();
    var name_ref= checkValid('#name', 160);
    if(name_ref==false){
        if(jQuery('#name-element').children().size()<2){
            jQuery('#name-element').append('<label class="error" for="name" generated="true"><?php echo $this->translate("Name is not empty.");?></label>');   
        }
    }
    
    var valid= name_ref;
    
    if(valid){
        $('save').destroy();
        var save_new= new Element('input', {'id': "save", 'onclick': "javascript:saveResumeReference('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add');?>"});
        save_new.inject('refer_id', 'before');
        //fix ie
        save_new.onclick= function(){javascript:saveResumeReference('save');return false;};
        $('resume_loading').style.display= "block";
        var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/resume-reference-edit' ?>";
        new Request({
        url: url,
        method: "post",
        data : {
            'ref_id': refer_id,
            'type': type,
    		'resume_id': resume_id,
    		'name': $('name').value,
            'title': $('title').value,
            'phone': $('phone').value,
            'email': $('email').value,
            'description': jQuery('#description').val()
    	},
        onSuccess : function(responseHTML)
        {
            // inform error date
            //alert(responseHTML);
            $('resume_loading').style.display= "none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/list-reference' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    //alert(responseHTML);
                    $('resume_reference_list').set('html', responseHTML);
                    
                    $('resume_reference_form').reset();
                    jQuery('#description').html('');
                }
            }).send();
                
            }
        
        }
    }).send();
    }
}
function delete_reference(refer_id){
    var url="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/delete-reference'?>";
    //alert(url);
    var resume_id= jQuery('#resume_id_reference').val();
   
    if(confirm("<?php echo $this->translate('Do you really want to delete this reference?');?>")){
        
        $('resume_loading').style.display= "block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'refer_id': refer_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            $('resume_reference_form').reset();
            $('save').destroy();
            var save_new= new Element('input', {'id': "save", 'onclick': "javascript:saveResumeReference('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add');?>"});
            save_new.inject('refer_id', 'before');
            //fix ie
            save_new.onclick= function(){javascript:saveResumeReference('save');return false;};
            $('resume_loading').style.display= "none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/list-reference' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    $('resume_reference_list').set('html', responseHTML);
                    jQuery('#description').html('');
                }
                }).send();
            }
            else{
                alert("Can't delete this reference");
            }
            
        }
    }).send();
	}	

}
window.addEvent('domready', function(){
   var resume_ref_list  = new Element('div', {id: 'resume_reference_list'});
   resume_ref_list.inject($('list_reference_temp'), 'after');
   
   var refer_id = new Element('input', {id: 'refer_id', type: 'hidden'});
   refer_id.inject('save', 'after');
   
   var resume_id_init= jQuery('#resume_id_reference').val();
   
   var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/list-reference' ?>";
   new Request({
        url: url,
        method: "post",
        data : {
        		'resume_id': resume_id_init
        		
       	},
        onSuccess : function(responseHTML)
        {
            //alert(responseHTML);
            $('resume_reference_list').set('html', responseHTML);
            //check if edit
           var count_childrent= jQuery('#resume_reference_list table tbody').children().size();
           
           if(count_childrent > 1){
                jQuery('#resume_reference_edit').addClass('resume_reference_edit');
           }
        }
    }).send();
    var language= <?php echo count($languages);?>;
    var group_skill= <?php echo count($group_skills);?>;
    
    if(language >0 || group_skill >0){
        jQuery('#resume_skill_edit').addClass('checked_resume');
    }
    var references= <?php echo count($references);?>;

    if(references> 0){
        jQuery('#resume_reference_edit').addClass('checked_resume');
    }
    jQuery('#resume_reference_form').validate({
		messages : {
            "name" : {
			     required: "<?php echo $this->translate('Name is not empty.')?>",
                 maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
             }, 
             "email":{
                email: "<?php echo $this->translate('Please enter a valid email address.')?>"
             }
		},
		rules: {
            "name" : {
		      required: true,
		      maxlength: 160
		    },
            "email":{
                email: true
            }
        }
    }); 
});
</script>