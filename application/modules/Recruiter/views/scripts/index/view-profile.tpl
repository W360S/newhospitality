<?php
$profile = $this->profile;
$industries = $this->industries;
$user_id = $this->user_id;
$paginator = $this->paginator_jobs;
?>
<div class="subsection">
    <div class="pt-job-detail-title pt-job-detail-title-01">
        <?php if ($profile->photo_id != null) { ?>
            <?php echo $this->itemPhoto($profile, 'thumb.profile'); ?>
        <?php } else { ?>
            <img src='application/modules/Job/externals/images/no_image.gif' class="thumb_profile item_photo_recruiter  thumb_profile" />
        <?php } ?>
        <h4><?php echo $profile->company_name; ?></h4>
        <span>
            <?php
            $i = 0;
            foreach ($industries as $industry) {
                $i++;
                if ($i == count($industries)) {
                    echo $this->categoryJob($industry->industry_id)->name;
                } else {
                    echo $this->categoryJob($industry->industry_id)->name . " - ";
                }
            }
            ?>
        </span>
        <p><?php echo $profile->description; ?></p>
        <p>Qui mô công ty: <?php echo $profile->company_size; ?><br>
            Tên người liên hệ: Ms. Cat Tuong</p>
        <?php if ($user_id == $profile->user_id) : ?>
            <a class="pt-icon pt-icon-01" href="<?php echo $this->baseUrl() . '/recruiter/index/edit-profile/profile_id/' . $profile->recruiter_id; ?>"></a>
            <a class="pt-icon pt-icon-02" href="javascript:void(0);" onclick="delete_profile('<?php echo $profile->recruiter_id; ?>');
                    return false;"></a>
           <?php endif; ?>
    </div>

    <div id="loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>

</div>
<div class="subsection search_result">

    <h2><?php echo $this->translate('Jobs of '); ?><?php echo $profile->company_name; ?></h2>
    <?php if (count($paginator) > 0): ?>
        <table cellspacing="0" cellpadding="0">
            <tr>
                <th style="width:240px"><?php echo $this->translate("Job Title"); ?></th>

                <th style="width:92px"><?php echo $this->translate("Location"); ?></th>
                <th><?php echo $this->translate("Date Posted"); ?></th>
            </tr>
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
                <tr class="<?php echo $class ?>">
                    <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                    <td class="align_l"><?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $item->position, array('target' => '_blank')) ?></td>

                    <td><?php echo $this->city($item->city_id)->name ?> - <?php echo $this->country($item->country_id)->name; ?></td>
                    <td><?php echo date('d F Y', strtotime($item->creation_date)); ?></td>
                </tr>
            <?php endforeach; ?>
        </table>
    <?php else: ?>
        <div style="margin-top: 5px; margin-left: 5px;" class="tip">
            <span>
                <?php echo $this->translate("Haven't job in company during this time.") ?>
            </span>
        </div>

    <?php endif; ?>
</div>
<?php if (count($paginator) > 0): ?>
    <?php echo $this->paginationControl($paginator); ?>
<?php endif; ?>
<script type="text/javascript">
    function delete_profile(profile_id) {
        var url = "<?php echo $this->baseUrl() . '/recruiter/index/delete-profile' ?>";
        if (confirm("Do you really want to delete this profile?")) {
            $('loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'profile_id': profile_id

                },
                onSuccess: function(responseHTML)
                {
                    $('loading').style.display = "none";
                    if (responseHTML == 1) {
                        //tam thoi cho redirect ve trang nay
                        window.location.href = "<?php echo $this->baseUrl() . '/recruiter/' ?>";
                    }

                }
            }).send();
        }
    }
</script>