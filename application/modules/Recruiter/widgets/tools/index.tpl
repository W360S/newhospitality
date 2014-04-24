<div class="job_manage_tool subsection">
 <h2>
      <?php echo $this->translate('Tools') ?>
 </h2>

 <ul>
    <li class="apply_job"><a href="<?php echo $this->baseUrl().'/recruiter/job/apply-job/job_id/'.$this->job_id ?>"><?php echo $this->translate('Apply to this job')?></a></li>
    
    <li class="save_job"><a href="<?php echo $this->baseUrl().'/recruiter/job/save-job/job_id/'.$this->job_id ?>"><?php echo $this->translate('Save this job')?></a></li>
    
 </ul>

</div>