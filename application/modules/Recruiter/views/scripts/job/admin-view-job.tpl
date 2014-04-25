<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
</style>
<?php
    $job= $this->job;
    $industries= $this->industries; 
    $types= $this->types;
    $contactvias= $this->contact_vias;
?>
<div class="layout_main">
<!-- search job -->
<?php //echo $this->content()->renderWidget('recruiter.search-job');?>
<!-- end -->
<div id="content">
    <div class="section jobs">
        
        <div class="layout_right">
                <!-- online resume -->
                <?php //echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php //echo $this->content()->renderWidget('recruiter.manage-job');?>
                <!-- end -->
                
                <!-- feature employers -->
                <?php //echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                
            </div>
        <div class="layout_middle">
        
        <div class="job_main">
                <?php echo $this->content()->renderWidget('recruiter.profile-company');?>
                <?php if(!empty($job)){?>
                <div class="subsection">
                <h2><?php echo $this->translate('Job Detail')?></h2>
                <div class="job_description">
                    <p><label><?php echo $this->translate('Job Title: ');?></label>
                        <span><strong><?php echo $job->position;?></strong></span>
                    </p>
                    <p><label><?php echo $this->translate('Industry: ');?></label>
                    <span><strong>
                        <?php 
                        $i=0;
                            foreach($industries as $industry){
                                $i++;
                                
                                if($i==count($industries)){
                                    echo $this->industry($industry->industry_id)->name;
                                }else{
                                    echo $this->industry($industry->industry_id)->name. " - ";
                                }
                                
                                
                            }
                        ?>
                        </strong></span>
                        </p>
                        <p><label><?php echo $this->translate('Position: ');?></label> <span><strong><?php echo $job->position;?></strong></span></p>
                        <p><label><?php echo $this->translate('Quantity: ')?></label><span><strong><?php echo $job->num;?></strong></span></p>
                        <p><label><?php echo $this->translate('Place to work: ')?></label><span><?php echo $this->city($job->city_id)->name?> - <?php echo $this->country($job->country_id)->name;?></span></p>
                        <p><label><?php echo $this->translate('Type: ')?></label>
                        <?php 
                        $i=0;
                            foreach($types as $type){
                                $i++;
                                if($i==count($types)){
                                    echo $this->type($type->type_id)->name;
                                }else{
                                    echo $this->type($type->type_id)->name. " - ";
                                }
                                
                            }
                        ?>
                        </p>
                        <p><label><?php echo $this->translate('Description: ')?></label>
                            <span><?php echo $job->description;?></span>
                        </p>
                        <p><label><?php echo $this->translate('Skill-set required: ')?></label><span><?php echo $job->skill;?></span></p>
                        <p><label><?php echo $this->translate('Salary: ')?></label><span><strong><?php echo $job->salary;?></strong></span></p>
                        <p><label><?php echo $this->translate('Deadline: ')?></label><span><?php echo date('d F Y', strtotime($job->deadline));?>
                        <?php if($job->deadline < date('Y-m-d')){
                            echo " - <b style='color: red'>Expired</b>";
                        }?>
                        </span>
                        </p>
                        <p><label><?php echo $this->translate("Views: ");?> </label>
                            <span><?php echo $job->view_count;?> - <a href="<?php echo $this->baseUrl() ?>/activity/index/share/type/job/id/<?php echo $job->job_id ?>/format/smoothbox" class="smoothbox"><?php echo $this->translate('Share') ?></a></span>
                        </p>
                    </div>
                </div>
                <div class="subsection">
                <div class="job_description">
                    <h2><?php echo $this->translate("Contact Information")?></h2>
                    
                        <p><label><?php echo $this->translate('Contact to: ');?></label><span><strong><?php echo $job->contact_name;?></strong></span></p>
                        <p><label><?php echo $this->translate('Address: ');?></label><span><?php echo $job->contact_address;?></span></p>
                        <p><label><?php echo $this->translate('Contact via: ');?></label>
                            <span>
                            <?php 
                            $i=0;
                            foreach($contactvias as $contactvia){
                                $i++;
                                if($i==count($contactvias)){
                                    echo $this->contact($contactvia->contact_id)->name;
                                }else{
                                    echo $this->contact($contactvia->contact_id)->name. " - ";
                                }
                                
                            }
                        ?>
                        </span>
                        </p>
                        <p><label><?php echo $this->translate('Phone: ');?></label><span><?php echo $job->contact_phone;?></span></p>
                    
                    <?php } ?>
                    </div>
                    </div>
                    
                
        </div>
</div>
</div>

<script type="text/javascript">
function apply_job(job_id){
    var url= "<?php echo $this->baseUrl().'/recruiter/job/apply-job/job_id/'?>"+ job_id;
    window.location.href= url;
}
function save_job(job_id){
    var url= "<?php echo $this->baseUrl().'/recruiter/job/save-job/job_id/'?>"+ job_id;
    window.location.href= url;
}

</script>
