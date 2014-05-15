<?php if (!empty($this->references) && count($this->references) >=1) : ?>

    <?php foreach ($this->references as $reference): ?>
        <ol>
            <li><strong><?php echo $reference->name; ?></strong></li>
        </ol>
        <span><?php echo $reference->title; ?> - <?php echo $reference->phone ?> <?php echo $reference->email ?></span>
        <p>
            <a class="edit" title="<?php echo $this->translate('Edit') ?>" href="javascript:void(0);" onclick="edit_reference('<?php echo $reference->reference_id ?>');">Edit</a> | 
            <a class="smoothbox" title="<?php echo $this->translate('Delete') ?>" href="javascript:void(0);" onclick="delete_reference('<?php echo $reference->reference_id ?>');">Delete</a>
        </p>

    <?php endforeach; ?>
    
<?php else: ?>
    <strong>Mô tả chi tiết:</strong>
    <ol>
        <li>Những nhận xét từ đồng nghiệp/thầy cô/bạn bè sẽ giúp nhà tuyển dụng hiểu rõ hơn về tính cách và năng lực của bạn. Nên chọn người bạn nghĩ sẽ đưa ra nhận xét tốt.</li>
    </ol>
<?php endif; ?>
