<?php
$resume = $this->resume;
$works = $this->works;
$educations = $this->educations;
$languages = $this->languages;
$group_skills = $this->group_skill;
$references = $this->references;
?>

<div class="resume_info_main subsection">
    <h2><?php echo $this->translate('Resume Information') ?></h2>

    <form action="<?php echo $this->baseUrl() ?>/resumes/index/resume-info-edit/resume_id/<?php echo $resume->resume_id ?>" method="post" id="resume_info_form">
        <fieldset class="job-form job-form-step-1">
            <div class="input">
                <label for="resume title"><?php echo $this->translate("Resume Title (*): ") ?></label>
                <input type="text" name="resume_title" id="resume_title" value="<?php echo $resume->title ?>" />
                <p><?php echo $this->translate("(e.g., Experienced Brand Manager with profound knowledge in FMCG industry)") ?></p>
            </div>
            <div class="radio">
                <label><?php echo $this->translate('Privacy Status') ?></label>
            </div>

            <?php if ($resume->enable_search == 1) { ?>
                <div class="radio">
                    <input type="radio" value="1" name="searchable" checked /> <?php echo $this->translate('Searchable (recommended): ') ?>
                    <?php echo $this->translate(' This option allows employers to contact you by phone or email and view all your resume information.') ?>

                </div>
                <div class="radio">
                    <input type="radio" value="0" name="searchable" /><?php echo $this->translate('Non Searchable (not recommended): ') ?>
                    <?php echo $this->translate("This option does not allow employers to search your resume by making your resume 'invisible'.") ?>   
                </div>
            <?php } else {
                ?>
                <div class="radio">
                    <input type="radio" value="1" name="searchable" /> <?php echo $this->translate('Searchable (recommended): ') ?>
                    <?php echo $this->translate(' This option allows employers to contact you by phone or email and view all your resume information.') ?>

                </div>
                <div class="radio">
                    <input type="radio" value="0" name="searchable" checked /><?php echo $this->translate('Non Searchable (not recommended): ') ?>
                    <?php echo $this->translate("This option does not allow employers to search your resume by making your resume 'invisible'.") ?>   
                </div>
            <?php }
            ?>
            <div class="submit">
                <input type="submit" value="<?php echo $this->translate('Next'); ?>" class="min" />
            </div>
        </fieldset>
    </form>
</div>
<script type="text/javascript">
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