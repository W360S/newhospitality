
<?php $num_resume = $this->num_resume; ?>

<div class="resume_info_main subsection" style="border:none">
    <h2><?php echo $this->translate('Resume Information') ?></h2>
    <div class="main-form-wrapper">
        <form action="<?php echo $this->baseUrl() ?>/resumes/index/resume-info" method="post" id="resume_info_form">
            <div class="fieldset-wrapper">
                <fieldset class="job-form job-form-step-1">
                    <div class="input">
                        <label for="resume title"><?php echo $this->translate("Resume Title (*): ") ?></label>
                        <input type="text" name="resume_title" id="resume_title" />
                        <p><?php echo $this->translate("(e.g., Experienced Brand Manager with profound knowledge in FMCG industry)") ?></p>
                    </div>
                    <div class="input">
                        <label><?php echo $this->translate('Privacy Status') ?></label>
                        <div class="radio-wrapper">
                            <div class="radio-item-wrapper">
                                <input type="radio" value="1" name="searchable" checked /> <?php echo $this->translate('Searchable (recommended): ') ?>
                                <?php echo $this->translate(' This option allows employers to contact you by phone or email and view all your resume information.') ?>
                            </div>
                            
                            <div class="radio-item-wrapper">
                                <input type="radio" value="0" name="searchable" /><?php echo $this->translate('Non Searchable (not recommended): ') ?>
                                <?php echo $this->translate("This option does not allow employers to search your resume by making your resume 'invisible'.") ?> 
                            </div>
                              
                        </div>
                    </div>
                    <div class="submit input">
                        <button type="submit" title="" class="button"><span></span>Tiếp tục</button>
                        <button type="submit" title="" class="button">Hủy</button>
                    </div>
                </fieldset>
            </div>
        </form>
    </div>

</div>
<script type="text/javascript">
    window.addEvent('domready', function() {
        jQuery('#resume_info_form').validate({
            messages: {
                "resume_title": {
                    required: "<?php echo $this->translate('Title Resume is not empty') ?>",
                    maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.') ?>"
                }
            },
            rules: {
                "resume_title": {
                    required: true,
                    maxlength: 160
                }
            }
        });
    });
</script>