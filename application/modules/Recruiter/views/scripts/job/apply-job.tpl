
<?php
$this->headScript()
        ->appendFile($this->baseUrl() . '/externals/tinymce/tiny_mce.js')
//->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<script type="text/javascript">
    tinyMCE.init({
        theme: "simple",
        mode: "textareas",
        elements: "description",
        theme_advanced_toolbar_location: "top",
        theme_advanced_toolbar_align: "left",
        paste_use_dialog: false,
        theme_advanced_resizing: true,
        theme_advanced_resize_horizontal: true,
        apply_source_formatting: true,
        force_br_newlines: true,
        force_p_newlines: false,
        relative_urls: true
    });
</script>
<?php
$form = $this->form;
$check = $this->check;
?>
<div class="apply_job">

    <div class="resume_info_main subsection" style="border: medium none; margin-bottom: 35px;">

        <h2><?php echo $this->translate('Apply Job') ?></h2>
        <?php if ($check == true): ?>
            <div class="tip">
                <span>
                    <?php echo $this->translate("You have been applied to this job.") ?>
                </span>
            </div>

        <?php else : ?>
            <div class="main-form-wrapper">
                <form id="recruiter_apply_job_form" action="<?php echo $form->getAction(); ?>" method="post" enctype="multipart/form-data">
                    <div class="fieldset-wrapper">
                        <fieldset class="job-form">
                            <div class="input apply_job_title" >
                                <?php echo $form->title; ?>
                            </div>
                            <div class="input resumes">
                                <?php echo $form->resume_id; ?>
                            </div>
                            <div class="input">
                                <?php echo str_replace('480', '368', $form->description); ?>
                            </div>
                            <div class="input file">
                                <?php echo $form->file; ?>
                            </div>
                            <div class="submit">

                                <button type="submit" value="<?php echo $this->translate('Apply'); ?>" class="min">Nộp đơn</button>
                                <button type="reset" value="<?php echo $this->translate('Reset'); ?>" class="min" onclick="reset();">Đặt lại</button>
                            </div>
                        </fieldset>
                    </div>

                </form>  
            </div>

        <?php endif; ?>

    </div>
</div>

<script type="text/javascript">
    function toggle_list() {
        jQuery('#list_resume_toggle').toggle();

    }
    function select_resume() {
        var resume_id = $('resume_id').value;

        //ajax load resume
        var url = "<?php echo $this->baseUrl() . '/resumes/index/list' ?>";
        new Request({
            url: url,
            method: "post",
            data: {
                'resume_id': resume_id
            },
            onSuccess: function(responseHTML)
            {

                $('list_resume').set('html', responseHTML);

            }
        }).send();
    }
    window.addEvent('domready', function() {
        if ($('resume_id').value == '') {
            jQuery('#resume_id-element').append("<span style='position:relative;top:11px;'><?php echo $this->translate('Please') ?> <a href='<?php echo $this->baseUrl() . PATH_SERVER_INDEX ?>/resumes/index/resume-info' ><?php echo $this->translate('create a new resume') ?> </a><?php echo $this->translate('before apply job') ?>.</span>");
            jQuery('#resume_id').css('display', 'none');
            jQuery('#resume_id').append("<option value='0'></option>");

        }
        var list_resume = new Element('div', {id: 'list_resume', 'class': 'list_resume'});
        list_resume.inject($('resume_id-wrapper'), 'after');

        jQuery('#recruiter_apply_job_form').validate({
            messages: {
                "title": {
                    required: "<?php echo $this->translate('Subject is not empty.') ?>",
                    maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.') ?>"
                },
                "resume_id": {
                    required: "<?php echo $this->translate('Please create a resume.') ?>",
                    min: "<?php echo $this->translate('Please create a resume.') ?>"
                }
            },
            rules: {
                "title": {
                    required: true,
                    maxlength: 160
                },
                "resume_id": {
                    required: true,
                    min: 1
                }
            }
        });
    });
    function reset() {
        $('recruiter_apply_job_form').reset();
    }
</script>