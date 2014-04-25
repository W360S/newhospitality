<style type="text/css">
#global_wrapper {background:none;}
</style>
<?php
    $resumes= $this->resumes;

    $viewer_id= $this->viewer_id; 
    $status= $this->status;

?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong>
            
            <?php if($status== 'pending'){
                echo $this->translate("Pending Resumes");
               }
               else if($status=='approve'){
                echo $this->translate('Approved Resumes');
               } 
               else{
                echo $this->translate('Cancelled Resumes');
               }
            ?>
            
        </strong>
    </div>
</div>
 <div id="content">
 <div class="section jobs">
<div class="layout_right">
<!-- resume tools -->
    <?php echo $this->content()->renderWidget('resumes.resume-tools');?>
    <!-- end -->
    <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
    <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
    <div class="subsection">
        <a href="<?php echo $this->baseUrl().'/recruiter'?>"><img alt="Image" src="application/modules/Core/externals/images/img-showcase-4.jpg"></a>
    </div>
</div>
<div class="layout_middle">
<div class="resume_preview_main">
     <div class="subsection your_resumes my_jobs">
    <h2><?php echo $this->translate('Resumes')?></h2>
    <div id="resume_loading" style="display: none;">
      <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
      <?php echo $this->translate("Loading ...") ?>
    </div>
    <div id="list_resume">
    <?php if(count($resumes)){?>
        
        <table cellspacing="0" cellpadding="0">
            

            <tr>
                <th style="width:250px"><?php echo $this->translate('Resume Title')?></th>
                <th style="width:106px"><?php echo $this->translate('Status');?></th>
                <th style="width:72px"><?php echo $this->translate('Date Modified')?></th>
                <?php if($status=='pending'){?>
                    <th><?php echo $this->translate('Options ')?></th>
                <?php } ?>
            </tr>   
           <?php foreach($resumes as $resume){?>
           <tr>
            
            <td><?php echo $this->htmlLink(array('route'=>'default', 'module'=>'resumes', 'controller'=> 'resume', 'action'=>'view', 'resume_id' => $resume->resume_id), wordwrap($resume->title, "64", "<br />\n", true), array('target'=>'_blank')) ?></td>
            <td>
                <?php if($status=='approve'){
                    echo "<span style='color: #64A700;font-style:italic;font-size:10px;'>".$this->translate('Approved')."</span>";?><img src="<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/approve.gif'?>" />
                <?php } else if($status =='reject' && ($resume->approved==0)){
                        echo "<span style='color:red;font-style:italic;font-size:10px;'>".$this->translate('Incomplete')."</span>";?>  
                <?php } else{
                    echo "<span style='font-style:italic;font-size:10px;'>".$this->translate('Wait to approved')."</span>";
                }
                ?>
            </td>
            <td>
            <?php echo date('d F Y', strtotime($resume->modified_date));?>
            </td>
            <?php if($status=='pending'){?>
                <td>
                <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'resumes', 'controller' => 'resume', 'action' => 'approve', 'id' => $resume->resume_id), $this->translate('approve'), array(
                      'class' => 'smoothbox'
                    )) ?>
                   
                    |
                    <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'resumes', 'controller' => 'resume', 'action' => 'reject', 'id' => $resume->resume_id), $this->translate('reject'), array(
                      'class' => 'smoothbox'
                    )) ?>
                </td>
            <?php } ?>
       </tr>
            <?php }?>
        </table>
        
    <?php }
    else{?>
        <div style="margin-top: 5px; margin-left: 5px;" class="tip">
        <span>
          <?php echo $this->translate("There are no resume.") ?>
        </span>
      </div>
    <?php }?>
    </div>
    </div>
   <?php if(count($resumes)>0){?>
        <div>
        <?php echo $this->paginationControl($resumes); ?>
      </div>
       <?php }?>
</div>
</div>
</div>
</div>
