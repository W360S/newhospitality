<style>
a.pt-like-how1 {
    background-attachment: scroll;
    background-clip: border-box;
    background-color: rgba(0, 0, 0, 0);
    background-image: url(/application/themes/newhospitality/images/front/pt-sprite.png?c=34);
    background-origin: padding-box;
    background-position: -207px -489px;
    background-repeat: no-repeat;
    background-size: auto auto;
    display: inline-block;
    height: 22px;
    width: 21px;
    margin-right: 11px !important;
}
a.pt-like-how1:hover { background-position: -207px -512px;}
.pt-list-library li span{padding-right: 5px !important;}
</style>

<h3 class="pt-title-right"><?php echo $this->translate('top views');?></h3>
<?php if( count($this->data)): ?>
<ul class="pt-list-views">
<?php $dem = 0;  foreach($this->data as $item): $dem++;  
$arr_like_displayname = explode("&&",$item->like_name);
//Zend_Debug::dump($arr_like_displayname); exit;
$str ="";
for($i=0; $i<count($arr_like_displayname); $i++){
   if($i < count($arr_like_displayname) - 1){
   $str = $str.$arr_like_displayname[$i]. ",";
   } else {
   $str = $str.$arr_like_displayname[$i];
   }
}
?>
<li>

<?php if($item->photo_id): ?>
<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl('/').$item->storage_path; ?>" alt="" class='img_product' /></a>
<?php else: ?>
<a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id),'default',true); ?>"><img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" class='img_product'/></a>
<?php endif; ?>

<h2><a href="<?php echo $this->url(array('module'=>'library', 'controller'=>'index','action'=>'view','book_id'=>$item->book_id, 'slug'=>$slug),'default',true); ?>"><?php echo $item->title; ?></a></h2>
<span><?php if($item->credit == 0): ?>
			  <?php echo $this->translate('Free'); ?>
<?php else: ?>
    <?php  echo $item->credit. " Coupon"; ?></p>
			
<?php endif; ?>
</span>

<p >
<span title="<?php echo $str; ?>" style="float:left;margin-top:3px;padding-right:5px;"  id="<?php echo $item->book_id; ?>_like_book"><?php echo $item->cnt_like; ?></span>
<a class="pt-like-how1" href="javascript:void(0);"  onclick="javascript:ajaxLike1(<?php echo $item->book_id; ?>,<?php echo $item->cnt_like; ?>)"></a>

<span  style="margin-top:3px;"><?php echo $item->download_count; ?></span> Lượt tải.
</p> 

</li>
<?php endforeach; ?>
</ul>
<?php endif; ?>
<script type="text/javascript">
 function ajaxLike1(book_id, cnt)
  {  
	(new Request.JSON({
	      'format': 'json',
	      'url' : '<?php echo $this->url(array('module' => 'library', 'controller' => 'index', 'action' => 'like'), 'default', true) ?>',
	      'data' : {
		'format' : 'json',
		'book_id': book_id
	      },
	      'onRequest' : function(){
		
	      },
	      'onSuccess' : function(responseJSON, responseText)
	      {
	        var last = cnt+1;
		$(book_id+'_like_book').innerHTML = responseJSON[0].total;
	      }
	    })).send();
  }
</script>