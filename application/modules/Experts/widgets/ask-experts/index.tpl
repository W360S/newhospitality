<dt><a href="#"><?php echo $this->translate('Quản lý câu hỏi'); ?></a></dt>
<dd>
<div class="subcontent">
    <fieldset class="ask-experts">
        <form method="post" action="<?php echo $this->baseUrl().'/experts/my-questions/compose'; ?>"  enctype="multipart/form-data" >
        <textarea onblur="if(this.value == '') this.value = '<?php echo $this->translate('Tell us your issue?..') ?>';" onfocus="if(this.value == '<?php echo $this->translate('Tell us your issue?..') ?>') this.value = '';" id="description"  name="description" rows="3" cols="25"><?php echo $this->translate('Tell us your issue?..') ?></textarea>
        <input type="submit" value="<?php echo $this->translate('Send'); ?>" />
        </form>
    </fieldset>
</div>
</dd>
