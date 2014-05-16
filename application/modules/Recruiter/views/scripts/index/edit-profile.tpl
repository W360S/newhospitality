<?php
  $this->headScript()
    
    ->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce.js')
	->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<?php $form= $this->form;?>
<div class="pt-title-event">
    <ul class="pt-menu-event pt-menu-libraries">
        <li>
            <a href="/recruiter">Dành cho nhà tuyển dụng</a>
        </li>
        <li>
            <span>Chỉnh sửa hồ sơ</span>
        </li>
    </ul>
</div>
<div class="subsection">
    <h3 class="pt-title-right">Edit company profile</h3>
    <div class="main-form-wrapper">
        <form id="recruiter_profile_form" action="<?php echo $form->getAction(); ?>" method="post" enctype="multipart/form-data">
            <div class="fieldset-wrapper">
                <fieldset class="job-form">
                    <div class="input company_name">
                        <?php echo $form->company_name; ?>
                    </div>
                    <div class="input company_size">
                        <?php echo $form->company_size; ?>
                    </div>
                    <div class="input file">
                        <?php echo $form->logo; ?>
                    </div>
                    <div class="input">
                        <?php echo $form->industries; ?>
                    </div>
                    <div class="input">
                        <?php echo $form->description; ?>
                    </div>
                    <div class="submit">
                        <button type="submit" value="Create" class="min">Luu</button>
                        <button type="reset" value="Reset" class="min" onclick="reset();">Huy</button>
                    </div>
                </fieldset>
            </div>
            
        </form>
    </div>
    
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
   jQuery("#recruiter_profile_form").validate({
        messages : {
            "company_name" : {
                required: "<?php echo $this->translate('Company name is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            },
            "company_size":{
                required: "<?php echo $this->translate('Company size is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            }
		},
		rules: {
            "company_name" : {
		      required: true,
		      maxlength: 160
		    },
            "company_size":{
                required: true,
                maxlength: 160
            }
        }
   }); 
});
function reset(){
    $('recruiter_profile_form').reset();
}
</script>