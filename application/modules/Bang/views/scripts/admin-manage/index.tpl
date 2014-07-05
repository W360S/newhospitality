<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: index.tpl 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<style type="text/css">
    table.admin_table thead tr th{
        padding:10px 1px;
    }
    table.admin_table tbody tr td {
        padding:7px 1px;
    }
</style>
<h2><?php echo $this->translate('Manage Feedback');?></h2>

<?php if( count($this->navigation) ): ?>
<div class='tabs'>
    	<?php echo $this->navigation()->menu()->setContainer($this->navigation)->render() ?>
</div>
<?php endif; ?>

<p>
	<?php echo $this->translate('This page lists all the request posted by the users. Here, you can monitor request, delete them, make request featured / un-featured and set status for request.');?> 
</p>
<br />

<script type="text/javascript">
    var currentOrder = '<?php echo $this->order ?>';
    var currentOrderDirection = '<?php echo $this->order_direction ?>';
    var changeOrder = function(order, default_direction) {
        // Just change direction
        if (order == currentOrder) {
            $('order_direction').value = (currentOrderDirection == 'ASC' ? 'DESC' : 'ASC');
        }
        else {
            $('order').value = order;
            $('order_direction').value = default_direction;
        }
        $('filter_form').submit();
    }

    function multiDelete()
    {
        return confirm('<?php echo $this->string()->escapeJavascript($this->translate("Are you sure you want to delete selected request?")) ?>');
    }

    function selectAll()
    {
        var i;
        var multidelete_form = $('multidelete_form');
        var inputs = multidelete_form.elements;
        for (i = 1; i < inputs.length - 1; i++) {
            if (!inputs[i].disabled) {
                inputs[i].checked = inputs[0].checked;
            }
        }
    }
</script>

<div class='admin_search'>
	<?php //echo $this->formFilter->render($this) ?>
</div>
<br />

<div class='admin_members_results'>
    <div>
    	<?php echo $this->paginator->getTotalItemCount() ?> <?php echo $this->translate(' request found');?>
    </div>
  	<?php echo $this->paginationControl($this->paginator); ?>
</div>
<br />

<form id='multidelete_form' method="post" action="<?php echo $this->url(array('action'=>'multi-delete'));?>" onSubmit="return multiDelete()">
    <table class='admin_table'>
        <thead>
            <tr>
                <th style='width: 1%;'><input onclick="selectAll()" type='checkbox' class='checkbox'></th>
                <th style='width: 1%;'><a href="javascript:void(0);" onclick="javascript:changeOrder('request_id', 'ASC');"><?php echo $this->translate('ID');?></a></th>
                <th style='width: 1%;'><a href="javascript:void(0);" onclick="javascript:changeOrder('ad_title', 'ASC');"><?php echo $this->translate('Title');?></a></th>
                <th style='width: 1%;'><a href="javascript:void(0);" onclick="javascript:changeOrder('ad_email', 'ASC');"><?php echo $this->translate('Username');?></a></th>
                <th style='width: 1%;'><a href="javascript:void(0);" onclick="javascript:changeOrder('ad_phone', 'ASC');"><?php echo $this->translate('Phone');?></a></th>
                <th style='width: 1%;'><a href="javascript:void(0);" onclick="javascript:changeOrder('owner_id', 'ASC');"><?php echo $this->translate('Email');?></a></th>
                <th style='width: 1%;' class='admin_table_options admin_table_centered'><?php echo $this->translate('Options');?></th>
            </tr>
        </thead>
        <tbody>
	    <?php if( count($this->paginator) ): ?>
	    	<?php foreach( $this->paginator as $item ): ?>
        	<?php if(empty($item->owner_id)): ?>
            <tr style="background:#e1f1fa;">
	    		<?php else: ?>
            <tr>
	    		<?php endif; ?>
                <td><input name='delete_<?php echo $item->request_id;?>' type='checkbox' class='checkbox' value="<?php echo $item->request_id ?>"/></td>
                <td><?php echo $item->request_id; ?></td>
                <td class='admin_table_bold'><?php echo $this->htmlLink($item->getHref(), $item->truncate5Title(), array('target' => '_blank', 'title' => $item->getTitle())) ?></td> 
                <td>
            	<?php if(!empty($item->owner_id)): ?>
            		<?php echo $this->htmlLink($this->item('user', $item->owner_id)->getHref()	, $item->truncateOwner($this->user($item->owner_id)->username), array('target' => '_blank')) ?>
            	<?php else: ?>			
                    <font color = red ><?php echo $this->translate('Anonymous');?></font>	
              <?php endif; ?>
                </td>
                <td class=""><?php echo $item->ad_phone ?></td>
                <td class=""><?php echo $item->ad_email ?></td>
                <td class='admin_table_options'></td>
            </tr>
	      <?php endforeach; ?>
	    <?php endif; ?>
        </tbody>
    </table>
    <br />
    <div class='buttons'>
        <button type='submit'><?php echo $this->translate('Delete Selected');?></button>
    </div>
</form>


