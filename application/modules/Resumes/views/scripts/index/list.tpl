<style type="text/css">

ul li.resume_info, ul li.resume_work, ul li.resume_education, ul li.resume_skill, ul li.resume_reference{
    background-image: url(<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/check_suc.png'?>);
    background-repeat: no-repeat;
    background-position: 100% 50%;
    
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
?>

<a href="javascript:void(0);" onclick="toggle_list();"><?php echo $this->translate('[+]');?></a><br />
<div id="list_resume_toggle" class="resume_preview_main">
    <div class="subsection">
    
    <table class="last_resume">
        <tr>
            <td style="color: #F90; padding-left: 11px;" width="30%">
           
            <ul>
                <li> <?php echo $this->translate("Work Experience");?></li>
                <li>
                    <?php echo $this->translate("Total: ")?> <?php echo $total_year. " year(s)";?>
                </li>
                
                
            </ul>
            </td>
            <td>
                <div>
                    <?php 
                        foreach($works as $work){?>
                            <ul>
                                <li><strong><?php echo $work->title; ?></strong></li>
                                <li><strong><?php echo $this->level($work->level_id)->name;?> - <?php echo $this->category($work->category_id)->name;?></strong>
                                </li>
                                <li><?php echo $work->company_name;?></li>
                                <li><?php echo $this->city($work->city_id)->name; ?> - <?php echo $this->country($work->country_id)->name;?>
                                
                                </li>
                                <li>
                                    <label><?php echo $this->translate('<u>Related Information:</u>')?></label>
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
                
            </ul>
            </td>
            <td >
                <div>
                    <?php 
                        foreach($educations as $education){?>
                            <ul>
                                <li><strong><?php echo $this->degree($education->degree_level_id)->name;?></strong> </li>
                                <li><strong><?php echo $education->school_name; ?></strong></li>
                                
                                <li><?php echo $education->major;?></li>
                                <li><?php echo $this->country($education->country_id)->name;?>
                                
                                </li>
                                <li class="last_resume">
                                    <label><?php echo $this->translate('<u>Related Information:</u>')?></label>
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
                                <li><?php echo $this->translate('Related Information: ').$reference->description;?> </li>
                            </ul>
                        <?php }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    </div>
</div>

