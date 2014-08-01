<form method="post" class="global_form_popup" action="<?php echo $this->url(array()) ?>">
  <div>
    <textarea rows="10" cols="60" id="add_detail"  name="add_detail"></textarea>
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
