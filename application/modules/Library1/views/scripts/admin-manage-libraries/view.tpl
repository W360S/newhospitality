<style>
.detail_book tr td{
    padding-top: 10px;
}
</style>
<script type="text/javascript">
  en4.core.runonce.add(function(){$$('th.admin_table_short input[type=checkbox]').addEvent('click', function(){ $$('input[type=checkbox]').set('checked', $(this).get('checked', false)); })});
  
  var delectCommentSelected =function(){
    
    var checkboxes = $$('input[type=checkbox]');
    var selecteditems = [];
    
    checkboxes.each(function(item, index){
    var checked = item.get('checked', false);
    var value = item.get('value', false);
    if (checked == true && value != 'on'){
    selecteditems.push(value);
    }
    });
    $('delete_ids').value = selecteditems;
    $('delete_comments_selected').submit();
  }
  
  var approveCommentSelected =function(){
    
    var checkboxes = $$('input[type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });
    $('approve_ids').value = selecteditems;
    $('approve_comments_selected').submit();
  }
  
</script>
<a href="<?php echo $this->baseUrl().'/admin/library/manage-libraries'; ?>"><?php echo $this->translate('Manage Library');?></a>
<h2>
  <?php echo $this->translate("Book detail"); ?>
</h2>

<div class="search_my_question">
	<table class="detail_book" cellpadding="100" cellspacing="10" width="100%" border="1px">
        <tr>
            <td>
                <?php echo $this->translate('Code'); ?>: <?php echo $this->book->isbn; ?>
            </td>
            <td>
                <?php echo $this->translate('Author'); ?>: <?php echo $this->book->author; ?>
            </td>
            <td>
                <?php echo $this->translate('Create date'); ?>: <?php echo $this->book->created_date; ?>
            </td>
        </tr>
        <tr>
            <td>
               <?php echo $this->translate('Categories'); ?>: <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'index','cat_id'=>$this->book->category_ids), $this->book->category, array()) ?>
            </td>
            <td>
                <?php echo $this->translate('Credit'); ?>: <?php echo $this->book->credit; ?>
            </td>
            <td>
                <?php echo $this->translate('View'); ?>: <?php echo $this->book->view_count; ?>
            </td>
        </tr>
        
        <tr>
            <td>
                 <?php echo $this->translate('Download'); ?>: <?php echo $this->book->download_count; ?>
            </td>
            <td>
                <?php echo $this->translate('Comments'); ?>: <?php echo $this->paginator->getTotalItemCount(); ?>
            </td>
            <td >
            <?php 
                              	$rating= $this->book->rating;
                              	if($rating>0){
                              		for($x=1; $x<=$rating; $x++){?>
                              			<span class="rating_star_generic rating_star"></span>
                              		<?php }
                              		
                              		
                              		$remainder = round($rating)-$rating;  			
                              		if(($remainder<=0.5 && $remainder!=0)):?><span class="rating_star_generic rating_star_half"></span><?php endif;
                              		if(($rating<=4)){
                              			for($i=round($rating)+1; $i<=5; $i++){?>
                    					<span class="rating_star_generic rating_star_disabled"></span> 	
                    			<?php }
                              		}
                	    			
                              	}else{
                              		for($x=1; $x<=5; $x++){?>
                              		<span class="rating_star_generic rating_star_disabled"></span> 
                              	<?php }
                              	}
                               
                              	?>
               
                <?php echo $this->rating_count; ?> rating
            </td>
            
        </tr>
        
        <tr>
            <td >
                Photo: 
                <?php if($this->book->book_id): ?>
                    <?php 
                    echo $this->itemPhoto($this->book, 'thumb.normal',null,array('width'=>80,'height'=>122));
                    ?>
                <?php else: ?>
                    <img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/book-no-image.png'; ?>" width="80" height="122"/>
                <?php endif; ?>
                
            </td>
            <td colspan="3">
                <?php echo $this->translate('Title'); ?>: <?php echo $this->book->title; ?>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <b><?php echo $this->translate('Description'); ?>:</b> <?php echo $this->book->description; ?>
            </td>
        </tr>
    </table>
</div>	

<h2>
  <?php echo $this->translate("All comments"); ?>
</h2>
<?php if( $this->paginator->getTotalItemCount() ): ?>

<table class='admin_table'  >
  <thead>
    <tr>
      <th class='admin_table_short'><input onclick='selectAll();' type='checkbox' class='checkbox' /></th>
      <th width="200"><?php echo $this->translate("Content") ?></th>
      <th width="10%"><?php echo $this->translate("User") ?></th>
      <th width="10%"><?php echo $this->translate("Create") ?></th>
      <th width="10%"><?php echo $this->translate("Status") ?></th>
      <th width="10%"><?php echo $this->translate("Options") ?></th>
    </tr>
  </thead>
  <tbody>
    <?php foreach ($this->paginator as $item): ?>
      <tr>
        <td>
            <input type='checkbox' class='checkbox' value="<?php echo $item->comment_id; ?>"/>
        </td>
        <td  width="10%">
            <?php $short_comment = Engine_Api::_()->news()->truncate($item->content, 64, "...", false); 
            ?>
            <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'detail-comment','comment_id'=>$item->comment_id), $short_comment, array(
            'class' => 'smoothbox',
            )) ?>
        </td>
        <td  width="10"%>
            <a href="<?php echo $this->baseUrl('/').'profile/'.$item->username; ?>"><?php echo $item->username; ?></a>
        </td>
        <td  width="10%">
            <?php echo $item->created_date; ?>
        </td >
        <td  width="10%">
            <?php
                if(intval($item->status) == 1 ){
                    echo $this->translate("Approved");
                } else {
                    echo $this->translate("Pending");
                } 
            ?>
        </td >
        <td  width="10%">
        <?php if($item->status !=1){?>
          <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'approve-comment','comment_id'=>$item->comment_id), $this->translate('Approve'), array(
        'class' => 'smoothbox',
        )) ?>
        <?php } ?>
        <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'delete-comment','comment_id'=>$item->comment_id), $this->translate('Delete'), array(
        'class' => 'smoothbox',
        )) ?>
         </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<br />

<div class='buttons'>
  <button onclick="javascript:approveCommentSelected();" type='submit'>
    <?php echo $this->translate("Approve Selected") ?>
  </button>
  <button onclick="javascript:delectCommentSelected();" type='submit'>
    <?php echo $this->translate("Delete Selected") ?>
  </button>
</div>

<form id='delete_comments_selected' method='post' action='<?php echo $this->url(array('action' =>'delete-comments-selected')) ?>'>
  <input type="hidden" id="delete_ids" name="delete_ids" value=""/>
  <input type="hidden" id="book_id1" name="book_id" value="<?php echo $this->book_id; ?>"/>
</form>

<form id='approve_comments_selected' method='post' action='<?php echo $this->url(array('action' =>'approve-comments-selected')) ?>'>
  <input type="hidden" id="approve_ids" name="approve_ids" value=""/>
  <input type="hidden" id="book_id2" name="book_id" value="<?php echo $this->book_id; ?>"/>
</form>

<br/>
<div>
  <?php echo $this->paginationControl($this->paginator);; ?>
</div>
<?php else: ?>
<div><?php echo $this->translate("This book haven't any comment"); ?></div>
<?php endif; ?>
<a href="<?php echo $this->baseUrl().'/admin/library/manage-libraries'; ?>"><?php echo $this->translate('Manage Library');?></a>