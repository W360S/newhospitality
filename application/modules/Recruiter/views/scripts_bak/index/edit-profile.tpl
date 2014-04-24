<style type="text/css">
.job-form .input label.error{color: red; clear:both; width:266px;}
.job-form .company_size label.error{ width:256px;}
.job-form .input label {width: 93px;}
.panel{position:absolute;}
.panel .trigger{width: 359px;}
.panel .content{width: 350px;}
#description-label label{float:none;}
#industries-element ul.form-options-wrapper{
    height: 186px;
    overflow-y: auto;
    width: 360px;
    border: #E5E5E5 solid 1px;
}
</style>
<?php
  $this->headScript()
    
    ->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce.js')
	->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<?php $form= $this->form;?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter'?>"><?php echo $this->translate("Recruiter");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Edit company profile");?></strong>
    </div>
</div>
<div class="layout_main">
    <div class="content">
    <div class="section recruiter">
    <div class="layout_right">
        <?php echo $this->content()->renderWidget('recruiter.sub-menu');?>
        <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
        <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
        <div class="subsection">
            <a href="#"><img alt="Image" src="application/modules/Core/externals/images/img-showcase-4.jpg"></a>
        </div>
    </div>
    <div class="layout_middle">
    <div class="subsection">
            <h2>Create new company profile</h2>
            <form id="recruiter_profile_form" action="<?php echo $form->getAction();?>" method="post" enctype="multipart/form-data">
            <fieldset class="job-form">
                <div class="input company_name">
                    <?php echo $form->company_name;?>
                </div>
                <div class="input company_size">
                    <?php echo $form->company_size;?>
                </div>
                <div class="input file">
                    <?php echo $form->logo;?>
                </div>
                <div class="input">
                    <?php echo $form->industries;?>
                </div>
                <div class="input">
                    <?php echo $form->description;?>
                </div>
                <div class="submit">
                    <input type="submit" value="Create" class="min" />
                    <input type="reset" value="Reset" class="min" onclick="reset();" />
                </div>
            </fieldset>
            </form>
        </div>
    
    </div>
    </div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    //var create_profile= document.id('create_profile');
   //$('industries-element').inject(create_profile);
   //$('profile').inject('industries-label', 'after');
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