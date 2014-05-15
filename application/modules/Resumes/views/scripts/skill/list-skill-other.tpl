<strong>Danh sách kĩ năng khác:</strong>
<?php if (!empty($this->skills) && count($this->skills) >= 1) : ?>

    <?php foreach ($this->skills as $skill): ?>
        <ol>
            <li><strong><?php echo $skill->name; ?></strong></li>
        </ol>
        <span><?php echo date('d F Y', strtotime($skill->creation_date)); ?></span>
        <p>
            <a class="edit" title="<?php echo $this->translate('Edit') ?>" href="javascript:void(0);" onclick="edit_skill_other('<?php echo $skill->skill_id ?>');">Edit</a> | 
            <a class="smoothbox" title="<?php echo $this->translate('Delete') ?>" href="javascript:void(0);" onclick="delete_skill_other('<?php echo $skill->skill_id ?>');">Delete</a>
        </p>
        <div style="display:none">
            <input id="name_skill_other_<?php echo $skill->skill_id ?>" value="<?php echo $skill->name ?>" />
            <div id="description_skill_other_<?php echo $skill->skill_id ?>"><?php echo $skill->description ?></div>
        </div>
    <?php endforeach; ?>

<?php else: ?>

    <ol>
        <li>Liệt kê những kỹ năng mà bạn có</li>
    </ol>
<?php endif; ?>