<?php if (!empty($this->works) && count($this->works) >=1) : ?>

    <?php foreach ($this->works as $work): ?>
        <ol>
            <li><strong><?php echo $work->title; ?></strong></li>
        </ol>
        <span><?php echo $work->company_name; ?> - <?php echo $work->starttime ?> <?php echo $work->endtime ?></span>
        <p>
            <a href="javascript:void(0)">Xem chi tiết</a> | 
            <a class="edit" title="<?php echo $this->translate('Edit') ?>" href="javascript:void(0);" onclick="edit_work('<?php echo $work->experience_id ?>');">Edit</a> | 
            <a class="smoothbox" title="<?php echo $this->translate('Delete') ?>" href="javascript:void(0);" onclick="delete_work('<?php echo $work->experience_id ?>');">Delete</a>
        </p>

    <?php endforeach; ?>
    
<?php else: ?>
    <strong>Mô tả chi tiết:</strong>
    <ol>
        <li>Nhiệm vụ chính của từng vị trí bạn đảm trách</li>
        <li>Dự án đã tham gia hay quản lý (nếu có)</li>
        <li>Thành tích, kỹ năng đạt được</li>
    </ol>
<?php endif; ?>