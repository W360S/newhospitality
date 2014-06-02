<div class="settings">
<div class='global_form'>
  <?php if ($this->contact_ids):?>
  <form method="post">
    <div>
      <h3><?php echo $this->translate("Send email to selected contacts?") ?></h3>
      
      <br />
      <p>
        <input type="hidden" name="confirm" value='true'/>
        <input type="hidden" name="contact_ids" value="<?php echo $this->contact_ids?>"/>
        <br/>
        <input type="text" value="" id="name" name="name">
        <br/>
        <textarea rows="10" cols="80" id="body" name="body"></textarea>
        <br/>
        <button type='submit'><?php echo $this->translate("Send") ?></button>
        <br/>
        <?php echo Zend_Registry::get('Zend_Translate')->_(' or ') ?>
        <a href='<?php echo $this->url(array('action' => 'list-contact', 'id' => null)) ?>'>
        <?php echo $this->translate("cancel") ?></a>
      </p>
    </div>
  </form>
  <?php else: ?>
    <?php echo $this->translate("Please select a contact to send email.") ?> <br/><br/>
    <a href="<?php echo $this->url(array('action' => 'list-contact')) ?>" class="buttonlink icon_back">
      <?php echo $this->translate("Go Back") ?>
    </a>
  <?php endif;?>
</div>
</div>
<?php if( @$this->closeSmoothbox ): ?>
<script type="text/javascript">
  TB_close();
</script>
<?php endif; ?>
