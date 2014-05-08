</style>
<div class="pt-block">
    <h3 style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 10px 0;  text-transform: uppercase;"><?php echo $this->translate("Jobs management");?></h3>
    <div class="pt-how-story">
    	<a href="<?php echo $this->baseUrl().'/resumes/resume/manage'?>" class="pt-link-resume"><?php echo $this->translate("My Resume");?></a>
		<a href="<?php echo $this->baseUrl().'/recruiter/job/manage-apply' ?>" class="pt-link-apply"><?php echo $this->translate('Applied Jobs ')?><span><?php echo $this->applyjob ?></span></a>
		<a href="<?php echo $this->baseUrl().'/recruiter/job/save-job'?>" class="pt-link-save"><?php echo $this->translate('Saved Jobs ')?><span class="no"><?php echo $this->savejob ?></span></a>
    </div>
</div> 
<?php /*
<script src="<?php echo $this->baseUrl().'/application/modules/Job/externals/scripts/custom.jobs.js'?>" type="text/javascript"></script>
*/ ?>

