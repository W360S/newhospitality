
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
  
  window.addEvent('domready',function(){
    jQuery('#list_by_category').change(function() {
       var url = "<?php echo $this->url(); ?>";
       url = "<?php echo $this->baseUrl("/")."admin/statistics/content/index/cat/"; ?>"+jQuery(this).val();
       
       var opt= jQuery('#list_by_category option:selected').text();
       window.location.href = url;
    });
    
 });
</script>


    <h2><?php echo $this->translate("Statistics Plugin") ?></h2>
    
    <?php if( count($this->navigation) ): ?>
    <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
    </div>
    <?php endif; ?>
    
    <div class="button">
        <?php echo $this->htmlLink(
                array('route'=> 'admin_default', 'module'=> 'statistics', 'controller'=> 'profile', 'action'=>'create'), $this->translate('Add New'))?>
        
    </div>
    
    <?php if( count($this->paginator) ): ?>
    
    <table class='admin_table'>
      <thead>
        <tr>
          <th class='admin_table_short'><input type='checkbox' class='checkbox' /></th>
          <th ><?php echo $this->translate("Title") ?></th>
          <th><?php echo $this->translate("Category") ?></th>
          <th><?php echo $this->translate("Priority") ?></th>
          <th><?php echo $this->translate("Options") ?></th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($this->paginator as $item): ?>
          <tr>
            <td>
                <input type='checkbox' class='checkbox' value="<?php echo $item->content_id; ?>"/>
            </td>
            <td>
            <?php
               $title = Engine_Api::_()->getApi('setting', 'statistics')->truncate($item->title, 80, "...", false); 
                echo $title;
            ?></td>
            <td style="white-space: normal"><?php $category= Engine_Api::_()->getApi('setting', 'statistics')->getCategory($item->category_id); echo $category->name; ?></td>
             <td><?php echo $item->priority ?></td>
            <td nowrap="nowrap">
              <?php echo $this->htmlLink(
                array('route'=> 'admin_default', 'module'=> 'statistics', 'controller'=> 'profile', 'action'=>'index', 'id'=>$item->content_id),
                $this->translate('view')
                )?>
                |
              <?php echo $this->htmlLink(
              	array('route'=> 'admin_default', 'module'=> 'statistics', 'controller'=> 'profile', 'action'=>'edit', 'content_id'=>$item->content_id),
                $this->translate('edit')
              	) ?>
              	|
              <?php echo $this->htmlLink(
                array('route' => 'default', 'module' => 'statistics', 'controller' => 'admin-content', 'action' => 'delete', 'id' => $item->content_id),
                $this->translate('delete'),
                array('class' => 'smoothbox',
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
    
    <div>
        
        <?php echo $this->paginationControl($this->paginator); ?>
    </div>
    
    <?php else:?>
    <div class="tip">
        <span>
          <?php echo $this->translate("There are no news posted by your members yet.") ?>
        </span>
    </div>
    <?php endif; ?>
