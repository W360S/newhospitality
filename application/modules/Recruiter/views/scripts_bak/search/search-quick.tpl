<style type="text/css">
.search_result{padding-top: 0; width: 100%;}
</style>
<?php
     
    $paginator_jobs= $this->paginator_jobs;
    $viewer_id= $this->viewer_id; 
    $quicksearch= $this->quicksearch;
?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Quick Search");?></strong>
    </div>
</div>
<div id="content">
<div class="section jobs">

<div class="layout_right">
<?php echo $this->content()->renderWidget('recruiter.quick-search');?>
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
        <a href="http://www.moevenpick-hotels.com/en/asia/vietnam/ho-chi-minh-city/hotel-saigon/overview/">
            <img src="application/modules/Job/externals/images/companies/movenpick.png" alt="Image" />
        </a>
        <a href="http://www.seasideresort.com.vn/201203_seaside/">
            <img src="application/modules/Job/externals/images/companies/seaside.png" alt="Image" />
        </a>
        <a href="http://www.namnguhotel.com/index.php">
            <img src="application/modules/Job/externals/images/companies/namngu.png" alt="Image" />
        </a>
    </div>
</div>
<div class="layout_middle">
<div class="resume_preview_main">
    <div class="subsection search_result">
        <h2><?php echo $this->translate('Search Result');?></h2>
        
        <?php if( count($paginator_jobs) ): ?>
    <div class="list_job_saved">
      <table cellspacing="0" cellpadding="0">
        <tr>
			<th style="width:240px"><?php echo $this->translate("Job Title");?></th>
			<th style="width:120px"><?php echo $this->translate("Company");?></th>
			<th style="width:92px"><?php echo $this->translate("Location");?></th>
			<th><?php echo $this->translate("Status");?></th>
		</tr>        
        <tbody>
          <?php 
            $i=0;
            foreach ($paginator_jobs as $item):
                $i++;    
                    if($i%2==0){
                        $class= "bg_color";
                    }
                    else{ $class="";}
                ?>
            <tr class="<?php echo $class;?>">
                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                <td class="align_l"><?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position) ?></td>
                <td><?php echo $this->company($item->user_id)->company_name;?></td>
                <td><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></td>
              
              <td >
                <?php
                $status= $this->saveJob($item->job_id, $viewer_id)->status;
                if($status==0){?>
                    
                    <a class="apply" href="<?php echo $this->baseUrl().'/recruiter/job/apply-job/job_id/'.$item->job_id ?>" ><?php echo $this->translate('Apply');?></a>
                <?php }
                else {
                    echo $this->translate('Applied');
                }
                ?>
              </td>
              
            </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
      </div>
      <br />    
    <?php else: ?>
      <div style="margin-top: 5px; margin-left: 5px;" class="tip">
        <span>
          <?php echo $this->translate("There are no jobs.") ?>
        </span>
      </div>
      
    <?php endif; ?>
    </div>
    <?php if(count($paginator_jobs)>0){?>
        <div>
        <?php echo $this->paginationControl($paginator_jobs); ?>
      </div>
       <?php }?>
     <div class="block_content gutter">
    	<div class="jobs_promotion"><a href="<?php echo $this->baseUrl().'/resumes'?>"><img src="application/modules/Job/externals/images/img_promotion_01.jpg" alt="Image" /></a></div>
    </div>
    <div class="block_content">
    	<div class="jobs_promotion"><a href="<?php echo $this->baseUrl().'/resumes'?>"><img src="application/modules/Job/externals/images/img_promotion_02.jpg" alt="Image" /></a></div>
    </div>
</div>
</div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    var qsearch= "<?php echo $quicksearch ?>";
    if(qsearch==''){
        qsearch= "<?php echo $this->translate('Enter keyword')?>";
    }
    $('quicksearch').set('value', qsearch);
});
</script>