<style type="text/css">
.paging {
    padding-bottom:0px;
    padding-top:5px;
}

.paging .pages ul.paginationControl li{
    border-bottom-width:0px;
    height:auto;
    padding: 0px;
}

.layout_middle .tab .item li a {
    border: 0px !important;
    padding-right:0px !important;
}
.layout_middle .tab .item li.current a span {
    background-image: url("application/modules/Core/externals/images/sprite.png") !important;
}
</style>
<div id="ajax_tophome-tab">
<?php 
    if( $this->paginator->getTotalItemCount() ): 
?>

<ul class="pt-reply-list">
	<?php foreach ($this->paginator as $item): 
	//var_dump($this->substring($item->content,200)); exit;
	?>
	<?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
	
	<li>
		<div class="pt-vote">
			<a href="#" class="pt-votes"><span><?php echo intval($item->view_count); ?></span><span>Lượt xem</span></a>
			<a href="#" class="pt-replys pt-replys-no" ><span><?php echo $item->cnt_answer; ?></span><span>Trả lời</span></a>
		</div>
		<h3><a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'detail', 'question_id' => $item->question_id, 'slug' => $slug), 'default', true); ?>"><?php echo $item->title; ?></a></h3>
		<?php //echo $this->substring($item->content,200); 
		$content = Engine_Api::_()->library()->truncate($item->content, 300, "...", false); 
		echo $content;
		?>
		
		<p class="last">Chuyên mục: <?php 
		$arr_cat_id = explode("&&", $item->category_id);
		$arr_cat_name = explode("&&", $item->category);
		for($i=0; $i<=count($arr_cat_name); $i++){
		  if($i<count($arr_cat_name)){
		   echo "<a href='".$this->url(array('module'=>'experts','controller'=>'index','action'=>'category', 'category_id'=>$arr_cat_id[$i]),'default',true)."'>".$arr_cat_name[$i]."</a>".", "; 
		  } else {
		    echo "<a href='".$this->url(array('module'=>'experts','controller'=>'index','action'=>'category', 'category_id'=>$arr_cat_id[$i]),'default',true)."'>".$arr_cat_name[$i]."</a>"; 
		  }		
		}
		
		?><strong><?php echo $this->translate('Asked by') ?>:</strong><a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"> <?php echo $item->username; ?> </a>-<span><?php echo $this->timestamp($item->created_date); ?></span></p>
	</li>
	<?php endforeach; ?>
</ul>
<div class="pt-paging">
	<?php echo $this->paginationControl($this->paginator, null, "application/modules/Experts/views/scripts/pagination-home.tpl"); ?>
</div>
<?php endif; ?>

</div>