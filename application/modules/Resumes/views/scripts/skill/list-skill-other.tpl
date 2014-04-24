<?php 
if(!empty($this->skills)){?>
<div class="subsection my-work-experience">
<h2><?php echo $this->translate('Other Skill')?></h2>
     <table cellspacing="0" cellpadding="0">
    <tr class="row_work">
        <th style="width:218px"><?php echo $this->translate('Skill')?></th>
        <th style="width:240px"><?php echo $this->translate('Create Date')?></th>
        <th><?php echo $this->translate('Options ')?></th>
    </tr>   
   <?php foreach($this->skills as $skill){?>
   <tr>
        <td>
        <?php echo $skill->name;?>
        </td>
        <td>
        <?php echo date('d F Y', strtotime($skill->creation_date));?>
        </td>
        <td>
        <a class="edit" href="javascript:void(0);" onclick="edit_skill_other('<?php echo $skill->skill_id ?>');"></a>

        <a class="smoothbox" href="javascript:void(0);" onclick="delete_skill_other('<?php echo $skill->skill_id ?>');"></a>
        </td>
   </tr>
    <div style="display:none">
        
        <input id="name_skill_other_<?php echo $skill->skill_id ?>" value="<?php echo $skill->name ?>" />
       
        <div id="description_skill_other_<?php echo $skill->skill_id ?>"><?php echo $skill->description ?></div>
   </div>
    <?php }?>
    </table>
    </div>
<?php }
?>