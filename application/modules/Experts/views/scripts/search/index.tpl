<style>
    .subsection {
        -moz-border-radius:3px 3px 3px 3px;
        background-color:#E9F4FA;
        border:1px solid #D0E2EC;
        margin-bottom:10px;
        margin-top: 0px;
    }
    .layout_middle_question{padding-left: 1px;}
    .list_my_questions table {display: block; width: 740px;}
    .tr_end{border-top: 1px solid #D0E2EC;}
    .tr_top{border-bottom: 1px solid #D0E2EC;}

</style>
<?php
    $paginator = $this->paginator;
    $tmp_this = $this;
    $type_search = $this->type_search;
    $pagination_control = $this->paginationControl($this->paginator);
?>
<div class="section">
    <div class="layout_right">
        <?php
               echo $this->content()->renderWidget('experts.my-accounts'); 
        ?>
        <div class="subsection">
            <?php
               echo $this->content()->renderWidget('experts.featured-experts'); 
            ?>
        </div>
        <div class="subsection">
            <?php echo $this->content()->renderWidget('group.ad'); ?>
        </div>
    </div>
    <div class="layout_middle">
        <div class="layout_middle_question">
			<div class="search_my_question">
				<?php
                    echo $this->content()->renderWidget('experts.search'); 
                ?>
                <div class="total_search_result">
                    <?php if($type_search == 1): ?>
                	<strong>Search result:</strong> <span><?php  echo $this->translate(array('%s question found', '%s questions found', $paginator->getTotalItemCount()), $paginator->getTotalItemCount()); ?></span>
                    <?php endif; ?>
                    <?php if($type_search == 2): ?>
                	<strong>Search result:</strong> <span><?php  echo $paginator->getTotalItemCount().$this->translate(' experts found'); ?></span>
                    <?php endif; ?>  
                </div>
			</div>	
			<div class="list_my_questions">
            <?php if($type_search == 1): ?>
                <?php if( $paginator->getTotalItemCount() ): ?>
                <table cellspacing="0" cellpadding="0" border="0">
                    <?php if($paginator->count()>1){?>
					<tr class="tr_top" >
						<td colspan="3" style="border-bottom: 1px solid #D0E2EC" align="right">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
                    <?php }?>
                    <tr class="tb_experts_header">
                            
                          <td><strong><?php echo $this->translate("Title") ?></strong></td>
                          
                          <td><strong><?php echo $this->translate("Views") ?></strong></td>
                          <td><strong><?php echo $this->translate("Posted date") ?></strong></td>
                     </tr>
                    <?php $cnt = 1; foreach ($paginator as $item):?>
                    <tr class="<?php if($cnt%2 != 0) echo "background_gray"; ?>">
                        <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
						<td style="width:55%"><a class="title" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'detail','question_id'=>$item->question_id, 'slug'=>$slug),'default',true) ?>"><?php echo $item->title; ?></a></td>
						<!-- <td style="width:15%"><?php echo $item->category_name; ?></td> -->
                        <td><?php  echo $this->translate(array('%s View', '%s Views', intval($item->view_count)), intval($item->view_count)); ?></td>
						<td style="width:15%"><?php echo $item->created_date; ?></td>
					</tr>
                    <?php $cnt++; endforeach; ?>
					<?php if($paginator->count()>1){?>
					<tr class="tr_end">
						<td colspan="3" style="border-top: 1px solid #D0E2EC" align="right">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
                    <?php }?>
			    </table>
                <?php endif; ?>
            <?php endif; ?>
            
            <?php if($type_search == 2): ?>
                
                <?php if( $paginator->getTotalItemCount() ): ?>
                <table cellspacing="0" cellpadding="0" border="0">
                    <?php if($paginator->count()>1){?>
					<tr class="tr_top">
						<td colspan="3" style="border-bottom: 1px solid #D0E2EC" align="right">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
                    <?php }?>
                     <tr class="tb_experts_header">
                            
                          <td><strong><?php echo $this->translate("Full name") ?></strong></td>
                          
                          <td><strong><?php echo $this->translate("Company") ?></strong></td>
                          <td><strong><?php echo $this->translate("Experience") ?></strong></td>
                          <td><strong><?php echo $this->translate("Answed");?></strong></td>
                          
                     </tr>
                    <?php $cnt = 1; foreach ($paginator as $item): ?>
                    <tr class="<?php if($cnt%2 != 0) echo "background_gray"; ?>">
                        <td style="width:55%"><a class="title" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile','username'=>$item->username),'default',true) ?>"><?php echo $item->displayname; ?></a></td>
						<!-- <td style="width:15%"><?php echo $item->category_name; ?></td> -->
                        <td ><?php echo $item->company; ?></td>
                        <td style="width:15%"><?php  echo $this->translate(array('%s year', '%s years', intval($item->experience)), intval($item->experience)); ?></td>
                        <!--<td style="width:15%"><?php echo $item->created_date; ?></td>-->
                        <td>
                        <a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>"><?php echo $this->countAnswer($item->user_id)?></a>
                        </td>
					</tr>
                    <?php $cnt++; endforeach; ?>
                    <?php if($paginator->count()>1){?>
					<tr class="tr_end">
						<td colspan="3" style="border-top: 1px solid #D0E2EC" align="right">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
                    <?php }?>
			    </table>
                <?php endif; ?>
            <?php endif; ?>
            </div>
		</div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
