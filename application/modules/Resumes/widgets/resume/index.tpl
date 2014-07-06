<?php
$resume = $this->resume;
$works = $this->works;
$total_year = $this->total_year;
$educations = $this->educations;
$languages = $this->languages;
$group_skills = $this->group_skill;
$references = $this->references;
$user_id = $this->user_id;
$user_resume = $this->user_resume;
$re_candidate = $this->re_candidate;
$rated = $this->rated;
?>

<div class="resume_preview_main">
    <div id="video_rating" class="rating" onmouseout="rating_out();">
        <span id="rate_1" class="rating_star_big_generic" onclick="rate(1);"onmouseover="rating_over(1);"></span>
        <span id="rate_2" class="rating_star_big_generic" onclick="rate(2);" onmouseover="rating_over(2);"></span>
        <span id="rate_3" class="rating_star_big_generic" onclick="rate(3);" onmouseover="rating_over(3);"></span>
        <span id="rate_4" class="rating_star_big_generic" onclick="rate(4);"onmouseover="rating_over(4);"></span>
        <span id="rate_5" class="rating_star_big_generic" onclick="rate(5);" onmouseover="rating_over(5);"></span>
        <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate'); ?></span>
    </div>
    <div class="pt-content-info">
        <h3 class="pt-title-right">thông tin hồ sơ</h3>
        <div class="pt-content-file-record">
            <div class="pt-title-file-record">
                <h3><?php echo $resume->title; ?></h3>
                <input type="hidden" value="<?php echo $resume->resume_id ?>" id="resume" />
                <a href="#" class="pt-finger-prints"><img src="<?php echo $this->baseUrl() ?>/application/modules/Core/externals/img/thumb/PDF.png" alt="Image">In ra PDF</a>
            </div>
            <div class="pt-content-file">
                <div class="pt-content-file-title">
                    <div class="pt-lv-first">
                        <p>
                            <?php if (!empty($resume->path_image)): ?>
                                <img id="updateNewImage" class="thumb_profile item_photo_user  thumb_profile" alt="Profile Image" src="<?php echo $this->baseUrl() ?>/public/profile_recruiter/<?php echo $resume->path_image ?>">
                            <?php else: ?>
                                <?php
                                echo $this->itemPhoto($user_inform, 'thumb.profile', 'Profile Image', array('id' => 'updateNewImage'));
                                ?>
                            <?php endif; ?>
                        </p>
                        <?php if ($user_id == $user_resume): ?>
                            <p class="last"><a href="#" class="pt-edit">Chỉnh sửa</a></p>
                        <?php endif; ?>
                        <?php if ($user_id == $user_resume): ?>
                            <form style="display: none" method="post" id="updateImage"  enctype="multipart/form-data" action="<?php echo $this->baseUrl() . '/resumes/resume/image'; ?>">
                                <input style="padding-left: 8px;" type="file" id="fileImage" name="fileImage" />
                                <input type="hidden" name="fr_resume" value="<?php echo $resume->resume_id ?>" id="fr_resume" />
                                <input type="submit" value="<?php echo $this->translate('Update Image') ?>" style="cursor: pointer;" />
                                <img id="ajaxImageLoading" src='<?php echo $this->baseUrl() ?>/application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px; display:none;' />
                            </form>
                        <?php endif; ?>
                    </div>
                    <div class="pt-lv-second">
                        <h3>
                            <?php if (!empty($resume->username)): ?>
                                <?php echo $resume->username; ?>
                            <?php else: ?>
                                <?php echo $user_inform->displayname; ?>
                            <?php endif; ?>
                            <?php if ($user_id == $user_resume): ?>
                                <a href="javascript:void(0);" onclick="updateUsername('<?php echo $resume->resume_id ?>');"> <?php echo $this->translate("[Update]"); ?></a>
                            <?php endif; ?>
                        </h3>
                        <p><?php echo $gender; ?></p>
                        <p>Ngày sinh: <?php echo date('d m Y', strtotime($birthday)); ?></p>
                        <p>Địa chỉ: <?php echo $this->from ?></p>
                        <p>Điện thoại: <?php echo $this->phone ?>	</p>
                        <p>
                            <?php if (!empty($resume->email)): ?>
                                <?php echo $resume->email; ?>
                            <?php else: ?>
                                <?php echo $user_inform->email; ?>
                            <?php endif; ?>
                            <?php if ($user_id == $user_resume): ?>
                                <a href="javascript:void(0);" onclick="updateEmail('<?php echo $resume->resume_id ?>');"> <?php echo $this->translate("[Update]"); ?></a>
                            <?php endif; ?>
                        </p>
                    </div>
                </div>
                <div class="pt-content-file-block">
                    <div class="pt-lv-first">
                        <h3>Kinh nghiệm làm việc</h3>
                        <?php if ($user_id == $user_resume) { ?>
                            <a  class="pt-edit" href="<?php echo $this->baseUrl() . '/resumes/index/resume-work/id/' . $resume->resume_id ?>"><?php echo $this->translate('[Edit]') ?></a>
                        <?php } ?>
                    </div>
                    <div class="pt-lv-second">
                        <?php foreach ($works as $work): ?>
                            <h3><?php echo $this->level($work->level_id)->name; ?> - <?php echo $this->category($work->category_id)->name; ?> tại <?php echo $work->title; ?></h3>
                            <p>Tháng 6/2012 đến Tháng 6/2013</p>
                            <p><?php echo $work->description; ?></p>
                            <br>
                        <?php endforeach; ?>
                    </div>
                </div>
                <div class="pt-content-file-block">
                    <div class="pt-lv-first">
                        <h3>Học vấn</h3>
                        <?php if (count($works) && $user_id == $user_resume) { ?>
                            <a class="pt-edit" href="<?php echo $this->baseUrl() . '/resumes/education/index/resume_id/' . $resume->resume_id ?>"><?php echo $this->translate('[Edit]') ?></a>
                        <?php } ?>
                    </div>
                    <div class="pt-lv-second">
                        <?php foreach ($educations as $education): ?>
                            <h3><?php echo $education->school_name; ?></h3>
                            <p><?php echo $this->degree($education->degree_level_id)->name; ?> - <?php echo $education->major; ?> - Tháng 6/2011 đến Tháng 10/2013</p>
                            <p><?php echo $education->description; ?></p>
                            <br>
                        <?php endforeach; ?>
                    </div>
                </div>
                <div class="pt-content-file-block">
                    <div class="pt-lv-first">
                        <h3>Kĩ năng</h3>
                        <?php if (count($works) && count($educations) && $user_id == $user_resume) { ?>
                            <a class="pt-edit" href="<?php echo $this->baseUrl() . '/resumes/skill/index/resume_id/' . $resume->resume_id ?>"><?php echo $this->translate('[Edit]') ?></a>
                        <?php } ?>
                    </div>
                    <div class="pt-lv-second">
                        <?php if (count($languages) > 0): ?>
                            <h3><?php echo $this->translate("Language") ?></h3>
                            <?php foreach ($languages as $language): ?>
                                <p>
                                    <?php echo $this->language($language->language_id)->name; ?> - <?php echo $this->groupSkill($language->group_skill_id)->name; ?>
                                </p>
                            <?php endforeach; ?>
                        <?php endif; ?>

                        <?php if (count($group_skills) > 0): ?>
                            <?php foreach ($group_skills as $group_skill): ?>
                                <h3 class="pt-fix-mt"><?php echo $group_skill->name; ?></h3>
                                <p><?php echo $group_skill->description; ?></p>
                            <?php endforeach; ?> 
                        <?php endif; ?>
                    </div>
                </div>
                <div class="pt-content-file-block">
                    <div class="pt-lv-first">
                        <h3>Tham khảo</h3>
                        <?php if (count($works) && count($educations) && $user_id == $user_resume) { ?>
                            <a class="pt-edit" href="<?php echo $this->baseUrl() . '/resumes/reference/index/resume_id/' . $resume->resume_id ?>"><?php echo $this->translate('[Edit]') ?></a>
                        <?php } ?>
                    </div>
                    <div class="pt-lv-second">
                        <?php if (count($references) > 0): ?>
                            <?php foreach ($references as $reference): ?>
                                <h3><?php echo $reference->name; ?></h3>
                                <p><?php echo $reference->title; ?></p>
                                <p>Email: <?php echo $reference->phone ?> - Điện thoại: <?php $reference->email; ?></p>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>


        <div id="save_success" style="padding-bottom: 10px; display:none; color: red;"><?php echo $this->translate('You have been saved this candidate successfully!') ?></div>

<!--<a class="print_profile" href="<?php //echo $this->baseUrl() . '/resumes/resume/pdf/resume_id/' . $resume->resume_id  ?>"><?php echo $this->translate("Print to profile"); ?></a>-->
    </div>

</div>
<script type="text/javascript">
    var pre_rate = <?php echo $re_candidate->rating; ?>;
    var applyjob_id = <?php echo $re_candidate->applyjob_id; ?>;
    var rated = <?php echo $rated; ?>;
    function set_rating() {
        var rating = pre_rate;

        if (rated > 0) {
            $('rating_text').innerHTML = "<?php echo $this->translate('you already rated'); ?>";

        } else {
            $('rating_text').innerHTML = "<?php echo $this->translate('click to rate'); ?>";
        }
        for (var x = 1; x <= parseInt(rating); x++) {
            $('rate_' + x).set('class', 'rating_star_big_generic rating_star_big');
        }

        for (var x = parseInt(rating) + 1; x <= 5; x++) {
            $('rate_' + x).set('class', 'rating_star_big_generic rating_star_big_disabled');
        }

        var remainder = Math.round(rating) - rating;
        if (remainder <= 0.5 && remainder != 0) {
            var last = parseInt(rating) + 1;
            $('rate_' + last).set('class', 'rating_star_big_generic rating_star_big_half');
        }
    }
    function rating_over(rating) {

        //if (rated >0){
        //$('rating_text').innerHTML = "<?php echo $this->translate('you already rated'); ?>";

        //}else{
        $('rating_text').innerHTML = "<?php echo $this->translate('click to rate'); ?>";
        for (var x = 1; x <= 5; x++) {
            if (x <= rating) {
                $('rate_' + x).set('class', 'rating_star_big_generic rating_star_big');
            } else {
                $('rate_' + x).set('class', 'rating_star_big_generic rating_star_big_disabled');
            }
        }
        //}
    }
    function rating_out() {

        //$('rating_text').innerHTML = " <?php echo $this->translate(array('%s rating', '%s ratings', $this->rating_count), $this->locale()->toNumber($this->rating_count)) ?>";
        if (pre_rate != 0) {
            set_rating();
        }
        else {
            for (var x = 1; x <= 5; x++) {
                $('rate_' + x).set('class', 'rating_star_big_generic rating_star_big_disabled');
            }
        }
    }
    function rate(rating) {
        $('rating_text').innerHTML = "<?php echo $this->translate('Thanks for rating!'); ?>";
        for (var x = 1; x <= 5; x++) {
            $('rate_' + x).set('onclick', '');
        }
        (new Request.JSON({
            'format': 'json',
            'url': '<?php echo $this->url(array('module' => 'recruiter', 'controller' => 'job', 'action' => 'rate'), 'default', true) ?>',
            'data': {
                'format': 'json',
                'rating': rating,
                'applyjob_id': applyjob_id
            },
            'onRequest': function() {
                pre_rate = rating;
                set_rating();
            },
            'onSuccess': function(responseJSON, responseText)
            {
                rated = 1;
            }
        })).send();

    }
    window.addEvent('domready', function() {
        set_rating();
    });
</script>
