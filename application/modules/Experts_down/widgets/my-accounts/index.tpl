<h3 class="pt-title-right">Quản lý câu hỏi </h3>
<div class="pt-how-story">
	<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-experts','action'=>'index'),'default',true); ?>" class="pt-link-01"><?php echo $this->translate('Câu hỏi tôi đã trả lời'); ?><?php echo "(". intval($this->cnt_experts).")"; ?></a>
	<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-questions','action'=>'index'),'default',true); ?>" class="pt-link-02"><?php echo $this->translate('Câu hỏi của tôi'); ?><?php echo "(". intval($this->cnt_answers).")"; ?></a>
</div>