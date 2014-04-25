<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
</style>
<?php
    $paginator= $this->paginator; 
    $user_id= $this->user_id;

?>
<div class="layout_main">
<?php echo $this->content()->renderWidget('recruiter.search-job');?>
<div id="content">
    <div class="section jobs">  
            <div class="layout_right">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
                <!-- end -->
                <!-- feature employers -->
                <?php //echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                <!-- insert some advertising -->
                <div class="subsection">
                    <a href="http://www.vtcb.org.vn/">
                        <img src="application/modules/Job/externals/images/companies/vtcb.jpg" alt="Image" />
                    </a>
                </div>
                <div class="subsection">
                    <a href="http://www.moevenpick-hotels.com/en/asia/vietnam/ho-chi-minh-city/hotel-saigon/overview/">
                        <img src="application/modules/Job/externals/images/companies/movenpick.png" alt="Image" />
                    </a>
                </div>
                <div class="subsection">
                    <a href="http://www.seasideresort.com.vn/201203_seaside/">
                        <img src="application/modules/Job/externals/images/companies/seaside.png" alt="Image" />
                    </a>
                </div>
                <div class="subsection">
                    <a href="http://www.namnguhotel.com/index.php">
                        <img src="application/modules/Job/externals/images/companies/namngu.png" alt="Image" />
                    </a>
                </div>
            </div>
            <div class="layout_middle">
            <div class="job_main_manage">
                <div id="breadcrumb">
                    <div class="section">
                        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Applied Jobs");?></strong>
                    </div>
                </div>
                    <div id="loading" style="display: none;">
                      <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
                      <?php echo $this->translate("Loading ...") ?>
                    </div>
                    <?php if( count($paginator) ): ?>
                    <div class="job-list">
                         <table class='admin_table' cellspacing="0" cellpadding="0">
                         <thead>
                          <tr>
                                            
                            <th><?php echo $this->translate("Position") ?></th>
                            <th><?php echo $this->translate("Company") ?></th>
                            <!--<th><?php //echo $this->translate("Salary") ?></th>-->
                            <th style="width:81px"><?php echo $this->translate("Created Date") ?></th>
                            <th style="width:115px"></th>
                            
                          </tr>
                          </thead>
                        <tbody>
                          <?php 
                            $i=0;
                            foreach ($paginator as $item):
                                $i++;    
                                    if($i%2==0){
                                        $class= "back_gr_gray";
                                    }
                                    else{ $class="";}
                                ?>
                            <tr>
                              
                              <td  class="title">
                              <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                                <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?>
                        			
                              </td>
                              <td><?php echo $this->company($item->user_id)->company_name;?></td>
                              <!--<td><?php //echo $item->salary;?></td>-->
                              <td><?php echo date('d F Y', strtotime($item->creation_date)); ?></td>
                              
                              <td class="action">
                              <?php $applyjob_id= $this->applyJob($user_id, $item->job_id)->applyjob_id;?>
                                <a target="_blank" href="<?php echo $this->baseUrl().'/recruiter/job/my-apply/apply/'. $applyjob_id ?>"><?php echo $this->translate('View applied');?></a> |
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