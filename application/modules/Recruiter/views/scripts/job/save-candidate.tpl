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
                        <th align="center"><?php echo $this->translate('Full Name'); ?></th>
                        <th align="center"><?php echo $this->translate('Experience'); ?></th>
                        <th align="center"><?php echo $this->translate('Applied in'); ?></th>
                        <th align="center"><?php echo $this->translate('Rating') ?></th>
                        <th align="center"><?php echo $this->translate('Notes') ?></th>
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
                            <a href="<?php echo $this->baseUrl() . '/recruiter/job/candidate/apply/' . $paginator->applyjob_id ?>"><?php echo $this->user($paginator->user_id)->displayname; ?></a>
                        </td>
                        <td>
                            <?php echo $this->countExperience($paginator->resume_id) . " years"; ?>
                        </td>
                        <td><?php echo date('d F Y', strtotime($paginator->creation_date)); ?></td>
                        <td>
                            <?php
                            $rating = $paginator->rating;
                            if ($rating > 0) {
                                for ($x = 1; $x <= $rating; $x++) {
                                    ?>
                                    <span class="rating_star_generic rating_star"></span>
                                    <?php
                                }


                                $remainder = round($rating) - $rating;
                                if (($remainder <= 0.5 && $remainder != 0)):
                                    ?><span class="rating_star_generic rating_star_half"></span><?php
                                endif;
                                if (($rating <= 4)) {
                                    for ($i = round($rating) + 1; $i <= 5; $i++) {
                                        ?>
                                        <span class="rating_star_generic rating_star_disabled"></span>  
                                        <?php
                                    }
                                }
                            } else {
                                for ($x = 1; $x <= 5; $x++) {
                                    ?>
                                    <span class="rating_star_generic rating_star_disabled"></span> 
                                    <?php
                                }
                            }
                            ?>
                        </td>
                        <td>
                            <?php
                            $notes = $this->note($paginator->applyjob_id);
                            ?>
                            <?php
                            if (!empty($notes)) {
                                foreach ($notes as $note) {
                                    ?>

                                    <?php echo $note->description; ?>(<span style="font-size: 9px;" ><?php echo date('d F Y', strtotime($note->creation_date)) ?></span>)
                                    <br />

                                    <?php
                                }
                            }
                            ?>
                        </td>
                        <td class="action">
                            <a href="<?php echo $this->baseUrl() . '/recruiter/job/candidate/apply/' . $paginator->applyjob_id ?>"><?php echo $this->translate('View Applicant'); ?></a> |

                            <a href="javascript:void(0);" onclick="delete_save_candidate('<?php echo $paginator->applyjob_id ?>')"><?php echo $this->translate('Delete'); ?></a>

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
    function delete_save_candidate(applyjob_id) {
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/delete-save-candidate' ?>";
        if (confirm("Do you really want to delete this candidate?")) {
            $('loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'applyjob_id': applyjob_id

                },
                onSuccess: function(responseHTML)
                {
                    $('loading').style.display = "none";

                    if (responseHTML == 1) {
                        //tam thoi cho redirect ve trang nay
                        window.location.href = "<?php echo $this->baseUrl() . '/recruiter/job/save-candidate' ?>";
                    }

                }
            }).send();
        }
    }
</script>
