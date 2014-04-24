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
</script>

<h2>
  <?php echo $this->translate("Resume Plugin") ?>
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

<p><?php echo $this->translate('Please select valid resumes and approve them.')?></p>
<br />

<?php if( count($this->paginator) ): ?>
  <table class='admin_table'>
    <thead>
      <tr>
        <th class='admin_table_short'><input type='checkbox' class='checkbox' /></th>
        <!--<th class='admin_table_short'>ID</th>-->
        <th><?php echo $this->translate("Title") ?></th>
        
        
        <th><?php echo $this->translate("Created by") ?></th>
        
        
        <th><?php echo $this->translate("Created Date") ?></th>
        <th><?php echo $this->translate("Modified Date") ?></th>
        <th><?php echo $this->translate("Options") ?></th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($this->paginator as $item): ?>
        <tr>
          <td><input type='checkbox' class='checkbox' value="<?php echo $item->resume_id ?>"/></td>
          
         
         <td><?php echo $this->htmlLink(array('route'=>'default', 'module'=>'resumes', 'controller'=> 'resume', 'action'=>'view', 'resume_id' => $item->resume_id), wordwrap($item->title, "64", "<br />\n", true)) ?></td>
          <td><?php echo $this->user($item->user_id);?></td>
          
          <td><?php echo date('d F Y', strtotime($item->creation_date)) ?></td>
          <td><?php echo date('d F Y', strtotime($item->modified_date)) ?></td>
          
          <td>
           
            <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'resumes', 'controller' => 'admin-manage', 'action' => 'delete', 'id' => $item->resume_id), $this->translate('delete'), array(
              'class' => 'smoothbox',
            )) ?>
            
            <?php if($item->approved !=1){?>
            |
            <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'resumes', 'controller' => 'admin-manage', 'action' => 'approve', 'id' => $item->resume_id), $this->translate('approve'), array(
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
      <?php echo $this->translate("There are no resumes posted by members yet.") ?>
    </span>
  </div>
<?php endif; ?>
