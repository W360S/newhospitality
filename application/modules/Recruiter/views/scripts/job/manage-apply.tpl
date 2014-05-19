<?php
$paginator = $this->paginator;
$user_id = $this->user_id;
?>
<div class="pt-title-event">
    <ul class="pt-menu-event pt-menu-libraries">
        <li>
            <a href="/resumes/">Người tìm việc</a>
        </li>
        <li>
            <span>Hồ sơ đã nộp</span>
        </li>
    </ul>
</div>
<div class="job_main_manage">

    <div id="loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>
    <?php if (count($paginator)): ?>
        <div class="pt-list-table">
            <table cellspacing="0" cellpadding="0">
                <thead>
                    <tr>                                        
                        <th><strong><?php echo $this->translate("Position") ?></strong></th>
                        <th><strong><?php echo $this->translate("Company") ?></strong></th>
                        <!--<th><?php //echo $this->translate("Salary")   ?></th>-->
                        <th style="width:115px"><strong><?php echo $this->translate("Created Date") ?></strong></th>
                        <th style="width:170px"><strong><?php echo $this->translate("Action") ?></strong></th>

                    </tr>
                </thead>
                <tbody>
                    <?php
                    $i = 0;
                    foreach ($paginator as $item):
                        $i++;
                        if ($i % 2 == 0) {
                            $class = "odd";
                        } else {
                            $class = "";
                        }
                        ?>
                        <tr class="<?php echo $class; ?>">

                            <td>
                                <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                                <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $item->position, array('target' => '_blank')) ?>

                            </td>
                            <td><?php echo $this->company($item->user_id)->company_name; ?></td>
                            <!--<td><?php //echo $item->salary;  ?></td>-->
                            <td><?php echo date('d F Y', strtotime($item->creation_date)); ?></td>

                            <td class="action">
                                <?php $applyjob_id = $this->applyJob($user_id, $item->job_id)->applyjob_id; ?>
                                <a target="_blank" href="<?php echo $this->baseUrl() . '/recruiter/job/my-apply/apply/' . $applyjob_id ?>"><?php echo $this->translate('View applied'); ?></a> |
                                <a href="javascript:void(0);" onclick="delete_apply('<?php echo $item->job_id ?>')"><?php echo $this->translate('Delete') ?></a>
                            </td>

                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    <?php else: ?>
        <div style="margin-top: 5px; margin-left: 5px;" class="tip">
            <span>
                <?php echo $this->translate("There are no jobs applied.") ?>
            </span>
        </div>

    <?php endif; ?>

</div>
<script type="text/javascript">
    function delete_apply(job_id) {
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/delete-apply' ?>";
        if (confirm("Do you really want to delete this apply job?")) {
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
                        window.location.href = "<?php echo $this->baseUrl() . '/recruiter/job/manage-apply' ?>";
                    }

                }
            }).send();
        }
    }
</script>