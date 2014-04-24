<style type="text/css">
label.error{color: red;}
.global_form input + label {float:none;}
.global_form > div > div {border:none;}
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
.global_form > div > div {background: #fff;}
.job-form .resumes label{width: 93px;}
.job-form .input label.error{color: red; clear:both; width:238px;}
</style>
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
    $check= $this->check;
?>

<div class="layout_main">
<?php echo $this->content()->renderWidget('recruiter.search-job');?>
    <div id="content">
        <div class="section jobs">
            <div class="layout_right">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
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
                <div class="apply_job">
                <div id="breadcrumb">
                    <div class="section">
                        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Apply Job");?></strong>
                    </div>
                </div>
                    <div class="subsection">
                    <h2><?php echo $this->translate('Apply Job')?></h2>
                    <?php if($check==true){?>
                        <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                        <span>
                          <?php echo $this->translate("You have been applied to this job.") ?>
                        </span>
                      </div>
                      
                    <?php }
                        else{?>
                            <form id="recruiter_apply_job_form" action="<?php echo $form->getAction();?>" method="post" enctype="multipart/form-data">
                                <fieldset class="job-form">
                                    <div class="input apply_job_title">
                                        <?php echo $form->title;?>
                                    </div>
                                    <div class="input resumes">
                                        <?php echo $form->resume_id;?>
                                    </div>
                                    <div class="input">
                                        <?php echo $form->description;?>
                                    </div>
                                    <div class="input file">
                                        <?php echo $form->file;?>
                                    </div>
                                    <div class="submit">
                                        <input type="submit" value="<?php echo $this->translate('Apply');?>" class="min" />
                                        <input type="reset" value="<?php echo $this->translate('Reset');?>" class="min" onclick="reset();" />
                                    </div>
                                </fieldset>
                            </form>                    
                        <?}
                    ?>
        
                    </div>
                </div>
            
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
function toggle_list(){
    jQuery('#list_resume_toggle').toggle();
    
}
function select_resume(){
    var resume_id= $('resume_id').value;
    
    //ajax load resume
    var url= "<?php echo $this->baseUrl().'/resumes/index/list' ?>";
    new Request({
        url: url,
        method: "post",
        data : {
        		
        		'resume_id': resume_id
        	},
        onSuccess : function(responseHTML)
        {
            
            $('list_resume').set('html', responseHTML);
        		
        }
    }).send();
}
window.addEvent('domready', function(){
    if($('resume_id').value==''){
        jQuery('#resume_id-element').append("<span style='position:relative;top:11px;'><?php echo $this->translate('Please')?> <a href='<?php echo $this->baseUrl()?>/resumes/index/resume-info' ><?php echo $this->translate('create a new resume')?> </a><?php echo $this->translate('before apply job')?>.</span>");
        jQuery('#resume_id').css('display', 'none');
        jQuery('#resume_id').append("<option value='0'></option>");

    }
    var list_resume  = new Element('div', {id: 'list_resume', 'class': 'list_resume'});
    list_resume.inject($('resume_id-wrapper'), 'after');

    jQuery('#recruiter_apply_job_form').validate({
       messages : {
            
			"title" : {
			     required: "<?php echo $this->translate('Subject is not empty.')?>",
                 maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
             }, 
             "resume_id":{
                 required: "<?php echo $this->translate('Please create a resume.')?>",
                 min: "<?php echo $this->translate('Please create a resume.')?>"
             }
		},
		rules: {
            
			"title" : {
		      required: true,
		      maxlength: 160
		    },
            "resume_id":{
                required: true,
                min: 1
            }
        } 
    });
});
function reset(){
    $('recruiter_apply_job_form').reset();
}
</script>