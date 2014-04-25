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
                <?php include 'ads/right-column-ads.php'; ?>
            </div>
            <div class="layout_middle">
                <div class="apply_job">
                <div id="breadcrumb">
                    <div class="section">
                        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Send Email");?></strong>
                    </div>
                </div>
                    <div class="subsection">
                    <h2><?php echo $this->translate('Email job to a friend')?></h2>
                    
                        <form id="recruiter_send_email_job_form" action="<?php echo $form->getAction();?>" method="post" enctype="multipart/form-data">
                            <fieldset class="job-form">
                                <div class="input apply_job_title">
                                    <?php echo $form->email;?>
                                </div>
                                <div class="input apply_job_title">
                                    <?php echo $form->cc_email;?>
                                    
                                </div>
                                <div>
                                <p style="padding-left: 100px;font-style:italic;"><?php echo $this->translate('Email is seperated by "," ')?></p>
                                </div>
                                <div class="input apply_job_title">
                                    <?php echo $form->title;?>
                                </div>
                                
                                <div class="input">
                                    <?php echo $form->description;?>
                                </div>
                                
                                <div class="submit">
                                    <input type="submit" value="<?php echo $this->translate('Send');?>" class="min" />
                                    <input type="reset" value="<?php echo $this->translate('Reset');?>" class="min" onclick="reset();" />
                                </div>
                            </fieldset>
                        </form>                    
                      
        
                    </div>
                </div>
            
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    jQuery('#recruiter_send_email_job_form').validate({
       messages : {
            
			"email" : {
			     required: "<?php echo $this->translate('Email is not empty.')?>",
                 email: "<?php echo $this->translate('Please enter a valid email.')?>"
             }
		},
		rules: {
            
			"email" : {
		      required: true,
		      email: true
		    }
        } 
    });
});
function reset(){
    $('recruiter_send_email_job_form').reset();
}
</script>