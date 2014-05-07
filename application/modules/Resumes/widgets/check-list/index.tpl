<div class="pt-right-job"> 
    <div class="pt-block">
        <h3 class="pt-title-right" style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 14px 0;  text-transform: uppercase;">
            <?php echo $this->translate('Check List') ?>
        </h3>
        <ul class="pt-list-cbth">
            <li class="<?php if($this->step > 1):?>pt-active<?php endif; ?>"><span class="pt-number-1">1</span><span class="pt-text"><?php echo $this->translate('Compulsory') ?></span><span class="pt-icon-oky"></span></li>
            <li class="<?php if($this->step > 2):?>pt-active<?php endif; ?>"><span class="pt-number-1">2</span><span class="pt-text"><?php echo $this->translate('Work experience ') ?></span><span class="pt-icon-oky"></span></li>
            <li class="<?php if($this->step > 3):?>pt-active<?php endif; ?>"><span class="pt-number-1">3</span><span class="pt-text"><?php echo $this->translate('Education') ?></span><span class="pt-icon-oky"></span></li>
            <li class="<?php if($this->step > 4):?>pt-active<?php endif; ?>"><span class="pt-number-1">4</span><span class="pt-text"><?php echo $this->translate('Skills ') ?></span><span class="pt-icon-oky"></span></li>
            <li class="<?php if($this->step > 5):?>pt-active<?php endif; ?>"><span class="pt-number-1">5</span><span class="pt-text"><?php echo $this->translate('Reference ') ?></span><span class="pt-icon-oky"></span></li>
        </ul>
    </div>	
</div>