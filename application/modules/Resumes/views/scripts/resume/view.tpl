
<style type="text/css">

ul li.resume_info, ul li.resume_work, ul li.resume_education, ul li.resume_skill, ul li.resume_reference{
    background-image: url(<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/check_suc.png'?>);
    background-repeat: no-repeat;
    background-position: 100% 50%;
    
}
#global_wrapper {background: none;}
</style>


<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter'?>"><?php echo $this->translate("Recruiter");?></a> <span>&gt;</span>  <strong><?php echo $this->translate("View Resume");?></strong>
    </div>
</div>
<div id="content">
<div class="section recruiter-view-profile">
<div class="layout_left">
<?php echo $this->content()->renderWidget('recruiter.profile')?>
<?php //echo $this->content()->renderWidget('user.profile-options')?>
<?php echo $this->content()->renderWidget('user.profile-info')?>
</div>
<div class="layout_middle">
<div class="resume_preview_main">
    <div id="save_success" style="padding-bottom: 10px; display:none; color: red;"><?php echo $this->translate('You have been saved this candidate successfully!')?></div>
    <div class="subsection">
    <input type="hidden" value="<?php echo $resume->resume_id?>" id="resume" />
    <h2><?php echo $this->translate('Resume')?></h2>
    <table class="last_resume">
        <tr>
            <td style="color: #F90; padding-left: 11px;" width="30%">
           
            <ul>
                <li> <?php echo $this->translate("Work Experience");?></li>
                <li>
                    <?php echo $this->translate("Total: ")?> <?php echo $total_year. " year(s)";?>
                </li>
                <?php if ($user_id==$user_resume){?>
                    <li><a href="<?php echo $this->baseUrl().'/resumes/index/resume-work/id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a></li>
                <?php }?>
                
            </ul>
            </td>
            <td>
                <div>
                    <?php 
                        foreach($works as $work){?>
                            <ul>
                                <li><label><?php echo $this->translate("Job Title")?>: </label><strong><?php echo $work->title; ?></strong></li>
                                <li><label><?php echo $this->translate("Job Level")?>: </label><strong><?php echo $this->level($work->level_id)->name;?> - <?php echo $this->category($work->category_id)->name;?></strong>
                                </li>
                                <li><label><?php echo $this->translate("Company Name")?>: </label><?php echo $work->company_name;?></li>
                                <li><?php echo $this->city($work->city_id)->name; ?> - <?php echo $this->country($work->country_id)->name;?>
                                
                                </li>
                                <li>
                                    <label><u><?php echo $this->translate('Related Information')?>:</u></label>
                                    <?php echo $work->description;?>
                                </li>
                            </ul>
                            
                        <?php }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    <table class="last_resume">
        <tr>
            <td width="30%" style="color: #F90; padding-left: 11px;">
            
            <ul>
                <li><?php echo $this->translate("Education");?></li>
                <?php if ($user_id==$user_resume){?>
                    <li><a href="<?php echo $this->baseUrl().'/resumes/education/index/resume_id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a></li>
                <?php } ?>
            </ul>
            </td>
            <td >
                <div>
                    <?php 
                        foreach($educations as $education){?>
                            <ul>
                                <li><label><?php echo $this->translate("Degree Level")?>: </label><strong><?php echo $this->degree($education->degree_level_id)->name;?></strong> </li>
                                <li><label><?php echo $this->translate("School Name")?>: </label><strong><?php echo $education->school_name; ?></strong></li>
                                
                                <li><label><?php echo $this->translate("Major")?>: </label><?php echo $education->major;?></li>
                                <li><?php echo $this->country($education->country_id)->name;?>
                                
                                </li>
                                <li class="last_resume">
                                    <label><u><?php echo $this->translate('Related Information')?>:</u></label>
                                    <?php echo $education->description;?>
                                </li>
                            </ul>
                        <?php }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    <table class="last_resume">
        <tr>
            <td width="31%" style="color: #F90; padding-left: 11px;">
            
            <ul>
                <li><?php echo $this->translate("Skills");?></li>
                <?php if ($user_id==$user_resume){?>
                    <li><a href="<?php echo $this->baseUrl().'/resumes/skill/index/resume_id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a></li>
                <?php } ?>
            </ul>
            </td>
            
            <td>
                <div>
                <?php if(count($languages)>0){?>
                    <h4><?php echo $this->translate("Language")?></h4>
                    <?php 
                        foreach($languages as $language){?>
                            <ul>
                                <li>
                                    <?php echo $this->language($language->language_id)->name;?> - <?php echo $this->groupSkill($language->group_skill_id)->name;?>
                                </li>
                                
                               
                                
                            </ul>
                        <?php } }
                    ?>
                    <?php if(count($group_skills)>0){?>
                    <h4><?php echo $this->translate("Other Skills")?></h4>
                    <?php 
                        foreach($group_skills as $group_skill){?>
                            <ul>
                                <li><strong><?php echo $group_skill->name;?></strong></li>
                                
                                <li><?php echo $group_skill->description;?></li>
                                
                            </ul>
                        <?php } }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td width="30%" style="color: #F90; padding-left: 11px;">
            
            <ul>
                <li><?php echo $this->translate("Reference");?></li>
                <?php if ($user_id==$user_resume){?>
                    <li><a href="<?php echo $this->baseUrl().'/resumes/reference/index/resume_id/'.$resume->resume_id?>"><?php echo $this->translate('[Edit]')?></a></li>
                <?php } ?>
            </ul>
            </td>
            <td>
                <div>
                    <?php 
                        foreach($references as $reference){?>
                            <ul>
                                <li><strong><?php echo $reference->name;?> </strong>- <?php echo $reference->title;?></li>
                                
                                <li><?php echo $this->translate('Phone: ').$reference->phone;?> </li>
                                <li><?php echo $this->translate('Email: '). $reference->email;?> </li>
                                <li><u><?php echo $this->translate('Related Information')."</u>: ".$reference->description;?> </li>
                            </ul>
                        <?php }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    </div>
    <a class="print_profile" href="<?php echo $this->baseUrl().'/resumes/resume/pdf/resume_id/'.$resume->resume_id ?>"><?php echo $this->translate("Print to profile");?></a>
</div>
</div>
</div>
</div>
<script type="text/javascript">
function save_candidate(){
    var resume_id= $('resume').value;
    //alert(resume_id);return false;
    var url= "<?php echo $this->baseUrl().'/recruiter/job/save-resume' ?>";
    var href= window.location;
    if(confirm("<?php echo $this->translate('Do you really want to save this candidate?');?>")){
        
        new Request({
            url: url,
            method: "post",
            data : {
                    'resume_id': resume_id
            	},
            onSuccess : function(responseHTML)
            { 
                if(responseHTML==1){
                    $('save_success').style.display= 'block';
                }
               
                else{
                    $('save_success').style.display= 'block';
                    jQuery('#save_success').html('<?php echo $this->translate("Save faild!")?>');
                }
               
            }
        }).send();
    }
}
</script>
