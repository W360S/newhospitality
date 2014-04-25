<?php 
if($this->educations){?>
<div class="subsection my-work-experience">
    <h2><?php echo $this->translate('My Education')?></h2>
    <table cellspacing="0" cellpadding="0">
    <tr class="row_work">
        <th style="width:218px"><?php echo $this->translate('School Name')?></th>
        <th style="width:240px"><?php echo $this->translate('Graduation Date')?></th>
        <th><?php echo $this->translate('Options ')?></th>
    </tr>   
   <?php foreach($this->educations as $education){?>
   <tr>
        <td>
        <?php echo $education->school_name;?>
        </td>
        <td>
        <?php echo date('F Y', strtotime($education->endtime));?>
        </td>
        <td>
        <a class="edit" href="javascript:void(0);" onclick="edit_education('<?php echo $education->education_id ?>');"></a>

        <a class="smoothbox" href="javascript:void(0);" onclick="delete_education('<?php echo $education->education_id ?>');"></a>
        </td>
   </tr>
    <div style="display:none">
        
        <input id="degree_level_edu_<?php echo $education->education_id ?>" value="<?php echo $education->degree_level_id ?>" />
        <input id="school_name_edu_<?php echo $education->education_id ?>" value="<?php echo $education->school_name ?>" />
        <input id="major_edu_<?php echo $education->education_id ?>" value="<?php echo $education->major ?>" />
        <input id="country_edu_<?php echo $education->education_id ?>" value="<?php echo $education->country_id ?>" />
        
        <input id="start_edu_<?php echo $education->education_id ?>" value="<?php echo $education->starttime ?>" />
        <input id="end_edu_<?php echo $education->education_id ?>" value="<?php echo $education->endtime ?>" />
        <div id="description_edu_<?php echo $education->education_id ?>"><?php echo $education->description ?></div>
   </div>
    <?php }?>
    </table>
    </div>
<?php }
?>