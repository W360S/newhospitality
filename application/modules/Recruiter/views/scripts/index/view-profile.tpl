<?php
$profile = $this->profile;
$industries = $this->industries;
$user_id = $this->user_id;
$paginator = $this->paginator_jobs;
?>
<div class="pt-title-event">
    <ul class="pt-menu-event pt-menu-libraries">
        <li>
            <a href="/recruiter">Dành cho nhà tuyển dụng</a>
        </li>
        <li>
            <span>Hồ sơ công ty </span>
        </li>
    </ul>
</div>
<div class="subsection">
    <div class="pt-job-detail-title pt-job-detail-title-first">
        <?php if ($profile->photo_id != null) { ?>
            <?php echo $this->itemPhoto($profile, 'thumb.icon'); ?>
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
        <?php 
            $user = Engine_Api::_()->getItem('user', $profile->user_id);
        ?>
        <p>Qui mô công ty: <?php echo $profile->company_size; ?><br>
            Tên người liên hệ: <a href="<?php echo $user->getHref() ?>"><?php echo $user->getTitle() ?></a></p>
        <?php if ($user_id == $profile->user_id) : ?>
            <a class="pt-icon pt-icon-checkall" href="<?php echo $this->baseUrl() . '/recruiter/index/edit-profile/profile_id/' . $profile->recruiter_id; ?>"></a>
            <?php /*
            <a class="pt-icon pt-icon-delete" href="javascript:void(0);" onclick="delete_profile('<?php echo $profile->recruiter_id; ?>');return false;"></a>
            */ ?>
            
            <?php endif; ?>
    </div>

    <div id="loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>

</div>
<div class="subsection search_result">
    <?php if (count($paginator) > 0): ?>
        <h3 class="pt-style-title">CÔNG VIỆC CỦA <?php echo $profile->company_name; ?></h3>
        <div class="pt-list-job">
            <ul class="pt-list-job-ul">
                <?php $i = 0; ?>
                <?php foreach ($paginator as $item): ?>
                    <?php $selected_types = Engine_Api::_()->getApi('job', 'recruiter')->getTypeOfJob($item->job_id); ?>
                    <?php $label = Engine_Api::_()->getApi('job', 'recruiter')->getJobLabels($selected_types); ?>
                    <li>
                        <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                        <div class="pt-lv1"><span class="<?php echo $label[0] ?>"><?php echo $label[1] ?></span></div>
                        <div class="pt-lv2">
                            <h3>
                                <?php $text = $item->position; ?>
                                <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $text) ?>
                            </h3>
                            <span>Company Name</span>
                        </div>
                        <div class="pt-lv3">
                            <p class="pt-address"><span></span><?php echo $this->city($item->city_id)->name ?></p>
                        </div>
                        <div class="pt-lv4">
                            <div class="pt-user-name">
                                <?php $user = $item->getUser(); ?>
                                <?php $avatar = $this->itemPhoto($user, 'thumb.icon', $user->getTitle()) ?>
                                <a href="<?php echo $user->getHref() ?>" class="pt-avatar">
                                    <?php echo $avatar ?>
                                </a>
                                <strong>Đăng bởi:</strong>
                                <p><a href="<?php echo $user->getHref() ?>"><?php echo $user->getTitle() ?></a><span>- <?php echo date('d F Y', strtotime($item->creation_date)); ?></span></p><p></p>
                            </div>
                        </div>
                    </li>
                <?php endforeach; ?>
            </ul>
            <div class="pt-paging">
                <?php echo $this->paginationControl($paginator); ?>
            </div>
        </div>
    <?php else: ?>
        <span>
            <?php echo $this->translate("Haven't job in company during this time.") ?>
        </span>
    <?php endif; ?>
</div>
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
                        //window.location.href = "<?php echo $this->baseUrl() . '/recruiter/' ?>";
                    }

                }
            }).send();
        }
    }
</script>