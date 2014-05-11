<strong>Kĩ năng ngoại ngữ :</strong>
<?php if (!empty($this->arr) && count($this->arr) >=1) : ?>

    <?php foreach ($this->arr as $key=>$value): ?>
        <ol>
            <li><strong><?php echo $value['lang'];?></strong></li>
        </ol>
        <span><?php echo $value['skill'];?></span>
        <p>
            <a class="edit" title="<?php echo $this->translate('Edit') ?>" href="javascript:void(0);" onclick="edit_skill('<?php echo $key ?>');">Edit</a> | 
            <a class="smoothbox" title="<?php echo $this->translate('Delete') ?>" href="javascript:void(0);" onclick="delete_skill('<?php echo $key ?>');">Delete</a>
        </p>

    <?php endforeach; ?>
    
<?php else: ?>
    
    <ol>
        <li>Nhiệm vụ chính của từng vị trí bạn đảm trách</li>
        <li>Dự án đã tham gia hay quản lý (nếu có)</li>
        <li>Thành tích, kỹ năng đạt được</li>
    </ol>
<?php endif; ?>