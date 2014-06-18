<form method="post" class="global_form_popup" action="<?php echo $this->url(array()) ?>">
  <div>
    <h3><?php echo $this->translate("Approve this comment?") ?></h3>
    <p>
      <?php echo $this->translate("Are you sure that you want to approve this comment? It will not be recoverable after being approve.") ?>
    </p>
    <br />
    <p>
      <button type='submit'><?php echo $this->translate("Approve") ?></button>
      <?php echo $this->translate("or") ?>
    	<a href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
    		<?php echo $this->translate("Cancel") ?>
    	</a>
    </p>
  </div>
</form>

<?php if( @$this->closeSmoothbox ): ?>
  <script type="text/javascript">
    TB_close();
  </script>
<?php endif; ?>
