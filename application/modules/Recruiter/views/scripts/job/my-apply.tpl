<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
.description_job p{padding-left: 150px; margin-top: -28px;}

#breadcrumb a:link, #breadcrumb a:visited{
	 color: #A4A9AE;
}
#breadcrumb a, #breadcrumb span, #breadcrumb strong{
	color: #008ECD;
	 font-weight: normal;
}
#breadcrumb span{
	background:url("../img/front/icon-menu-top.png") no-repeat scroll right 5px rgba(0, 0, 0, 0);
}
#breadcrumb span{
	width:9px;
	padding-left:9px;
	margin-right:9px;
}
#breadcrumb{
	 padding-bottom: 9px;
    padding-top: 15px;
}
.layout_middle .subsection h2{
	padding:0px;
	border-bottom:1px solid #E5E5E5;
}
.subsection h2{
	background:none;
	border-bottom:1px solid #E5E5E5;
	font-size:14px;
	color:#262626;
	line-height: 31px;
}
.pt-list-table {
    background: none repeat scroll 0 0 #FFFFFF;
    float: left;
    margin: 15px 0;
    overflow: hidden;
    width: 100%;
}
.pt-list-table table {
    text-align: left;
}
.pt-list-table table th {
    background-color: #FAFAFA;
    border-bottom: 1px solid #E9E9E9;
    padding: 15px;
    text-align: left;
}
.pt-list-table table td {
    color: #707070;
    font-size: 13px;
    padding: 15px;
    text-align: left;
}
.pt-list-table table td a {
    color: #76CEEC;
}
.pt-list-table table td span {
    display: block;
}
.pt-list-table table td a:hover {
    text-decoration: underline;
}
.pt-list-table table tr.layout_middleodd {
    background-color: #F7FAFA;
}
.pt-list-table table tr.layout_middle {
    background-color: #fff;
}

</style>

<div class="layout_main">
<?php //echo $this->content()->renderWidget('recruiter.search-job');?>
<div id="breadcrumb">
            <div class="section">
                <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter'?>"><?php echo $this->translate("Recruiter");?></a> <span>&gt;</span>  <strong><?php echo $this->translate("View applied job");?></strong>
            </div>
        </div>
<div id="content">
    <div class="section jobs">
            <div style="width:282px;float:right;margin-top: -18px;">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
                <?php echo $this->content()->renderWidget('recruiter.hot-job');?>
                <?php echo $this->content()->renderWidget('recruiter.articals');?>
                <!-- end -->
                <!-- job tools -->
                <?php //echo $this->content()->renderWidget('recruiter.job-tools');?>
                <!-- end -->
                <!-- feature employers -->
                <?php echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                <!-- insert some advertising -->
                <?php //include 'ads/right-column-ads.php'; ?>
            </div>
        <div class="layout_middle" style="width:766px;float:left;padding:0px;background:none">
        
        <div class="subsection" style="padding:10px">
            <?php echo $this->content()->renderWidget('recruiter.my-apply');?>
        </div>
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