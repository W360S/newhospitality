<style type="text/css">
.clear {
	clear:both;
}
.slider{
	height: 260px;
}
.nivo-caption{
	display: none!important;
}
</style>
<?php
$form= $this->form; 
?>
<div class="slider">
	<div class="slider-item">
		<img src="application/modules/School/externals/images/shmsx.jpg" alt="banner" title="imi"/>
	</div>
    <div class="slider-item">
		<img src="application/modules/School/externals/images/imi_banner.jpg" alt="banner" title="imi"/>
	</div>
    <div class="slider-item">
		<img src="application/modules/School/externals/images/school-banner-1.jpg" alt="banner" title="imi" />
	</div>	
	<div class="slider-item">		
		<img src="application/modules/School/externals/images/school-banner-2.jpg" alt="banner" title="imi" />
	</div>
	<div class="slider-item">		
		<img src="application/modules/School/externals/images/school-banner-3.jpg" alt="banner" title="imi" />
	</div>
    <div class="slider-item">		
		<img src="application/modules/School/externals/images/school-banner-4.jpg" alt="banner" title="imi" />
	</div>
</div>
<div class="find-school">
<form method="get" action="<?php echo $this->baseUrl().'/school/index/search';?>">
	<fieldset>
		<input id="input_search" name="input_search" type="text" value="<?php echo $this->translate('Enter your keyword');?>" onfocus="if(this.value=='<?php echo $this->translate("Enter your keyword");?>') this.value='';" onblur="if(this.value=='') this.value='<?php echo $this->translate("Enter your keyword");?>'">
		<?php echo $form->country_id;?>
        
		<input class="bt_find_shool" type="submit" value="<?php echo $this->translate('Find School');?>" />
	</fieldset>
 </form>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
   jQuery('.slider').nivoSlider(); 
});
</script>