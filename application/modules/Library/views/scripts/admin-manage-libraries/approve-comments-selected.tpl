<div class="settings">
<div class='global_form'>
  <?php if ($this->approve_ids):?>
  <form method="post">
    <div>
      <h3><?php echo $this->translate("Approve the selected comments?") ?></h3>
      <p>
        <?php echo $this->translate("Are you sure that you want to approve the %d comments? It will not be recoverable after being approve.", $this->count) ?>
      </p>
      <br />
      <p>
        <input type="hidden" name="confirm" value='true'/>
        <input type="hidden" name="approve_ids" value="<?php echo $this->approve_ids?>"/>
        <input type="hidden" name="book_id" value="<?php echo $this->book_id; ?>"/>
        <button type='submit'><?php echo $this->translate("Approve") ?></button>
        <?php echo Zend_Registry::get('Zend_Translate')->_(' or ') ?>
        <a href='<?php echo $this->url(array('action' => 'index', 'id' => null)) ?>'>
        <?php echo $this->translate("cancel") ?></a>
      </p>
    </div>
  </form>
  <?php else: ?>
    <?php echo $this->translate("Please select a comment to approve.") ?> <br/><br/>
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
