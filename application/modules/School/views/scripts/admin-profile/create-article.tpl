<style type="text/css">
input{
	width: 230px;
    margin-bottom: 10px;
}

</style>
<?php
  $this->headScript()
    
    ->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce.js')
	->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<h2><?php echo $this->translate("School Plugin") ?></h2>

<?php if( count($this->navigation) ): ?>
  <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
  </div>
<?php endif; ?>

<?php echo $this->form->render($this);?>