<?php
$paginators = $this->paginator;
?>
<div class="candidate_main_manage">


    <div id="loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>
    <?php if (count($paginators) > 0) { ?>
        <div class="job-list">
            <table cellspacing="0" cellpadding="0">
                <thead>
                    <tr>
                        <th style="text-align: center;"><?php echo $this->translate('Title Resume'); ?></th>
                        <th style="text-align: center;"><?php echo $this->translate('Full Name'); ?></th>
                        <th style="text-align: center;"><?php echo $this->translate('Date Saved'); ?></th>
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
                            <?php
                            $title = $this->resume($paginator->resume_id)->title;
                            if (!empty($title)) {
                                $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($title);
                                ?>
                                <a target="_blank" href="<?php echo $this->baseUrl() . '/resumes/resume/view/resume_id/' . $paginator->resume_id . '/' . $slug ?>"><?php echo $this->resume($paginator->resume_id)->title; ?></a>
                                <?php
                            } else {
                                echo $this->translate("<strong style='color:red'>Resume has been deleted</strong>");
                            }
                            ?>
                        </td>
                        <td class="title">
                            <?php //echo $this->user($paginator->per_id)->displayname; ?>
                        </td>

                        <td><?php echo date('d F Y', strtotime($paginator->date_saved)); ?></td>

                        <td class="">

                            <a href="javascript:void(0);" onclick="delete_save_candidate('<?php echo $paginator->candidate_id ?>')"><?php echo $this->translate('Delete'); ?></a>

                        </td>
                    </tr>

                <?php } ?>
            </table>
        </div>
    <?php } else { ?>
        <div class="tip" style="margin-top: 5px; margin-left: 5px;">
            <span>
                <?php echo $this->translate("There are no candidate") ?>
            </span>
        </div>
    <?php }
    ?>   
</div>

<?php echo $this->paginationControl($paginators); ?>
<script type="text/javascript">
    function delete_save_candidate(candidate_id) {
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/delete-save-resume-candidate' ?>";
        if (confirm("Do you really want to delete this candidate?")) {
            $('loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'candidate_id': candidate_id

                },
                onSuccess: function(responseHTML)
                {
                    $('loading').style.display = "none";

                    if (responseHTML == 1) {
                        //tam thoi cho redirect ve trang nay
                        window.location.href = "<?php echo $this->baseUrl() . '/recruiter/job/save-resume-candidate' ?>";
                    }

                }
            }).send();
        }
    }
</script>
