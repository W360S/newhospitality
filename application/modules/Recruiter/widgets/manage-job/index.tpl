<style type="text/css">
ul.jobs_management li{padding:10px 0;border-bottom:1px solid #e5e5e5}
.pt-how-story a.pt-link-03 {
    /*background: url("/images/front/icon-10.png") no-repeat scroll 0 3px rgba(0, 0, 0, 0);*/
}
.pt-how-story a.pt-link-04 {
    /*background: url("/images/front/icon-11.png") no-repeat scroll 0 3px rgba(0, 0, 0, 0);*/
}
.pt-how-story a.pt-link-05 {
    /*background: url("/images/front/icon-12.png") no-repeat scroll 0 3px rgba(0, 0, 0, 0);*/
}
.pt-how-story a.pt-link-06 {
    /*background: url("/images/front/icon-13.png") no-repeat scroll 0 3px rgba(0, 0, 0, 0);*/
}
.pt-block {
    background-color: #FFFFFF;
    margin-bottom: 20px;
    overflow: hidden;
}
.pt-title-right {
    border-bottom: 1px solid #E5E5E5;
    color: #262626;
    font-size: 14px;
    font-weight: normal;
    margin: 0 10px;
    overflow: hidden;
    padding: 10px 0;
    text-transform: uppercase;
}
.pt-how-story {
    overflow: hidden;
    padding: 10px;
}
.pt-how-story a {
    color: #707070;
    display: block;
    font-size: 13px;
    margin-bottom: 10px;
    overflow: hidden;
    padding-left: 25px;
}
.pt-how-story a span {
    background-color: #4FC1E9;
    border-radius: 3px;
    color: #FFFFFF;
    display: inline-block;
    font-size: 13px;
    margin-left: 5px;
    padding: 0 4px;
}
.pt-how-story a span.no {
    background-color: #BEC7CA;
    color: #FFFFFF;
    display: inline-block;
    font-size: 13px;
    padding: 0 4px;
}
.pt-how-story a:hover {
    text-decoration: underline;
}
</style>
<div class="pt-block">
    <h3 style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 10px 0;  text-transform: uppercase;"><?php echo $this->translate("Jobs management");?></h3>
    <div class="pt-how-story">
    	<a href="<?php echo $this->baseUrl().'/resumes/resume/manage'?>" class="pt-link-03"><?php echo $this->translate("My Resume");?></a>
		<a href="<?php echo $this->baseUrl().'/recruiter/job/manage-apply' ?>" class="pt-link-04"><?php echo $this->translate('Applied Jobs ')?><span><?php echo $this->applyjob ?></span></a>
		<a href="<?php echo $this->baseUrl().'/recruiter/job/save-job'?>" class="pt-link-05"><?php echo $this->translate('Saved Jobs ')?><span class="no"><?php echo $this->savejob ?></span></a>
		<!--<ul class="jobs_management">
			<li><a href="<?php echo $this->baseUrl().'/recruiter/job/manage-apply' ?>"><?php echo $this->translate('Applied Jobs ')?>(<?php echo $this->applyjob ?>)</a></li>
    
            <li><a href="<?php echo $this->baseUrl().'/recruiter/job/save-job'?>"><?php echo $this->translate('Saved Jobs ')?>(<?php echo $this->savejob ?>)</a></li>
    
		</ul>-->	
    </div>
</div> 
<?php /*
<script src="<?php echo $this->baseUrl().'/application/modules/Job/externals/scripts/custom.jobs.js'?>" type="text/javascript"></script>
*/ ?>

