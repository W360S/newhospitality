<?php
$paginators= $this->paginator; 
?>
<div class="layout_main">
    <div class="headline">
    <?php echo $this->translate('day la headline');?>
    </div>
    <div class="layout_left">
    <?php echo $this->translate('day la left');?>
    </div>
    <div class="layout_middle">
        <div class="school_main_manage">
            <div class="subsection">
            <h2><?php echo $this->translate('Posted Articals')?></h2>
            <div id="loading" style="display: none;">
              <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
              <?php echo $this->translate("Loading ...") ?>
            </div>
             <?php if(count($paginators)){?>
                <div class="list_school_manage">
                    <table>
                        <tr>
                            <th style="padding-left: 5px; width: 50%;"><?php echo $this->translate('Title');?></th>
                            <th><?php echo $this->translate('School');?></th>
                            <th><?php echo $this->translate('View');?></th>
                            <th></th>
                        </tr>
                    <?php 
                    $i=0;
                        foreach($paginators as $paginator){
                            $i++;    
                            if($i%2==0){
                                $class= "back_gr_gray";
                            }
                            else{ $class="";}
                        ?>
                        
                            <tr class="<?php echo $class;?>">
                                <td style="padding-left: 5px;">
                                   
                                    <?php echo $this->htmlLink(array('route' => 'view-school-artical', 'id' => $paginator->artical_id), $paginator->title) ?>
                                </td>
                            
                                <td>
                                    <?php echo $this->school($paginator->school_id)->name;?>
                                </td>
                                <td><?php echo $paginator->view_count; ?></td>
                                <td>
                                <a href="<?php echo $this->baseUrl().'/school/artical/edit/artical_id/'.$paginator->artical_id;?>"><?php echo $this->translate('Edit');?></a>
                                <a href="javascript:void(0);" onclick="delete_artical('<?php echo $paginator->artical_id ?>')"><?php echo $this->translate('Delete');?></a>
                                
                                </td>
                            </tr>
                            
                    <?php }?>
                    </table>
                    </div>
            <?php } else{?>
                <div class="tip" style="padding-top: 5px; padding-left:5px;">
                <span>
                  <?php echo $this->translate("There are no schools.") ?>
                </span>
              </div>
            <?php }
             ?>   
             </div>
             <?php echo $this->paginationControl($paginators);?>
        </div>
    </div>
    
</div>
<script type="text/javascript">
function delete_artical(artical_id){
    var url="<?php echo $this->baseUrl().'/school/artical/delete'?>";
    if(confirm("Do you really want to delete this artical?")){
        $('loading').style.display="block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'artical_id': artical_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            $('loading').style.display="none";
            
            if(responseHTML==1){
                //tam thoi cho redirect ve trang nay
                window.location.href= "<?php echo $this->baseUrl().'/school/artical/manage'?>";
            }
            
        }
    }).send();
	}	
 }
</script>
