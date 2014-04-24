<style type="text/css">

.check_list p.resume_info, .check_list p.resume_education, .check_list p.resume_work, .checked_resume{
    background-image: url(<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/check_suc.png'?>);
    background-repeat: no-repeat;
    background-position: 84% 50%;
    
}
.check_list p.resume_skill{
    background-color:#E4F3FB;
    font-weight:bold;
}
.check_list p.resume_skill span {
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
    $form_other= $this->form_other;
    $languages= $this->languages;
    $group_skills= $this->group_skill;
    $references= $this->references;
?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Create resume");?></strong>
    </div>
</div>
<div id="content">
<div class="section recruiter">

<div class="layout_right">
<?php echo $this->content()->renderWidget('resumes.check-list');?>
</div>
<div class="layout_middle" style="width:72%; background: none repeat scroll 0 0 #FFFFFF;">
<div class="resume_info_main subsection" style="border: medium none; margin-bottom: 35px;">
    <h2><?php echo $this->translate('Skill')?></h2>
    <div id="resume_loading" style="display: none;">
      <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
      <?php echo $this->translate("Loading ...") ?>
    </div>
    <div class="pt-signin pt-from-01 pt-from-02">
   <form style="display:none" id="resume_skill_form" action="<?php echo $form->getAction();?>" method="post" enctype="application/x-www-form-urlencoded">
     <fieldset class="job-form job-form-step-2">
		<div class="input">
            <?php echo $form->language_id;?>
        </div>
		<div class="input">
            <?php echo $form->group_skill_id;?>
        </div>
        <div class="submit">
            <input id="save" type="button" value="<?php echo $this->translate('Add');?>" class="min submit_save" onclick="saveResumeLanguage('save');" />
        </div>
    </fieldset>
    <div id="list_skill_temp">
    </div>
    </form>
    
    <input type="hidden" value="<?php echo $resume_id ?>" id="resume_id_skill" />
    <!-- other skill-->
    <form id="resume_other_skill_form" action="<?php echo $form_other->getAction();?>" method="post" enctype="application/x-www-form-urlencoded">
    <div class="pt-title-from-02">
			<strong>Mô tả chi tiết:</strong>
			<ol>
				<li>Liệt kê những kỹ năng chuyên môn mà bạn có.</li>
				<li>Liệt kê những kỹ năng khác mà bạn có...</li>
			</ol>
		</div>
	<div style="background-color: rgb(248, 248, 248); border: 1px solid rgb(216, 216, 216); margin-left: 100px; width: 77%; padding: 10px 15px 11px 27px;">
    <fieldset class="job-form job-form-step-2">
    <h4 style="text-align: center; margin-top: -10px; margin-bottom: 10px;">Liệt kê những kỹ mà bạn có</h4>
		<div class="input">
            <?php echo $form_other->name;?>
        </div>
		<div class="input">
            <?php echo $form_other->description;?>
        </div>
        <div class="submit">
            <input type="hidden" id="save_skill_temp" />
           <!--<input id="save_skill" type="button" value="<?php echo $this->translate('Add');?>" class="min submit_save" onclick="saveResumeSkill('save');" />-->
        </div>
    </fieldset>
    <div id="list_skill_other_temp">
    </div>
    <div class="button_control">
		<!--<a class="edit" id="cancel" onclick="back_resume_education();"><?php echo $this->translate("Back");?></a>-->
		<input id="save_skill" type="button" value="<?php echo $this->translate('Save');?>" class="save" onclick="saveResumeSkill('save');" />
		<a style="color:#fff"  id="submit" onclick="saveResumeLanguage('next');"><?php echo $this->translate("Next");?></a>
	</div>"
	</div>
    </form>
    </div>
</div>
</div>
</div>
</div>
<script type="text/javascript">

function saveResumeLanguage(type){
    //alert(type);
    var resume_id= jQuery('#resume_id_skill').val();
    
    
    var language_id= $('language_id').value;
    
    if(language_id==0){
        language_id= false; 
        
    }
    else{
        language_id=true;
    }
    
    var group_skill_id= $('group_skill_id').value;
    if(group_skill_id==0){
        group_skill_id= false; 
        
    }
    else{
        group_skill_id=true;
    }     
    if(type=='next'){
            
        if(language_id== false && group_skill_id==false){
            var url_next="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/index/resume_id/' ?>"+ resume_id;
            window.location.href= url_next;
        }
        return false;
    }
    if(language_id==false){
        if(jQuery('#language_id-element').children().size()<2){
           
            jQuery('#language_id-element').append('<label class="error" for="language_id" generated="true"><?php echo $this->translate("Please select a language proficiency.");?></label>');   
        }
        else{
            jQuery('#language_id-element label').attr('style', 'display:block');
        }
    }  
    if(group_skill_id==false){
        if(jQuery('#group_skill_id-element').children().size()<2){
            jQuery('#group_skill_id-element').append('<label class="error" for="group_skill_id" generated="true"><?php echo $this->translate("Please select a language level.");?></label>');   
        }
        else{
            jQuery('#group_skill_id-element label').attr('style', 'display:block');
        }
    }
    
    var valid= language_id && group_skill_id;
    
    if(valid){
        $('resume_loading').style.display="block";
        var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/index' ?>";
        new Request({
        url: url,
        method: "post",
        data : {
            'type': type,
    		'resume_id': resume_id,
    		'language_id': $('language_id').value,
            'group_skill_id': jQuery('#group_skill_id').val()
    	},
        onSuccess : function(responseHTML)
        {
            // inform error date
            //alert(responseHTML);
            
            if(responseHTML==1){
                $('resume_loading').style.display="none";
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/list-skill' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    
                    //alert(responseHTML);
                    $('resume_skill_list').set('html', responseHTML);
                    
                    $('resume_skill_form').reset();
                }
            }).send();
                
            }
        	else if(responseHTML==2){
        	   var url_next="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/index/resume_id/' ?>"+ resume_id;
               window.location.href= url_next;
     	   }
        }
    }).send();
    }
    
    
}
function back_resume_education(){
    
    var resume_id_back= jQuery('#resume_id_skill').val();
    
    var url="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/education/index/resume_id/'?>"+ resume_id_back;
    window.location.href= url;
}
function edit_skill(skill_id){
    document.documentElement.scrollTop = 200;
    //alert(education_id);
    //load data into form
    var language_id= $('language_pro_'+skill_id).value;
    
    var group_level_id= $('group_pro_'+skill_id).value;
    
    //populate data
    //alert(school_name);
    jQuery('#language_id option').each(function(){
        
        if(language_id==jQuery(this).attr('label')){
            jQuery(this).attr('selected', 'selected');
        }
    });
    jQuery('#group_skill_id option').each(function(){
        
        if(group_level_id==jQuery(this).attr('label')){
            jQuery(this).attr('selected', 'selected');
        }
    });
    //change action at button save and submit
    $('save').destroy();
    var save_new= new Element('input', {'id': "save", 'onclick': "javascript:edit_skill_lang('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Save');?>"});
    save_new.inject('skill_id', 'before');
    //fix ie
    save_new.onclick= function(){javascript:edit_skill_lang('save');return false;};
    $('submit').destroy();
    var submit_new= new Element('a', {'id': "submit", 'onclick': "javascript:edit_skill_lang('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next');?>"});
    submit_new.inject('cancel', 'after');
    //fix ie
    submit_new.onclick= function(){javascript:edit_skill_lang('next');return false;};
    jQuery('#submit').attr('style', 'margin-left: 3px;');
    
    $('skill_id').set('value', skill_id);
}
function edit_skill_lang(type){
    var skill_id= $('skill_id').value;
    //alert(type);
    var resume_id= jQuery('#resume_id_skill').val();
    var language_id= $('language_id').value;
    
    if(language_id==0){
        language_id= false; 
        
    }
    else{
        language_id=true;
    }
    if(language_id==false){
        if(jQuery('#language_id-element').children().size()<2){
           
            jQuery('#language_id-element').append('<label class="error" for="language_id" generated="true"><?php echo $this->translate("Please select a language proficiency.");?></label>');   
        }
    }
    var group_skill_id= $('group_skill_id').value;
    if(group_skill_id==0){
        group_skill_id= false; 
        
    }
    else{
        group_skill_id=true;
    }         
      
    if(group_skill_id==false){
        if(jQuery('#group_skill_id-element').children().size()<2){
            jQuery('#group_skill_id-element').append('<label class="error" for="group_skill_id" generated="true"><?php echo $this->translate("Please select a language level.");?></label>');   
        }
    }
    
    var valid= language_id && group_skill_id;
    
    if(valid){
        $('save').destroy();
        var save_new= new Element('input', {'id': "save", 'onclick': "javascript:saveResumeLanguage('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add');?>"});
        save_new.inject('skill_id', 'before');
        //fix ie
        save_new.onclick= function(){javascript:saveResumeLanguage('save');return false;};
        $('submit').destroy();
        var submit_new= new Element('a', {'id': "submit", 'onclick': "javascript:saveResumeLanguage('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next');?>"});
        submit_new.inject('cancel', 'after');
        //fix ie
        submit_new.onclick= function(){javascript:saveResumeLanguage('next');return false;};
        jQuery('#submit').attr('style', 'margin-left: 3px;');
        $('resume_loading').style.display="block";
        var url= "<?php echo $this->baseUrl().'/resumes/skill/skill-edit' ?>";
        new Request({
        url: url,
        method: "post",
        data : {
            'skill_id': skill_id,
            'type': type,
    		'resume_id': resume_id,
    		'language_id': $('language_id').value,
            'group_skill_id': jQuery('#group_skill_id').val()
    	},
        onSuccess : function(responseHTML)
        {
            // inform error date
            //alert(responseHTML);
            $('resume_loading').style.display="none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().'/resumes/skill/list-skill' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    //alert(responseHTML);
                    $('resume_skill_list').set('html', responseHTML);
                    
                    $('resume_skill_form').reset();
                    //$('save').set('onclick', "javascript:saveResumeLanguage('save');");
                    //$('submit').set('onclick', "javascript:saveResumeLanguage('next');");
                }
            }).send();
                
            }
        	else if(responseHTML==2){
        	   var url_next="<?php echo $this->baseUrl().'/resumes/reference/index/resume_id/' ?>"+ resume_id;
               window.location.href= url_next;
     	   }
        }
    }).send();
    }
}
function delete_skill(skill_id){
    
    var url="<?php echo $this->baseUrl().'/resumes/skill/delete-skill'?>";
    //alert(url);
    var resume_id= jQuery('#resume_id_skill').val();
   
    if(confirm("<?php echo $this->translate('Do you really want to delete this language?');?>")){
        $('resume_loading').style.display="block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'skill_id': skill_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            $('resume_skill_form').reset();
            $('save').destroy();
            var save_new= new Element('input', {'id': "save", 'onclick': "javascript:saveResumeLanguage('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add');?>"});
            save_new.inject('skill_id', 'before');
            //fix ie
            save_new.onclick= function(){javascript:saveResumeLanguage('save');return false;};
            $('submit').destroy();
            var submit_new= new Element('a', {'id': "submit", 'onclick': "javascript:saveResumeLanguage('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next');?>"});
            submit_new.inject('cancel', 'after');
            //fix ie
            submit_new.onclick= function(){javascript:saveResumeLanguage('next');return false;};
            jQuery('#submit').attr('style', 'margin-left: 3px;');
            $('resume_loading').style.display="none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().'/resumes/skill/list-skill' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    $('resume_skill_list').set('html', responseHTML);
                }
                }).send();
            }
            else{
                alert("Can't delete this language");
            }
            
        }
    }).send();
	}	
    

}
//other skill

function saveResumeSkill(type){
    var content = tinyMCE.activeEditor.getContent(); // get the content
    jQuery('#description').val(content);
    var resume_id= jQuery('#resume_id_skill').val();
    
    
    var name_skill= checkValid('#name_skill', 160);
    //alert(name_skill);
    
    if(name_skill==false){
        if(jQuery('#name-element').children().size()<2){
           
            jQuery('#name-element').append('<label class="error" for="name_skill" generated="true"><?php echo $this->translate("Skill is not empty.");?></label>');   
        }
        else{
            jQuery('#name-element label').css('display', 'block');
        }
    }
    
    var valid= name_skill;
    
    if(valid){
        $('resume_loading').style.display="block";
        var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/resume-skill' ?>";
        new Request({
        url: url,
        method: "post",
        data : {
            'type': type,
    		'resume_id': resume_id,
    		'name_skill': jQuery('#name_skill').val(),
            
            'description': jQuery('#description').val()
            
    	},
        onSuccess : function(responseHTML)
        {
            // inform error date
            //alert(responseHTML);
            $('resume_loading').style.display="none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/list-skill-other' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    //alert(responseHTML);
                    $('resume_skill_other_list').set('html', responseHTML);
                    
                    $('resume_other_skill_form').reset();
                }
            }).send();
                
            }
        	
        }
    }).send();
    }

    
}
function edit_skill_other(skill_id){
     document.documentElement.scrollTop = 200;
    //load data into form
    var name_skill= $('name_skill_other_'+skill_id).value;
    
    var description_skill= $('description_skill_other_'+skill_id).get('html');
    
    //populate data
    //alert(school_name);
    $('name_skill').set('value', name_skill);
    jQuery('#description').html(description_skill);
    tinyMCE.activeEditor.setContent(description_skill);
    $('save_skill').destroy();
    var save_new= new Element('input', {'id': "save_skill", 'onclick': "javascript:save_skill_other('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save_skill", 'value': "<?php echo $this->translate('Save');?>"});
    save_new.inject('save_skill_temp', 'before');
    //fix ie
    save_new.onclick= function(){javascript:save_skill_other('save');return false;};
    $('skill_id').set('value', skill_id);
}
function save_skill_other(type){
    var content = tinyMCE.activeEditor.getContent(); // get the content
    jQuery('#description').val(content);
    var resume_id= jQuery('#resume_id_skill').val();
    
    
    var name_skill= checkValid('#name_skill', 160);
    //alert(name_skill);
    
    if(name_skill==false){
        if(jQuery('#name-element').children().size()<2){
           
            jQuery('#name-element').append('<label class="error" for="name_skill" generated="true"><?php echo $this->translate("Skill is not empty.");?></label>');   
        }
        else{
            jQuery('#name-element label').css('display', 'block');
        }
    }
    var skill_id= $('skill_id').value;
    var valid= name_skill;
    
    if(valid){
        $('save_skill').destroy();
        var save_new= new Element('input', {'id': "save_skill", 'onclick': "javascript:saveResumeSkill('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save_skill", 'value': "<?php echo $this->translate('Add');?>"});
        save_new.inject('save_skill_temp', 'before');
        //fix ie
        save_new.onclick= function(){javascript:saveResumeSkill('save');return false;};
        $('resume_loading').style.display="block";
        var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/resume-save-skill-other' ?>";
        new Request({
        url: url,
        method: "post",
        data : {
            'skill_id': skill_id,
            'type': type,
    		'resume_id': resume_id,
    		'name_skill': jQuery('#name_skill').val(),
            
            'description': jQuery('#description').val()
            
    	},
        onSuccess : function(responseHTML)
        {
            // inform error date
            //alert(responseHTML);
            
            
            $('resume_loading').style.display="none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/list-skill-other' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    //alert(responseHTML);
                    $('resume_skill_other_list').set('html', responseHTML);
                    
                    $('resume_other_skill_form').reset();
                    jQuery('#description').html('');
                    
                    
                }
            }).send();
                
            }
        	
        }
    }).send();
    }
}
function delete_skill_other(skill_other_id){
    var url="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/delete-skill-other'?>";
    //alert(url);
    var resume_id= jQuery('#resume_id_skill').val();
   
    if(confirm("<?php echo $this->translate('Do you really want to delete this skill?');?>")){
        $('resume_loading').style.display="block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'skill_other_id': skill_other_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            $('resume_loading').style.display="none";
            $('resume_other_skill_form').reset();
            $('save_skill').destroy();
            var save_new= new Element('input', {'id': "save_skill", 'onclick': "javascript:saveResumeSkill('save');return false;", 'type':"button", 'class':"min submit_save", 'name': "save_skill", 'value': "<?php echo $this->translate('Add');?>"});
            save_new.inject('save_skill_temp', 'before');
            //fix ie
            save_new.onclick= function(){javascript:saveResumeSkill('save');return false;};
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/list-skill-other' ?>";
                new Request({
                url: url,
                method: "post",
                data : {
                		'resume_id': resume_id
                		
               	},
                onSuccess : function(responseHTML)
                {
                    $('resume_skill_other_list').set('html', responseHTML);
                }
                }).send();
            }
            else{
                alert("Can't delete this skill");
            }
            
        }
    }).send();
	}	
}
window.addEvent('domready', function(){
   var resume_skill_list  = new Element('div', {id: 'resume_skill_list'});
   resume_skill_list.inject($('list_skill_temp'), 'after');
   var resume_skill_other_list  = new Element('div', {id: 'resume_skill_other_list'});
   resume_skill_other_list.inject($('list_skill_other_temp'), 'after');
   var skill_id = new Element('input', {id: 'skill_id', type: 'hidden'});
   skill_id.inject('save', 'after');
   
   var resume_id_init= jQuery('#resume_id_skill').val();
   
   var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/list-skill' ?>";
   new Request({
        url: url,
        method: "post",
        data : {
        		'resume_id': resume_id_init
        		
       	},
        onSuccess : function(responseHTML)
        {
            //alert(responseHTML);
            $('resume_skill_list').set('html', responseHTML);
            //check if edit
           var count_childrent= jQuery('#resume_skill_list table tbody').children().size();
           
           if(count_childrent > 1){
                jQuery('#resume_skill_edit').addClass('resume_skill_edit');
           }
        }
    }).send();
    var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/list-skill-other' ?>";
    new Request({
        url: url,
        method: "post",
        data : {
        		'resume_id': resume_id_init
        		
       	},
        onSuccess : function(responseHTML)
        {
            //alert(responseHTML);
            $('resume_skill_other_list').set('html', responseHTML);
            var count_childrent= jQuery('#resume_skill_list table tbody').children().size();
            var count_skill_other= jQuery('#resume_skill_other_list table tbody').children().size();
            
            if(count_childrent <1){
                if(count_skill_other >1){
                    jQuery('#resume_skill_edit').addClass('resume_skill_edit');
                }
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
    jQuery('#resume_skill_form').validate({
		messages : {
            "language_id" : {
			     required: "<?php echo $this->translate('Language proficiency is not empty')?>",
                 min: "<?php echo $this->translate('Please select a language proficiency.')?>"
             },
			"group_skill_id" : {
			     required: "<?php echo $this->translate('Language level is not empty')?>",
                 min: "<?php echo $this->translate('Please select a language level.')?>"
             }
		},
		rules: {
            "language_id" : {
		      required: true,
		      min: 1
		    },
			"group_skill_id" : {
		      required: true,
		      min: 1
		    }
        }
    }); 
    jQuery('#resume_other_skill_form').validate({
		messages : {
            "name_skill" : {
			     required: "<?php echo $this->translate('Skill is not empty.')?>",
                 maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
             }
			
		},
		rules: {
            "name_skill" : {
		      required: true,
		      maxlength: 160
		    }
        }
    }); 
});
</script>