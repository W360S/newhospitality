<style>
table.admin_table thead tr th, table.admin_table tbody tr td{
    white-space: normal !important;
}
</style>
<script type="text/javascript">
  en4.core.runonce.add(function(){$$('th.admin_table_short input[type=checkbox]').addEvent('click', function(){ $$('input[type=checkbox]').set('checked', $(this).get('checked', false)); })});
  
  var delectSelected =function(){
    
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

<div class="search_my_question">
	<?php
        $paginator = $this->paginator; 
        $pagination_control = $this->paginationControl($this->paginator);
        $categories = $this->categories;
        
        echo $this->content()->renderWidget('experts.admin-search-question'); 
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
            echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-questions', 'action' => 'index','cat_id'=>$item->category_id), $item->category_name."({$item->cnt_question})", array(
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
      <th width="100"><?php echo $this->translate("Question") ?></th>
      <th width="50"><?php echo $this->translate("Posted by") ?></th>
      <th width="100"><?php echo $this->translate("Status") ?></th>
      <th width="50"><?php echo $this->translate("Categories") ?></th>
      <th width="50"><?php echo $this->translate("Experts selected") ?></th>
      <th width="50"><?php echo $this->translate("Stats counter") ?></th>
      <th width="100"><?php echo $this->translate("Action") ?></th>
    </tr>
  </thead>
  <tbody>
    <?php foreach ($paginator as $item):  ?>
      <tr>
        <td>
            <input name="questions_checbox" type='checkbox' class='checkbox' value="<?php echo $item->question_id; ?>"/>
        </td>
        <td width="120">
            <?php echo $item->title; ?>
        </td>
        <td  width="120">
            <a href="<?php echo $this->baseUrl("/").'profile/'.$item->username; ?>"><?php echo $item->username; ?></a>
            <div>
                At: <?php  echo $item->created_date; ?>
            </div>
        </td >
        <td  width="30">
            <?php 
                switch($item->question_status)
                {
                   case 1:
                        $status = $this->translate('Pending');
                        break;
                   case 2:
                        $status = $this->translate('Answered');
                        break;                 
                   case 3:
                        $status = $this->translate('Closed');
                        break;
                   case 4:
                        $status = $this->translate('Cancelled');
                        break;                        
                }
            ?>
            <?php  echo $status . $this->translate(' by: ');  ?><a href="<?php echo $this->baseUrl("/").'profile/'.$item->lasted_by; ?>"><?php echo $item->lasted_by; ?></a>
        </td >
        <td width="120">
            <?php echo $item->category; ?>
        </td>
        <td width="30">
            <?php echo $item->experts; ?>
        </td>
        <td  width="30">
            <div>
                <?php  echo $this->translate(array('%s view', '%s views', intval($item->question_view_count)), intval($item->question_view_count)); ?>
            </div>
            <div>
                <div>
                    <?php if($item->rating>0):?>
                        <?php for($x=1; $x<=$item->rating; $x++): ?><span class="rating_star"></span><?php endfor; ?><?php if((round($item->rating)-$item->rating)>0):?><span class="rating_star_half"></span><?php endif; ?>
                    <?php endif; ?>
                </div>
                <div>
                    <?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->cnt_rating)), intval($item->cnt_rating)); ?>
                </div>
            </div>
        </td>
        
        <td width="20">
            <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-questions', 'action' => 'view','question_id'=>$item->question_id), $this->translate('View'), array(
                //'class' => 'smoothbox',
                )) ?> 
              
            <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'experts', 'controller' => 'manage-questions', 'action' => 'delete','question_id'=>$item->question_id), $this->translate('Delete'), array(
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
