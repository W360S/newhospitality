<form method="post" class="global_form_popup" action="<?php echo $this->url(array()) ?>">
  <div>
    <h3><?php echo $this->translate("Close this question?") ?></h3>
    <p>
      <?php echo $this->translate("Are you sure that you want to close this question? It will not be recoverable after being closed.") ?>
    </p>
    <br />
    <p>
      <button type='submit'><?php echo $this->translate("Submit") ?></button>
      <?php echo $this->translate("or") ?>
    	<a href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
    		<?php echo $this->translate("cancel") ?>
    	</a>
    </p>
  </div>
</form>

<?php if( @$this->closeSmoothbox ): ?>
  <script type="text/javascript">
    TB_close();
  </script>
<?php endif; ?>
