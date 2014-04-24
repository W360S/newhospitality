
<style type="text/css">
.check_list p.resume_info{
    background-color:#E4F3FB;
    font-weight:bold;
}
.check_list p.resume_info span {
    background-position:0 -18px;
    color:#FFFFFF;
}

.job-form label { color: #000; float: left; font-weight: bolder; line-height: 35px; margin-right: 10px; text-align: right; width: 90px; }
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
.job-form .input p{
	padding-left:0px;
}
.job-form .input label{
	color: #777F82;
}
.job-form .radio {
    margin-left: 222px;
    margin-top: 24px;
    overflow: hidden;
    padding-left: 4px;
    width: 59%;
}
.job-form .submit input{
	background: none repeat scroll 0 0 #50C1E9;
    border: medium none;
    border-radius: 3px;
    color: #FFFFFF;
    cursor: pointer;
    float: left;
    font-size: 1.25em;
    height: 35px;
    line-height: 35px;
    margin-right: 10px;
    text-align: center;
    width: 127px;
}
.job-form .submit input.min{
	background:none repeat scroll 0 0 #50C1E9;
	width:127px;
}

.button {
    background-color: #50C1E9;
    background-image: url("/application/modules/Core/externals/images/buttonbg.png");
    background-position: 0 1px;
    background-repeat: repeat-x;
    border: 1px solid #50809B;
    border-radius: 3px;
    color: #FFFFFF;
    font-size: 13px;
    font-weight: 700;
    padding: 8px 10px 8px 8px;
}
.button:hover{
	background-color: #50C1E9;
    background-image: url("/application/modules/Core/externals/images/buttonbg.png");
    background-position: 0 1px;
    background-repeat: repeat-x;
    border: 1px solid #50809B;
    border-radius: 3px;
    color: #FFFFFF;
    font-size: 13px;
    font-weight: 700;
    padding: 8px 10px 8px 8px;
	background:#2F95B9;
}
.job-form-step-1 .submit {
    padding-left: 227px;
}
.job-form {
    padding: 50px 19px 60px;
}
</style>
<?php $num_resume= $this->num_resume;?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Create resume");?></strong>
    </div>
</div>
<div id="content">
<div class="section recruiter">

<?php if(count($num_resume)<3){?>
<div class="layout_right">
<?php echo $this->content()->renderWidget('resumes.check-list');?>
</div>

<div class="layout_middle" style="width:72%; background: none repeat scroll 0 0 #FFFFFF;">
<div class="resume_info_main subsection" style="border:none">
    <h2><?php echo $this->translate('Resume Information')?></h2>
    
    <form action="<?php echo $this->baseUrl().PATH_SERVER_INDEX?>/resumes/index/resume-info" method="post" id="resume_info_form" style="margin-top:20px">
        <fieldset class="job-form job-form-step-1">
            <div class="input">
                <label for="resume title"><?php echo $this->translate("Resume Title (*): ")?></label>
                <input type="text" name="resume_title" id="resume_title" />
				<p><?php echo $this->translate("(e.g., Experienced Brand Manager with profound knowledge in FMCG industry)")?></p>
            </div>
			<div class="radio" style=" margin-left: 102px;margin-top: 25px;width:14%;float:left;">
                <label><?php echo $this->translate('Privacy Status')?></label>
            </div>
			<div class="radio">
                <input type="radio" value="1" name="searchable" checked /> <?php echo $this->translate('Searchable (recommended): ')?>
                 <?php echo $this->translate(' This option allows employers to contact you by phone or email and view all your resume information.')?>
                
            </div>
			<div class="radio">
                <input type="radio" value="0" name="searchable" /><?php echo $this->translate('Non Searchable (not recommended): ')?>
                 <?php echo $this->translate("This option does not allow employers to search your resume by making your resume 'invisible'.")?>   
            </div>
            <div class="submit">
            	<button type="submit" title="" class="button"><span style="background: url('../img/front/pt-sprite.png') no-repeat scroll -91px -275px rgba(0, 0, 0, 0); display: block;float: left;height: 19px; margin: 0 5px 0 0; width: 19px;"></span><?php echo $this->translate('Next');?></button>&nbsp;&nbsp;
            	<button type="submit" title="" class="button" style="margin-top: 2px; position: relative; padding-top: 8px; padding-bottom: 10px;"><?php echo $this->translate('Cancel');?></button>
                <!--<input type="submit" value="<?php echo $this->translate('Next');?>" class="min" />-->
            </div>
        </fieldset>
        
    </form>
</div>
</div>
<?php } else{
    echo $this->translate('You have created 3 resumes. Could not create any new one.');
    }?>
</div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
   jQuery('#resume_info_form').validate({
		messages : {
			"resume_title" : {
			     required: "<?php echo $this->translate('Title Resume is not empty')?>",
                 maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
             }
		},
		rules: {
			"resume_title" : {
		      required: true,
		      maxlength: 160
		    }
        }
    }); 
});
</script>