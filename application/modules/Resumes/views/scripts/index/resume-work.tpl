
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
$educations = $this->educations;
$languages = $this->languages;
$group_skills = $this->group_skill;
$references = $this->references;
?>
<div class="resume_info_main subsection" style="border:none;padding-bottom:20px;">
    <h2><?php echo $this->translate('Work Experience') ?></h2>
    <div id="resume_loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>
    <div class="pt-signin pt-from-01 pt-from-02">
        <form id="resume_work_form" action="<?php echo $this->baseUrl() . $form->getAction(); ?>" method="post" enctype="application/x-www-form-urlencoded">
            <div class="pt-title-from-02">
                <div id="list-works-experiences">
                </div>
                <div id="form-works-experience" style="display: none">
                    <div class="work-job-work-form-wrapper">	
                        <fieldset class="job-form job-form-step-2">
                            <h4 style="text-align: center;">Bổ sung Kinh Nghiệm Làm Việc</h4>
                            <div class="input">
                                <?php echo $form->company_name; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->num_year; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->title; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->level_id; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->category_id; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->country_id; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->city_id; ?>
                            </div>
                            <div class="input" style="opacity:0.8">
                                <?php echo $form->starttime; ?>
                            </div>
                            <div class="input" style="opacity:0.8">
                                <?php echo $form->endtime; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->description; ?>
                            </div>
                        </fieldset>

                        <div id="list_work_temp"></div>
                        <div class="button_control">
                            <!--<button onclick="saveResumeWork('next');" type="button" title="" class="button" id="save">Tiep</button>-->
                            <button onclick="saveResumeWork('save');" type="button" title="" class="button" id="save">Lưu</button>
                            <!--<button onclick="back_resume_info();" type="button" title="" class="button">Hủy</button>-->
                            <!--<button onclick="saveResumeWork('next');" type="submit" title="" class="button">Hủy</button>-->

                        </div>
                    </div>
                </div>

                <a id="btn-add-experience" href="javascript:void(0)" class="pt-supplementary-report" onClick="addExperience(this)">Bổ sung</a>
                <div id="main-control">
                    <button onclick="back_resume_info();" type="button" title="" class="button">Quay lại</button>
                    <button onclick="saveResumeWork('next');" type="button" title="" class="button"><span></span>Tiếp tục</button>
                </div>
            </div>


            <script>
                function addExperience(el){
                    jQuery("#form-works-experience").show();
                    jQuery("#list-works-experiences").hide();
                    jQuery("#btn-add-experience").hide();
                    jQuery("#main-control").hide();
                }
            </script>

        </form>
    </div>
    <input type="hidden" value="<?php echo $resume_id ?>" id="resume_id_work" />
</div>
<script type="text/javascript">
    function list_city() {
        var url = "<?php echo $this->baseUrl() . '/resumes/index/city' ?>";
        var country_id = $('country_id').get('value');

        new Request({
            url: url,
            method: "post",
            data: {
                'country_id': country_id
            },
            onSuccess: function(responseHTML)
            {

                $('city_id').set('html', responseHTML);

            }
        }).send();
    }
    function saveResumeWork(type) {

        var content = tinyMCE.activeEditor.getContent(); // get the content
        jQuery('#description').val(content);

        var resume_id = jQuery('#resume_id_work').val();
        var check;

        if (type == 'save') {
            check = true;
        } else {
            var count_childrent = jQuery('#list-works-experiences table tbody').children().size();
            if (count_childrent == 1) {
                check = true;
            } else {
                check = false;
                var num_year = checkNumber('#num_year');
                var title = checkValid('#title', 160);
                var company_name = checkValid('#company_name', 160);
                var valid = num_year && title && company_name;
                if (num_year == false && title == false && company_name == false) {
                    var url_next = "<?php echo $this->baseUrl() . '/resumes/education/index/resume_id/' ?>" + resume_id;
                    window.location.href = url_next;
                } else {
                    if (num_year == false) {
                        if (jQuery('#num_year-element').children().size() < 2) {
                            jQuery('#num_year-element').append('<label class="error" for="num_year" generated="true"><?php echo $this->translate("Please enter a valid number."); ?></label>');
                        }
                    }
                    if (title == false) {
                        if (jQuery('#title-element').children().size() < 2) {
                            jQuery('#title-element').append('<label class="error" for="title" generated="true"><?php echo $this->translate("Job title is not empty."); ?></label>');
                        }
                    }
                    if (company_name == false) {
                        if (jQuery('#company_name-element').children().size() < 2) {
                            jQuery('#company_name-element').append('<label class="error" for="company_name" generated="true"><?php echo $this->translate("Company name is not empty."); ?></label>');
                        }
                    }
                }
                if (valid) {
                    $('resume_loading').style.display = "block";
                    var url = "<?php echo $this->baseUrl() . '/resumes/index/resume-work' ?>";
                    new Request({
                        url: url,
                        method: "post",
                        data: {
                            'type': type,
                            'resume_id': resume_id,
                            'num_year': jQuery('#num_year').val(),
                            'title': jQuery('#title').val(),
                            'company_name': jQuery('#company_name').val(),
                            'level_id': jQuery('#level_id').val(),
                            'category_id': jQuery('#category_id').val(),
                            'country_id': jQuery('#country_id').val(),
                            'city_id': jQuery('#city_id').val(),
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
                            else if (responseHTML == 3) {
                                //goto next page
                                var url_next = "<?php echo $this->baseUrl() . '/resumes/education/index/resume_id/' ?>" + resume_id;
                                window.location.href = url_next;

                            }

                        }
                    }).send();
                }
            }
        }

        if (check == true) {
            var num_year = checkNumber('#num_year');
            if (num_year == false) {
                if (jQuery('#num_year-element').children().size() < 2) {
                    jQuery('#num_year-element').append('<label class="error" for="num_year" generated="true"><?php echo $this->translate("Please enter a valid number."); ?></label>');
                }
                else {
                    jQuery('#num_year-element label').attr('style', 'display:block');
                }
            }
            var title = checkValid('#title', 160);
            if (title == false) {
                if (jQuery('#title-element').children().size() < 2) {
                    jQuery('#title-element').append('<label class="error" for="title" generated="true"><?php echo $this->translate("Job title is not empty."); ?></label>');
                }
                else {
                    jQuery('#title-element label').attr('style', 'display:block');
                }
            }
            var company_name = checkValid('#company_name', 160);
            if (company_name == false) {
                if (jQuery('#company_name-element').children().size() < 2) {
                    jQuery('#company_name-element').append('<label class="error" for="company_name" generated="true"><?php echo $this->translate("Company name is not empty."); ?></label>');
                }
                else {
                    jQuery('#company_name-element label').attr('style', 'display:block');
                }
            }

            var valid = num_year && title && company_name;

            console.log("valid" + valid);

            //alert(jQuery('#starttime-month').val());
            if (valid) {
                $('resume_loading').style.display = "block";
                var url = "<?php echo $this->baseUrl() . '/resumes/index/resume-work' ?>";
                new Request({
                    url: url,
                    method: "post",
                    data: {
                        'type': type,
                        'resume_id': resume_id,
                        'num_year': jQuery('#num_year').val(),
                        'title': jQuery('#title').val(),
                        'company_name': jQuery('#company_name').val(),
                        'level_id': jQuery('#level_id').val(),
                        'category_id': jQuery('#category_id').val(),
                        'country_id': jQuery('#country_id').val(),
                        'city_id': jQuery('#city_id').val(),
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
                            var url = "<?php echo $this->baseUrl() . '/resumes/index/list-work' ?>";
                            new Request({
                                url: url,
                                method: "post",
                                data: {
                                    'resume_id': resume_id

                                },
                                onSuccess: function(responseHTML)
                                {
                                    $('resume_loading').style.display = "none";
                                    $('list-works-experiences').set('html', responseHTML);
                                    $('error_date').set('html', '');

                                    $('resume_work_form').reset();
                                    $('country_id').set('value', 230);
                                    $('starttime-day').set('value', 1).hide();
                                    $('endtime-day').set('value', 1).hide();
                                    list_city();
                                    
                                    jQuery("#form-works-experience").hide();
                                    jQuery("#list-works-experiences").show();
                                    jQuery("#main-control").show();
                                    jQuery("#btn-add-experience").show();
                                    
                                }
                            }).send();

                        }
                        else if (responseHTML == 3) {
                            var url_next = "<?php echo $this->baseUrl() . '/resumes/education/index/resume_id/' ?>" + resume_id;
                            window.location.href = url_next;
                        }
                    }
                }).send();
            }
        }

    }
    function edit_work(experience_id) {
        document.documentElement.scrollTop = 200;
        //load data into form
        var num_year = $('num_year_exp_' + experience_id).value;
        var title = $('title_exp_' + experience_id).value;
        var level_id = $('job_level_exp_' + experience_id).value;
        var category = $('category_exp_' + experience_id).value;
        var company = $('company_exp_' + experience_id).value;
        var country = $('country_exp_' + experience_id).value;
        var city = $('city_exp_' + experience_id).value;
        var starttime = $('start_exp_' + experience_id).value;
        var endtime = $('end_exp_' + experience_id).value;
        var description = $('description_exp_' + experience_id).get('html');

        //populate data
        $('num_year').set('value', num_year);
        $('title').set('value', title);
        jQuery('#level_id option').each(function() {
            if (level_id == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });
        jQuery('#category_id option').each(function() {
            if (category == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
            }
        });

        $('company_name').set('value', company);
        jQuery('#country_id option').each(function() {
            if (country == jQuery(this).val()) {
                jQuery(this).attr('selected', 'selected');
                var url = "<?php echo $this->baseUrl() . '/resumes/index/city' ?>";
                var country_id = $('country_id').get('value');

                new Request({
                    url: url,
                    method: "post",
                    data: {
                        'country_id': country_id
                    },
                    onSuccess: function(responseHTML)
                    {

                        $('city_id').set('html', responseHTML);
                        jQuery('#city_id option').each(function() {
                            if (city == jQuery(this).val()) {
                                jQuery(this).attr('selected', 'selected');
                            }
                        });
                    }
                }).send();

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
        //alert(description);
        tinyMCE.activeEditor.setContent(description);
        //change action at button save and submit

        $('save').destroy();
        var save_new = new Element('input', {'id': "save", 'onclick': "javascript:edit_work_exp('save');return false;", 'type': "button", 'class': "min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Save'); ?>"});
        save_new.inject('exp_id', 'before');
        //fix ie
        save_new.onclick = function() {
            javascript:edit_work_exp('save');
            return false;
        };
        $('submit').destroy();
        var submit_new = new Element('a', {'id': "submit", 'onclick': "javascript:edit_work_exp('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next'); ?>"});
        submit_new.inject('cancel', 'after');
        //fix ie
        submit_new.onclick = function() {
            javascript:edit_work_exp('next');
            return false;
        };
        jQuery('#submit').attr('style', 'margin-left: 3px;');
        $('exp_id').set('value', experience_id);
    }
    function edit_work_exp(type) {
        var content = tinyMCE.activeEditor.getContent(); // get the content
        jQuery('#description').val(content);

        var exper_id = $('exp_id').value;

        var resume_id = jQuery('#resume_id_work').val();
        var num_year = checkNumber('#num_year');

        if (num_year == false) {
            if (jQuery('#num_year-element').children().size() < 2) {
                jQuery('#num_year-element').append('<label class="error" for="num_year" generated="true"><?php echo $this->translate("Please enter a valid number."); ?></label>');
            }
        }
        var title = checkValid('#title', 160);

        if (title == false) {
            if (jQuery('#title-element').children().size() < 2) {
                jQuery('#title-element').append('<label class="error" for="title" generated="true"><?php echo $this->translate("Job title is not empty."); ?></label>');
            }
        }
        var company_name = checkValid('#company_name', 160);
        if (company_name == false) {
            if (jQuery('#company_name-element').children().size() < 2) {
                jQuery('#company_name-element').append('<label class="error" for="company_name" generated="true"><?php echo $this->translate("Company name is not empty."); ?></label>');
            }
        }


        var valid = num_year && title && company_name;
        if (valid) {
            $('save').destroy();
            var save_new = new Element('input', {'id': "save", 'onclick': "javascript:saveResumeWork('save');return false;", 'type': "button", 'class': "min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add'); ?>"});
            save_new.inject('exp_id', 'before');
            //fix ie
            save_new.onclick = function() {
                javascript:saveResumeWork('save');
                return false;
            };
            $('submit').destroy();
            var submit_new = new Element('a', {'id': "submit", 'onclick': "javascript:saveResumeWork('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next'); ?>"});
            submit_new.inject('cancel', 'after');
            //fix ie
            submit_new.onclick = function() {
                javascript:saveResumeWork('next');
                return false;
            };
            jQuery('#submit').attr('style', 'margin-left: 3px;');
            $('resume_loading').style.display = "block";
            var url = "<?php echo $this->baseUrl() . '/resumes/index/resume-work-edit' ?>";
            new Request({
                url: url,
                method: "post",
                data: {
                    'exp_id': exper_id,
                    'type': type,
                    'resume_id': resume_id,
                    'num_year': jQuery('#num_year').val(),
                    'title': jQuery('#title').val(),
                    'company_name': jQuery('#company_name').val(),
                    'level_id': jQuery('#level_id').val(),
                    'category_id': jQuery('#category_id').val(),
                    'country_id': jQuery('#country_id').val(),
                    'city_id': jQuery('#city_id').val(),
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
                        $('resume_loading').style.display = "none";
                    }
                    else if (responseHTML == 1) {
                        $('error_date').set('html', '<?php echo $this->translate("Start date must be less than end date"); ?>');
                        $('resume_loading').style.display = "none";
                    }
                    else if (responseHTML == 2) {
                        $('resume_loading').style.display = "block";
                        var url = "<?php echo $this->baseUrl() . '/resumes/index/list-work' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            data: {
                                'resume_id': resume_id

                            },
                            onSuccess: function(responseHTML)
                            {
                                $('resume_loading').style.display = "none";
                                $('list-works-experiences').set('html', responseHTML);
                                $('error_date').set('html', '');

                                $('resume_work_form').reset();
                                $('country_id').set('value', 230);
                                $('starttime-day').set('value', 1).hide();
                                $('endtime-day').set('value', 1).hide();
                                list_city();
                                jQuery('#description').html('');
                                //$('save').set('onclick', "javascript:saveResumeWork('save');");
                                //$('submit').set('onclick', "javascript:saveResumeWork('next');");
                            }
                        }).send();

                    }
                    else if (responseHTML == 3) {
                        var url_next = "<?php echo $this->baseUrl() . '/resumes/education/index/resume_id/' ?>" + resume_id;
                        window.location.href = url_next;
                    }
                }
            }).send();
        }

    }

    function delete_work(expr_id) {

        var url = "<?php echo $this->baseUrl() . '/resumes/index/delete-work' ?>";
        //alert(url);
        var resume_id = jQuery('#resume_id_work').val();

        if (confirm("<?php echo $this->translate('Do you really want to delete this work experience?'); ?>")) {
            $('resume_loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'expr_id': expr_id

                },
                onSuccess: function(responseHTML)
                {
                    $('resume_work_form').reset();
                    jQuery('#description').html('');
                    $('save').destroy();
                    var save_new = new Element('input', {'id': "save", 'onclick': "javascript:saveResumeWork('save');return false;", 'type': "button", 'class': "min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add'); ?>"});
                    save_new.inject('exp_id', 'before');
                    //fix ie
                    save_new.onclick = function() {
                        javascript:saveResumeWork('save');
                        return false;
                    };
                    
                    /*
                    $('submit').destroy();
                    var submit_new = new Element('a', {'id': "submit", 'onclick': "javascript:saveResumeWork('next');return false;", 'name': "submit", 'html': "<?php echo $this->translate('Next'); ?>"});
                    submit_new.inject('cancel', 'after');
                    //fix ie
                    submit_new.onclick = function() {
                        javascript:saveResumeWork('next');
                        return false;
                    };
                    jQuery('#submit').attr('style', 'margin-left: 3px;');
                    */
                       
                    if (responseHTML == 1) {
                        $('resume_loading').style.display = "block";
                        var url = "<?php echo $this->baseUrl() . '/resumes/index/list-work' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            data: {
                                'resume_id': resume_id

                            },
                            onSuccess: function(responseHTML)
                            {
                                $('resume_loading').style.display = "none";
                                $('list-works-experiences').set('html', responseHTML);
                                $('country_id').set('value', 230);
                                $('starttime-day').set('value', 1).hide();
                                $('endtime-day').set('value', 1).hide();
                            }
                        }).send();
                    }
                    else {
                        alert("Can't delete this work experience");
                    }

                }
            }).send();
        }
    }
    function back_resume_info() {

        var resume_id_back = jQuery('#resume_id_work').val();

        var url = "<?php echo $this->baseUrl() . '/resumes/index/resume-info-edit/resume_id/' ?>" + resume_id_back;
        window.location.href = url;
    }

    window.addEvent('domready', function() {
        //list-works-experiences
        //var resume_work_list = new Element('div', {id: 'resume_work_list'});
        //resume_work_list.inject($('list_work_temp'), 'after');
        var resume_work_list = $('list-works-experiences');

        var error_date = new Element('div', {id: 'error_date'});
        error_date.inject($('city_id'), 'after');

        var exp_id = new Element('input', {id: 'exp_id', type: 'hidden'});
        exp_id.inject('save', 'after');

        var resume_id_init = jQuery('#resume_id_work').val();
        var url = "<?php echo $this->baseUrl() . '/resumes/index/list-work' ?>";
        new Request({
            url: url,
            method: "post",
            data: {
                'resume_id': resume_id_init

            },
            onSuccess: function(responseHTML)
            {
                $('list-works-experiences').set('html', responseHTML);
                //check if edit
                var count_childrent = jQuery('#list-works-experiences table tbody').children().size();

                if (count_childrent > 1) {
                    jQuery('#resume_work_edit').addClass('resume_work_edit');
                }
            }
        }).send();

        var education = <?php echo count($educations); ?>;
        var language = <?php echo count($languages); ?>;
        var group_skill = <?php echo count($group_skills); ?>;
        var references = <?php echo count($references); ?>;


        if (education > 0) {
            jQuery('#resume_education_edit').addClass('checked_resume');
        }

        if (language > 0 || group_skill > 0) {
            jQuery('#resume_skill_edit').addClass('checked_resume');
        }

        if (references > 0) {
            jQuery('#resume_reference_edit').addClass('checked_resume');
        }
        //load country vnam
        var country_id = 230;
        $('country_id').set('value', country_id);
        //cho mặc định ngày là 1 và hidden

        $('starttime-day').set('value', 1).hide();
        $('endtime-day').set('value', 1).hide();

        jQuery('#resume_work_form').validate({
            messages: {
                "num_year": {
                    required: "<?php echo $this->translate('Total years is not empty') ?>",
                    number: "<?php echo $this->translate('Please enter a valid number.') ?>"
                },
                "title": {
                    required: "<?php echo $this->translate('Job title is not empty') ?>",
                    maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.') ?>"
                },
                "company_name": {
                    required: "<?php echo $this->translate('Company name is not empty') ?>",
                    maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.') ?>"
                }
            },
            rules: {
                "num_year": {
                    required: true,
                    number: true
                },
                "title": {
                    required: true,
                    maxlength: 160
                },
                "company_name": {
                    required: true,
                    maxlength: 160
                }
            }
        });

    });

    function resume_work_form_validate() {

    }

    jQuery(document).ready(function() {
        resume_work_form_validate();
    });
</script>