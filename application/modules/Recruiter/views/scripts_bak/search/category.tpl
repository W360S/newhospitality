<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
.search_result{padding-top: 0; width: 100%;}
div.search_result table td a{color: #028EB9;}
</style>
<?php
    $paginator= $this->paginator; 
    $category_id= $this->category_id;
    
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
            <div id="breadcrumb">
                <div class="section">
                    <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->category($category_id)->name;?></strong>
                </div>
            </div>
            <div class="subsection search_result">
            	
                <?php if( count($paginator)>0 ): ?>
                
                <table cellspacing="0" cellpadding="0">
                    <tr>
            			<th style="width:240px"><?php echo $this->translate("Job Title");?></th>
            			<th style="width:120px"><?php echo $this->translate("Company");?></th>
            			<th style="width:92px"><?php echo $this->translate("Location");?></th>
            			<th><?php echo $this->translate("Date Posted");?></th>
            		</tr>
                	<?php $i = 0; foreach($paginator as $item): 
                            $i++;
                            if($i%2==0){
                                $class= "bg_color";
                            }
                            else{ $class="";}
                        ?>
                		<tr class="<?php echo $class ?>">
                            <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                			<td class="align_l"><?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?></td>
                			<td><?php if($this->company($item->user_id)) echo $this->company($item->user_id)->company_name;?></td>
                			<td><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></td>
                			<td><?php echo date('d F Y', strtotime($item->creation_date));?></td>
                		</tr>
                	</li>
                <?php endforeach; ?>
                </table>
                
                <?php else: ?>
                <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                    <span>
                      <?php echo $this->translate("Haven't job in this industry.") ?>
                    </span>
                </div>
                
                <?php endif; ?>
            </div>
            <?php  if(count($paginator)>0 ){
                echo $this->paginationControl($paginator);
                }
            ?>
            </div>
        </div>
     </div>
</div>