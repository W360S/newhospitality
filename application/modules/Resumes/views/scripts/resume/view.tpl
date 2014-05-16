<?php
    $resume= $this->resume; 
    $works= $this->works;
    $total_year= $this->total_year;
    $educations= $this->educations;
    $languages= $this->languages;
    $group_skills= $this->group_skill;
    $references= $this->references;
    $user_id= $this->user_id;
    $user_resume= $this->user_resume;
    $user_inform = $this->user_inform;
    $birthday = $this->birthday;
?>

<div class="pt-content-info">
    <h3 class="pt-title-right">thông tin hồ sơ</h3>
    <div class="pt-content-file-record">
        <div class="pt-title-file-record">
            <h3>Nhân viên kinh doanh</h3>
            <input type="hidden" value="<?php echo $resume->resume_id?>" id="resume" />
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
    
    <!--<a class="print_profile" href="<?php //echo $this->baseUrl() . '/resumes/resume/pdf/resume_id/' . $resume->resume_id ?>"><?php echo $this->translate("Print to profile"); ?></a>-->
</div>

<script type="text/javascript">
    function save_candidate() {
        var resume_id = $('resume').value;
        //alert(resume_id);return false;
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/save-resume' ?>";
        var href = window.location;
        if (confirm("<?php echo $this->translate('Do you really want to save this candidate?'); ?>")) {

            new Request({
                url: url,
                method: "post",
                data: {
                    'resume_id': resume_id
                },
                onSuccess: function(responseHTML)
                {
                    if (responseHTML == 1) {
                        $('save_success').style.display = 'block';
                    }

                    else {
                        $('save_success').style.display = 'block';
                        jQuery('#save_success').html('<?php echo $this->translate("Save faild!") ?>');
                    }

                }
            }).send();
        }
    }
</script>
