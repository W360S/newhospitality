<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Video
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7250 2010-09-01 07:42:35Z john $
 * @author     Jung
 */
?>

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
        var url = "<?php echo $this->baseUrl().'/admin/recruiter/manage/index/'; ?>";
        var order = jQuery("#search_option").val();
        var key_word = jQuery("#search_keyword").val();
        if(key_word.trim() == "" || (key_word == "Enter text")){
            key_word = "";
        }
        url = url +  "keyword/" + key_word +  "/status/" + order ;
        window.location.href = url;
    });
    
 });
</script>

<h2>
  <?php echo $this->translate("Job Plugin") ?>
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
<div class="subcontent">

<fieldset class="filter">
		<div class="input" style="padding-right: 10px;">
			<input id="search_keyword" type="text"onblur="if(this.value=='') this.value='Enter text'"
								onfocus="if(this.value=='Enter text') this.value='';" 
								value='Enter text' 
                                
                                />						
		</div>
        <?php echo $this->translate('Search by'); ?>
        <select id="search_option">
            <option <?php if($this->status == 0){echo 'selected' ;} ?>  value="noassign"><?php echo $this->translate("Jobs"); ?></option>
            <option <?php if($this->status == 1){echo 'selected' ;} ?> value="assign"><?php echo $this->translate('Assign'); ?></option>
            <option <?php if($this->status == 2){echo 'selected' ;} ?> value="resolved"><?php echo $this->translate('Resolved by'); ?></option>
        
        </select>
		<button id="search" type="button"><?php echo $this->translate('Search'); ?></button>
        
	
	</fieldset>
    </div>

<br />

<?php if( count($this->paginator) ): ?>
  <table class='admin_table'>
    <thead>
      <tr>
        <th class='admin_table_short'><input type='checkbox' class='checkbox' /></th>
        
        <th><?php echo $this->translate("Job Title") ?></th>
        
        <th><?php echo $this->translate("Company") ?></th>
        <th><?php echo $this->translate("Created by") ?></th>
        
        
        <!--<th><?php //echo $this->translate("Created Date") ?></th>-->
        <th><?php echo $this->translate("Modified Date") ?></th>
        <th><?php echo $this->translate("Resolved by");?></th>
        <th><?php echo $this->translate("Assign members");?></th>
        <th><?php echo $this->translate("Options") ?></th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($this->paginator as $item): ?>
        <tr>
          <td><input type='checkbox' class='checkbox' value="<?php echo $item->job_id ?>"/></td>
         
          <td><?php echo $this->htmlLink(array('route' => 'admin-view-job', 'id' => $item->job_id), wordwrap($item->position, "32", "<br />\n", true)) ?></td>
          <td><?php if($this->company($item->user_id)) echo wordwrap($this->company($item->user_id)->company_name, "32", "<br />");?></td>
          
          <td><?php echo $this->user($item->user_id);?></td>
          
          <!--<td><?php //echo date('d F Y', strtotime($item->creation_date)) ?></td>-->
          <td><?php echo date('d F Y', strtotime($item->modified_date)) ?></td>
          <td><?php if(!empty($item->resolved_by))echo $this->user($item->resolved_by);?></td>
          <td>
            <?php
           
           
            $users= $this->assignModule($item->job_id);
            if(!empty($users) && count($users)){?>
                <table class='admin_table'>
                
                <tbody>
                  <?php foreach ($users as $key=>$val): ?>
                    <tr>   
                      <td><?php echo $this->user($val); ?></td>
                    </tr>
                  <?php endforeach; ?>
                  
                </tbody>
              </table>
              <?php 
            } else{
                echo $this->translate(' No users');
            }
            ?>
          </td>
          <td>
           
            <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'recruiter', 'controller' => 'admin-manage', 'action' => 'delete', 'id' => $item->job_id), $this->translate('delete'), array(
              'class' => 'smoothbox',
            )) ?>
            
            <?php if($item->status !=2){?>
            |
            <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'recruiter', 'controller' => 'admin-manage', 'action' => 'approve', 'id' => $item->job_id), $this->translate('approve'), array(
              'class' => 'smoothbox',
            )) ?>
            <?php } ?>
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

  <form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'deleteselected')) ?>'>
    <input type="hidden" id="ids" name="ids" value=""/>
  </form>

  <br/>

  <div>
    <?php echo $this->paginationControl($this->paginator); ?>
  </div>

<?php else: ?>
  <div class="tip">
    <span>
      <?php echo $this->translate("There are no jobs posted by members yet.") ?>
    </span>
  </div>
<?php endif; ?>
