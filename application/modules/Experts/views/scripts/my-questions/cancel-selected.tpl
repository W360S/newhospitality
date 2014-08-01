<div class="settings">
<div class='global_form'>
  <?php if ($this->ids):?>
  <form method="post">
    <div>
      <h3><?php echo $this->translate("Cancel the selected quetions?") ?></h3>
      <p>
        <?php echo $this->translate("Are you sure that you want to cancel the %d quetions? It will not be recoverable after being applied.", $this->count) ?>
      </p>
      <br />
      <p>
        <input type="hidden" name="confirm" value='true'/>
        <input type="hidden" name="ids" value="<?php echo $this->ids?>"/>
        
        <button type='submit'><?php echo $this->translate("Submit") ?></button>
        <?php echo Zend_Registry::get('Zend_Translate')->_(' or ') ?>
        <a href='<?php echo $this->url(array('action' => 'index', 'id' => null)) ?>'>
        <?php echo $this->translate("cancel") ?></a>
      </p>
    </div>
  </form>
  <?php else: ?>
    <?php echo $this->translate("Please select a quetion to cancel.") ?> <br/><br/>
    <a href="<?php echo $this->url(array('action' => 'index')) ?>" class="buttonlink icon_back">
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
