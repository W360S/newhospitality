<?php 
if(!empty($this->works)){?>
<div class="subsection my-work-experience">
    <h2><?php echo $this->translate('My Work Experience')?></h2>
    <table cellspacing="0" cellpadding="0">
    <tr>
        <th style="width:218px"><?php echo $this->translate('Company')?></th>
        <th style="width:240px"><?php echo $this->translate('Title ')?></th>
        <th ><?php echo $this->translate('Options ')?></th>
    </tr>   
   <?php foreach($this->works as $work){?>
   <tr>
        
        <td ><?php echo $work->company_name;?></td>
        <td ><?php echo $work->title;?></td>
        
        
        <td >
        <a class="edit" title="<?php echo $this->translate('Edit')?>" href="javascript:void(0);" onclick="edit_work('<?php echo $work->experience_id ?>');"></a>

        <a class="smoothbox" title="<?php echo $this->translate('Delete')?>" href="javascript:void(0);" onclick="delete_work('<?php echo $work->experience_id ?>');"></a>
        </td>
   </tr>
   <div style="display:none">
        
        <input id="num_year_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->num_year ?>" />
        <input id="title_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->title ?>" />
        <input id="company_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->company_name ?>" />
        <input id="job_level_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->level_id ?>" />
        <input id="category_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->category_id ?>" />
        <input id="country_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->country_id ?>"/>
        <input id="city_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->city_id ?>" />
        <input id="start_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->starttime ?>" />
        <input id="end_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->endtime ?>" />
        <div id="description_exp_<?php echo $work->experience_id ?>"><?php echo $work->description ?></div>
   </div>
   
    <?php }?>
    </table>
    </div>
<?php }
?>