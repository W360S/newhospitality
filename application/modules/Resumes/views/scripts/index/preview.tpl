
<style type="text/css">

.check_list p.resume_info, .checked_resume{
    background-image: url(<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/check_suc.png'?>);
    background-repeat: no-repeat;
    background-position: 84% 50%;
    
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
.subsection{
	border:none;
}
.recruiter .subsection .subsection{
	margin-left:0px;
	margin-right:0px;
}
.pt-content-file-record {
    overflow: hidden;
    padding: 20px;
}
.pt-content-file-record .pt-title-file-record h3 {
    color: #30AEE9;
    float: left;
    font-size: 20px;
    margin-top: 6px;
}
.pt-content-file-record .pt-title-file-record h3 a {
    background: url("../img/front/icon-edit.png") no-repeat scroll 0 0 rgba(0, 0, 0, 0);
    display: inline-block;
    height: 12px;
    margin-left: 10px;
    width: 11px;
}
.pt-content-file-record .pt-title-file-record .pt-finger-prints {
    color: #3D7CBF;
    display: block;
    float: right;
    font-size: 13px;
    line-height: 32px;
}
.pt-content-file-record .pt-title-file-record .pt-finger-prints:hover {
    text-decoration: underline;
}
.pt-content-file-record .pt-title-file-record .pt-finger-prints img {
    float: left;
    height: 32px;
    margin-right: 10px;
    width: 28px;
}
.pt-title-file-record {
     float: left;
    margin-top: 20px;
    overflow: hidden;
    padding: 10px;
    width: 100%;
}
.information-profile img {
    float: left;
    margin-bottom: 10px;
    margin-right: 10px;
     width: 145px;
     height:150px;
}
.information-profile {
    background: none repeat scroll 0 0 #F6F6F6;
     padding: 30px 20px 50px;
     height: 160px;
     margin-top: 10px;
}
.pt-lv-01 .pt-edit {
    background: url("../img/front/icon-edit.png") no-repeat scroll 0 3px rgba(0, 0, 0, 0);
    color: #3D7CBF;
    font-size: 12px;
    padding-left: 15px;
    text-decoration: underline;
}
.pt-lv-01 .pt-edit:hover {
    text-decoration: none;
}
</style>

<?php
    $resume= $this->resume; 
    $works= $this->works;
    $total_year= $this->total_year;
    $educations= $this->educations;
    $languages= $this->languages;
    $group_skills= $this->group_skill;
    $references= $this->references;
    $user_id= $this->user_id;
    $user_resume= $this->user_resume;
    $user_inform= $this->user_inform;
    $gender= $this->gender;
    $birthday= $this->birthday;
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
<div class="resume_info_main subsection" style="border:none;padding-bottom:20px;">
    <div class="subsection">
    <h2><?php echo $this->translate('Resume Information')?></h2>
    <div class="pt-title-file-record">
		<h3 style="font-size:20px;color:#30AEE9;width:88%;float:left"><?php echo $this->translate($resume->title); ?><a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/index/resume-info-edit/resume_id/'.$resume->resume_id ?>" class="pt-edit"><img style="padding-left: 10px; padding-top: 4px;" src="img/front/icon-edit.png"> </a></h3>
		<a style="float:right; color: #3D7CBF;line-height:32px" target="_blank" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/pdf/resume_id/'.$resume->resume_id ?>" class="pt-finger-prints"><img style=" padding-right: 10px;" src="img/thumb/PDF.png" alt="Image"/>In ra PDF</a>
	</div>
   <!-- <ul>
        <li><label><?php echo $this->translate('Resume Title: ')?></label>
        <strong><?php echo $resume->title; ?></strong> 
        <?php if ($user_id==$user_resume){?>
        <a href="<?php echo $this->baseUrl().'/resumes/index/resume-info-edit/resume_id/'.$resume->resume_id ?>"><img src="../img/front/icon-edit.png"> <?php //echo $this->translate("[Edit]");?></a>
        <?php } ?>
        </li>
        <li><label><?php echo $this->translate('Privacy Status: ')?></label>
        <?php if($resume->enable_search==1){
            echo $this->translate("Searchable");
            } else {
                echo $this->translate("NonSearchable");
            }
        ?>
        </li>
        <li style="height: 23px;">
            <a class="preview_pdf" target="_blank" href="<?php echo $this->baseUrl().'/resumes/resume/pdf/resume_id/'.$resume->resume_id ?>"><?php echo $this->translate("Print to Pdf");?></a>
        </li>
    </ul>-->
    <div style="clear:both"></div>
    <div class="information-profile">
    <div class="imgage" style="float:left">
    <?php if(!empty($resume->path_image)):?>
        <img width="70" height="70" id="updateNewImage" class="thumb_profile item_photo_user  thumb_profile" alt="Profile Image" src="<?php echo $this->baseUrl()?>/public/profile_recruiter/<?php echo $resume->path_image?>">
        <!--<span style="padding-left: 10px;"><?php echo $this->translate("Good Size: 4x6(cm)")?></span>-->
        <?php else:?>
        <?php
            echo $this->itemPhoto($user_inform, 'thumb.profile', 'Profile Image', array('id'=>'updateNewImage'));
        ?>
        <!--<span style="padding-left: 10px;"><?php echo $this->translate("Good Size: 4x6(cm)")?></span>-->
        
    <?php endif;?>
    <div style="clear:both"></div>
    <?php if ($user_id==$user_resume):?>
    <form style="width:145px" method="post" id="updateImage"  enctype="multipart/form-data" action="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/image'; ?>">
   <!-- <input style="padding-left: 8px;" type="file" id="fileImage" name="fileImage" />
    <input type="hidden" name="fr_resume" value="<?php echo $resume->resume_id ?>" id="fr_resume" />
    <input type="submit" value="<?php echo $this->translate('Update Image')?>" style="cursor: pointer;" />
    
    
    <img id="ajaxImageLoading" src='<?php echo $this->baseUrl()?>/application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px; display:none;' />-->
    <p class="last"><a class="pt-edit" style="background: url('../img/front/icon-edit.png') no-repeat scroll 0px 3px transparent; padding-left: 21px; color: rgb(61, 124, 191); margin-left: 31px;" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/image'; ?>"><?php echo $this->translate("Edit");?></a></p>
    </form>
    <?php endif;?>
    </div>
    <ul>
        <?php if(!empty($resume->username)):?>
            <li><strong id="displayname"><?php echo $resume->username; ?></strong>
            <?php else: ?>
                <li><strong id="displayname"><?php echo $user_inform->displayname; ?></strong>
        <?php endif;?>
        
        <?php if ($user_id==$user_resume){?>
        <a style="padding-left:10px;color:#3D7CBF" href="javascript:void(0);" onclick="updateUsername('<?php echo $resume->resume_id ?>');"> <?php echo $this->translate("[Update]");?></a>
        <?php } ?>
        </li>
        <li><label><strong style="color:#656565; font-size: 13px;font-weight: normal;"><?php echo $this->translate("Gender")?>: </strong></label><?php echo $gender;?></li>
        <li><label><strong style="color:#656565; font-size: 13px;font-weight: normal;"><?php echo $this->translate("Birthday")?>:</strong></label> <?php //echo $birthday;?><?php echo date('d m Y', strtotime($birthday)); ?></li>
        <li><label>
            <strong style="color:#656565; font-size: 13px;font-weight: normal;"><?php echo $this->translate("Email") ?>:</strong></label>
            <?php if(!empty($resume->email)):?>
            <span id="email"> <?php echo $resume->email;?></span>
            <?php else:?>
            <span id="email"><?php echo $user_inform->email;?></span>
            <?php endif;?>
            <?php if ($user_id==$user_resume){?>
            <a style="padding-left:10px;color:#3D7CBF" href="javascript:void(0);" onclick="updateEmail('<?php echo $resume->resume_id ?>');"> <?php echo $this->translate("[Update]");?></a>
            <?php } ?>
        </li>
    </ul>
    
    </div>
    
    
    </div>
    <div class="subsection">
    <style>
    	.pt-content-file-block {
    border-bottom: 1px solid #ECECEC;
    overflow: hidden;
    padding: 40px 0;
}
.pt-lv-01 {
    float: left;
    min-height: 50px;
    width: 205px;
}
.pt-lv-01 p {
    margin-bottom: 10px;
    text-align: center;
}
.pt-lv-01 p.last {
    margin-bottom: 0;
}
.pt-lv-01 p img {
    height: 140px;
    width: 140px;
}
.pt-lv-01 .pt-edit {
    background: url("../img/front/icon-edit.png") no-repeat scroll 0 3px rgba(0, 0, 0, 0);
    color: #3D7CBF;
    font-size: 12px;
    padding-left: 15px;
    text-decoration: underline;
}
.pt-lv-02 {
    float: left;
    width: 533px;
}
    </style>
    <h2><?php echo $this->translate('Resume')?></h2>
    <div class="pt-content-file-block">
        <div class="pt-lv-01">
            <h3 style="color:#30AEE9;font-size:15px"><?php echo $this->translate("Work Experience");?></h3>
												<?php if ($user_id==$user_resume){?>
           <a class="pt-edit" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/index/resume-work/id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a>
                <?php }?>
		</div>
        <div class="pt-lv-02">
                    <?php 
                        foreach($works as $work){?>
                            	<h3><?php echo $work->title; ?></h3>
                                <p><?php echo $this->level($work->level_id)->name;?> - <?php echo $this->category($work->category_id)->name;?></p> 
                                <p><?php echo $work->company_name;?></p>
                                <p><?php echo $this->city($work->city_id)->name; ?> - <?php echo $this->country($work->country_id)->name;?></p>
                               <!-- <li>
                                    <label><u><?php echo $this->translate('Related Information')?></u>:</label>
                                    <?php echo $work->description;?>
                                </li>-->
                            	</br>
                            
                        <?php }
                    ?>
        </div>
    </div>
    <div class="pt-content-file-block">
        <div class="pt-lv-01">
            <h3 style="color:#30AEE9;font-size:15px"><?php echo $this->translate("Education");?></h3>
											<?php if ( count($works) && $user_id==$user_resume){?>
           <a class="pt-edit" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/education/index/resume_id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a>
                <?php }?>
		</div>
        <div class="pt-lv-02">
                    <?php 
                        foreach($educations as $education){?>
                            	<h3><?php echo $this->degree($education->degree_level_id)->name;?></h3>
                                <p><?php echo $education->school_name; ?></p> 
                                <p><<?php echo $education->major;?></p>
                                <p><?php echo $this->country($education->country_id)->name;?></p>
                               <!-- <li>
                                    <label><u><?php echo $this->translate('Related Information')?></u>:</label>
                                    <?php echo $work->description;?>
                                </li>-->
                            	</br>
                            
                        <?php }
                    ?>
        </div>
    </div>
    <div class="pt-content-file-block">
        <div class="pt-lv-01">
            <h3 style="color:#30AEE9;font-size:15px"><?php echo $this->translate("Skills");?></h3>
											<?php if (count($works) && count($educations) && $user_id==$user_resume){?>
           <a class="pt-edit" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/skill/index/resume_id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a>
                <?php }?>
		</div>
        <div class="pt-lv-02">
                    <?php if(count($languages)>0){ ?>
                    	<h3><?php echo $this->translate("Language")?></h3>
                       <?php foreach($languages as $language){?>
                            	<h3><?php echo $this->degree($education->degree_level_id)->name;?></h3>
                                <?php echo $this->language($language->language_id)->name;?> - <?php echo $this->groupSkill($language->group_skill_id)->name; ?>
                            	</br>
                            
                        <?php
								} 
							} 
						?>
						</br>
                    <?php  if(count($group_skills)>0){ ?>
					<h4><?php echo $this->translate("Other Skills")?></h4>
					<?php 
                        foreach($group_skills as $group_skill){?>
						<h3><?php echo $group_skill->name;?></h3>                                
                                <p><?php echo $group_skill->description;?></p>
                        <?php 
							} 
						}
                    ?>
        </div>
    </div>
    <div class="pt-content-file-block">
        <div class="pt-lv-01">
            <h3 style="color:#30AEE9;font-size:15px"><?php echo $this->translate("Reference");?></h3>
											<?php if (count($works) && count($educations) && $user_id==$user_resume){?>
           <a class="pt-edit" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/reference/index/resume_id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a>
                <?php }?>
		</div>
        <div class="pt-lv-02">
                    
                        <?php foreach($references as $reference){ ?>
                            	<h3><?php echo $reference->name;?> </strong>- <?php echo $reference->title;?></h3>
                                <p><?php echo $this->translate('Phone: ').$reference->phone;?></p>
                                <p><?php echo $this->translate('Email: '). $reference->email;?></p>
                                <p><?php echo $this->translate('Related Information');?></u>:<?php echo $reference->description;?></p>
                            	</br>
                            
                        <?php
							} 
                    ?>
        </div>
    </div>
    </div>
</div>
<div class="button_control">

	<a onclick="javascript:manage_resume(); return false;"><span></span><?php echo $this->translate('Finish ')?></a>&nbsp;&nbsp;<img alt="Image" src="img/thumb/img-submit-oky.png">
    
</div>
<style>
.button_control a span {
    background: url("../img/front/pt-sprite.png") no-repeat scroll -93px -275px rgba(0, 0, 0, 0);
    display: block;
    float: left;
    height: 19px;
    margin: 0 5px 0 0;
    padding: 0;
    width: 19px;
}
.pt-lv-02 button:hover {
    background-color: #2F95B9;
}
.button_control a{
	height: auto;
    line-height: 1.5;
    margin-right: 0px;
    padding: 8px;
    text-align: center;
    width: auto;
}

</style>
</div>
</div>
</div>
<div id="updateUsername" style="display:none;" title="<?php echo $this->translate('Update Fullname')?>">
<input type="text" class="input" id="txt-username" />
<input type="submit" value"<?php echo $this->translate('Save')?>" id="save_username" style="cursor: pointer;" />

</div>
<div id="updateEmail" style="display:none;" title="<?php echo $this->translate('Update Email')?>">
<input type="text" class="input" id="txt-email" />
<input type="submit" value"<?php echo $this->translate('Save')?>" id="save_email" style="cursor: pointer;" />
</div>
<script type="text/javascript">
function updateUsername(resume_id){
    jQuery('#updateUsername').dialog({resizable: false, modal: true});
    
    jQuery('#save_username').click(function(){
        var user= jQuery('#txt-username').val();
        if(user !=''){
        jQuery.post
                    ('<?php echo $this->baseUrl() .PATH_SERVER_INDEX. '/resumes/resume/update' ?>',
                    { 
                        resume_id : resume_id,
                        username: user
                       
                    },
                    function (data){ 
                        if(data==1){
                            jQuery('#displayname').html(user);
                             jQuery('#updateUsername').dialog('close');
                        }
                        
                    }
                    );
        }
        else{
            alert("Full name is not empty")
        }
    });
}
function updateEmail(resume_id){
    jQuery('#updateEmail').dialog({resizable: false, modal: true});
    
    jQuery('#save_email').click(function(){
        var email= jQuery('#txt-email').val();
        if(email !=''){
        jQuery.post
                    ('<?php echo $this->baseUrl() .PATH_SERVER_INDEX. '/resumes/resume/email' ?>',
                    { 
                        resume_id : resume_id,
                        emailUpdate: email
                       
                    },
                    function (data){ 
                        if(data==1){
                            jQuery('#email').html(email);
                             jQuery('#updateEmail').dialog('close');
                        }
                        
                    }
                    );
        }
        else{
            alert("Email is not empty")
        }
    });
}
function manage_resume(){
    var url="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/manage'?>";
    window.location.href= url;
}
window.addEvent('domready', function(){
    var works= <?php echo count($works);?>;
    var education= <?php echo count($educations);?>;
    var language= <?php echo count($languages);?>;
    var group_skill= <?php echo count($group_skills);?>;
    var references= <?php echo count($references);?>;
    
    if(works> 0){
        jQuery('#resume_work_edit').addClass('checked_resume');
    }  
    if(education> 0){
        jQuery('#resume_education_edit').addClass('checked_resume');
    } 
    if(language >0 || group_skill >0){
        jQuery('#resume_skill_edit').addClass('checked_resume');
    }
    if(references> 0){
        jQuery('#resume_reference_edit').addClass('checked_resume');
    }
    var options = { 
            dataType:  'json',   
            success: showResponse, 
            beforeSubmit:  showRequest, 
            type : 'post',
            clearForm: true
    };     
    jQuery('#updateImage').ajaxForm(options);
    
});
function showRequest(formData, jqForm, options) {
    $('ajaxImageLoading').style.display= "block";
}
function showResponse(responseText)  {
    
            if(responseText.message == 'success')
            {      
                
                //request to get image update
                var resume_id = jQuery('#fr_resume').val();
                jQuery.post
                    ('<?php echo $this->baseUrl() .PATH_SERVER_INDEX.'/resumes/resume/image-update' ?>',
                    { 
                        resume_id : resume_id
                    },
                    function (data){ 
                        if(data !=0){
                            var src= "/public/profile_recruiter/"+data;
                            jQuery('#updateNewImage').attr('src', src);
                        }
                        $('ajaxImageLoading').style.display= "none";
                    }
                    );
            }
            else if(responseText.message == 'file'){
                alert("<?php echo $this->translate('Your file is too big!')?>");
                $('ajaxImageLoading').style.display= "none";
            }
            else if(responseText.message == 'extension'){
                alert("<?php echo $this->translate('Check that the file is a valid format.')?>");
                $('ajaxImageLoading').style.display= "none";
            }
            else
            {
                  
            }     
            return false;
    } 
</script>