<div class="subsection">
    <h2><?php echo $this->translate("Resume Tools");?></h2>
    <div class="subcontent">
		<ul class="jobs_management">
			<li class="first"><a href="<?php echo $this->baseUrl().'/resumes/resume/rs-status/st/approve' ?>"><?php echo $this->translate('Approved Resumes ')?>(<?php echo $this->resume_approved ?>)</a></li>
    
            <li class="first"><a href="<?php echo $this->baseUrl().'/resumes/resume/rs-status/st/pending'?>"><?php echo $this->translate('Pending Resumes ')?>(<?php echo $this->resume_pending ?>)</a></li>
            <li style="padding:10px 0;"><a href="<?php echo $this->baseUrl().'/resumes/resume/rs-status/st/reject'?>"><?php echo $this->translate('Cancelled Resumes ')?>(<?php echo $this->resume_reject ?>)</a></li>
    
		</ul>
		
    </div>
</div> 