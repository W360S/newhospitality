<?php
$profile = $this->profile;
$industries = $this->industries;
?>
<?php if (!empty($profile)) { ?>
    <div class="pt-job-detail-title">
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
        <p>Qui mô công ty: <?php echo $profile->company_size; ?>
            <!--            
            <br>
                        Tên người liên hệ: Ms. Cat Tuong
            -->
        </p>
    </div>
<?php } ?>