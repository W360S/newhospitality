<style>
.wd-content-left { width:204px; float:left; padding-top:20px;}
.pt-subpage  .wd-center  {width:1188px !important}
.pt-comment-text .pt-submit-comment { margin-left:0px !important;}
.pt-comment-text .pt-textarea {width:528px !important;}
.bt-loading-detele .pt-detele button{
    background-position: -149px -488px;
    margin-top: 10px;
    height: 40px;
    height: 34px;
}
</style>
<script type="text/javascript">
  
  /* Close delete questions */
  var deleteSelected =function(){
    
    var checkboxes = jQuery('input[name=questions_checbox][type=checkbox]');
    var selecteditems = [];
    jQuery('#my_question :checked').each(function() {
       selecteditems.push(jQuery(this).val());
     });
    
    jQuery('#delete_ids').val(selecteditems);
    jQuery('#delete_selected').submit();
  }

</script>
<div id="wd-content-container">
<div class="wd-center">
	<div class="wd-content-left">
		<?php echo $this->content()->renderWidget('experts.categories'); ?>
	</div>
	<div class="wd-content-content-sprite pt-fix">
		<div class="wd-content-event">
			<div class="pt-content-event">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
				<div class="pt-reply-how">
					<div class="pt-reply-left">
						<ul class="pt-menu-event">
							<li class="active">
								<a href="#">Hỏi đáp</a>
							</li>
							<li>	
								<?php  if($this->view_user == null):  ?>
								<a href="#" >Câu hỏi của tôi</a>
								<?php else: ?>
								<a href="<?php echo $this->baseUrl("/") . "profile/" . $this->view_user; ?>">Câu hỏi của <?php echo $this->view_user; ?></a>
								<?php endif; ?>
							</li>
						</ul>
						<?php if($this->view_user == ''): ?>
						<div class="bt-loading-detele">
							<a href="<?php echo $this->url(array('action'=>'index')); ?>" class="pt-loading"></a>
							<div class="pt-detele">
							<button class="bt_cancel" onclick="javascript:deleteSelected();" type='submit'>
							    <?php echo $this->translate('Delete'); ?>
							</button>
							</div>
							<form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'delete-selected')) ?>'>
							  <input type="hidden" id="delete_ids" name="delete_ids" value=""/>
							</form>
						</div>
						<?php endif; ?>
						<div class="pt-list-table">
							<?php
							    $paginator = $this->paginator;
							    $status = $this->status;
							    $pagination_control = $this->paginationControl($this->paginator);
							?>
							<?php if( $paginator->getTotalItemCount() ): ?>
							<div class="pt-paging">
							<?php echo $pagination_control; ?>
							</div>
							<table id="my_question" cellspacing="0" cellpadding="0">
								<thead>
									<tr>
										<th><input type='checkbox' class='checkbox' /></th>
										<th><strong>Tiêu đề</strong></th>
										<th><strong>Danh mục</strong></th>
										<th><strong>Thay đổi mới nhất</strong></th>
										<th><strong>Ngày đăng</strong></th>
									</tr>
								</thead>
								<tbody>
									<?php $cnt = 1; foreach ($paginator as $item): ?>
									<tr>
										<td><input name="questions_checbox" type="checkbox" class='checkbox' value="<?php echo $item->question_id; ?>" /></td>
										<td><a href="<?php echo $this->url(array('controller'=>'index','action'=>'detail','question_id'=>$item->question_id)); ?>"><?php echo $item->title ; ?></a></td>
										<td><?php echo $item->category ; ?></td>
										<td><?php echo $item->lasted_by ; ?></td>
										<td><span><?php echo $item->created_date ; ?></span></td>
									</tr>
									 <?php $cnt++; endforeach; ?>
								</tbody>
							</table>
							<?php endif; ?>
							<div class="pt-paging">
							<?php echo $pagination_control; ?>
							</div>
						</div>
					</div>
					<div class="pt-reply-right">
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.post-question'); ?>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.my-accounts'); ?>
						</div>
					
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.featured-experts'); ?>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
<div id="wd-extras">
	<div class="wd-center">
		
	</div>	
</div>
<script src="<?php echo $this->baseUrl().'/application/modules/Experts/externals/scripts/common.js'?>" type="text/javascript"></script>
