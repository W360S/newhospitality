<style type="text/css">
#global_wrapper {background:none;}
#breadcrumb{
	padding-bottom: 16px;
    padding-top: 16px;
}
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
    
    float: left;
    margin: 0px 0;
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
.layout_middle {
    background: none repeat scroll 0 0 #FFFFFF;
    border-left: medium none;
    padding: 18px 10px;
}
</style>
<?php
    $resumes= $this->resumes;
    $paginator= $this->paginator;
    $viewer_id= $this->viewer_id; 
    $paginator_jobs= $this->paginator_jobs;
?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("My resumes");?></strong>
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
<div class="resume_preview_main">
<div class="bt-loading-detele pt-fix-title">
				<a class="pt-loading" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/manage' ?>"></a>
				<a class="pt-detele" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/manage' ?>"></a>
				<!--<button class="pt-detele" onclick="javascript:delectSelected();" type='submit'>
                      <?php //echo $this->translate("Delete Selected") ?>
    			</button>-->
			</div>
     <div class="subsection my-work-experience">
    	
            <style>
            	.pt-fix-title {
				    margin-top: 11px;
				}
				.bt-loading-detele {
				     float: left;
				    margin-bottom: 8px;
				    margin-top: -8px;
				    overflow: hidden;
				    width: 100%;
				}
				.bt-loading-detele a {
				    background: url("../img/front/pt-sprite.png") no-repeat scroll 0 7px rgba(0, 0, 0, 0);
				    display: block;
				    float: left;
				    height: 35px;
				    margin-right: 10px;
				    margin-top: 10px;
				    width: 40px;
				}
				.bt-loading-detele button {
				    background: url("../img/front/pt-sprite.png") no-repeat scroll 0 7px rgba(0, 0, 0, 0);
				    display: block;
				    float: left;
				    height: 35px;
				    margin-right: 10px;
				    margin-top: 10px;
				    width: 40px;
				}
				.bt-loading-detele a.pt-loading {
				    background-position: -97px -488px;
				}
				.bt-loading-detele a.pt-loading:hover {
				    background-position: -97px -533px;
				}
				.bt-loading-detele a.pt-detele {
				    background-position: -149px -488px;
				}
				.bt-loading-detele a.pt-detele:hover {
				    background-position: -149px -533px;
				}
				.bt-loading-detele button.pt-detele {
				    background-position: -149px -488px;
				}
				.bt-loading-detele button.pt-detele:hover {
					background: url("../img/front/pt-sprite.png") no-repeat scroll 0 7px rgba(0, 0, 0, 0);
				    background-position: -149px -533px;
				}
				
				.my-work-experience table td{
					background:none;
				}
            </style>
    <div id="resume_loading" style="display: none;">
      <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
      <?php echo $this->translate("Loading ...") ?>
    </div>
    <div id="list_resume" class="pt-list-table">
    <?php if(count($resumes)){?>
        
        <table cellspacing="0" cellpadding="0">
            
			<thead>
   				<tr>                                        
			       <th><strong><?php echo $this->translate('Resume Title')?></strong></th>
			       <th><strong><?php echo $this->translate('Status');?></strong></th>
			       <!--<th><?php //echo $this->translate("Salary") ?></th>-->
			       <th style="width:140px"><strong><?php echo $this->translate('Date Modified')?></strong></th>
			       <th style="width:108px"><strong><?php echo $this->translate('Options ')?></strong></th>
		       </tr>
   			</thead>
            <!--<tr>
                <th style="width:270px"><?php echo $this->translate('Resume Title')?></th>
                <th style="width:106px"><?php echo $this->translate('Status');?></th>
                <th style="width:92px"><?php echo $this->translate('Date Modified')?></th>
                <th><?php echo $this->translate('Options ')?></th>
            </tr> -->  
           <?php 
		   $i=0;
		   foreach($resumes as $resume){
		   	$i++;    
                            if($i%2==0){
                                $class= "odd";
                            }
                            else{ $class="";}
			   ?>
           <tr class="layout_middle<?php echo $class; ?>">
            <td>
            <?php echo $resume->title;?>
            </td>
            <td>
                <?php if($resume->approved==1){
                    echo "<span style='color: #64A700;font-style:italic;font-size:10px;'>".$this->translate('Approved')."</span>";?><img src="<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/approve.gif'?>" />
                <?php } else if($resume->approved==0){
                        echo "<span style='color:red;font-style:italic;font-size:10px;'>".$this->translate('Incomplete')."</span>";?>  
                <?php } else{
                    echo "<span style='font-style:italic;font-size:10px;'>".$this->translate('Pending for approval')."</span>";
                }
                ?>
            </td>
            <td>
            <?php echo date('d F Y', strtotime($resume->modified_date));?>
            </td>
            <td>
            <a class="edit" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/index/preview/resume_id/'.$resume->resume_id ?>"></a>
    
            <a href="javascript:void(0);" onclick="javascript:delete_resume('<?php echo $resume->resume_id ?>');"></a>
            </td>
       </tr>
            <?php }?>
        </table>
        
    <?php } else{?>
    <div style="margin-top: 5px; margin-left: 5px;" class="tip">
        <span>
          <?php echo $this->translate("You have not create resume.") ?>
        </span>
      </div>
        
    <?php }?>
    </div>
    </div>
    <button style="background: none repeat scroll 0 0 #4FC1E9;border: 1px solid #FAFAFA;border-radius: 5px;color: #FFFFFF;font-size: 11px;font-weight: normal;    padding: 10px;" onclick="javascript:create_resume(); return false;"><?php echo $this->translate('Create New Resume')?></button>
    
    
</div>
</div>
</div>

</div>
</div>
<script type="text/javascript">
function create_resume(){
    var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/index/resume-info'?>";
    window.location.href= url;
}
function delete_resume(resume_id){
    var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/delete' ?>";
    if(confirm("<?php echo $this->translate('Do you really want to delete this resume?');?>")){
        $('resume_loading').style.display="block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'resume_id': resume_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            
            $('resume_loading').style.display="none";
            if(responseHTML==1){
                var url= "<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes/resume/list' ?>";
                new Request({
                url: url,
                method: "post",
                
                onSuccess : function(responseHTML)
                {
                    //alert(responseHTML);
                    $('list_resume').set('html', responseHTML);
                }
                }).send();
            }
            else{
                alert("Can't delete this resume");
            }
            
        }
    }).send();
	}	
}
</script>
