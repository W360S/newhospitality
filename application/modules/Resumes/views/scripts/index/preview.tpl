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
$user_inform = $this->user_inform;
$gender = $this->gender;
$birthday = $this->birthday;
?>
<div class="subsection">
    <h2><?php echo $this->translate('Resume Information') ?></h2>
    <div class="pt-content-file-record">
        <div class="pt-title-file-record">
            <h3><?php echo $resume->title; ?>
                <?php if ($user_id == $user_resume) { ?>
                    <a class="pt-edit" href="<?php echo $this->baseUrl() . '/resumes/index/resume-info-edit/resume_id/' . $resume->resume_id ?>"></a>
                <?php } ?>
            </h3>
            <a class="pt-finger-prints" target="_blank" href="<?php echo $this->baseUrl() . '/resumes/resume/pdf/resume_id/' . $resume->resume_id ?>">
                <img src="<?php echo $this->baseUrl() ?>/application/modules/Core/externals/img/thumb/PDF.png" alt="Image"><?php echo $this->translate("Print to Pdf"); ?>
            </a>
        </div>
        <div class="pt-content-file">
            <div class="pt-content-file-title">
                <div class="pt-lv-01">
                    <p>
                        <?php if (!empty($resume->path_image)): ?>
                            <img id="updateNewImage" class="thumb_profile item_photo_user  thumb_profile" alt="Profile Image" src="<?php echo $this->baseUrl() ?>/public/profile_recruiter/<?php echo $resume->path_image ?>">
                        <?php else: ?>
                            <?php
                            echo $this->itemPhoto($user_inform, 'thumb.profile', 'Profile Image', array('id' => 'updateNewImage'));
                            ?>
                        <?php endif; ?>
                    </p>
                    <p class="last"><a href="#" class="pt-edit">Chỉnh sửa</a></p>
                    <?php if ($user_id == $user_resume): ?>
                        <form style="display: none" method="post" id="updateImage"  enctype="multipart/form-data" action="<?php echo $this->baseUrl() . '/resumes/resume/image'; ?>">
                            <input style="padding-left: 8px;" type="file" id="fileImage" name="fileImage" />
                            <input type="hidden" name="fr_resume" value="<?php echo $resume->resume_id ?>" id="fr_resume" />
                            <input type="submit" value="<?php echo $this->translate('Update Image') ?>" style="cursor: pointer;" />
                            <img id="ajaxImageLoading" src='<?php echo $this->baseUrl() ?>/application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px; display:none;' />
                        </form>
                    <?php endif; ?>
                </div>
                <div class="pt-lv-02">
                    <h3>
                        <?php if (!empty($resume->username)): ?>
                            <?php echo $resume->username; ?>
                        <?php else: ?>
                            <?php echo $user_inform->displayname; ?>
                        <?php endif; ?>
                        <?php if ($user_id == $user_resume):?>
                            <a href="javascript:void(0);" onclick="updateUsername('<?php echo $resume->resume_id ?>');"> <?php echo $this->translate("[Update]"); ?></a>
                        <?php endif; ?>
                    </h3>
                    <p>Nam</p>
                    <p>Ngày sinh: 01/06/1991</p>
                    <p>Địa chỉ: 70 Cù Chính Lan - Thành phố Đà Nẵng, Việt Nam</p>
                    <p>Điện thoại: 0906404101	</p>
                    <p>Email: pyro1691@gmail.com<a href="#">Cập nhật</a></p>
                </div>
            </div>
            <div class="pt-content-file-block">
                <div class="pt-lv-01">
                    <h3>Kinh nghiệm làm việc</h3>
                    <a href="#" class="pt-edit">Chỉnh sửa</a>
                </div>
                <div class="pt-lv-02">
                    <h3>Nhân viên kinh doanh tại Novotel Hotel</h3>
                    <p>Tháng 6/2012 đến Tháng 6/2013</p>
                    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. </p>
                    <h3 class="pt-fix-mt">Nhân viên kinh doanh tại Sungroup</h3>
                    <p>Tháng 6/2012 đến Tháng 6/2013</p>
                    <p>- Chăm sóc và tìm kiếm khách hàng<br>
                        - Lập kế hoạch kinh doanh<br>
                        - Triển khai các dòng sản phẩm phần mềm của công ty<br>
                        - Quản lý phòng kinh doanh </p>
                </div>
            </div>
            <div class="pt-content-file-block">
                <div class="pt-lv-01">
                    <h3>Học vấn</h3>
                    <a href="#" class="pt-edit">Chỉnh sửa</a>
                </div>
                <div class="pt-lv-02">
                    <h3>Đại học Duy Tân</h3>
                    <p>Trung cấp - Du lịch/ Khách sạn - Tháng 6/2011 đến Tháng 10/2013</p>
                    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. </p>

                </div>
            </div>
            <div class="pt-content-file-block">
                <div class="pt-lv-01">
                    <h3>Kĩ năng</h3>
                    <a href="#" class="pt-edit">Chỉnh sửa</a>
                </div>
                <div class="pt-lv-02">
                    <h3>Ngôn ngữ</h3>
                    <p>English - advanced</p>
                    <h3 class="pt-fix-mt">Kĩ năng khác</h3>
                    <p>Đá bóng, đá cầu, nhảy dây</p>
                </div>
            </div>
            <div class="pt-content-file-block">
                <div class="pt-lv-01">
                    <h3>Tham khảo</h3>
                    <a href="#" class="pt-edit">Chỉnh sửa</a>
                </div>
                <div class="pt-lv-02">
                    <h3>A Tũn</h3>
                    <p>Quản lý - Khách sạn Hoàng Nhi</p>
                    <p>Email: 123@gmail.com - Điện thoại: 0123456789</p>
                    <p><a href="#">Thông tin thêm</a></p>
                </div>
            </div>
            <div class="pt-content-file-block pt-content-file-button">
                <div class="pt-lv-01">

                </div>
                <div class="pt-lv-02">
                    <button type="submit" title="" class="button"><span></span>Quay lại</button>
                    <button type="submit" title="" class="button"><span></span>Hoàn tất</button>
                    <img src="img/thumb/img-submit-oky.png" alt="Image">
                </div>
            </div>
        </div>
    </div>

</div>

<div id="updateUsername" style="display:none;" title="<?php echo $this->translate('Update Fullname') ?>">
    <input type="text" class="input" id="txt-username" />
    <input type="submit" value"<?php echo $this->translate('Save') ?>" id="save_username" style="cursor: pointer;" />

</div>
<div id="updateEmail" style="display:none;" title="<?php echo $this->translate('Update Email') ?>">
    <input type="text" class="input" id="txt-email" />
    <input type="submit" value"<?php echo $this->translate('Save') ?>" id="save_email" style="cursor: pointer;" />
</div>
<script type="text/javascript">
    function updateUsername(resume_id) {
        jQuery('#updateUsername').dialog({resizable: false, modal: true});

        jQuery('#save_username').click(function() {
            var user = jQuery('#txt-username').val();
            if (user != '') {
                jQuery.post
                        ('<?php echo $this->baseUrl() . '/resumes/resume/update' ?>',
                                {
                                    resume_id: resume_id,
                                    username: user

                                },
                        function(data) {
                            if (data == 1) {
                                jQuery('#displayname').html(user);
                                jQuery('#updateUsername').dialog('close');
                            }

                        }
                        );
            }
            else {
                alert("Full name is not empty")
            }
        });
    }
    function updateEmail(resume_id) {
        jQuery('#updateEmail').dialog({resizable: false, modal: true});

        jQuery('#save_email').click(function() {
            var email = jQuery('#txt-email').val();
            if (email != '') {
                jQuery.post
                        ('<?php echo $this->baseUrl() . '/resumes/resume/email' ?>',
                                {
                                    resume_id: resume_id,
                                    emailUpdate: email

                                },
                        function(data) {
                            if (data == 1) {
                                jQuery('#email').html(email);
                                jQuery('#updateEmail').dialog('close');
                            }

                        }
                        );
            }
            else {
                alert("Email is not empty")
            }
        });
    }
    function manage_resume() {
        var url = "<?php echo $this->baseUrl() . '/resumes/resume/manage' ?>";
        window.location.href = url;
    }
    window.addEvent('domready', function() {
        var works = <?php echo count($works); ?>;
        var education = <?php echo count($educations); ?>;
        var language = <?php echo count($languages); ?>;
        var group_skill = <?php echo count($group_skills); ?>;
        var references = <?php echo count($references); ?>;

        if (works > 0) {
            jQuery('#resume_work_edit').addClass('checked_resume');
        }
        if (education > 0) {
            jQuery('#resume_education_edit').addClass('checked_resume');
        }
        if (language > 0 || group_skill > 0) {
            jQuery('#resume_skill_edit').addClass('checked_resume');
        }
        if (references > 0) {
            jQuery('#resume_reference_edit').addClass('checked_resume');
        }
        var options = {
            dataType: 'json',
            success: showResponse,
            beforeSubmit: showRequest,
            type: 'post',
            clearForm: true
        };
        jQuery('#updateImage').ajaxForm(options);

    });
    function showRequest(formData, jqForm, options) {
        $('ajaxImageLoading').style.display = "block";
    }
    function showResponse(responseText) {

        if (responseText.message == 'success')
        {

            //request to get image update
            var resume_id = jQuery('#fr_resume').val();
            jQuery.post
                    ('<?php echo $this->baseUrl() . '/resumes/resume/image-update' ?>',
                            {
                                resume_id: resume_id
                            },
                    function(data) {
                        if (data != 0) {
                            var src = "/public/profile_recruiter/" + data;
                            jQuery('#updateNewImage').attr('src', src);
                        }
                        $('ajaxImageLoading').style.display = "none";
                    }
                    );
        }
        else if (responseText.message == 'file') {
            alert("<?php echo $this->translate('Your file is too big!') ?>");
            $('ajaxImageLoading').style.display = "none";
        }
        else if (responseText.message == 'extension') {
            alert("<?php echo $this->translate('Check that the file is a valid format.') ?>");
            $('ajaxImageLoading').style.display = "none";
        }
        else
        {

        }
        return false;
    }
</script>