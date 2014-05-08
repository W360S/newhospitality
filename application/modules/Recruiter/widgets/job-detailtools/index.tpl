<?php 
$job->job_id = $this->params['id'];
$user_id = $this->user_id;
?>
<div class="pt-block">
    <h3 class="pt-title-right">Quản lý việc làm</h3>
    <div class="pt-how-story">
            <?php //if ($job->deadline >= date('Y-m-d')) { ?>
        <a class="pt-link-resume" style="cursor: pointer;" onclick="apply_job('<?php echo $job->job_id; ?>')" ><?php echo $this->translate('Apply to this job') ?></a>
            <?php //} ?>
            <a class="pt-link-apply" style="cursor: pointer;" onclick="save_job('<?php echo $job->job_id; ?>')"><?php echo $this->translate('Save this job') ?></a>
            <a class="pt-link-save" href="<?php echo $this->baseUrl() . '/recruiter/job/send-email/job_id/' . $job->job_id ?>"><?php echo $this->translate('Email this job to a friend'); ?></a>
            <?php if ($user_id) { ?>
                <a class="pt-link-07" class="share_job smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/job/id/<?php echo $job->job_id ?>/format/smoothbox" ><?php echo $this->translate('Share to network') ?></a>
            <?php } ?>
    </div>
</div>