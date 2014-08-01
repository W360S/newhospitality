<style>
table.admin_table thead tr th, table.admin_table tbody tr td{
    white-space: normal !important;
}
</style>
<script type="text/javascript">
  en4.core.runonce.add(function(){$$('th.admin_table_short input[type=checkbox]').addEvent('click', function(){ $$('input[type=checkbox]').set('checked', $(this).get('checked', false)); })});
  
  var delectSelected =function(){
    
    var checkboxes = $$('input[name=experts_checbox][type=checkbox]');
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
<h2>
  <?php echo $this->translate("Expert Plugin") ?>
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

<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'admin-manage-experts','action'=>'create'),'default',true); ?>"><?php echo $this->translate("Add new"); ?></a>

<div class="search_my_question">
	<?php
        $paginator = $this->paginator; 
        $pagination_control = $this->paginationControl($this->paginator);
        $categories = $this->categories;
        echo $this->content()->renderWidget('experts.admin-search-experts'); 
    ?>
</div>	

<?php if(count($categories)): ?>
<div class='clear'>
  <div class='settings'>
    <form class="global_form">
    <div class="subsection">
        <ul class="list_category">
            <?php foreach($categories as $item): ?>
    		<li>
            <?php 
            echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-experts', 'action' => 'index','cat_id'=>$item->category_id), $item->category_name."({$item->cnt_expert})", array(
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

<?php if( $paginator->getTotalItemCount() ): ?>
<table class='admin_table' >
  <thead>
    <tr>
      <th class='admin_table_short'><input onclick='selectAll();' type='checkbox' class='checkbox' /></th>
      <th width="100"><?php echo $this->translate("Experts") ?></th>
      <th width="50"><?php echo $this->translate("Join date") ?></th>
      <th width="100"><?php echo $this->translate("Experience") ?></th>
      <th width="50"><?php echo $this->translate("Categories") ?></th>
      <th width="50"><?php echo $this->translate("Quetions") ?></th>
      <th width="50"><?php echo $this->translate("Answered") ?></th>
      <th width="100"><?php echo $this->translate("Action") ?></th>
    </tr>
  </thead>
  <tbody>
    <?php foreach ($paginator as $item):  ?>
      <tr>
        <td>
            <input name="experts_checbox" type='checkbox' class='checkbox' value="<?php echo $item->expert_id; ?>"/>
        </td>
        <td  width="120">
            <a href="<?php echo $this->baseUrl("/").'profile/'.$item->username; ?>"><?php echo $item->username; ?></a>
        </td >
        <td width="50">
            <?php  echo $item->created_date; ?>
        </td>
        <td width="30">
            <?php  echo intval($item->experience); ?>
        </td>
        <td width="120">
            <?php echo $item->category; ?>
        </td>
        <td  width="30">
            <?php  echo $item->cnt_question; ?>
        </td>
        <td  width="30">
            <?php  echo intval($item->cnt_answered); ?>
        </td>
        <td width="20">
            <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-experts', 'action' => 'view','expert_id'=>$item->expert_id), $this->translate('View'), array(
                //'class' => 'smoothbox',
                )) ?> 
            <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-experts', 'action' => 'edit','expert_id'=>$item->expert_id), $this->translate('Edit'), array(
                //'class' => 'smoothbox',
                )) ?>  
            <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-experts', 'action' => 'delete','expert_id'=>$item->expert_id), $this->translate('Delete'), array(
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
  <input type="hidden" id="delete_ids" name="delete_ids" value=""/>
</form>

<br/>
<div>
  <?php echo $pagination_control; ?>
</div>

<?php endif; ?>
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
