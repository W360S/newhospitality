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
#breadcrumb{
	padding-top:12px;
	padding-bottom:5px;
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
.pt-how-story a.pt-link-07 {
    background: url("../img/front/icon-09.png") no-repeat scroll 0 3px rgba(0, 0, 0, 0);
}
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
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("View job");?></strong>
    </div>
</div>
<div class="layout_main">
<!-- search job -->
<?php //echo $this->content()->renderWidget('recruiter.search-job');?>
<!-- end -->
<div id="content">
    <div style="width:282px;float:right;margin-top: -18px;">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
                <?php if($user_id && ($job->status==2) && ($job->reject==0)){?>
                <div class="pt-block">
                    <h3 class="pt-title-right"><?php echo $this->translate("Tools");?></h3>
                    <div class="pt-how-story">
                        <?php if($job->deadline >= date('Y-m-d')){?>
                			<a class="pt-link-04" style="cursor: pointer;" onclick="apply_job('<?php echo $job->job_id;?>')" ><?php echo $this->translate('Apply to this job')?></a>
                        <?php }?>
                            <a style="font-size:12px" class="pt-link-05" style="cursor: pointer;" onclick="save_job('<?php echo $job->job_id;?>')"><?php echo $this->translate('Save this job')?></a>
                            <a class="pt-link-06" href="<?php echo $this->baseUrl().'/recruiter/job/send-email/job_id/'.$job->job_id?>"><?php echo $this->translate('Email this job to a friend');?></a>
                            <?php if($user_id){?>
                            <a class="pt-link-07" class="share_job smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/job/id/<?php echo $job->job_id ?>/format/smoothbox" ><?php echo $this->translate('Share to network') ?></a>
                            <?php }?>	
                    </div>
                </div> 
                <?php } ?>
                <?php echo $this->content()->renderWidget('recruiter.hot-job');?>
                <?php echo $this->content()->renderWidget('recruiter.articals');?>
                <!-- end -->
                <!-- job tools -->
                <?php //echo $this->content()->renderWidget('recruiter.job-tools');?>
                <!-- end -->
                <!-- feature employers -->
                <?php echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                <!-- insert some advertising -->
                <?php //include 'ads/right-column-ads.php'; ?>
    </div>
    <div class="layout_middle" style="width:766px;float:left;padding:18px">
    <style>
    	.layout_middle .subsection h2{
    		border-bottom:none;
    		background:#fff;
    		color:#30AEE9;
    		font-size:14px;
    		font-family:inherit;
    		padding:0px;
    	}
    	.job_description p label{
    		text-align:left;
    	}
    	.job_description p{
    		padding:5px 0;
    	}
    	.button_control{
    		padding:20px 0 30px;
    	}
   	.pt-lv-02 {
     margin-top: 38px;
    padding-bottom: 10px;
    width: 100%;
}
.pt-job-detail .pt-lv-02 img {
    padding-top: 8px;
}
.pt-lv-02 a.icon-01 span {
    background: url("../img/front/icon-tai.png") no-repeat scroll 2px 2px rgba(0, 0, 0, 0);
}
.pt-lv-02 a.icon-02 span {
    background: url("../img/front/icon-tai.png") no-repeat scroll 2px -37px rgba(0, 0, 0, 0);
}
span.button a, a.button{
	 background-color: #50C1E9;
	 border:none;
	 padding:11px;
	 background-image:none;
}
span.button a, a.button:hover{
	 background-color: #2F95B9;
	 border:none;
	 padding:11px;
	  background-image:none;
}
.button{
	
}
	</style>    
        <div class="job_main">
        		<h2 style="color: rgb(48, 174, 233); margin-bottom: 23px; margin-top: 5px; font-size: 20px;"><?php echo $job->position;?></h2>
                <?php echo $this->content()->renderWidget('recruiter.profile-company');?>
                <?php if(!empty($job)){?>
                <div class="subsection">
                <h2><?php echo $this->translate('Job Detail')?></h2>
                <div class="job_description">
	<div style="width:75%;float:left;padding:5px">
		
  		<p><?php echo $des ?></p>
	</div>
	<div style="width:21%;float:right;padding:5px 5px 5px 15px;background:#F6F6F6">
		<p style="width:100%"><label><?php echo $this->translate('Deadline: ')?></label><span><?php echo date('d F Y', strtotime($job->deadline));?>
                        <?php if($job->deadline < date('Y-m-d')){
                            echo " - <b style='color: red'>Expired</b>";
                        }?>
                        </span>
  		</p>
		  <p style="width:100%"><label><?php echo $this->translate('Place to work:')?></label><span style="color:#3D7CBF;text-decoration:underline"><?php echo $this->city($job->city_id)->name?> - <?php echo $this->country($job->country_id)->name;?></span></p>
		  <p style="width:100%"><label><?php echo $this->translate('Degree Level:')?></label><span style="color:#3D7CBF;text-decoration:underline"><?php echo $this->degree($job->degree_id)->name;?></span></p>
		  <p style="width:100%"><label><?php echo $this->translate('Career: ');?></label>
                    <span style="color:#3D7CBF;text-decoration:underline;width:100%">
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
                        </span>
                        
    	</p>
			
	</div>
	<div style="clear:both"></div>
		<h2><?php echo $this->translate('Skill-set required: ')?></h2>
                        <p><?php echo $skill_des ?></p>
                        <!-- <p><label><?php echo $this->translate('Salary: ')?></label><span><strong><?php echo $job->salary;?></strong></span></p>
                    
                       <span><strong><?php echo $job->position;?></strong</span>
                                  
                        
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
                    
                        
                        <p><label><?php echo $this->translate('Quantity:')?></label><span><strong><?php echo $job->num;?></strong></span></p>
                        <p><label><?php echo $this->translate('Year Experience:')?></label><span><strong><?php echo $job->year_experience;?></strong></span></p>
                        
                        
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
                        </p>-->
                        
                        
                        
</div>
                
        		</div>
		</div>
        
                <div class="subsection">
                <div class="job_description">
                    <h2><?php echo $this->translate("Contact Information")?></h2>
                    <?php
						$_SESSION['contact_name']=$job->contact_name;
					?>
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
                <div class="pt-lv-02">
                	<a class="button icon-02" onclick="save_job('<?php echo $job->job_id;?>')"><img style="padding-right: 8px; padding-top: 3px;" src="img/front/nguoc.png" alt="Image"/><?php echo $this->translate('Save this job');?></a>
                    <?php if($job->deadline >= date('Y-m-d')){?>
                            <a class="button icon-01" onclick="apply_job('<?php echo $job->job_id;?>')"><img style="padding-right: 8px; padding-top: 3px;" src="img/front/icon-tai.png" alt="Image"/><?php echo $this->translate('Apply');?></a>
                            <img style="margin-top:-10px" src="img/thumb/img-submit-oky1.png" alt="Image"/>
                        <?php }?>
					
                    
                    
				</div>
                <?php } ?>
        </div>
</div>
</div>

<script type="text/javascript">
function apply_job(job_id){
    var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/job/apply-job/job_id/'?>"+ job_id;
    window.location.href= url;
}
function save_job(job_id){
    var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/job/save-job/job_id/'?>"+ job_id;
    window.location.href= url;
}
</script>
 
