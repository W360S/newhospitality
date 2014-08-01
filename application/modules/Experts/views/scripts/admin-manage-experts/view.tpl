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
<a href="<?php echo $this->baseUrl().'/admin/experts/manage-experts'; ?>"><?php echo $this->translate('Manage Experts');?></a>
<h2>
  <?php echo $this->translate("Expert Detail"); ?>
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
        $data = $this->data;
        echo $this->content()->renderWidget('experts.admin-search-question-profile'); 
    ?>
</div>	

<?php if(count($data)): ?>
<div class='clear'>
  <div class='settings'>
    <form class="global_form">
    <div class="subsection">
       <table class="admin_profile_table"  width="100%" border="1px">
        <tr>
            <td>
                <?php echo $this->translate('username'); ?>: <a href="<?php echo $this->baseUrl("/").'profile/'.$data->username; ?>"><?php echo $data->username; ?></a>
            </td>
            <td>
                <?php echo $this->translate('Join date'); ?>: <?php echo $data->created_date; ?>
            </td>
        </tr>
        <tr>
            <td>
                <?php echo $this->translate('Occupation'); ?>: <?php echo $data->occupation; ?>
            </td>
            <td>
                <?php echo $this->translate('Experience'); ?>: <?php echo $data->experience; ?>
            </td>
            <td>
                <?php echo $this->translate('Company'); ?>: <?php echo $data->company; ?>
            </td>
        </tr>
        <tr>
            <td>
                <?php echo $this->translate('Profile Acttachment'); ?>: <a href="<?php echo $this->baseUrl('/').$data->storage_path; ?>"><?php echo $data->storage_name; ?></a>
            </td>
            <td>
                <?php echo $this->translate('Questions'); ?>: <?php echo $data->cnt_question; ?>
            </td>
            <td>
               <?php echo $this->translate('Answered'); ?>: <?php echo $data->cnt_answered; ?>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <b><?php echo $this->translate('Description'); ?>:</b> <?php echo $data->description; ?>
            </td>
        </tr>
    </table>
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
            <?php  echo $status . ' by: ';  ?><a href="<?php echo $this->baseUrl("/").'profile/'.$item->lasted_by; ?>"><?php echo $item->lasted_by; ?></a>
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
