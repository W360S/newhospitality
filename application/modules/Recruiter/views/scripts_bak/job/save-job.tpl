<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
</style>
<script type="text/javascript">
  en4.core.runonce.add(function(){$$('th.admin_table_short input[type=checkbox]').addEvent('click', function(){ $$('input[type=checkbox]').set('checked', $(this).get('checked', false)); })});

  var delectSelected =function(){
    var checkboxes = $$('input[type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });

    $('ids').value = selecteditems;
    $('delete_selected').submit();
  }
</script>
<?php 
$paginator= $this->paginator;
$viewer_id= $this->viewer_id;
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
                    <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Saved Jobs");?></strong>
                </div>
            </div>
            
            <?php if( count($paginator) ): ?>
            <div class="job-list">
              <table class='admin_table'>
                
                  <tr>
                    <th class='admin_table_short'><input type='checkbox' class='checkbox' /></th>
                    
                    <th><?php echo $this->translate("Position") ?></th>
                    <th><?php echo $this->translate("Company") ?></th>
                    <th><?php echo $this->translate("Date Saved") ?></th>
                    <th><?php echo $this->translate("Status") ?></th>
                    
                  </tr>
                
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
                      <td><input type='checkbox' class='checkbox' value="<?php echo $item->job_id ?>"/></td>
                      
                      <td class="title">
                      <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                        <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?>
                			
                      </td>
                      <td><?php echo $this->company($item->user_id)->company_name;?></td>
                      <td><?php echo date('d F Y', strtotime($this->saveJob($item->job_id, $viewer_id)->date_saved)); ?></td>
                      
                      <td>
                        <?php
                        $status= $this->saveJob($item->job_id, $viewer_id)->status;
                        if($status==0){?>
                            
                            <a target="_blank" href="<?php echo $this->baseUrl().'/recruiter/job/apply-job/job_id/'.$item->job_id ?>" ><?php echo $this->translate('Apply');?></a>
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
            
              
            
              <form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'deleteselected')) ?>'>
                <input type="hidden" id="ids" name="ids" value=""/>
              </form>
            
              <br/>
            
              
            
            <?php else: ?>
              <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                <span>
                  <?php echo $this->translate("There are no jobs saved.") ?>
                </span>
              </div>
              
            <?php endif; ?>
            </div>
            <?php if(count($paginator)>0){?>
                <div>
                <?php echo $this->paginationControl($paginator); ?>
              </div>
                <div class='buttons'>
                    <button onclick="javascript:delectSelected();" type='submit'>
                      <?php echo $this->translate("Delete Selected") ?>
                    </button>
              </div>
            <?php }?>
            
            </div>
            </div>
        </div>
    </div>
