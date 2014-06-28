<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: statistic.tpl 2010-07-08 9:40:21Z SocialEngineAddOns $
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
        <h3>Feedback Statistics</h3>
        <p class="description"> <?php echo $this->translate('Below are some valuable statistics for the Feedback submitted on this site:');?> </p>
        <table class='admin_table' width="100%">
          <tbody>
            <tr>
            	<td width="45%" style="font-weight:bold;"><?php echo $this->translate('Total feedback');?> :</td>
            	<td style="font-weight:bold;"><?php echo $this->total_feedback ?></td>
            </tr>
            <tr>
            	<td width="45%" style="font-weight:bold;"><?php echo $this->translate('Total Public Feedback');?> :</td>
            	<td style="font-weight:bold;"><?php echo $this->total_private ?></td>
            </tr>
            <tr>
            	<td width="45%" style="font-weight:bold;"><?php echo $this->translate('Total Private Feedback');?> :</td>
            	<td style="font-weight:bold;"><?php echo $this->total_public ?></td>
            </tr>
            <tr>
            	<td width="45%" style="font-weight:bold;"><?php echo $this->translate('Total Anonymous Feedback');?> :</td>
            	<td style="font-weight:bold;"><?php echo $this->total_anonymous ?></td>
            </tr>
            <tr>
            	<td width="45%" style="font-weight:bold;"><?php echo $this->translate('Total Comments');?> :</td>
            	<td style="font-weight:bold;">
	            	<?php if(!empty($this->total_comments)): ?>
	            		<?php echo $this->total_comments ?>
	            	<?php else:?>	
	            		0
	            	<?php endif;?>
            	</td>
            </tr>
            <tr>
            	<td width="45%" style="font-weight:bold;"><?php echo $this->translate('Total Votes');?> :</td>
            	<td style="font-weight:bold;">
            		<?php if(!empty($this->total_votes)): ?>
            			<?php echo $this->total_votes ?>
            		<?php else:?>	
	            		0
	            	<?php endif;?>	
            	</td>
            </tr>	
          </tbody>
        </table>
    </form>
  </div>
</div>
