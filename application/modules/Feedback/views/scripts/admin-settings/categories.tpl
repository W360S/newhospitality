<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: categories.tpl 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<h2><?php echo $this->translate('Feedback Plugin');?></h2>
<?php if( count($this->navigation) ): ?>
<div class='tabs'> <?php echo $this->navigation()->menu()->setContainer($this->navigation)->render() ?> </div>
<?php endif; ?>
<div class='clear'>
  <div class='settings'>
    <form class="global_form">
      <div>
        <h3><?php echo $this->translate('Feedback Categories');?></h3>
        <p class="description"> <?php echo $this->translate('If you want to allow your users to categorize their feedback, create the categories below. If you have no categories, your users will not be given the option of assigning a feedback category.');?></p>
        <table class='admin_table' width="70%">
          <thead>
            <tr>
              <th width="100"><?php echo $this->translate('Category Name');?></th>
              <th class="admin_table_centered"><?php echo $this->translate('Number of Times Used');?></th>
              <th width="50"><?php echo $this->translate('Options');?></th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($this->categories as $category): ?>
            <tr>
              <td><?php echo $category->category_name?></td>
              <td class="admin_table_centered"><?php echo $category->getUsedCount()?></td>
              <td><?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'feedback', 'controller' => 'settings', 'action' => 'edit-category', 'id' =>$category->category_id), $this->translate('edit'), array(
	                					'class' => 'smoothbox',
	              					)) ?> | <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'feedback', 'controller' => 'settings', 'action' => 'delete-category', 'id' =>$category->category_id), $this->translate('delete'), array(
	                				'class' => 'smoothbox',
	              					)) ?> </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
        <br/>
        <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'feedback', 'controller' => 'settings', 'action' => 'add-category'), $this->translate('Add New Category'), array(
      			'class' => 'smoothbox buttonlink',
      			'style' => 'background-image: url(application/modules/Core/externals/images/admin/new_category.png);')) ?> </div>
    </form>
  </div>
</div>
