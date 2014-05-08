<?php
$paginators = $this->paginator;
$status = $this->status;
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
                        <th><?php echo $this->translate('Job Title'); ?></th>
                        <th><?php echo $this->translate('Company'); ?></th>

                        <th><?php echo $this->translate('Date Posted') ?></th>
                        <th><?php echo $this->translate("Modified Date") ?></th>
                        <?php if ($status == 'pending') { ?>
                            <th><?php echo $this->translate('Status') ?></th>
                        <?php } ?>
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
                            <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $paginator->job_id, 'slug' => $slug), $paginator->position, array('target' => '_blank')) ?>
                        </td>
                        <td style="text-align:left;"><?php if ($this->company($paginator->user_id)) echo $this->company($paginator->user_id)->company_name; ?></td>
                        <td><?php echo date('d F Y, g:i:a', strtotime($paginator->creation_date)); ?></td>
                        <td><?php echo date('d F Y, g:i:a', strtotime($paginator->modified_date)) ?></td>
                        <?php if ($status == 'pending') { ?>
                            <td>
                                <?php
                                echo $this->htmlLink(array('route' => 'default', 'module' => 'recruiter', 'controller' => 'job', 'action' => 'approve', 'id' => $paginator->job_id), $this->translate('approve'), array(
                                    'class' => 'smoothbox'
                                ))
                                ?>

                                |
                                <?php
                                echo $this->htmlLink(array('route' => 'default', 'module' => 'recruiter', 'controller' => 'job', 'action' => 'reject', 'id' => $paginator->job_id), $this->translate('reject'), array(
                                    'class' => 'smoothbox'
                                ))
                                ?>
                            </td>
                        <?php } ?>
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
