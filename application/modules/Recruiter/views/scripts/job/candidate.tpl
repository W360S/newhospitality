<style type="text/css">
#global_wrapper {background: none;}
</style>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter'?>"><?php echo $this->translate("Recruiter");?></a> <span>&gt;</span>  <strong><?php echo $this->translate("View Applican");?></strong>
    </div>
</div>
<div id="content">
    <div class="section recruiter-view-profile">

        
        <div class="layout_left">
        <?php echo $this->content()->renderWidget('recruiter.profile')?>
        
        </div>
        <div class="layout_middle">
            <?php echo $this->content()->renderWidget('recruiter.candidates');?>
        </div>
    </div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    //When page loads...
	jQuery(".tab_content").hide(); //Hide all content
	jQuery("ul.tabs li:first").addClass("active").show(); //Activate first tab
	jQuery(".tab_content:first").show(); //Show first tab content

	//On Click Event
	jQuery("ul.tabs li").click(function() {

		jQuery("ul.tabs li").removeClass("active"); //Remove any "active" class
		jQuery(this).addClass("active"); //Add "active" class to selected tab
		jQuery(".tab_content").hide(); //Hide all tab content

		var activeTab = jQuery(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
		jQuery(activeTab).fadeIn(); //Fade in the active ID content
		return false;
	});

});
</script>