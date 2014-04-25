<style type="text/css">
.panel{position:absolute;}
.panel .trigger{width: 359px;}
.panel .content{width: 350px;}

.job-form .input label.error{color: red; clear:both; width:221px;}
.job-form .contact_name label.error{ width:232px;}
.job-form .contact_via ul li { clear:none; margin-left:-3px; margin-top: -4px; padding:0px;}
#industries-element ul.form-options-wrapper, #types-element ul.form-options-wrapper, #categories-element ul.form-options-wrapper{
    height: 186px;
    overflow-y: auto;
    width: 360px;
    border: #E5E5E5 solid 1px;
}
.job-form .job_year_experience label.error{padding-left: 48px;}
.job-form .job_degree label.error{padding-left: 42px;}

</style>
<?php
  //$this->headScript()
    
    //->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce.js')
	//->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<?php 
    $form= $this->form;
    $arr_cats= $this->arr_cats;
    $profile= $this->profile;
?>

<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter'?>"><?php echo $this->translate("Recruiter");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Create new job");?></strong>
    </div>
</div>
<?php if($profile !=0){?>
<div class="layout_main">
    <div class="content">
    <div class="section recruiter">
    <div class="layout_right">
        <?php echo $this->content()->renderWidget('recruiter.sub-menu');?>
        <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
        <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
        <div class="subsection">
            <a href="<?php echo $this->baseUrl().'/recruiter'?>"><img alt="Image" src="application/modules/Core/externals/images/img-showcase-4.jpg"></a>
        </div>
    </div>
    <div class="layout_middle">
   
    <div class="subsection">
            <h2><?php echo $this->translate("Create new job");?></h2>
            <form id="recruiter_job_form" action="<?php echo $form->getAction();?>" method="post" enctype="application/x-www-form-urlencoded" >
           
            <fieldset class="job-form">
                <div class="input">
                    <?php echo $form->categories;?>
                    
                    <input type="hidden" value="0" id="val_categories" name="val_categories" />
                </div>
                <div class="input">
                    <?php echo $form->industries;?>
                    
                    <input type="hidden" value="0" id="val_industries" name="val_industries" />
                </div>
                <div class="input job_title">
                    <?php echo $form->position;?>
                </div>
                <div class="input job_num">
                    <?php echo $form->num;?>
                    
                </div>
                <div class="input job_year_experience">
                    <?php echo $form->year_experience;?>
                    
                </div>
                <div class="input job_degree">
                    <?php echo $form->degree_id;?>
                </div>
                <div class="input">
                    <?php echo $form->country_id;?>
                    <?php echo $form->city_id;?>
                </div>
                <div class="input">
                    <?php echo $form->description;?>
                </div>
                <div class="input">
                    <?php echo $form->skill;?>
                </div>
                <div class="input">
                    <?php echo $form->types;?>
                    <input type="hidden" value="0" id="val_types" name="val_types" />
                </div>
                <div class="input">
                    <?php echo $form->salary;?>
                </div>
                <div class="job_date">
                    <?php echo $form->deadline;?>
                </div>
                <div class="input">
                </div>
                <h3><?php echo $this->translate("Contact information");?></h3>
                <div class="input contact_name">
                    <?php echo $form->contact_name;?>
                </div>
                <div class="input job_num">
                    <?php echo $form->contact_address;?>
                </div>
                <div class="input contact_via">
                    <?php echo $form->contact_via;?>
                </div>
                <div class="input">
                    <?php echo $form->contact_phone;?>
                </div>
                <div class="input">
                    <?php echo $form->contact_email;?>
                </div>
                <div class="submit">
                    <input type="submit" value="<?php echo $this->translate('Submit')?>" class="min" />
                    <input type="reset" value="<?php echo $this->translate('Reset')?>" class="min" onclick="reset();" />
                </div>
            </fieldset>
        </div>
       </form>
    </div>
    </div>
    </div>
    </div>
<?php }
else{?>
    <p><?php echo $this->translate("You have not create your company profile. Please");?> <a href="<?php echo $this->baseUrl().'/recruiter/index/create-profile'?>"><?php echo $this->translate(" create new company profile ");?></a><?php echo $this->translate("in order to post a job!");?></p>
<?php }?>
<script type="text/javascript">
function list_city(){
    var url= "<?php echo $this->baseUrl().'/resumes/index/city' ?>";
    var country_id= $('country_id').get('value');
    
    new Request({
        url: url,
        method: "post",
        data : {
        		
        		'country_id': country_id
        	},
        onSuccess : function(responseHTML)
        {
            
            $('city_id').set('html', responseHTML);
        		
        }
    }).send();
}
window.addEvent('domready', function(){
    //var select_job= document.id('select_job');
   //$('industries-element').inject(select_job);
   //$('sl_job').inject('industries-label', 'after');
   //type
   //var select_type= document.id('select_type');
   //$('types-element').inject(select_type);
   //$('sl_type').inject('types-label', 'after');
   //thiết lập việt nam mặc định (hơi thừa);
   var url= "<?php echo $this->baseUrl().'/resumes/index/city' ?>";
    var country_id= 230;

    new Request({
        url: url,
        method: "post",
        data : {
        		
        		'country_id': country_id
        	},
        onSuccess : function(responseHTML)
        {
            $('country_id').set('value', country_id);
            $('city_id').set('html', responseHTML);
        		
        }
    }).send();
    jQuery.validator.addMethod( 
	  "selectCategory", 
	  function(value, element) { 
    	   var n = jQuery("#categories-element input:checked").length;
           if(n==0){
                return false;
           }else{
                return true;
           }
      }, 
	  "<?php echo $this->translate('Please select a industry.')?>" 
	); 
    jQuery.validator.addMethod( 
	  "selectIndustry", 
	  function(value, element) { 
    	   var n = jQuery("#industries-element input:checked").length;
           if(n==0){
                return false;
           }else{
                return true;
           }
      }, 
	  "<?php echo $this->translate('Please select a career.')?>" 
	); 
    jQuery.validator.addMethod( 
	  "selectType", 
	  function(value, element) { 
    	   var n = jQuery("#types-element input:checked").length;
           if(n==0){
                return false;
           }else{
                return true;
           }
      }, 
	  "<?php echo $this->translate('Please select a type.')?>" 
	); 
   jQuery("#recruiter_job_form").validate({
        messages : {
            
            "position" : {
                required: "<?php echo $this->translate('Job Title is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            },
            "num" : {
                required: "<?php echo $this->translate('Number is not empty.')?>"
               
            },
            "year_experience" : {
                required: "<?php echo $this->translate('Year Experience is not empty.')?>"
               
            },
            "degree_id" : {
			     required: "<?php echo $this->translate('Degree Level is not empty.')?>",
                 min: "<?php echo $this->translate('Please select a degree level.')?>"
             },
            "place" : {
                required: "<?php echo $this->translate('Place to work is not empty.')?>"
               
            },
            "contact_name" : {
                required: "<?php echo $this->translate('Contact to is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            },
            "contact_address" : {
                required: "<?php echo $this->translate('Address is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            }
		},
		rules: {
		  "val_categories":{
		      selectCategory: true
		  },
		  "val_industries":{
		      selectIndustry: true
		  },
            "position" : {
		      required: true,
		      maxlength: 160
		    },
            "num":{
                required: true
            },
            "year_experience":{
                required: true
            },
            "degree_id" : {
		      required: true,
		      min: 1
		    },
            "place":{
                required: true
            },
            "val_types":{
              selectType: true  
            },
            "contact_name":{
                required: true,
                maxlength: 160
            },
            "contact_address":{
                required: true,
                maxlength: 160
            }
        }
   }); 
});
function reset(){
    $('recruiter_job_form').reset();
}
</script>
