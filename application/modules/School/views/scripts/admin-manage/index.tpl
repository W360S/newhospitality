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
        var url = "<?php echo $this->baseUrl().'/admin/hotel/manage/index/'; ?>";
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
  <?php echo $this->translate("School Plugin") ?>
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
<div class="button">
    <?php echo $this->htmlLink(
            array('route'=> 'admin_default', 'module'=> 'school', 'controller'=> 'profile', 'action'=>'create'), $this->translate('Add School'))?>
    
</div>
<?php if( count($this->paginator) ): ?>
  <table class='admin_table'>
    <thead>
      <tr>
        <th class='admin_table_short'><input type='checkbox' class='checkbox' /></th>
        
        <th><?php echo $this->translate("School name") ?></th>
        
        <th><?php echo $this->translate("Articles") ?></th>
        <th><?php echo $this->translate("Created by") ?></th>
        <th><?php echo $this->translate("Created Date") ?></th>
        <th><?php echo $this->translate("Options") ?></th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($this->paginator as $item): ?>
        <tr>
          <td><input type='checkbox' class='checkbox' value="<?php echo $item->school_id ?>"/></td>
          
          <td><?php echo $this->htmlLink(array('route' => 'view-school', 'id' => $item->school_id), wordwrap($item->name, "64", "<br />\n", true)) ?></td>
          <td><?php echo $item->num_artical;?></td>
          <td><?php echo $this->user($item->user_id);?></td>
          
          <td><?php echo date('d F Y', strtotime($item->created)) ?></td>
          <td>
           <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'school', 'controller' => 'admin-profile', 'action' => 'edit', 'school_id' => $item->school_id), $this->translate('edit')
            ) ?>
            |
            <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'school', 'controller' => 'admin-manage', 'action' => 'delete', 'id' => $item->school_id), $this->translate('delete'), array(
              'class' => 'smoothbox',
            )) ?>
            |
             <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'school', 'controller' => 'admin-profile', 'action' => 'create-article', 'school_id' => $item->school_id), $this->translate('create article')
            ) ?>
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
      <?php echo $this->translate("There are no schools posted by members yet.") ?>
    </span>
  </div>
<?php endif; ?>
