<div class="pt-block">
    <h3 class="pt-title-right">Quản trị hồ sơ</h3>
    <div class="pt-how-story">
        <a class="pt-link-17" href="<?php echo $this->baseUrl() . '/recruiter/job/job-status/st/approve' ?>"><?php echo $this->translate('Approved Jobs ') ?><span><?php echo $this->job_approved ?></span></a>
        <a class="pt-link-17" href="<?php echo $this->baseUrl() . '/recruiter/job/job-status/st/pending' ?>"><?php echo $this->translate('Pending Jobs ') ?><span><?php echo $this->job_pending ?></span></a>
        <a class="pt-link-18" href="<?php echo $this->baseUrl() . '/recruiter/job/job-status/st/reject' ?>"><?php echo $this->translate('Cancelled Jobs ') ?><span><?php echo $this->job_reject ?></span></a>
    </div>
</div>
<?php
/*
  <div class="subsection">
  <h2><?php echo $this->translate("Job Tools"); ?></h2>
  <div class="subcontent">
  <ul class="jobs_management">
  <li><a href="<?php echo $this->baseUrl() . '/recruiter/job/job-status/st/approve' ?>"><?php echo $this->translate('Approved Jobs ') ?>(<?php echo $this->job_approved ?>)</a></li>
  <li><a href="<?php echo $this->baseUrl() . '/recruiter/job/job-status/st/pending' ?>"><?php echo $this->translate('Pending Jobs ') ?>(<?php echo $this->job_pending ?>)</a></li>
  <li><a href="<?php echo $this->baseUrl() . '/recruiter/job/job-status/st/reject' ?>"><?php echo $this->translate('Cancelled Jobs ') ?>(<?php echo $this->job_reject ?>)</a></li>
  </ul>
  </div>
  </div>
 * 
 */?>