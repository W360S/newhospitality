<?php
$apply = $this->apply;
$candidate = $this->candidate;
$notes = $this->notes;
?>

<div class="pt-event-tabs">
    <ul class="pt-title">
        <li id="tabs-1-title" class="ui-state-active"><a href="javascript:ishowTab1()">Nội dung đơn xin việc</a></li>
        <li id="tabs-4-title" class=""><a href="javascript:ishowTab4()">Ghi chú</a></li>
        <li id="tabs-2-title" class=""><a href="javascript:ishowTab2()">Hồ sơ xin việc</a></li>
    </ul>
    <div id="tabs-1" class="pt-content-tab">
        <p><span><?php echo $this->translate('Subject: ') ?></span> <strong><?php echo $candidate->title; ?> </strong></p>
        <p><span><?php echo $this->translate('Content: ') ?></span></p>
        <div class="content_letter">
            <?php echo $candidate->content; ?>
        </div>
        <?php if (!empty($this->storage)) { ?>
            <p><span><?php echo $this->translate('Attachment: ') ?></span>
                <a href="<?php echo $this->baseUrl('/') . $this->storage->storage_path; ?>"><?php
                    $size = round($this->storage->size / 1024, 2);
                    echo $this->storage->name . " (" . $size . " KB)";
                    ?></a>
            </p>
        <?php } ?>

    </div>
    
    <div id="tabs-4" style="display: none" class="pt-content-tab">
        <!--Content-->
        <?php //if(empty($candidate->description)){   ?>
        <div id="resume_loading" style="display: none;">
            <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
            <?php echo $this->translate("Loading ...") ?>
        </div>
        <form id="note_form">
            <div >
                <textarea cols="50" rows="7" id="des_note"></textarea>
                <input type="hidden" value="<?php echo $apply ?>" id="apply" />
                <button onclick="add_note();
                        return false;"><?php echo $this->translate('Save') ?></button>
            </div>
        </form>
        <?php //}else{   ?>
        <div id="note_job" class="my-work-experience">
            <table>
                <tr>
                    <th style="width: 150px;"><?php echo $this->translate('Created Date') ?></th>
                    <th style="width: 380px;"><?php echo $this->translate('Note') ?></th>
                    <th></th>
                </tr>

                <?php
                if (!empty($notes)) {
                    foreach ($notes as $note) {
                        ?>
                        <tr>
                            <td><?php echo date('d F Y', strtotime($note->creation_date)) ?></td>
                            <td><?php echo $note->description; ?></td>
                            <td><a href="javascript:void(0);" onclick="delete_note('<?php echo $note->note_id ?>');"></a></td>
                        </tr>
                        <?php
                    }
                }
                ?>

            </table>
        </div>
        <?php //}   ?>
    </div>
    
    <div id="tabs-2" style="display: none" class="pt-content-tab">
        <?php echo $this->content()->renderWidget('resumes.resume'); ?>
    </div>

</div>
<div id="save_success" style="padding-top: 10px; display:none; color: red;"><?php echo $this->translate('You have been saved this candidate successfully!') ?></div>
<a class="print_profile" href="<?php echo $this->baseUrl() . '/resumes/resume/pdf/resume_id/' . $candidate->resume_id ?>"><?php echo $this->translate("Print to profile"); ?></a>

<script>
    function ishowTab1() {
        jQuery(".pt-content-tab").each(function() {
            jQuery(this).hide();
        });
        jQuery("#tabs-1").show();
        jQuery("#tabs-1-title").addClass('ui-state-active');
        jQuery("#tabs-2-title").removeClass('ui-state-active');
        jQuery("#tabs-4-title").removeClass('ui-state-active');
    }

    function ishowTab2() {
        jQuery(".pt-content-tab").each(function() {
            jQuery(this).hide();
        });
        jQuery("#tabs-2").show();
        jQuery("#tabs-2-title").addClass('ui-state-active');
        jQuery("#tabs-1-title").removeClass('ui-state-active');
        jQuery("#tabs-4-title").removeClass('ui-state-active');
    }

    function ishowTab4() {
        jQuery(".pt-content-tab").each(function() {
            jQuery(this).hide();
        });
        jQuery("#tabs-4").show();
        jQuery("#tabs-4-title").addClass('ui-state-active');
        jQuery("#tabs-2-title").removeClass('ui-state-active');
        jQuery("#tabs-1-title").removeClass('ui-state-active');
    }
</script>

<script type="text/javascript">
    function add_note() {
        var description = $('des_note').value;
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/add-note' ?>";
        $('resume_loading').style.display = "block";
        new Request({
            url: url,
            method: "post",
            data: {
                'apply_id': $('apply').value,
                'description': description
            },
            onSuccess: function(responseHTML)
            {
                $('note_form').reset();
                $('des_note').set('html', ' ');
                $('resume_loading').style.display = "none";
                $('note_job').set('html', responseHTML);

            }
        }).send();
    }
    function delete_note(note_id) {
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/del-note' ?>";

        if (confirm("<?php echo $this->translate('Do you really want to delete this note?'); ?>")) {
            $('resume_loading').style.display = "block";
            new Request({
                url: url,
                method: "post",
                data: {
                    'note_id': note_id,
                    'apply_id': $('apply').value
                },
                onSuccess: function(responseHTML)
                {
                    $('resume_loading').style.display = "none";
                    $('note_job').set('html', responseHTML);
                }
            }).send();
        }
    }
    function save_candidate() {
        var url = "<?php echo $this->baseUrl() . '/recruiter/job/add-candidate' ?>";
        var href = window.location;
        if (confirm("<?php echo $this->translate('Do you really want to save this candidate?'); ?>")) {

            new Request({
                url: url,
                method: "post",
                data: {
                    'apply_id': $('apply').value
                },
                onSuccess: function(responseHTML)
                {
                    $('save_success').style.display = 'block';
                }
            }).send();
        }
    }
</script>
