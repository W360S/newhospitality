<script type="text/javascript">
  en4.core.runonce.add(function(){$$('td.admin_table_short input[type=checkbox]').addEvent('click', function(){ $$('input[type=checkbox]').set('checked', $(this).get('checked', false)); })});
  
  /* Cancel selected questions */
  var cancelSelected =function(){
    var checkboxes = $$('input[name=questions_checbox][type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });
    
    $('cancel_ids').value = selecteditems;
    $('cancel_selected').submit();
  }
  
  /* Close selected questions */
  var closeSelected =function(){
    
    var checkboxes = $$('input[name=questions_checbox][type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });

    $('close_ids').value = selecteditems;
    $('close_selected').submit();
  }
  
  /* Close delete questions */
  var deleteSelected =function(){
    
    var checkboxes = $$('input[name=questions_checbox][type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });
    
    $('delete_ids').value = selecteditems;
    $('delete_selected').submit();
  }

</script>

<div class="section">
    <div class="layout_right">
        <div class="subsection">
            <?php
                $paginator = $this->paginator;
                $status = $this->status;
                $expert_id  = $this->expert_id;
                $expert_name  = $this->expert_name;
                $pagination_control = $this->paginationControl($this->paginator);
                echo $this->content()->renderWidget('experts.featured-experts'); 
            ?>
        </div>
        <div class="subsection">
            <?php echo $this->content()->renderWidget('group.ad'); ?>
        </div>
    </div>
    <div class="layout_middle">
        <div class="headline">
			<div class="breadcrumb_expert">
				<h2><a class="first" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'index'),'default', true); ?>">expert</a> <a href="<?php echo $this->baseUrl("/")."experts/my-experts/"; ?>">my experts</a><a href="<?php echo $this->baseUrl("/")."experts/my-experts/manage/expert_id/".$expert_id; ?>"><?php echo $expert_name; ?></a></h2>
			</div>
			<div class="clear"></div>
        </div>
		<div class="layout_left layout_left_expert">
			<div class="subsection">
				<?php echo $this->content()->renderWidget('experts.my-experts'); ?>
			</div>
		</div>
		<div class="layout_middle_question">
			<div class="search_my_question">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
                
			</div>	
			<div class="list_my_questions">
                <?php if( $paginator->getTotalItemCount() ): ?>
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr class="container_func">
                        <td  class='admin_table_short'>
                            <input onclick='selectAll();' type='checkbox' class='checkbox' />
                        </td>
						<td >
							<?php if($status == 1): ?>
                            <button class="bt_cancel" onclick="javascript:cancelSelected();" type='submit'>
                               Cancel
                            </button>
                            <?php endif; ?>
                            
                            <?php if($status == 2): ?>
                            <button class="bt_cancel" onclick="javascript:closeSelected();" type='submit'>
                                Close
                            </button>
                            <?php endif; ?>
                            
                            <?php if(in_array($status,array(1,3,4))): ?>
                            <button class="bt_cancel" onclick="javascript:deleteSelected();" type='submit'>
                                Delete
                            </button>
                            <?php endif; ?>
						</td>
						<td colspan="2">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
                    <?php $cnt = 1; foreach ($paginator as $item): ?>
                        <tr class="<?php if($cnt%2 != 0) echo "background_gray"; ?>">
							<td  style="width:8px">
                                <input name="questions_checbox" type='checkbox' class='checkbox' value="<?php echo $item->question_id; ?>"/>
                            </td>                       
							<td style="width:300px"><a class="title" href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-experts','action'=>'detail','expert_id'=>$item->expert_id,'question_id'=>$item->question_id),'default', false); ?>"><?php echo $item->title ; ?></a></td>
							<td style="width:120px"><?php echo $item->category ; ?></td>
							<td style="width:130px"><?php echo $item->created_date ; ?></td>
						</tr>
                    <?php $cnt++; endforeach; ?>
					<tr class="container_func">
						<td  class='admin_table_short'>
                            <input onclick='selectAll();' type='checkbox' class='checkbox' />
                        </td>
						<td >
                            <?php if($status == 1): ?>
                            <button class="bt_cancel" onclick="javascript:cancelSelected();" type='submit'>
                               <?php echo $this->translate('Cancel'); ?>
                            </button>
                            <?php endif; ?>
                            
                            <?php if($status == 2): ?>
                            <button class="bt_cancel" onclick="javascript:closeSelected();" type='submit'>
                                <?php echo $this->translate('Close'); ?>
                            </button>
                            <?php endif; ?>
                            
                            <?php if(in_array($status,array(1,3,4))): ?>
                            <button class="bt_cancel" onclick="javascript:deleteSelected();" type='submit'>
                                <?php echo $this->translate('Delete'); ?>
                            </button>
                            <?php endif; ?>
						</td>
						<td colspan="2">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
				</table>
                <form id='cancel_selected' method='post' action='<?php echo $this->url(array('action' =>'cancel-selected')) ?>'>
                  <input type="hidden" id="cancel_ids" name="cancel_ids" value=""/>
                  <input type="hidden" id="cancel_experts_id" name="cancel_experts_id" value="<?php echo $expert_id; ?>"/>
                </form>
                <form id='close_selected' method='post' action='<?php echo $this->url(array('action' =>'close-selected')) ?>'>
                  <input type="hidden" id="close_ids" name="close_ids" value=""/>
                  <input type="hidden" id="close_experts_id" name="close_experts_id" value="<?php echo $expert_id; ?>"/>
                </form>
                <form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'delete-selected')) ?>'>
                  <input type="hidden" id="delete_ids" name="delete_ids" value=""/>
                  <input type="hidden" id="delete_experts_id" name="delete_experts_id" value="<?php echo $expert_id; ?>"/>
                </form>
			    <?php else: ?>
                 <table cellspacing="0" cellpadding="0" border="0">
					<tr class="container_func">
						<td colspan="2">
							<?php echo $this->translate("No questions in this item."); ?>
						</td>
                    </tr>
                 </table>       
                <?php endif; ?>    
            </div>
		</div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
