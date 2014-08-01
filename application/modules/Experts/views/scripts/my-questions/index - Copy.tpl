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
<style>
    
    div, td {
        color:#555555;
        font-size: 12px;
    }
    .subsection {
        -moz-border-radius:3px 3px 3px 3px;
        background-color:#E9F4FA;
        border:1px solid #D0E2EC;
        margin-bottom:10px;
        margin-top: 0px;
    }
    .layout_middle_question{padding-left: 1px;}
</style>
<?php
    $paginator = $this->paginator;
    $status = $this->status;
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
        <div class="headline">
			<div class="breadcrumb_expert">
				<h2><a class="first" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'index'),'default',true); ?>"><?php echo $this->translate('experts'); ?></a> <a href="<?php echo $this->url(array('module'=>'experts','controller'=>'my-questions','action'=>'index'),'default',true); ?>"><?php echo $this->translate('my questions'); ?></a> </h2>
			</div>
			<div class="clear"></div>
        </div>
		<div class="layout_left layout_left_expert">
        <!--
			<div class="subsection">
				<div class="bt_function_question">
					<a href="<?php //echo $this->baseUrl().'/experts/my-questions/compose'; ?>" class="create">Post a Question</a>
				</div>
			</div>
            -->
			<div class="subsection">
				<?php echo $this->content()->renderWidget('experts.my-questions'); ?>
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
                            <input type='checkbox' class='checkbox' />
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
						<td colspan="4">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
                    <tr class="tb_experts_header">
                          <td></td>  
                          <td><strong><?php echo $this->translate("Title") ?></strong></td>
                          <td><strong><?php echo $this->translate("Categories") ?></strong></td>
                          <td><strong><?php echo $this->translate("Experts") ?></strong></td>
                          <td><strong><?php echo $this->translate("Lasted change") ?></strong></td>
                          <td><strong><?php echo $this->translate("Created date") ?></strong></td>
                     </tr>
                    <?php $cnt = 1; foreach ($paginator as $item): ?>
                    <tr class="<?php if($cnt%2 != 0) echo "background_gray"; ?>">
						<td  style="width:8px">
                            <input name="questions_checbox" type='checkbox' class='checkbox' value="<?php echo $item->question_id; ?>"/>
                        </td>
                        <td style="width:300px"><a class="title" href="<?php echo $this->url(array('action'=>'detail','question_id'=>$item->question_id)); ?>"><?php echo $item->title ; ?></a></td>
						<td style="width:120px"><?php echo $item->category ; ?></td>
						<td style="width:120px"><?php echo $item->experts ; ?></td>
                        <td style="width:120px"><?php echo $item->lasted_by ; ?></td>
                        <td style="width:130px"><?php echo $item->created_date ; ?></td>
					</tr>
                    <?php $cnt++; endforeach; ?>
					<tr class="container_func">
						<td  class='admin_table_short'>
                            <input  type='checkbox' class='checkbox' />
                        </td>
						<td >
                            <?php if($status == 1): ?>
                            <button class="bt_cancel" onclick="javascript:cancelSelected();" type='submit'>
                               <?php echo $this->translate("Cancel") ?>
                            </button>
                            <?php endif; ?>
                            
                            <?php if($status == 2): ?>
                            <button class="bt_cancel" onclick="javascript:closeSelected();" type='submit'>
                                <?php echo $this->translate("Close") ?>
                            </button>
                            <?php endif; ?>
                            
                            <?php if(in_array($status,array(1,3,4))): ?>
                            <button class="bt_cancel" onclick="javascript:deleteSelected();" type='submit'>
                                <?php echo $this->translate("Delete") ?>
                            </button>
                            <?php endif; ?>
						</td>
						<td colspan="4">
							<?php echo $pagination_control; ?>
						</td>
					</tr>
				</table>
                <form id='cancel_selected' method='post' action='<?php echo $this->url(array('action' =>'cancel-selected')) ?>'>
                  <input type="hidden" id="cancel_ids" name="cancel_ids" value=""/>
                </form>
                <form id='close_selected' method='post' action='<?php echo $this->url(array('action' =>'close-selected')) ?>'>
                  <input type="hidden" id="close_ids" name="close_ids" value=""/>
                </form>
                <form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'delete-selected')) ?>'>
                  <input type="hidden" id="delete_ids" name="delete_ids" value=""/>
                </form>
			    <?php else: ?>
                 <table cellspacing="0" cellpadding="0" border="0">
					<tr class="container_func">
						<td colspan="2">
							<?php echo $this->translate("Haven't questions in this item.") ?>
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
<script type="text/javascript">
 window.addEvent('domready',function(){
    jQuery('.experts_selected').each(function() {
        var experts_name = jQuery(this).attr("value");
        var url = jQuery(this).attr('href');
        url = url.replace('#','<?php echo $this->baseUrl('/') ?>'+'experts/index/profile/username/'+experts_name);
        jQuery(this).attr("href",url);
        jQuery(this).text(experts_name);
    });
 });
</script>