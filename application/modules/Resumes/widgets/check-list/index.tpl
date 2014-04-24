<style type="text/css">
h4 > span {background-color: #F8F8F8;}
#global_wrapper {background: none;}
.pt-list-cbth {
}
.pt-list-cbth li {
    overflow: hidden;
    padding: 10px;
}
.pt-list-cbth li span {
    display: block;
    float: left;
}
.pt-list-cbth li .pt-number-1 {
    background-color: #BEC7CA;
    border-radius: 3px;
    color: #FFFFFF;
    padding: 2px 6px;
}
.pt-list-cbth li .pt-text {
    color: #707070;
    font-size: 13px;
    margin: 2px 0 0 10px;
}
.pt-list-cbth li .pt-icon-oky {
    background: url("../img/front/icon-oky.png") no-repeat scroll 0 0 rgba(0, 0, 0, 0);
    display: none;
    float: right;
    height: 20px;
    width: 20px;
}
.pt-list-cbth li.pt-active .pt-icon-oky {
    display: block;
}
.pt-list-cbth li.pt-active .pt-number-1 {
    background-color: #4FC0E8;
    color: #FFFFFF;
}
.pt-right-job {
    float: right;
    margin-top: 64px;
    width: 270px;
}
.pt-right-job .pt-list-right .pt-user-post .pt-how-info-user-post {
    width: 191px;
}
.pt-block {
    background-color: #FFFFFF;
    margin-bottom: 20px;
    overflow: hidden;
}
</style>
<div class="pt-right-job" style="margin-top:-20px"> 
 <div class="pt-block">
 	<h3 class="pt-title-right" style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 14px 0;  text-transform: uppercase;">
      <?php echo $this->translate('Check List') ?>
 	</h3>
 	<?php
	$currenturl=$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
	//echo $currenturl;
	$urlarray=explode('/',$currenturl);
	$here= $urlarray[2];
	
	 ?>
 	<ul class="pt-list-cbth">
		<li class="pt-active"><span class="pt-number-1">1</span><span class="pt-text"><?php echo $this->translate('Compulsory')?></span><span class="pt-icon-oky"></span></li>
		<li class="<?php if(($here=='resume_work') || ($urlarray[3]=='education')|| ($urlarray[3]=='skill')|| ($urlarray[3]=='reference')) echo 'pt-active'; ?>"><span class="pt-number-1">2</span><span class="pt-text"><?php echo $this->translate('Work experience ')?></span><span class="pt-icon-oky"></span></li>
		<li class="<?php if(($urlarray[3]=='education')|| ($urlarray[3]=='skill')|| ($urlarray[3]=='reference')) echo 'pt-active'; ?>"><span class="pt-number-1">3</span><span class="pt-text"><?php echo $this->translate('Education')?></span><span class="pt-icon-oky"></span></li>
		<li class="<?php if(($urlarray[3]=='skill')|| ($urlarray[3]=='reference')) echo 'pt-active'; ?>"><span class="pt-number-1">4</span><span class="pt-text"><?php echo $this->translate('Skills ')?></span><span class="pt-icon-oky"></span></li>
		<li class="<?php if($urlarray[3]=='reference') echo 'pt-active'; ?>"><span class="pt-number-1">5</span><span class="pt-text"><?php echo $this->translate('Reference ')?></span><span class="pt-icon-oky"></span></li>
	</ul><!--reference
	<h4 class="title_check_list"><?php echo $this->translate('Compulsory')?> <span><?php echo $this->translate('Completed')?></span></h4>
	<p class="resume_info"><span>1</span> <?php echo $this->translate('Resume information ')?> </p>
	<p class="resume_work" id="resume_work_edit"><span>2</span> <?php echo $this->translate('Work experience ')?></p>
	<p class="resume_education" id="resume_education_edit"><span>3</span> <?php echo $this->translate('Education')?> </p>
	<h4 class="title_check_list"><?php echo $this->translate('Recommended')?></h4>
	<p class="resume_skill" id="resume_skill_edit"><span>4</span><?php echo $this->translate('Skills ')?> </p>
	<p class="resume_reference" id="resume_reference_edit"><span>5</span> <?php echo $this->translate('Reference ')?> </p>-->
</div>	
</div>