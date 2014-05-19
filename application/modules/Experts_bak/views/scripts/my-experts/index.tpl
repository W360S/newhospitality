<style>
.wd-content-left { width:204px; float:left; padding-top:20px;}
.pt-subpage  .wd-center  {width:1188px !important}
.pt-comment-text .pt-submit-comment { margin-left:0px !important;}
.pt-comment-text .pt-textarea {width:528px !important;}

</style>
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
								<a href="#" >Câu hỏi tôi đã trả lời</a>
							</li>
						</ul>
						
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
										<th><strong>Tiêu đề</strong></th>
										<th><strong>Danh mục</strong></th>
										<th><strong>Thay đổi mới nhất</strong></th>
										<th><strong>Ngày đăng</strong></th>
									</tr>
								</thead>
								<tbody>
									<?php $cnt = 1; foreach ($paginator as $item): ?>
									<tr>
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
							<div class="pt-contents-response">
								<p>Mauris iaculis porttitor posuere. Praesent id metus massa, ut blandit odio. Proin quis tortor orci.</p>
								<a href="#">GỬI CÂU HỎI</a>
							</div>
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