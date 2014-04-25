<div class="subsection my-work-experience">
<h2><?php echo $this->translate('My Language')?></h2>
    <table cellspacing="0" cellpadding="0">
    <tr class="row_work">
        <th style="width:218px"><?php echo $this->translate('Language Proficiency')?></th>
        <th style="width:240px"><?php echo $this->translate('Language Level')?></th>
        <th><?php echo $this->translate('Options ')?></th>
    </tr>   
    <?php 
    if(!empty($this->arr)){?>
   <?php foreach($this->arr as $key=> $value){?>
   <tr>
        <td>
        <?php echo $value['lang'];?>
        </td>
        <td>
        <?php echo $value['skill'];?>
        </td>
        <td>
        <a class="edit" href="javascript:void(0);" onclick="edit_skill('<?php echo $key ?>');"></a>

        <a class="smoothbox" href="javascript:void(0);" onclick="delete_skill('<?php echo $key ?>');"></a>
        </td>
   </tr>
    <div style="display:none">
        
        <input id="language_pro_<?php echo $key ?>" value="<?php echo $value['lang'] ?>" />
        <input id="group_pro_<?php echo $key ?>" value="<?php echo $value['skill'] ?>" />
       
   </div>
    <?php }?>
    <?php }
?>
    </table>
</div>