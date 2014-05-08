<?php
$paginators = $this->paginator;
?>
<div class="job_main_manage">
    <div id="loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>
    <?php if (!empty($paginators) && count($paginators)) { ?>
        <div class="job-list">
            <table cellspacing="0" cellpadding="0">
                <thead>
                    <tr>
                        <th align="center"><?php echo $this->translate('Job Title'); ?></th>
                        <th align="center"><?php echo $this->translate('Status'); ?></th>
                        <th align="center"><?php echo $this->translate('Created date'); ?></th>
                        <th></th>
                    </tr>
                </thead>
                <?php
                $i = 0;
                foreach ($paginators as $paginator) {
                    $i++;
                    if ($i % 2 == 0) {
                        $class = "back_gr_gray";
                    } else {
                        $class = "";
                    }
                    ?>

                    <tr>
                        <td class="title">
                            <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($paginator->position); ?>
                            <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $paginator->job_id, 'slug' => $slug), $paginator->position) ?>
                        </td>
                        <td>
                            <?php
                            $status = $paginator->status;
                            if ($status == 1 && ($paginator->deadline >= date('Y-m-d'))) {
                                echo $this->translate("Pending");
                            } else if ($status == 2 && ($paginator->deadline >= date('Y-m-d'))) {
                                echo $this->translate("Active");
                            } else if ($paginator->deadline < date('Y-m-d')) {
                                echo $this->translate("Expired");
                            }
                            ?>
                        </td>
                        <td><?php echo date('d F Y', strtotime($paginator->creation_date)); ?></td>
                        <td class="action">
                            <a href="<?php echo $this->baseUrl() . '/recruiter/job/view-candidate/job_id/' . $paginator->job_id; ?>"><?php echo $this->translate('Candidates'); ?>
                                (<?php echo $paginator->num_apply; ?>)
                            </a>
                            |
                            <a href="<?php echo $this->baseUrl() . '/recruiter/job/edit/job_id/' . $paginator->job_id; ?>"><?php echo $this->translate('Edit'); ?></a>
                            |
                            <a href="javascript:void(0);" onclick="delete_job('<?php echo $paginator->job_id ?>')"><?php echo $this->translate('Delete'); ?></a>

                        </td>
                    </tr>

                <?php } ?>
            </table>
        </div>
    <?php } else { ?>
        <div class="tip">
            <span>
                <?php echo $this->translate("There are no jobs.") ?>
            </span>
        </div>
    <?php }
    ?>   
</div>
<?php echo $this->paginationControl($paginators); ?>

<script type="text/javascript">
    function delete_job(job_id) {
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/delete-job' ?>";
        if (confirm("Do you really want to delete this job?")) {
            $('loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'job_id': job_id

                },
                onSuccess: function(responseHTML)
                {
                    $('loading').style.display = "none";

                    if (responseHTML == 1) {
                        //tam thoi cho redirect ve trang nay
                        window.location.href = "<?php echo $this->baseUrl() . '/recruiter/job/manage' ?>";
                    }

                }
            }).send();
        }
    }
</script>
