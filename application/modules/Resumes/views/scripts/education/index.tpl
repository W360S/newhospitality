<script src="<?php echo $this->baseUrl() . '/externals/viethosp/jquery_check_form.js' ?>" type="text/javascript"></script>
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
$resume_id = $this->resume_id;
$works = $this->works;
$languages = $this->languages;
$group_skills = $this->group_skill;
$references = $this->references;
?>
<div class="pt-title-event">
    <ul class="pt-menu-event pt-menu-libraries">
        <li>
            <a href="<?php echo $this->baseUrl() ?>/resumes/">Người tìm việc</a>
        </li>
        <li>
            <span>Tạo hồ sơ</span>
        </li>
    </ul>
</div>
<div class="resume_education_main subsection">
    <h3 class="pt-title-right"><?php echo $this->translate('Education') ?></h3>
    <div id="resume_loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>
    <div class="main-form-wrapper">
        <form id="resume_education_form" method="post" action="<?php echo $form->getAction(); ?>" enctype="application/x-www-form-urlencoded">
            <div class="pt-title-from-02">
                <div id="list-educations">

                </div>
                <div id="form-works-education" style="display: none">
                    <div class="work-job-work-form-wrapper">
                        <fieldset class="job-form job-form-step-2">
                            <div class="input">
                                <?php echo $form->degree_level_id; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->school_name; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->major; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->country_id; ?>
                            </div>

                            <div class="resume_date">
                                <?php echo $form->starttime; ?>
                            </div>
                            <div class="input"></div>
                            <div class="resume_date">
                                <?php echo $form->endtime; ?>
                            </div>
                            <div class="input"></div>

                            <div class="input">
                                <?php echo $form->description; ?>
                            </div>
                            
                            <div class="button_control">
                                <button id="save" onclick="saveResumeEducation('save');" type="button" title="" class="button">Tiếp tục</button>
                                <button onclick="cancelResumeEducation('save');" type="button" title="" class="button">Huỷ</button>
                            </div>
                            
                        </fieldset>
                        <div id="list_education_temp">
                        </div>
                        
                    </div>
                </div>
                
                <a id="btn-add-experience" href="javascript:void(0)" class="pt-supplementary-report" onClick="addExperience(this)">Bổ sung</a>
                <div id="main-control">
                    <button onclick="back_resume_work();" type="button" title="" class="button">Quay lại</button>
                    <button onclick="saveResumeEducation('next');" type="button" title="" class="button"><span></span>Tiếp tục</button>
                </div>
                
                <script>
                    function addExperience(el){
                        showEducationForm();
                    }
                    
                    function showEducationForm(){
                        jQuery("#form-works-education").show();
                        jQuery("#list-educations").hide();
                        jQuery("#btn-add-experience").hide();
                        jQuery("#main-control").hide();
                    }
                    
                    function hideEducationForm(){
                        jQuery("#form-works-education").hide();
                        jQuery("#list-educations").show();
                        jQuery("#btn-add-experience").show();
                        jQuery("#main-control").show();
                    }
                    
                </script>
                
            </div>
        </form>
        <input type="hidden" value="<?php echo $resume_id ?>" id="resume_id_education" />
    </div>
</div>
<script type="text/javascript">
    function cancelResumeEducation(type){
        hideEducationForm();
    }
    function saveResumeEducation(type) {
        console.log("saveResumeEducation " + type);
        var content = tinyMCE.activeEditor.getContent(); // get the content
        jQuery('#description').val(content);
        var resume_id = jQuery('#resume_id_education').val();
        var check;
        if (type == 'save') {
            check = true;
        }else {
            var count_childrent = jQuery('#list-educations table tbody').children().size();

            if (count_childrent == 1) {
                check = true;
            }else {
                console.log("checked false");
                
                check = false;
                var school_name = checkValid('#school_name', 160);
                var degree_level_id = $('degree_level_id').value;

                if (degree_level_id == 0) {
                    degree_level_id = false;
                }
                else {
                    degree_level_id = true;
                }
                var valid = degree_level_id && school_name;

                if (degree_level_id == false && school_name == false) {
                    var url_next = "<?php echo $this->baseUrl() . '/resumes/skill/index/resume_id/' ?>" + resume_id;
                    window.location.href = url_next;
                }else {
                    if (degree_level_id == false) {
                        if (jQuery('#degree_level_id-element').children().size() < 2) {
                            jQuery('#degree_level_id-element').append('<label class="error" for="degree_level_id" generated="true"><?php echo $this->translate("Please select a degree."); ?></label>');
                        }
                    }
                    if (school_name == false) {
                        if (jQuery('#school_name-element').children().size() < 2) {
                            jQuery('#school_name-element').append('<label class="error" for="school_name" generated="true"><?php echo $this->translate("School name is not empty."); ?></label>');
                        }
                    }
                }
                if (valid) {
                    console.log("checked valid");
                    var url = "<?php echo $this->baseUrl() . '/resumes/education/index' ?>";
                    new Request({
                        url: url,
                        method: "post",
                        data: {
                            'type': type,
                            'resume_id': resume_id,
                            'degree_level_id': jQuery('#degree_level_id').val(),
                            'school_name': jQuery('#school_name').val(),
                            'major': jQuery('#major').val(),
                            'country_id': jQuery('#country_id').val(),
                            'starttime_month': jQuery('#starttime-month').val(),
                            'starttime_day': jQuery('#starttime-day').val(),
                            'starttime_year': jQuery('#starttime-year').val(),
                            'endtime_month': jQuery('#endtime-month').val(),
                            'endtime_day': jQuery('#endtime-day').val(),
                            'endtime_year': jQuery('#endtime-year').val(),
                            'description': jQuery('#description').val()

                        },
                        onSuccess: function(responseHTML)
                        {
                            // inform error date
                            //alert(responseHTML);
                            if (responseHTML == 0) {
                                $('error_date').set('html', '<?php echo $this->translate("Start date or End date does not empty"); ?>');
                            }
                            else if (responseHTML == 1) {
                                $('error_date').set('html', '<?php echo $this->translate("Start date must be less than end date"); ?>');
                            }
                            else if (responseHTML == 3) {
                                //goto next page
                                var url_next = "<?php echo $this->baseUrl() . '/resumes/skill/index/resume_id/' ?>" + resume_id;
                                window.location.href = url_next;

                            }

                        }
                    }).send();
                }else{
                    console.log("checked not valid");
                }
            }
        }

        if (check == true) {
            console.log("checked true");
            var degree_level_id = $('degree_level_id').value;

            if (degree_level_id == 0) {
                degree_level_id = false;

            }
            else {
                degree_level_id = true;
            }

            if (degree_level_id == false) {
                if (jQuery('#degree_level_id-element').children().size() < 2) {

                    jQuery('#degree_level_id-element').append('<br /><label class="error" for="degree_level_id" generated="true"><?php echo $this->translate("Please select a degree level."); ?></label>');
                }
                else {
                    jQuery('#degree_level_id-element label').attr('style', 'display:block');
                }
            }
            var school_name = checkValid('#school_name', 160);

            if (school_name == false) {
                if (jQuery('#school_name-element').children().size() < 2) {
                    jQuery('#school_name-element').append('<label class="error" for="school_name" generated="true"><?php echo $this->translate("School name is not empty."); ?></label>');
                }
                else {
                    jQuery('#school_name-element label').attr('style', 'display:block');
                }
            }

            var valid = degree_level_id && school_name;

            if (valid) {
                $('resume_loading').style.display = "block";
                var url = "<?php echo $this->baseUrl() . '/resumes/education/index' ?>";
                new Request({
                    url: url,
                    method: "post",
                    data: {
                        'type': type,
                        'resume_id': resume_id,
                        'degree_level_id': jQuery('#degree_level_id').val(),
                        'school_name': jQuery('#school_name').val(),
                        'major': jQuery('#major').val(),
                        'country_id': jQuery('#country_id').val(),
                        'starttime_month': jQuery('#starttime-month').val(),
                        'starttime_day': jQuery('#starttime-day').val(),
                        'starttime_year': jQuery('#starttime-year').val(),
                        'endtime_month': jQuery('#endtime-month').val(),
                        'endtime_day': jQuery('#endtime-day').val(),
                        'endtime_year': jQuery('#endtime-year').val(),
                        'description': jQuery('#description').val()

                    },
                    onSuccess: function(responseHTML)
                    {
                        // inform error date
                        //alert(responseHTML);
                        if (responseHTML == 0) {
                            $('resume_loading').style.display = "none";
                            $('error_date').set('html', '<?php echo $this->translate("Start date or End date does not empty"); ?>');
                        }
                        else if (responseHTML == 1) {
                            $('resume_loading').style.display = "none";
                            $('error_date').set('html', '<?php echo $this->translate("Start date must be less than end date"); ?>');
                        }
                        else if (responseHTML == 2) {
                            $('resume_loading').style.display = "none";
                            var url = "<?php echo $this->baseUrl() . '/resumes/education/list-education' ?>";
                            new Request({
                                url: url,
                                method: "post",
                                data: {
                                    'resume_id': resume_id

                                },
                                onSuccess: function(responseHTML)
                                {
                                    //alert(responseHTML);
                                    $('list-educations').set('html', responseHTML);
                                    $('error_date').set('html', '');

                                    $('resume_education_form').reset();
                                    $('country_id').set('value', 230);
                                    $('starttime-day').set('value', 1).hide();
                                    $('endtime-day').set('value', 1).hide();
                                    
                                    hideEducationForm();
                                }
                            }).send();

                        }
                        else if (responseHTML == 3) {
                            var url_next = "<?php echo $this->baseUrl() . '/resumes/skill/index/resume_id/' ?>" + resume_id;
                            window.location.href = url_next;
                        }
                    }
                }).send();
            }
        }else{
            console.log("checked false");
        }

    }
    
    function back_resume_work() {
        var resume_id_back = jQuery('#resume_id_education').val();
        var url = "<?php echo $this->baseUrl() . '/resumes/index/resume-work/id/' ?>" + resume_id_back;
        window.location.href = url;
    }
    
    function edit_education(education_id) {
        document.documentElement.scrollTop = 200;
        //alert(education_id);
        //load data into form
        
        showEducationForm();
        
        var degree_level = $('degree_level_edu_' + education_id).value;

        var school_name = $('school_name_edu_' + education_id).value;
        var major = $('major_edu_' + education_id).value;

        var country = $('country_edu_' + education_id).value;

        var starttime = $('start_edu_' + education_id).value;
        var endtime = $('end_edu_' + education_id).value;
        var description = $('description_edu_' + education_id).get('html');
        //populate data
        //alert(school_name);
        jQuery('#degree_level_id option').each(function() {
            if (degree_level == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        $('school_name').set('value', school_name);

        $('major').set('value', major);
        jQuery('#country_id option').each(function() {
            if (country == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });

        var st_time = starttime.split('-');
        var st_time_month = st_time[1].split('0');
        if (st_time_month[0] == 0) {
            st_time[1] = st_time_month[1];
        }
        jQuery('#starttime-month option').each(function() {
            if (parseInt(st_time[1]) == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        var st_time_day = st_time[2].split('0');
        if (st_time_day[0] == 0) {
            st_time[2] = st_time_day[1];
        }
        jQuery('#starttime-day option').each(function() {
            if (parseInt(st_time[2]) == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        jQuery('#starttime-year option').each(function() {
            if (st_time[0] == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        //$('starttime-hour').

        var ed_time = endtime.split('-');

        var ed_time_month = ed_time[1].split('0');
        if (ed_time_month[0] == 0) {
            ed_time[1] = ed_time_month[1];
        }
        jQuery('#endtime-month option').each(function() {
            if (parseInt(ed_time[1]) == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        var ed_time_day = ed_time[2].split('0');
        if (ed_time_day[0] == 0) {
            ed_time[2] = ed_time_day[1];
        }
        jQuery('#endtime-day option').each(function() {
            if (parseInt(ed_time[2]) == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        jQuery('#endtime-year option').each(function() {
            if (ed_time[0] == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        jQuery('#description').html(description);
        tinyMCE.activeEditor.setContent(description);
        //change action at button save and submit

        $('save').destroy();
        var save_new = new Element('input', {'id': "save", 'onclick': "javascript:edit_edu('save');return false;", 'type': "button", 'class': "button", 'name': "save", 'value': "<?php echo $this->translate('Save'); ?>"});
        save_new.inject('edu_id', 'before');
        //fix ie
        save_new.onclick = function() {
            javascript:edit_edu('save');
            return false;
        };
        
        /*
        $('submit').destroy();
        var submit_new = new Element('a', {'id': "submit", 'onclick': "javascript:edit_edu('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next'); ?>"});
        submit_new.inject('cancel', 'after');
        //fix ie
        submit_new.onclick = function() {
            javascript:edit_edu('next');
            return false;
        };
        jQuery('#submit').attr('style', 'margin-left: 3px;');
        */
           
        $('edu_id').set('value', education_id);
    }
    
    function edit_edu(type) {
        var content = tinyMCE.activeEditor.getContent(); // get the content
        jQuery('#description').val(content);
        var edu_id = $('edu_id').value;
        //alert(type);
        var resume_id = jQuery('#resume_id_education').val();
        var degree_level_id = $('degree_level_id').value;

        if (degree_level_id == 0) {
            degree_level_id = false;

        }
        else {
            degree_level_id = true;
        }
        if (degree_level_id == false) {
            if (jQuery('#degree_level_id-element').children().size() < 2) {

                jQuery('#degree_level_id-element').append('<br /><label class="error" for="degree_level_id" generated="true"><?php echo $this->translate("Please select a degree level."); ?></label>');
            }
        }
        var school_name = checkValid('#school_name', 160);

        if (school_name == false) {
            if (jQuery('#school_name-element').children().size() < 2) {
                jQuery('#school_name-element').append('<label class="error" for="school_name" generated="true"><?php echo $this->translate("School name is not empty."); ?></label>');
            }
        }

        var valid = degree_level_id && school_name;

        if (valid) {
            $('save').destroy();
            var save_new = new Element('input', {'id': "save", 'onclick': "javascript:saveResumeEducation('save');return false;", 'type': "button", 'class': "button", 'name': "save", 'value': "<?php echo $this->translate('Add'); ?>"});
            save_new.inject('edu_id', 'before');
            //fix ie
            save_new.onclick = function() {
                javascript:saveResumeEducation('save');
                return false;
            };
            
            /*
            $('submit').destroy();
            var submit_new = new Element('a', {'id': "submit", 'onclick': "javascript:saveResumeEducation('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next'); ?>"});
            submit_new.inject('cancel', 'after');
            //fix ie
            submit_new.onclick = function() {
                javascript:saveResumeEducation('next');
                return false;
            };
            jQuery('#submit').attr('style', 'margin-left: 3px;');
            */ 
               
            $('resume_loading').style.display = "block";
            var url = "<?php echo $this->baseUrl() . '/resumes/education/resume-education-edit' ?>";
            new Request({
                url: url,
                method: "post",
                data: {
                    'edu_id': edu_id,
                    'type': type,
                    'resume_id': resume_id,
                    'degree_level_id': jQuery('#degree_level_id').val(),
                    'school_name': jQuery('#school_name').val(),
                    'major': jQuery('#major').val(),
                    'country_id': jQuery('#country_id').val(),
                    'starttime_month': jQuery('#starttime-month').val(),
                    'starttime_day': jQuery('#starttime-day').val(),
                    'starttime_year': jQuery('#starttime-year').val(),
                    'endtime_month': jQuery('#endtime-month').val(),
                    'endtime_day': jQuery('#endtime-day').val(),
                    'endtime_year': jQuery('#endtime-year').val(),
                    'description': jQuery('#description').val()

                },
                onSuccess: function(responseHTML)
                {
                    // inform error date
                    //alert(responseHTML);
                    if (responseHTML == 0) {
                        $('resume_loading').style.display = "none";
                        $('error_date').set('html', '<?php echo $this->translate("Start date or End date does not empty"); ?>');
                    }
                    else if (responseHTML == 1) {
                        $('resume_loading').style.display = "none";
                        $('error_date').set('html', '<?php echo $this->translate("Start date must be less than end date"); ?>');
                    }
                    else if (responseHTML == 2) {
                        $('resume_loading').style.display = "block";
                        var url = "<?php echo $this->baseUrl() . '/resumes/education/list-education' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            data: {
                                'resume_id': resume_id

                            },
                            onSuccess: function(responseHTML)
                            {
                                //alert(responseHTML);
                                $('resume_loading').style.display = "none";
                                $('list-educations').set('html', responseHTML);
                                $('error_date').set('html', '');

                                $('resume_education_form').reset();
                                $('country_id').set('value', 230);
                                $('starttime-day').set('value', 1).hide();
                                $('endtime-day').set('value', 1).hide();
                                jQuery('#description').html('');
                                //$('save').set('onclick', "javascript:saveResumeEducation('save');");
                                //$('submit').set('onclick', "javascript:saveResumeEducation('next');");
                                
                                hideEducationForm();
                            }
                        }).send();

                    }
                    else if (responseHTML == 3) {
                        var url_next = "<?php echo $this->baseUrl() . '/resumes/skill/index/resume_id/' ?>" + resume_id;
                        window.location.href = url_next;
                    }
                }
            }).send();
        }
    }
    
    function delete_education(education_id) {

        var url = "<?php echo $this->baseUrl() . '/resumes/education/delete-education' ?>";
        //alert(url);
        var resume_id = jQuery('#resume_id_education').val();

        if (confirm("<?php echo $this->translate('Do you really want to delete this education?'); ?>")) {
            $('resume_loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'education_id': education_id

                },
                onSuccess: function(responseHTML)
                {
                    $('resume_education_form').reset();
                    $('save').destroy();
                    var save_new = new Element('input', {'id': "save", 'onclick': "javascript:saveResumeEducation('save');return false;", 'type': "button", 'class': "min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add'); ?>"});
                    save_new.inject('edu_id', 'before');
                    //fix ie
                    save_new.onclick = function() {
                        javascript:saveResumeEducation('save');
                        return false;
                    };
                    $('submit').destroy();
                    var submit_new = new Element('a', {'id': "submit", 'onclick': "javascript:saveResumeEducation('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next'); ?>"});
                    submit_new.inject('cancel', 'after');
                    //fix ie
                    submit_new.onclick = function() {
                        javascript:saveResumeEducation('next');
                        return false;
                    };
                    jQuery('#submit').attr('style', 'margin-left: 3px;');
                    if (responseHTML == 1) {
                        $('resume_loading').style.display = "block";
                        var url = "<?php echo $this->baseUrl() . '/resumes/education/list-education' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            data: {
                                'resume_id': resume_id

                            },
                            onSuccess: function(responseHTML)
                            {
                                $('resume_loading').style.display = "none";
                                $('list-educations').set('html', responseHTML);
                                $('country_id').set('value', 230);
                                $('starttime-day').set('value', 1).hide();
                                $('endtime-day').set('value', 1).hide();
                            }
                        }).send();
                    }
                    else {
                        alert("Can't delete this education");
                    }

                }
            }).send();
        }

    }
    
    window.addEvent('domready', function() {
        var resume_education_list = new Element('div', {id: 'list-educations'});
        //resume_education_list.inject($('list_education_temp'), 'after');
        
        var error_date = new Element('div', {id: 'error_date'});
        error_date.inject($('country_id'), 'after');
        var edu_id = new Element('input', {id: 'edu_id', type: 'hidden'});
        edu_id.inject('save', 'after');

        var resume_id_init = jQuery('#resume_id_education').val();

        var url = "<?php echo $this->baseUrl() . '/resumes/education/list-education' ?>";
        new Request({
            url: url,
            method: "post",
            data: {
                'resume_id': resume_id_init

            },
            onSuccess: function(responseHTML)
            {
                //alert(responseHTML);
                $('list-educations').set('html', responseHTML);
                //check if edit
                var count_childrent = jQuery('#list-educations table tbody').children().size();

                if (count_childrent > 1) {
                    jQuery('#resume_education_edit').addClass('resume_education_edit');
                }
            }
        }).send();
        var works = <?php echo count($works); ?>;

        var language = <?php echo count($languages); ?>;
        var group_skill = <?php echo count($group_skills); ?>;
        var references = <?php echo count($references); ?>;

        if (works > 0) {
            jQuery('#resume_work_edit').addClass('checked_resume');
        }

        if (language > 0 || group_skill > 0) {
            jQuery('#resume_skill_edit').addClass('checked_resume');
        }
        if (references > 0) {
            jQuery('#resume_reference_edit').addClass('checked_resume');
        }
        $('country_id').set('value', 230);
        //cho mặc định ngày là 1 và hidden
        $('starttime-day').set('value', 1).hide();
        $('endtime-day').set('value', 1).hide();
        jQuery('#resume_education_form').validate({
            messages: {
                "degree_level_id": {
                    required: "<?php echo $this->translate('Degree Level is not empty') ?>",
                    min: "<?php echo $this->translate('Please select a degree level.') ?>"
                },
                "school_name": {
                    required: "<?php echo $this->translate('School Name is not empty.') ?>",
                    maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.') ?>"
                }
            },
            rules: {
                "degree_level_id": {
                    required: true,
                    min: 1
                },
                "school_name": {
                    required: true,
                    maxlength: 160
                }
            }
        });
    });
</script>