<?php
$resumes = $this->resumes;
$paginator = $this->paginator;
$viewer_id = $this->viewer_id;
$paginator_jobs = $this->paginator_jobs;
?>
<div class="resume_preview_main">
    <div class="subsection">
        <h2><?php echo $this->translate('My Resumes') ?></h2>
        <div id="resume_loading" style="display: none;">
            <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
            <?php echo $this->translate("Loading ...") ?>
        </div>
        <div id="list_resume" class="pt-list-table">
            <?php if (count($resumes)) : ?>
                <table cellspacing="0" cellpadding="0">
                    <tr>
                        <th><?php echo $this->translate('Resume Title') ?></th>
                        <th><?php echo $this->translate('Status'); ?></th>
                        <th><?php echo $this->translate('Date Modified') ?></th>
                        <th><?php echo $this->translate('Options ') ?></th>
                    </tr>   
                    <?php $i = 1; ?>
                    <?php foreach ($resumes as $resume) : ?>
                        <tr <?php if ($i % 2 == 0) echo "class='odd'" ?>>
                            <?php $i++; ?>
                            <td>
                                <?php echo $resume->title; ?>
                            </td>
                            <td>
                                <?php
                                if ($resume->approved == 1) {
                                    echo "<span style='color: #64A700;font-style:italic;font-size:10px;'>" . $this->translate('Approved') . "</span>";
                                    ?><img src="<?php echo $this->baseUrl() . '/application/modules/Resumes/externals/images/approve.gif' ?>" />
                                    <?php
                                } else if ($resume->approved == 0) {
                                    echo "<span style='color:red;font-style:italic;font-size:10px;'>" . $this->translate('Incomplete') . "</span>";
                                    ?>  
                                    <?php
                                } else {
                                    echo "<span style='font-style:italic;font-size:10px;'>" . $this->translate('Pending for approval') . "</span>";
                                }
                                ?>
                            </td>
                            <td>
                                <?php echo date('d F Y', strtotime($resume->modified_date)); ?>
                            </td>
                            <td>
                                <a class="pt-icon-detele" href="<?php echo $this->baseUrl() . '/resumes/index/preview/resume_id/' . $resume->resume_id ?>"></a>
                                <a class="pt-icon-edit" href="javascript:void(0);" onclick="javascript:delete_resume('<?php echo $resume->resume_id ?>');"></a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </table>
            <?php else: ?>
                <div class="tip">
                    <span>
                        <?php echo $this->translate("You have not create resume.") ?>
                    </span>
                </div>
            <?php endif; ?>
        </div>
        <a href="javascript:void(0)" class="pt-to-news" onclick="javascript:create_resume();return false;">Tạo mới</a>
    </div>
    
    <div class="subsection">
        <h2><?php echo $this->translate('My Jobs Saved'); ?></h2>
        <?php if (count($paginator)): ?>
            <div class="pt-list-table">
                <table>
                    <tr>
                        <th><?php echo $this->translate("Position") ?></th>
                        <th><?php echo $this->translate("Company") ?></th>
                        <th><?php echo $this->translate("Date Saved") ?></th>
                        <th><?php echo $this->translate("Status") ?></th>

                    </tr>
                    <tbody>
                        <?php
                        $i = 0;
                        foreach ($paginator as $item):
                            $i++;
                            if ($i % 2 == 0) {
                                $class = "bg_color";
                            } else {
                                $class = "";
                            }
                            ?>
                            <tr class="<?php echo $class; ?>">
                                <td>
                                    <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                                    <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $item->position) ?>
                                </td>
                                <td><?php echo $this->company($item->user_id)->company_name; ?></td>
                                <td><?php echo date('d F Y', strtotime($this->saveJob($item->job_id, $viewer_id)->date_saved)); ?></td>
                                <td>
                                    <?php
                                    $status = $this->saveJob($item->job_id, $viewer_id)->status;
                                    if ($status == 0) {
                                        ?>

                                        <a class="apply" href="<?php echo $this->baseUrl() . '/recruiter/job/apply-job/job_id/' . $item->job_id ?>" ><?php echo $this->translate('Apply'); ?></a>
                                        <?php
                                    } else {
                                        echo $this->translate('Applied');
                                    }
                                    ?>
                                </td>

                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
            <br />    
        <?php else: ?>
            <div class="tip">
                <span>
                    <?php echo $this->translate("There are no jobs.") ?>
                </span>
            </div>

        <?php endif; ?>
    </div>

    <div class="subsection">
        <h2><?php echo $this->translate('Jobs Matching your resumes'); ?></h2>

        <?php if (count($paginator_jobs)): ?>
            <div class="banner_your_resumes">
                <img src="<?php echo $this->baseUrl() . '/application/modules/Resumes/externals/images/img_banner_resume.jpg' ?>" alt="Banner" />
                <p><strong><?php echo $this->translate("Found ") . $paginator_jobs->getTotalItemCount() . $this->translate(" jobs matching your resume.") ?></strong></p>
                <p><?php echo $this->translate('There are no exact matching jobs, but below are the closest we could find in our system.'); ?></p>

            </div>

            <div class="list_job_saved">
                <table class='admin_table' cellspacing="0" cellpadding="0">

                    <tr>
                        <th style="width:270px"><?php echo $this->translate("Position") ?></th>
                        <th style="width:120px"><?php echo $this->translate("Company") ?></th>
                        <th style="width:92px"><?php echo $this->translate("Location") ?></th>

                    </tr>

                    <tbody>
                        <?php
                        $i = 0;
                        foreach ($paginator_jobs as $item):
                            $i++;
                            if ($i % 2 == 0) {
                                $class = "bg_color";
                            } else {
                                $class = "";
                            }
                            ?>
                            <tr class="<?php echo $class ?>">

                                <td >
                                    <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                                    <strong><?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $item->position) ?></strong>

                                </td>
                                <td><?php echo $this->company($item->user_id)->company_name; ?></td>
                                <td>
                                    <?php echo $this->city($item->city_id)->name; ?> - <?php echo $this->country($item->country_id)->name; ?>
                                </td>

                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
            <br />    
        <?php else: ?>
            <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                <span>
                    <?php echo $this->translate("There are no jobs.") ?>
                </span>
            </div>

        <?php endif; ?>
    </div>
    <?php if (count($paginator_jobs) > 0) { ?>
        <div>
            <?php echo $this->paginationControl($paginator_jobs); ?>
        </div>
    <?php } ?>
</div>
<script type="text/javascript">
    function create_resume() {
        var url = "<?php echo $this->baseUrl() . '/resumes/index/resume-info' ?>";
        window.location.href = url;
    }
    function delete_resume(resume_id) {
        var url = "<?php echo $this->baseUrl() . '/resumes/resume/delete' ?>";
        if (confirm("<?php echo $this->translate('Do you really want to delete this resume?'); ?>")) {
            $('resume_loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'resume_id': resume_id

                },
                onSuccess: function(responseHTML)
                {

                    $('resume_loading').style.display = "none";
                    if (responseHTML == 1) {
                        var url = "<?php echo $this->baseUrl() . '/resumes/resume/list' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            onSuccess: function(responseHTML)
                            {
                                //alert(responseHTML);
                                $('list_resume').set('html', responseHTML);
                            }
                        }).send();
                    }
                    else {
                        alert("Can't delete this resume");
                    }

                }
            }).send();
        }
    }
</script>