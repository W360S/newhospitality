<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: viewfriendsuggestion.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<div class="subsection content_invite">
    <h2><?php echo $this->translate('Friend requests'); ?></h2>
    <div class="suggestion-friends" style="border-bottom:none;">
    <div style="padding:10px;">	
    	<ul class='requests'>
          <?php if( $this->requests->getTotalItemCount() > 0 ): ?>
            <?php foreach( $this->requests as $notification ): ?>
              <?php
                $parts = explode('.', $notification->getTypeInfo()->handler);
                echo $this->action($parts[2], $parts[1], $parts[0], array('notification' => $notification));
              ?>
            <?php endforeach; ?>
          <?php else: ?>
            <li>
              <?php echo $this->translate("You have no requests.") ?>
            </li>
          <?php endif; ?>
        </ul>
     </div>
    </div>	  
</div>    