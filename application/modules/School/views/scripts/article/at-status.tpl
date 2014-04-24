<style type="text/css">
#global_wrapper{background:none;}
</style>
<?php
$paginators= $this->articles; 
$status= $this->status;
?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate('Home');?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/school'?>"><?php echo $this->translate('Education School');?></a> <span>&gt;</span> <strong>
            <?php if($status=='approve') {
                echo $this->translate('Approved Articles');
            }else if($status=='pending'){
                echo $this->translate('Pending Articles');
            }else{
                echo $this->translate('Cancelled Articles');
            }
            ?>
        </strong>
    </div>
</div>
<div id="content">
    <div class="section jobs hotel">
        <div class="layout_right">
            <?php echo $this->content()->renderWidget('school.school-tools');?>
            <?php echo $this->content()->renderWidget('school.top-article');?>
            <?php echo $this->content()->renderWidget('school.newest-comment');?>
        </div>
        <div class="layout_middle">
        <div class="subsection your_resumes">
            
            <h2><?php echo $this->translate('Manage Articles')?></h2>
            <div id="loading" style="display: none;">
              <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
              <?php echo $this->translate("Loading ...") ?>
            </div>
             <?php if(count($paginators)){?>
                
                    <table cellspacing="0" cellpadding="0">
                        <tr>
                            <th style="width:320px"><?php echo $this->translate('Title');?></th>
                            <th style="width:120px"><?php echo $this->translate('School');?></th>
                            
                            <?php if($status=='pending'){?>
                                <th><?php echo $this->translate('Options')?></th>
                            <?php } ?>                        
                            
                        </tr>
                    <?php 
                    $i=0;
                        foreach($paginators as $paginator){
                            $i++;    
                            if($i%2==0){
                                $class= "";
                            }
                            else{ $class="bg_color";}
                        ?>
                        
                            <tr class="<?php echo $class;?>">
                                <td class="align_l">
                                   
                                    <?php echo $this->htmlLink(array('route' => 'view-school-artical', 'id'=> $paginator->artical_id), $paginator->title) ?>
                                </td>
                                <td class="align_l"><?php echo $this->school($paginator->school_id)->name;?></td>
                                
                                <?php if($status=='pending'){?>
                                <td>
                                
                                    
                                    <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'school', 'controller' => 'article', 'action' => 'approve', 'id' => $paginator->artical_id), $this->translate('approve'), array(
                                      'class' => 'smoothbox',
                                    )) ?>
                                    |
                                    <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'school', 'controller' => 'article', 'action' => 'reject', 'id' => $paginator->artical_id), $this->translate('reject'), array(
                                      'class' => 'smoothbox',
                                    )) ?>
                                   
                                </td>
                                 <?php }?>
                            </tr>
                            
                    <?php }?>
                    </table>
                   
            <?php } else{?>
                <div class="tip" style="padding-top: 5px; padding-left:5px;">
                <span>
                  <?php echo $this->translate("There are no article.") ?>
                </span>
              </div>
            <?php }
             ?>   
             </div>
             <?php echo $this->paginationControl($paginators);?>
        </div>
    </div>
</div>
