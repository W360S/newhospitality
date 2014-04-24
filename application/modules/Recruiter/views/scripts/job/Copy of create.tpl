<style type="text/css">
.panel{position:absolute;}
.panel .trigger{width: 359px;}
.panel .content{width: 350px;}

.job-form .input label.error{color: red; clear:both; width:221px;}
.job-form .contact_name label.error{ width:232px;}
.job-form .contact_via ul li { clear:none; margin-left:-3px; margin-top: -4px; padding:0px;}

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
        <?php echo $this->content()->renderWidget('resumes.popular-resume');?>
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
                    <?php echo $form->industries;?>
                    <label for="industries" generated="true" class="error" id="err_industries" style="display:none;">Job Title is not empty.</label>
                    <input type="hidden" value="0" id="val_industries" />
                </div>
                <div class="input job_title">
                    <?php echo $form->position;?>
                </div>
                <div class="input job_num">
                    <?php echo $form->num;?>
                    
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
                    <?php echo $form->types;?>salary
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
                    <input type="submit" value="Submit" class="min" />
                    <input type="reset" value="Reset" class="min" onclick="reset();" />
                </div>
            </fieldset>
        </div>

    
        <div id="sl_job" class="input select_sort">
			<div class="panel">
				<div class="trigger"><?php echo $this->translate('Select Options'); ?></div>
				<div class="content" id="select_job">
					
				</div>
			</div>
        </div>
        <div id="sl_type" class="input select_sort">
			<div class="panel">
				<div class="trigger"><?php echo $this->translate('Select Options'); ?></div>
				<div class="content" id="select_type">
					
				</div>
			</div>
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
    var select_job= document.id('select_job');
   $('industries-element').inject(select_job);
   $('sl_job').inject('industries-label', 'after');
   //type
   var select_type= document.id('select_type');
   $('types-element').inject(select_type);
   $('sl_type').inject('types-label', 'after');
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
   jQuery("#recruiter_job_form").validate({
        messages : {
            "industries[]":{
                required: "<?php echo $this->translate('Industry is not empty.')?>",
            },
            "position" : {
                required: "<?php echo $this->translate('Job Title is not empty.')?>",
                maxlength: "<?php echo $this->translate('Please enter no more than 160 characters.')?>"
            },
            "num" : {
                required: "<?php echo $this->translate('Number is not empty.')?>"
               
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
		  "industries[]":{
		      required: true,
              min:1
		  },
            "position" : {
		      required: true,
		      maxlength: 160
		    },
            "num":{
                required: true
            },
            "place":{
                required: true
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
