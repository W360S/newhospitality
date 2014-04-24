<style type="text/css">

/* tab */
.layout_middle .tab .item { height: 31px; overflow: hidden; }
.layout_middle .tab .item li { float: left; margin-right: 3px; }
.layout_middle .tab .item li a, .layout_middle .tab .item li a span { display: block; }

.layout_middle .tab .item li a:hover { background-position: left -459px; }
.layout_middle .tab .item li a span { font-size: 1.25em; cursor: pointer; }
.layout_middle .tab .item li.current a { background-color: #00a9dd; background-image: none; color: #fff; text-shadow: #333 1px 1px; }

.layout_middle .tab .content { background-color: #e9f4fa; border: #d0e2ec solid 1px; border-radius: 3px; -moz-border-radius: 3px; -webkit-border-radius: 3px; border-top-left-radius: 0; -moz-border-radius-topleft: 0; -webkit-border-radius-topleft: 0; padding: 9px; }

</style>
<?php
$apply= $this->apply; 
$candidate= $this->candidate;
$notes= $this->notes;
?>
<div class="tab">
    <ul class="item">
        <li><a href="#section-1"><?php echo $this->translate("Applicant Letter");?></a></li>
        <li><a href="#section-2"><?php echo $this->translate("Resume");?></a></li>
        <li><a href="#section-3"><?php echo $this->translate("My Note");?></a></li>
    </ul>
    <div class="content">
        <div id="section-1">
            <p><span><?php echo $this->translate('Subject: ')?></span> <strong><?php echo $candidate->title;?> </strong></p>
            <p><span><?php echo $this->translate('Content: ')?></span></p>
			<div class="content_letter">
            <?php echo $candidate->content;?>
			</div>
            <?php if(!empty($this->storage)){?>
                <p><span><?php echo $this->translate('Attachment: ')?></span>
                <a href="<?php echo $this->baseUrl("/").$this->storage->storage_path; ?>"><?php $size = round($this->storage->size/1024,2); echo $this->storage->name. " (".$size." KB)"; ?></a>
                </p>
            <?php }?>
            
        </div>
        <div id="section-2">
            <?php echo $this->content()->renderWidget('resumes.resume');?>
        </div>
        <div id="section-3">
            <!--Content-->
               <?php //if(empty($candidate->description)){?>
                    <div id="resume_loading" style="display: none;">
                      <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
                      <?php echo $this->translate("Loading ...") ?>
                    </div>
                   <form id="note_form">
                   <div >
                        <textarea cols="50" rows="7" id="des_note"></textarea>
                        <input type="hidden" value="<?php echo $apply ?>" id="apply" />
                        <br />
                        <br />
                        <button onclick="add_note();return false;"><?php echo $this->translate('Save')?></button>
                   </div>
                   </form>
               <?php //}else{?>
                <br />
                    <div id="note_job" class="my-work-experience">
                        <table>
                        <tr>
                            <th style="width: 150px;"><?php echo $this->translate('Created Date')?></th>
                            <th style="width: 380px;"><?php echo $this->translate('Note')?></th>
                            <th></th>
                        </tr>
                        
                        <?php
                        if(!empty($notes)){
                            foreach($notes as $note){?>
                            <tr>
                                <td><?php echo date('d F Y', strtotime($note->creation_date)) ?></td>
                                <td><?php echo $note->description;?></td>
                                <td><a href="javascript:void(0);" onclick="delete_note('<?php echo $note->note_id ?>');"></a></td>
                            </tr>
                            <?php }
                        }
                        ?>
                        
                        </table>
                    </div>
               <?php //}?>
        </div>
    </div>
</div>
<div id="save_success" style="padding-top: 10px; display:none; color: red;"><?php echo $this->translate('You have been saved this candidate successfully!')?></div>
<a class="print_profile" href="<?php echo $this->baseUrl().'/resumes/resume/pdf/resume_id/'.$candidate->resume_id ?>"><?php echo $this->translate("Print to profile");?></a>

<script type="text/javascript">
function add_note(){
    var description= $('des_note').value;
    var url= "<?php echo $this->baseUrl().'/recruiter/job/add-note' ?>";
    $('resume_loading').style.display="block";
    new Request({
        url: url,
        method: "post",
        data : {
        		
        		'apply_id': $('apply').value,
                'description': description
        	},
        onSuccess : function(responseHTML)
        {
            $('note_form').reset();
            $('des_note').set('html', ' ');
            $('resume_loading').style.display="none";
            $('note_job').set('html', responseHTML);
        		
        }
    }).send();
}
function delete_note(note_id){
    var url= "<?php echo $this->baseUrl().'/recruiter/job/del-note' ?>";
    
    if(confirm("<?php echo $this->translate('Do you really want to delete this note?');?>")){
        $('resume_loading').style.display="block";
        new Request({
            url: url,
            method: "post",
            data : {
            		'note_id': note_id,
                    'apply_id': $('apply').value
            	},
            onSuccess : function(responseHTML)
            {
                $('resume_loading').style.display="none";
                $('note_job').set('html', responseHTML);
            }
        }).send();
    }
}
function save_candidate(){
    var url= "<?php echo $this->baseUrl().'/recruiter/job/add-candidate' ?>";
    var href= window.location;
    if(confirm("<?php echo $this->translate('Do you really want to save this candidate?');?>")){
        
        new Request({
            url: url,
            method: "post",
            data : {
                    'apply_id': $('apply').value
            	},
            onSuccess : function(responseHTML)
            { 
               $('save_success').style.display= 'block';
            }
        }).send();
    }
}
</script>
