
<?php
$apply= $this->apply; 
$candidate= $this->candidate;
?>
 <h2><?php echo $this->translate('Applicant Letter')?></h2>
    <div class="job_description">
            <p><label><?php echo $this->translate('Subject: ')?></label> <span><strong><?php echo $candidate->title;?> </strong></span></p>
            
            <p>
                <label><?php echo $this->translate('Cover letter: ')?></label>
                
            </p>
            <div class="description_job">
                <?php echo $candidate->content;?>
            </div>
            <p>
            <label><?php echo $this->translate('Resume: ');?></label>
            <span><a target="_blank" href="<?php echo $this->baseUrl().'/resumes/index/preview/resume_id/'.$candidate->resume_id ?>"><?php echo $this->resume($candidate->resume_id)->title; ?></a></span>
            </p>
            <?php if(!empty($this->storage)){?>
                <p><label><?php echo $this->translate('Attachment: ')?></label>
                <a href="<?php echo $this->baseUrl("/").$this->storage->storage_path; ?>"><?php $size = round($this->storage->size/1024,2); echo $this->storage->name. " (".$size." KB)"; ?></a>
                </p>
            <?php }?>
            
   </div>
