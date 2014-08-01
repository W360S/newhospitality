<div class="subsection">
   
    <div class="subcontent">
		<div class="content_online_resume">
			<a class="post_question" href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-questions','action'=>'compose'),'default',true); ?>"><?php echo $this->translate('Post A Question');?></a>
			<ul class="jobs_management expert_management">
                <?php if($this->check_expert > 0): ?>
                <li>
                    <a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-experts','action'=>'index'),'default',true); ?>"><?php echo $this->translate('Expert Tool'); ?><?php echo "(". intval($this->cnt_experts).")"; ?></a>
                </li>
                <?php endif; ?>
                <li>
                    <a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-questions','action'=>'index'),'default',true); ?>"><?php echo $this->translate('My Questions'); ?><?php echo " (". intval($this->cnt_questions).")"; ?></a>
                </li>
				
            </ul>	
		</div>	
    </div>
</div>
