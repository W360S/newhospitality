<style type="text/css">
label.error{color: red;}
.global_form input + label {float:none;}
.global_form > div > div {border:none;}
</style>
<?php
  $this->headScript()
    
    ->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce.js')
	->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<?php
    $form= $this->form; 
?>
<div class="layout_main">
    <div class="headline">
    <?php echo $this->translate('day la headline');?>
    </div>
    <div class="layout_left">
    <?php echo $this->translate('day la left');?>
    </div>
    <div class="layout_middle">
        <div class="artical_main_manage">
           <?php echo $form->render($this);?>
        </div>
    </div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    jQuery("#artical_create_form").validate({
        messages : {
            "title" : {
                required: "<?php echo $this->translate('Title is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            }
		},
		rules: {
            "title" : {
		      required: true,
		      maxlength: 160
		    }
        }
   }); 
});
</script>