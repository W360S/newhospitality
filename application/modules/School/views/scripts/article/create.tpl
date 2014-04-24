<style type="text/css">
label.error{color: red;}
.global_form input + label {float:none;}
.global_form > div > div {border:none;}
#global_wrapper {background:none;}
#content{padding: 20px 0;}
#breadcrumb {
    padding-top: 20px;
    padding-bottom: 0px;
}
#global_content .layout_middle {
    padding-right: 0px;
}
</style>
<?php
  $this->headScript()
    
    ->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce.js')
	->appendFile($this->baseUrl().'/externals/tinymce/tiny_mce-init.js');
?>
<?php
    $form= $this->form; 
    $school= $this->school;
    $success= $this->success;
    $poster_id= $this->poster_id;
?>
<div id="banner-school">
    <div class="section">
        <?php echo $this->content()->renderWidget('school.banner');?>
    </div>
</div>
<div id="breadcrumb">
        <div class="section">
            <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate('Home');?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/school'?>"><?php echo $this->translate('Education School');?></a>  <span>&gt;</span> <?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $school->school_id), $school->name) ?><span>&gt;</span> <strong><?php echo $this->translate('Post an Article');?></strong>
        </div>
    </div>
<div id="content">
    <div class="section school-post-article">
        <div class="layout_left">
            <?php echo $this->content()->renderWidget('school.lastest-article');?>
            <?php echo $this->content()->renderWidget('school.advertising');?>
        </div>
        
        <div class="layout_middle">
            <div class="subsection">
            	<h2><?php echo $school->name;?></h2>
                
				<div class="school-address">
					<?php echo $this->itemPhoto($school, 'thumb.normal', "Image", array('class'=>'img-school'));?>
					<ul>
					
						<li><?php echo $this->translate('Phone: ');?><?php echo $school->phone;?></li>
                        <li><?php echo $this->translate('Email: ');?><?php echo $school->email;?></li>								
                        <li><?php echo $this->translate('Website: ');?><span class="web-link"><?php echo $school->website;?></span></li>
						
						<li><a class="share smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/school_school/id/<?php echo $school->school_id ?>/format/smoothbox"><?php echo $this->translate('Share');?></a></li>
					</ul>
				</div>
				<div class="detail-post-article">
    				<p><?php echo $school->intro;?></p>
                    
                    <p><?php echo $this->htmlLink(array('route' => 'view-all-article', 'id'=> $school->school_id), $this->translate('See more'), array('class'=>'more')) ?>		</p>
                </div>	
                
                <div class="post_comment">
                <?php if($success == 0){?>
					<h3><?php echo $this->translate('Post an Article: ');?></h3>
					<div class="image"><?php echo $this->itemPhoto($this->user($poster_id));?></div>
                    <form id="artical_create_form" method="post" accept="<?php echo $form->getAction();?>">
					<fieldset class="post-article-form">
						<div class="input">
							<?php echo $form->title;?>
						</div>
						<div class="input">
							<?php echo $form->content;?>
						</div>
						<div class="submit">
							<input type="submit" value="<?php echo $this->translate('Post an Article');?>" class="bt-post-article" />
						</div>
					</fieldset>
                    </form>
                    <?php } 
                    else{
                        $link= $form->getAction();
                        echo $this->translate('You have been posted an article successfully. Please be waiting for approval'). $this->translate(' or')?><a href="<?php echo $link ?>"><?php echo $this->translate(' post another.')?></a>
                    <?php }
                    ?>
				</div>
                
            </div>
        </div>
    </div>
</div>    
<script type="text/javascript">
window.addEvent('domready', function(){
    document.body.scrollTop= 700;
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