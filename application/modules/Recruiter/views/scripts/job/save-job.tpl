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
<?php //echo $this->content()->renderWidget('recruiter.search-job');?>

<div id="breadcrumb">
                <div class="section">
                    <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Saved Jobs");?></strong>
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
            <div class="bt-loading-detele pt-fix-title">
				<a class="pt-loading" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/job/save-job' ?>"></a>
				<!--<a class="pt-detele" href="#"></a>-->
				<button class="pt-detele" onclick="javascript:delectSelected();" type='submit'>
                      <?php //echo $this->translate("Delete Selected") ?>
    			</button>
			</div>
            <style>
            	.pt-fix-title {
				    margin-top: 11px;
				}
				.bt-loading-detele {
				    float: left;
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
				.nopdon{
					 background: none repeat scroll 0 0 #dadada;
				    border: 1px solid #888888;
				    border-radius: 5px;
				    color: #000;
				    padding: 6px 10px;
				}
				.nopdon:hover{
					background: none repeat scroll 0 0 #b9e3fb;
					text-decoration:none;	
				}
				.pt-list-table table td button {
				    padding: 5px 10px;
				    background:none;
				    padding:5px;
				    border:1px solid #50809B;
				    font-weight: normal;
				    
				    
				}
				.pt-list-table table td button:hover {
				    padding: 5px 10px;
				    background:none;
				    padding:5px;
				    border:1px solid #50809B;
				    font-weight: normal;
				    background:#b9e3fb;
				    text-decoration:none;
				    
				}
				.pt-list-table table td button a{
				    padding: 5px 10px;
				    background:none;
				    padding:5px;
				    color:#333;
				    font-size:12px;
				    text-decoration:none;
				    
				}
				.pt-list-table table td button a:hover {
				    padding: 5px 10px;
				    background:none;
				    padding:5px;
				    color:#333;
				    text-decoration:none;
				    
				}
				span.button a, a.button{
					color:#333 !important;
					background:#eee;
					 font-weight: normal !important;
				}
				.pt-list-table table td a:hover{
				   
				    text-decoration:none;
				    
				}
				
            </style>
            <?php if( count($paginator) ): ?>
            <div class="pt-list-table">
            
            
              <table cellspacing="0" cellpadding="0">
              		<thead>
						<tr>
							<th><input type='checkbox' class='checkbox' /></th>
							<th><strong><?php echo $this->translate("Position") ?></strong></th>
							<th><strong><?php echo $this->translate("Company") ?></strong></th>
							<th style="width:100px"><strong><?php echo $this->translate("Date Saved") ?></strong></th>
							<th style="width:100px"><strong><?php echo $this->translate("Status") ?></strong></th>
						</tr>
					</thead>
                
                  <!--<tr>
                    <th class='admin_table_short'><input type='checkbox' class='checkbox' /></th>
                    <th><?php echo $this->translate("Position") ?></th>
                    <th><?php echo $this->translate("Company") ?></th>
                    <th><?php echo $this->translate("Date Saved") ?></th>
                    <th><?php echo $this->translate("Status") ?></th>
                    
                  </tr>-->
                
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
                      <td><input type='checkbox' value="<?php echo $item->job_id ?>"/></td>
                      <td>
                      <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                        <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?>
                			
                      </td>
                      <td><?php echo $this->company($item->user_id)->company_name;?></td>
                      <td><?php echo date('d F Y', strtotime($this->saveJob($item->job_id, $viewer_id)->date_saved)); ?></td>
                      
                      <td>
                        <?php
                        $status= $this->saveJob($item->job_id, $viewer_id)->status;
                        if($status==0){?>
                            
                            <a class="button" target="_blank" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/job/apply-job/job_id/'.$item->job_id ?>" ><?php echo $this->translate('Apply');?></a>
                        <?php }
                        else {
                            echo $this->translate('Applied').'<br>';
                            echo '('.date('d F Y', strtotime($this->saveJob($item->job_id, $viewer_id)->date_saved)).')';
							
							//print_r($this->saveJob($item->job_id, $viewer_id));
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
                <!--<div class='buttons'>
                    <button onclick="javascript:delectSelected();" type='submit'>
                      <?php echo $this->translate("Delete Selected") ?>
                    </button>
              </div>-->
            <?php }?>
            
            </div>
            </div>
        </div>
    </div>
