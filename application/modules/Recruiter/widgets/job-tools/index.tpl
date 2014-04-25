<div class="subsection">
    <h2><?php echo $this->translate("Job Tools");?></h2>
    <div class="subcontent">
		<ul class="jobs_management">
			<li><a href="<?php echo $this->baseUrl().'/recruiter/job/job-status/st/approve' ?>"><?php echo $this->translate('Approved Jobs ')?>(<?php echo $this->job_approved ?>)</a></li>
    
            <li><a href="<?php echo $this->baseUrl().'/recruiter/job/job-status/st/pending'?>"><?php echo $this->translate('Pending Jobs ')?>(<?php echo $this->job_pending ?>)</a></li>
            <li><a href="<?php echo $this->baseUrl().'/recruiter/job/job-status/st/reject'?>"><?php echo $this->translate('Cancelled Jobs ')?>(<?php echo $this->job_reject ?>)</a></li>
    
		</ul>
		
    </div>
</div> 