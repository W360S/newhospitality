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
        <li>Liệt kê những ngôn ngữ mà bạn có</li>
    </ol>
<?php endif; ?>