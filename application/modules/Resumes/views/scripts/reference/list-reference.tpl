<?php 
if(!empty($this->references)){?>
<div class="subsection my-work-experience">
<h2><?php echo $this->translate('Reference')?></h2>
    <table cellspacing="0" cellpadding="0">
    <tr class="row_work">
        <th style="width:218px"><?php echo $this->translate('Name')?></th>
        <th style="width:120px"><?php echo $this->translate('Title ')?></th>
        <th style="width:100px"><?php echo $this->translate('Phone')?></th>
        <th><?php echo $this->translate('Options ')?></th>
    </tr>   
   <?php foreach($this->references as $reference){?>
   <tr>
        <td>
        <?php echo $reference->name;?>
        </td>
        <td>
        <?php echo $reference->title;?>
        </td>
        <td>
        <?php echo $reference->phone;?>
        </td>
        <td>
        <a class="edit" href="javascript:void(0);" onclick="edit_reference('<?php echo $reference->reference_id ?>');"></a>
        
        <a class="smoothbox" href="javascript:void(0);" onclick="delete_reference('<?php echo $reference->reference_id ?>');"></a>
        </td>
   </tr>
    <div style="display:none">
        
        <input id="name_refer_<?php echo $reference->reference_id ?>" value="<?php echo $reference->name ?>" />
        <input id="title_refer_<?php echo $reference->reference_id ?>" value="<?php echo $reference->title ?>" />
        <input id="phone_refer_<?php echo $reference->reference_id ?>" value="<?php echo $reference->phone ?>" />
        <input id="email_refer_<?php echo $reference->reference_id ?>" value="<?php echo $reference->email ?>" />
        <div id="description_refer_<?php echo $reference->reference_id ?>"><?php echo $reference->description ?></div>
       
   </div>
    <?php }?>
    </table>
    </div>
<?php }
?>