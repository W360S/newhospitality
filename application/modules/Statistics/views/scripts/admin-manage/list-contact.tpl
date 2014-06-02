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
  
  var emailSelected =function(){
    
    var checkboxes = $$('input[type=checkbox]');
    var selecteditems = [];

    checkboxes.each(function(item, index){
      var checked = item.get('checked', false);
      var value = item.get('value', false);
      if (checked == true && value != 'on'){
        selecteditems.push(value);
      }
    });
    
    $('contact_ids').value = selecteditems;
    $('email_selected').submit();
  }
</script>

<h2>
  <?php echo $this->translate("Manage Contacts") ?>
</h2>

<?php if( count($this->paginator) ): ?>
<table class='admin_table'>
  <thead>
    <tr>
      <th class='admin_table_short'><input onclick='selectAll();' type='checkbox' class='checkbox' /></th>  
      <th><?php echo $this->translate("name") ?></th>
      <th><?php echo $this->translate("email") ?></th>
      
      <th><?php echo $this->translate("options") ?></th>
    </tr>
  </thead>
  <tbody>
    <?php foreach ($this->paginator as $item): ?>
      <tr>
        <td><input type='checkbox' class='checkbox' value="<?php echo $item['contact_id'] ?>"/></td>
        <td><?php echo $item['name']; ?></td>
        <td><?php echo $item['email']; ?></td>
        
        <td>
          <?php echo $this->htmlLink(array('route' => 'contact_view', 'module' => 'statistics', 'controller' => 'manage', 'action' => 'view-contact', 'contact_id' =>$item['contact_id']), $this->translate('view'), array(
            'class' => 'smoothbox',
          )) ?>
          |
          
          <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'statistics', 'controller' => 'manage', 'action' => 'delete-contact', 'id' =>$item['contact_id']), $this->translate('delete'), array(
            'class' => 'smoothbox',
          )) ?>
         </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>
<br />

<div class='buttons'>
  <button onclick="javascript:emailSelected();" type='submit'>
    <?php echo $this->translate("Send Email Selected") ?>
  </button>  
  <button onclick="javascript:delectSelected();" type='submit'>
    <?php echo $this->translate("Delete Selected") ?>
  </button>
</div>

<form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'delete-selected-contact')) ?>'>
  <input type="hidden" id="ids" name="ids" value=""/>
</form>

<form id='email_selected' method='post' action='<?php echo $this->url(array('action' =>'send-email-selected-contact')) ?>'>
  <input type="hidden" id="contact_ids" name="contact_ids" value=""/>
</form>
<br/>

<div>
  <?php echo $this->paginationControl($this->paginator); ?>
</div>


<?php else: ?>
  <div class="tip">
    <span>
      <?php echo $this->translate("There are no contact.") ?>
    </span>
  </div>
<?php endif; ?>
