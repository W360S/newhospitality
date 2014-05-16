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
<div class="resume_skill_main subsection">
    <h3 class="pt-title-right"><?php echo $this->translate('Reference') ?></h3>
    <div id="resume_loading" style="display: none;">
        <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
        <?php echo $this->translate("Loading ...") ?>
    </div>
    <div class="main-form-wrapper">
        <div class="pt-title-from-02">
            <div id="list-references">

            </div>

            <div id="form-works-references" style="display: none">
                <form id="resume_reference_form" action="<?php echo $form->getAction(); ?>" method="post" enctype="application/x-www-form-urlencoded">
                    <div class="work-job-work-form-wrapper">
                        <fieldset class="job-form job-form-step-2">
                            <div class="input">
                                <?php echo $form->name; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->title; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->phone; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->email; ?>
                            </div>
                            <div class="input">
                                <?php echo $form->description; ?>
                            </div>

                            <button id="save" onclick="saveResumeReference('save');" type="button" title="" class="button">Lưu</button>
                            <button onclick="cancelResumeReference('save');" type="button" title="" class="button">Huỷ</button>

                        </fieldset>
                        <div id="list_reference_temp">
                        </div>
                    </div>
                </form>
            </div>
            <a id="btn-add-reference" href="javascript:void(0)" class="pt-supplementary-report" onClick="addReference(this)">Bổ sung</a>
            <div id="main-control">
                <button onclick="back_resume_skill();" type="button" title="" class="button">Quay lại</button>
                <button onclick="preview();" type="button" title="" class="button"><span></span>Tiếp tục</button>
            </div>
            <script>
                function addReference(el) {
                    showFormReferences();
                }
                
                function showFormReferences(){
                    jQuery("#form-works-references").show();
                    jQuery("#list-references").hide();
                    jQuery("#btn-add-reference").hide();
                    jQuery("#main-control").hide();
                }
                
                function hideFormReferences(){
                    jQuery("#form-works-references").hide();
                    jQuery("#list-references").show();
                    jQuery("#btn-add-reference").show();
                    jQuery("#main-control").show();
                }
            </script>
            
        </div>

    </div>

    <input type="hidden" value="<?php echo $resume_id ?>" id="resume_id_reference" />

</div>
<script type="text/javascript">
    function cancelResumeReference(type){
        hideFormReferences();
    }
    function saveResumeReference(type) {
        var content = tinyMCE.activeEditor.getContent(); // get the content
        jQuery('#description').val(content);
        var resume_id = jQuery('#resume_id_reference').val();
        var name_ref = checkValid('#name', 160);

        if (name_ref == false) {
            if (jQuery('#name-element').children().size() < 2) {
                jQuery('#name-element').append('<label class="error" for="name" generated="true"><?php echo $this->translate("Name is not empty."); ?></label>');
            }
            else {
                jQuery('#name-element label').attr('style', 'display:block');
            }
        }

        var valid = name_ref;

        if (valid) {
            $('resume_loading').style.display = "block";
            var url = "<?php echo $this->baseUrl() . '/resumes/reference/index' ?>";
            new Request({
                url: url,
                method: "post",
                data: {
                    'type': type,
                    'resume_id': resume_id,
                    'name': $('name').value,
                    'title': $('title').value,
                    'phone': $('phone').value,
                    'email': $('email').value,
                    'description': jQuery('#description').val()
                },
                onSuccess: function(responseHTML)
                {
                    // inform error date
                    //alert(responseHTML);
                    $('resume_loading').style.display = "none";
                    if (responseHTML == 1) {
                        var url = "<?php echo $this->baseUrl() . '/resumes/reference/list-reference' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            data: {
                                'resume_id': resume_id

                            },
                            onSuccess: function(responseHTML)
                            {
                                //alert(responseHTML);
                                $('list-references').set('html', responseHTML);

                                $('resume_reference_form').reset();
                                
                                hideFormReferences();
                            }
                        }).send();

                    }

                }
            }).send();
        }


    }
    function preview() {
        var resume_id_back = jQuery('#resume_id_reference').val();
        var url = "<?php echo $this->baseUrl() . '/resumes/index/preview/resume_id/' ?>" + resume_id_back;
        window.location.href = url;
    }
    function back_resume_skill() {

        var resume_id_back = jQuery('#resume_id_reference').val();

        var url = "<?php echo $this->baseUrl() . '/resumes/skill/index/resume_id/' ?>" + resume_id_back;
        window.location.href = url;
    }
    function edit_reference(ref_id) {
        console.log("edit_reference");
        
        showFormReferences();
        
        document.documentElement.scrollTop = 200;
        //load data into form
        var name_ref = $('name_refer_' + ref_id).value;
        var title_ref = $('title_refer_' + ref_id).value;
        var phone_ref = $('phone_refer_' + ref_id).value;
        var email_ref = $('email_refer_' + ref_id).value;
        var des_ref = $('description_refer_' + ref_id).get('html');
        //alert(title_ref);
        //populate data
        $('name').set('value', name_ref);
        $('title').set('value', title_ref);
        $('phone').set('value', phone_ref);
        $('email').set('value', email_ref);
        jQuery('#description').html(des_ref);
        tinyMCE.activeEditor.setContent(des_ref);
        //change action at button save and submit
        $('save').destroy();
        var save_new = new Element('input', {'id': "save", 'onclick': "javascript:edit_ref('save');return false;", 'type': "button", 'class': "button", 'name': "save", 'value': "<?php echo $this->translate('Save'); ?>"});
        save_new.inject('refer_id', 'before');
        //fix ie
        save_new.onclick = function() {
            javascript:edit_ref('save');
            return false;
        };


        $('refer_id').set('value', ref_id);
    }
    function edit_ref(type) {
        var content = tinyMCE.activeEditor.getContent(); // get the content
        jQuery('#description').val(content);
        var refer_id = $('refer_id').value;
        //alert(type);
        var resume_id = jQuery('#resume_id_reference').val();
        var name_ref = checkValid('#name', 160);
        if (name_ref == false) {
            if (jQuery('#name-element').children().size() < 2) {
                jQuery('#name-element').append('<label class="error" for="name" generated="true"><?php echo $this->translate("Name is not empty."); ?></label>');
            }
        }

        var valid = name_ref;

        if (valid) {
            $('save').destroy();
            var save_new = new Element('input', {'id': "save", 'onclick': "javascript:saveResumeReference('save');return false;", 'type': "button", 'class': "button", 'name': "save", 'value': "<?php echo $this->translate('Add'); ?>"});
            save_new.inject('refer_id', 'before');
            //fix ie
            save_new.onclick = function() {
                javascript:saveResumeReference('save');
                return false;
            };
            $('resume_loading').style.display = "block";
            var url = "<?php echo $this->baseUrl() . '/resumes/reference/resume-reference-edit' ?>";
            new Request({
                url: url,
                method: "post",
                data: {
                    'ref_id': refer_id,
                    'type': type,
                    'resume_id': resume_id,
                    'name': $('name').value,
                    'title': $('title').value,
                    'phone': $('phone').value,
                    'email': $('email').value,
                    'description': jQuery('#description').val()
                },
                onSuccess: function(responseHTML)
                {
                    // inform error date
                    //alert(responseHTML);
                    $('resume_loading').style.display = "none";
                    if (responseHTML == 1) {
                        var url = "<?php echo $this->baseUrl() . '/resumes/reference/list-reference' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            data: {
                                'resume_id': resume_id

                            },
                            onSuccess: function(responseHTML)
                            {
                                //alert(responseHTML);
                                $('list-references').set('html', responseHTML);

                                $('resume_reference_form').reset();
                                jQuery('#description').html('');
                                
                                hideFormReferences();
                            }
                        }).send();

                    }

                }
            }).send();
        }
    }
    function delete_reference(refer_id) {
        var url = "<?php echo $this->baseUrl() . '/resumes/reference/delete-reference' ?>";
        //alert(url);
        var resume_id = jQuery('#resume_id_reference').val();

        if (confirm("<?php echo $this->translate('Do you really want to delete this reference?'); ?>")) {

            $('resume_loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'refer_id': refer_id

                },
                onSuccess: function(responseHTML)
                {
                    $('resume_reference_form').reset();
                    $('save').destroy();
                    var save_new = new Element('input', {'id': "save", 'onclick': "javascript:saveResumeReference('save');return false;", 'type': "button", 'class': "min submit_save", 'name': "save", 'value': "<?php echo $this->translate('Add'); ?>"});
                    save_new.inject('refer_id', 'before');
                    //fix ie
                    save_new.onclick = function() {
                        javascript:saveResumeReference('save');
                        return false;
                    };
                    $('resume_loading').style.display = "none";
                    if (responseHTML == 1) {
                        var url = "<?php echo $this->baseUrl() . '/resumes/reference/list-reference' ?>";
                        new Request({
                            url: url,
                            method: "post",
                            data: {
                                'resume_id': resume_id

                            },
                            onSuccess: function(responseHTML)
                            {
                                $('list-references').set('html', responseHTML);
                                jQuery('#description').html('');
                            }
                        }).send();
                    }
                    else {
                        alert("Can't delete this reference");
                    }

                }
            }).send();
        }

    }
    window.addEvent('domready', function() {
        //var resume_ref_list = new Element('div', {id: 'resume_reference_list'});
        //resume_ref_list.inject($('list_reference_temp'), 'after');

        var refer_id = new Element('input', {id: 'refer_id', type: 'hidden'});
        refer_id.inject('save', 'after');

        var resume_id_init = jQuery('#resume_id_reference').val();

        var url = "<?php echo $this->baseUrl() . '/resumes/reference/list-reference' ?>";
        new Request({
            url: url,
            method: "post",
            data: {
                'resume_id': resume_id_init

            },
            onSuccess: function(responseHTML)
            {
                //alert(responseHTML);
                $('list-references').set('html', responseHTML);
                //check if edit
                var count_childrent = jQuery('#list-references table tbody').children().size();

                if (count_childrent > 1) {
                    jQuery('#resume_reference_edit').addClass('resume_reference_edit');
                }
            }
        }).send();
        var language = <?php echo count($languages); ?>;
        var group_skill = <?php echo count($group_skills); ?>;

        if (language > 0 || group_skill > 0) {
            jQuery('#resume_skill_edit').addClass('checked_resume');
        }
        var references = <?php echo count($references); ?>;

        if (references > 0) {
            jQuery('#resume_reference_edit').addClass('checked_resume');
        }
        jQuery('#resume_reference_form').validate({
            messages: {
                "name": {
                    required: "<?php echo $this->translate('Name is not empty.') ?>",
                    maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.') ?>"
                },
                "email": {
                    email: "<?php echo $this->translate('Please enter a valid email address.') ?>"
                }
            },
            rules: {
                "name": {
                    required: true,
                    maxlength: 160
                },
                "email": {
                    email: true
                }
            }
        });
    });
</script>