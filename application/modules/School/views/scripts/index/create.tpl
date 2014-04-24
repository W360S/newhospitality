<style type="text/css">
label.error{color: red;}
.global_form input + label {float:none;}
.global_form > div > div {border:none;}
</style>
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
        <div class="school_main">
            <?php echo $form->render($this);?>
        </div>
    </div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    jQuery("#school_create_form").validate({
        messages : {
            "name" : {
                required: "<?php echo $this->translate('School name is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            },
             "email":{
                email: "<?php echo $this->translate('Please enter a valid email address.')?>"
             }
		},
		rules: {
            "name" : {
		      required: true,
		      maxlength: 160
		    },
            "email":{
                email: true
            }
        }
   }); 
});
</script>