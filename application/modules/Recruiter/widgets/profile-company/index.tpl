<?php
$profile = $this->profile;
$industries = $this->industries;

$user = Engine_Api::_()->getApi('core','user')->getUser($profile->user_id);

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
            Đăng bởi: <a href="<?php echo $user->getHref() ?>"><?php echo $user->getTitle() ?></a> vào lúc <?php echo $this->timestamp($profile->creation_date, array('notag' => 1)) ?>
        </span>
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
        <p class="no-space">Qui mô công ty: <?php echo $profile->company_size; ?><br>
            <p class="no-space">Website: <?php echo $profile->website; ?><br>
            <p class="no-space">Số Điện Thoại: <?php echo $profile->phone; ?><br>
            <p class="no-space">Địa chỉ: <?php echo $profile->address; ?><br>
        </p>
    </div>
<?php } ?>