<div class="pt-block">
        <h3 class="pt-title-right">Quản lý TUYỂN DỤNG</h3>
        <div class="pt-how-story">
                <a href="<?php echo $this->baseUrl().'/recruiter/job/manage' ?>" class="pt-link-04"><?php echo $this->translate('Posted Jobs')?></a>
                <a href="<?php echo $this->baseUrl().'/recruiter/job/save-candidate'?>" class="pt-link-16">
                    <?php echo $this->translate('Saved Candidates')?><span><?php echo $this->save_candidates ?></span>
                </a>
                <a href="<?php echo $this->baseUrl().'/recruiter/job/save-resume-candidate'?>" class="pt-link-16">
                    <?php echo $this->translate('Saved Resumes')?><span><?php echo $this->save_resume_candidates ?></span>
                </a>
        </div>
</div>
<?php /*
<style type="text/css">
ul.jobs_management li.first{padding:10px 0;border-bottom:1px solid #e5e5e5}
</style>

<div class="subsection">
    <h2><?php echo $this->translate("Recruiting Management");?></h2>
    <div class="subcontent">
		<ul class="jobs_management">
            <li class="first"><a href="<?php echo $this->baseUrl().'/recruiter/job/manage' ?>"><?php echo $this->translate('Posted Jobs')?> <span>(<?php echo $this->posted_jobs ?>)</span></a></li>
            <li class="first" style="padding-left:0px;"><a href="<?php echo $this->baseUrl().'/recruiter/job/save-candidate'?>"><?php echo $this->translate('Saved Candidates')?><span>(<?php echo $this->save_candidates ?>)</span></a></li>
            <li style="padding-left:0px;"><a href="<?php echo $this->baseUrl().'/recruiter/job/save-resume-candidate'?>"><?php echo $this->translate('Saved Resumes')?><span>(<?php echo $this->save_resume_candidates ?>)</span></a></li>
           
		</ul>	
    </div>
</div>
*/ ?>