<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
#breadcrumb{
	padding-top:12px;
	padding-bottom:5px;
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
<?php
    $paginator= $this->paginator; 
    $user_id= $this->user_id;

?>
<div class="layout_main">
<?php //echo $this->content()->renderWidget('recruiter.search-job');?>
<div id="breadcrumb">
                    <div class="section">
                        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Applied Jobs");?></strong>
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
            <div class="job_main_manage">
                
                    <div id="loading" style="display: none;">
                      <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
                      <?php echo $this->translate("Loading ...") ?>
                    </div>
                    <?php if( count($paginator) ): ?>
                    <div class="pt-list-table">
                         <table cellspacing="0" cellpadding="0">
                         <thead>
                          <tr>                                        
                            <th><strong><?php echo $this->translate("Position") ?></strong></th>
                            <th><strong><?php echo $this->translate("Company") ?></strong></th>
                            <!--<th><?php //echo $this->translate("Salary") ?></th>-->
                            <th style="width:115px"><strong><?php echo $this->translate("Created Date") ?></strong></th>
                            <th style="width:170px"><strong><?php echo $this->translate("Action") ?></strong></th>
                            
                          </tr>
                          </thead>
                        <tbody>
                          <?php 
                            $i=0;
                            foreach ($paginator as $item):
                                $i++;    
                                    if($i%2==0){
                                        $class= "odd";
                                    }
                                    else{ $class="";}
                                ?>
                            <tr class="layout_middle<?php echo $class; ?>">
                              
                              <td>
                              <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                                <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?>
                        			
                              </td>
                              <td><?php echo $this->company($item->user_id)->company_name;?></td>
                              <!--<td><?php //echo $item->salary;?></td>-->
                              <td><?php echo date('d F Y', strtotime($item->creation_date)); ?></td>
                              
                              <td class="action">
                              <?php $applyjob_id= $this->applyJob($user_id, $item->job_id)->applyjob_id;?>
                                <a target="_blank" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/job/my-apply/apply/'. $applyjob_id ?>"><?php echo $this->translate('View applied');?></a> |
                                <a href="javascript:void(0);" onclick="delete_apply('<?php echo $item->job_id ?>')"><?php echo $this->translate('Delete')?></a>
                              </td>
                              
                            </tr>
                        <?php endforeach; ?>
                        </tbody>
              </table>
                    </div>
                  <?php else: ?>
                      <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                        <span>
                          <?php echo $this->translate("There are no jobs applied.") ?>
                        </span>
                      </div>
              
                  <?php endif; ?>
                
            </div>
        </div>
    </div>
</div>
</div>
<script type="text/javascript">
function delete_apply(job_id){
    var url="<?php echo $this->baseUrl().'/recruiter/job/delete-apply'?>";
    if(confirm("Do you really want to delete this apply job?")){
        $('loading').style.display="block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'job_id': job_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            $('loading').style.display="none";
            
            if(responseHTML==1){
                //tam thoi cho redirect ve trang nay
                window.location.href= "<?php echo $this->baseUrl().'/recruiter/job/manage-apply' ?>";
            }
            
        }
        }).send();
	}	
}
</script>