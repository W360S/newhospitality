<?php if (!empty($this->educations) && count($this->educations) >=1) : ?>

    <?php foreach ($this->educations as $education): ?>
        <ol>
            <li><strong><?php echo $education->school_name; ?></strong></li>
        </ol>
        <span><?php echo $education->major; ?> - <?php echo $education->starttime ?> <?php echo $education->endtime ?></span>
        <p>
            <a class="edit" title="<?php echo $this->translate('Edit') ?>" href="javascript:void(0);" onclick="edit_education('<?php echo $education->education_id ?>');">Edit</a> | 
            <a class="smoothbox" title="<?php echo $this->translate('Delete') ?>" href="javascript:void(0);" onclick="delete_education('<?php echo $education->education_id ?>');">Delete</a>
        </p>

    <?php endforeach; ?>
    
<?php else: ?>
    <strong>Mô tả chi tiết:</strong>
    <ol>
        <li>Liệt kê bằng cấp chuyên môn, các khóa ngắn hạn hay những chương trình sau đại học bạn đã theo học.</li>
    </ol>
<?php endif; ?>