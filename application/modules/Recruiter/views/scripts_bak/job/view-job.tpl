<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
.description_job p{padding-left: 145px; margin-top: -28px;}
.description_job textarea{
    width: 514px;
    border: none;
    overflow: hidden;
}
#footer{font-size: 1em;}
</style>
<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
<?php
    $job= $this->job;
    $industries= $this->industries; 
    $categories= $this->categories;
    $types= $this->types;
    $contactvias= $this->contact_vias;
    $contact = $this->contact;
    $user_id= $this->user_id;
    //thay \n bằng br
    $des= str_replace("\n", "<br />", $job->description);
    $skill_des= str_replace("\n", "<br />", $job->skill);
?>
<div class="layout_main">
<!-- search job -->
<?php echo $this->content()->renderWidget('recruiter.search-job');?>
<!-- end -->
<div id="content">
    <div class="section jobs">
        
        <div class="layout_right">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
                <!-- end -->
                <!-- tool for job -->
                <?php if($user_id && ($job->status==2) && ($job->reject==0)){?>
                <div class="subsection">
                    <h2><?php echo $this->translate("Tools");?></h2>
                    <div class="subcontent">
                		<ul class="jobs_management">
                        <?php if($job->deadline >= date('Y-m-d')){?>
                			<li><a style="cursor: pointer;" onclick="apply_job('<?php echo $job->job_id;?>')" ><?php echo $this->translate('Apply to this job')?></a></li>
                        <?php }?>
                            <li><a style="cursor: pointer;" onclick="save_job('<?php echo $job->job_id;?>')"><?php echo $this->translate('Save this job')?></a></li>
                            <li><a href="<?php echo $this->baseUrl().'/recruiter/job/send-email/job_id/'.$job->job_id?>"><?php echo $this->translate('Email this job to a friend');?></a></li>
                            <?php if($user_id){?>
                            <li><a class="share_job smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/job/id/<?php echo $job->job_id ?>/format/smoothbox" ><?php echo $this->translate('Share to network') ?></a></li>
                            <?php }?>
                		</ul>	
                    </div>
                </div> 
                <?php } ?>
                <!-- end -->
                <!-- feature employers -->
                <?php //echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                <!-- insert some advertising -->
                <div class="subsection">
                    <a href="http://www.vtcb.org.vn/">
                        <img src="application/modules/Job/externals/images/companies/vtcb.jpg" alt="Image" />
                    </a>
                </div>
                <div class="subsection">
                    <a href="http://www.moevenpick-hotels.com/en/asia/vietnam/ho-chi-minh-city/hotel-saigon/overview/">
                        <img src="application/modules/Job/externals/images/companies/movenpick.png" alt="Image" />
                    </a>
                </div>
                <div class="subsection">
                    <a href="http://www.seasideresort.com.vn/201203_seaside/">
                        <img src="application/modules/Job/externals/images/companies/seaside.png" alt="Image" />
                    </a>
                </div>
                <div class="subsection">
                    <a href="http://www.namnguhotel.com/index.php">
                        <img src="application/modules/Job/externals/images/companies/namngu.png" alt="Image" />
                    </a>
                </div>
            </div>
        <div class="layout_middle">
        
        <div class="job_main">
                <?php echo $this->content()->renderWidget('recruiter.profile-company');?>
                <?php if(!empty($job)){?>
                <div class="subsection">
                <h2><?php echo $this->translate('Job Detail')?></h2>
                <div class="job_description">
                    <p><label><?php echo $this->translate('Job Title: ');?></label>
                        <span><strong><?php echo $job->position;?></strong>
                        
                        
                        </span>
                                  
                        
                    </p>
                    <p><label><?php echo $this->translate('Industry: ');?></label>
                    <span><strong>
                        <?php 
                        $i=0;
                            foreach($categories as $category){
                                $i++;
                                
                                if($i==count($categories)){
                                    echo $this->categoryJob($category->category_id)->name;
                                }else{
                                    echo $this->categoryJob($category->category_id)->name. " - ";
                                }
                                
                                
                            }
                        ?>
                        </strong></span>
                        </p>
                    <p><label><?php echo $this->translate('Career: ');?></label>
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
                        
                        <p><label><?php echo $this->translate('Quantity:')?></label><span><strong><?php echo $job->num;?></strong></span></p>
                        <p><label><?php echo $this->translate('Year Experience:')?></label><span><strong><?php echo $job->year_experience;?></strong></span></p>
                        <p><label><?php echo $this->translate('Degree Level:')?></label><span><strong><?php echo $this->degree($job->degree_id)->name;?></strong></span></p>
                        <p><label><?php echo $this->translate('Place to work:')?></label><span><?php echo $this->city($job->city_id)->name?> - <?php echo $this->country($job->country_id)->name;?></span></p>
                        <p><label><?php echo $this->translate('Type:')?></label>
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
                        
                        </p>
                        <div class="description_job" id="des"><p><?php echo $des ?></p></div>
                        
                        <p><label><?php echo $this->translate('Skill-set required: ')?></label></p>
                        <div class="description_job"><p><?php echo $skill_des ?></p></div>
                        <p><label><?php echo $this->translate('Salary: ')?></label><span><strong><?php echo $job->salary;?></strong></span></p>
                        <p><label><?php echo $this->translate('Deadline: ')?></label><span><?php echo date('d F Y', strtotime($job->deadline));?>
                        <?php if($job->deadline < date('Y-m-d')){
                            echo " - <b style='color: red'>Expired</b>";
                        }?>
                        </span>
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
                            if(count($contactvias)>0){
                                foreach($contactvias as $contactvia){
                                    $i++;
                                    if($i==count($contactvias)){
                                        echo $this->contact($contactvia->contact_id)->name;
                                    }else{
                                        echo $this->contact($contactvia->contact_id)->name. " - ";
                                    }
                                    
                                }
                            }
                        ?>
                        </span>
                        </p>
                        <p><label><?php echo $this->translate('Phone: ');?></label><span><?php echo $job->contact_phone;?></span></p>
                        <p><label><?php echo $this->translate('Email: ');?></label><span><?php echo $job->contact_email;?></span></p>
                    
                    <?php } ?>
                    </div>
                    </div>
                    <!-- AddThis Button BEGIN -->
                    <!--<a class="share_job_icon smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/job/id/<?php echo $job->job_id ?>/format/smoothbox" ><?php echo $this->translate('Share') ?></a>-->
                    <!--
		    <div class="addthis_toolbox addthis_default_style ">
                    
                    <g:plusone size="small"></g:plusone>
                    <a class="addthis_button_preferred_1"></a>
                    <a class="addthis_button_preferred_2"></a>
                    <a class="addthis_button_preferred_3"></a>
                    <a class="addthis_button_preferred_4"></a>
                    </div>
                    <script type="text/javascript">var addthis_config = {"data_track_clickback":true};</script>
                    <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=huynhnv"></script>
		    -->
                    <!-- AddThis Button END -->
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
        <?php if($user_id){?>
                <div class="button_control">
                    <?php if($job->deadline >= date('Y-m-d')){?>
                            <a class="edit" onclick="apply_job('<?php echo $job->job_id;?>')"><?php echo $this->translate('Apply');?></a>
                        <?php }?>
					
                    <a class="save_job" onclick="save_job('<?php echo $job->job_id;?>')"><?php echo $this->translate('Save this job');?></a>
				</div>
                <?php } ?>
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
 
