<style>
table.admin_table thead tr th, table.admin_table tbody tr td{
    white-space: normal !important;
}
</style>
<script type="text/javascript">
  en4.core.runonce.add(function(){$$('th.admin_table_short input[type=checkbox]').addEvent('click', function(){ $$('input[type=checkbox]').set('checked', $(this).get('checked', false)); })});
  
  var delectSelected =function(){
    
    var checkboxes = $$('input[type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });
    $('ids').value = selecteditems;
    $('delete_selected').submit();
  }
  
</script>
<h2>
  <?php echo $this->translate("Library Plugin") ?>
</h2>

<?php if( count($this->navigation) ): ?>
<div class='tabs'>
    <?php
    // Render the menu
    //->setUlClass()
    echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
</div>
<?php endif; ?>

<?php if(count($this->categories)): ?>
<div class='clear'>
  <div class='settings'>
    <form class="global_form">
    <div class="subsection">
        <ul class="list_category">
            <?php foreach($this->categories as $item): ?>
    		<li>
            <?php 
            echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'index','cat_id'=>$item->category_id), $item->name."({$item->cnt_book})", array(
            ))
            ?>
            </li>
            <?php endforeach; ?>
    	</ul>
    </div>  
    </form>
  </div>
</div>
<?php endif; ?>    
<br />

<div class="search_my_question">
	<?php
        $paginator = $this->paginator; 
        $pagination_control = $this->paginationControl($this->paginator);
        echo $this->content()->renderWidget('library.admin-search'); 
    ?>
</div>	


<?php if( $paginator->getTotalItemCount() ): ?>
<?php 
    echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'create'), $this->translate('Add new library'), array(
    //'class' => 'smoothbox',
    )) 
?>
<table class='admin_table' >
  <thead>
    <tr>
      <th class='admin_table_short'><input onclick='selectAll();' type='checkbox' class='checkbox' /></th>
      <th width="200"><?php echo $this->translate("Book name") ?></th>
      <th width="10%"><?php echo $this->translate("Code") ?></th>
      <th width="10%"><?php echo $this->translate("Author") ?></th>
      <th width="10%"><?php echo $this->translate("Categories") ?></th>
      <th width="10%"><?php echo $this->translate("Created") ?></th>
      <th width="10%"><?php echo $this->translate("Download count") ?></th>
      <th width="10%"><?php echo $this->translate("Comment count") ?></th>
      <th width="10%"><?php echo $this->translate("Rating count") ?></th>
      <th width="10%"><?php echo $this->translate("Options") ?></th>
    </tr>
  </thead>
  <tbody>
    <?php foreach ($paginator as $item): ?>
      <tr>
        <td>
            <input type='checkbox' class='checkbox' value="<?php echo $item->book_id; ?>"/>
        </td>
        <td  width="10"%>
            <?php echo $item->title; ?>
        </td>
        <td  width="10"%>
            <?php echo $item->isbn; ?>
        </td>
        <td  width="10%">
            <?php echo $item->author; ?>
        </td >
        <td  width="10%">
            <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'index','cat_id'=>$item->category_ids), $item->category, array()) ?>
        </td>
        
        <td  width="10%">
            <?php echo $item->created_date; ?>
        </td>
        <td  width="10%">
            <?php echo $item->download_count; ?>
        </td>
        <td  width="10%">
            <?php
                echo $item->cnt_comment;
            ?>
        </td>
        
        <td  width="10%">
            <?php
                echo $item->cnt_rating;
            ?>
        </td>
        <td  width="10%">
           <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'view','book_id'=>$item->book_id), $this->translate('View'), array(
                //'class' => 'smoothbox',
                )) ?> 
          <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'edit','book_id'=>$item->book_id), $this->translate('Edit'), array(
        //'class' => 'smoothbox',
        )) ?>
        <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'delete','book_id'=>$item->book_id), $this->translate('Delete'), array(
        'class' => 'smoothbox',
        )) ?>
         </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<br />
<div class='buttons'>
  <button onclick="javascript:delectSelected();" type='submit'>
    <?php echo $this->translate("Delete Selected") ?>
  </button>
</div>

<form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'delete-selected')) ?>'>
  <input type="hidden" id="ids" name="ids" value=""/>
</form>

<br/>
<div>
  <?php echo $pagination_control; ?>
</div>

<?php else: ?>
  <div class="tip">
    <span>
      <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'create'), $this->translate('Add new book'), array(
        //'class' => 'smoothbox',
        )) ?>
    </span>
  </div>
<?php endif; ?>
