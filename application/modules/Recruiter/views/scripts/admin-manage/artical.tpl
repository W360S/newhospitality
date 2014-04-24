
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
    var input_text= "<?php echo Zend_Controller_Front::getInstance()->getRequest()->keyword;?>";
   
    if(input_text.length >0){
        $('search_keyword').set('value', input_text);
    }
    
    jQuery('#search').click(function() {
        var url = "<?php echo $this->baseUrl().'/admin/recruiter/manage/artical/'; ?>";
        
        var key_word = jQuery("#search_keyword").val();
        if(key_word.trim() == "" || (key_word == "Enter text")){
            key_word = "";
        }
        url = url +  "keyword/" + key_word;
        window.location.href = url;
    });
    
 });
</script>
<h2><?php echo $this->translate("Job Plugin") ?></h2>

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
            array('route'=> 'admin_default', 'module'=> 'recruiter', 'controller'=> 'profile', 'action'=>'create'), $this->translate('Add new Article'))?>
        
</div>
<br />
<div class="subcontent">

<fieldset class="filter">
		<div class="input" style="padding-right: 10px;">
			<input id="search_keyword" type="text"onblur="if(this.value=='') this.value='Enter text'"
								onfocus="if(this.value=='Enter text') this.value='';" 
								value='Enter text' 
                                
                                />						
		</div>
		<button id="search" type="button"><?php echo $this->translate('Search'); ?></button>
        
	
	</fieldset>
    </div>
 <br />
<?php if( count($this->paginator) ): ?>
  <table class='admin_table'>
    <thead>
      <tr>
        <th class='admin_table_short'><input type='checkbox' class='checkbox' /></th>
        <!--<th class='admin_table_short'>ID</th>-->
        <th><?php echo $this->translate("Artical Title") ?></th>
        
        <th><?php echo $this->translate("Category") ?></th>
        <th><?php echo $this->translate("Created by") ?></th>
        
        
        <th><?php echo $this->translate("Created Date") ?></th>
        
        <th><?php echo $this->translate("Options") ?></th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($this->paginator as $item): ?>
        <tr>
          <td><input type='checkbox' class='checkbox' value="<?php echo $item->artical_id ?>"/></td>
         
          <td><?php echo $item->title;?></td>
          <td><?php echo $this->industry($item->category_id)->name;?></td>
          <td><?php echo $this->user($item->user_id);?></td>
          
          <td><?php echo date('d F Y', strtotime($item->created)) ?></td>
                    
          <td>
           
              <?php echo $this->htmlLink(
              	array('route'=> 'admin_default', 'module'=> 'recruiter', 'controller'=> 'profile', 'action'=>'edit', 'artical_id'=>$item->artical_id),
                $this->translate('edit')
              	) ?>
                |
            <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'recruiter', 'controller' => 'admin-manage', 'action' => 'delete-artical', 'id' => $item->artical_id), $this->translate('delete'), array(
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

  <form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'deletearticalselected')) ?>'>
    <input type="hidden" id="ids" name="ids" value=""/>
  </form>

  <br/>

  <div>
    <?php echo $this->paginationControl($this->paginator); ?>
  </div>

<?php else: ?>
  <div class="tip">
    <span>
      <?php echo $this->translate("There are no article posted yet.") ?>
    </span>
  </div>
<?php endif; ?>
