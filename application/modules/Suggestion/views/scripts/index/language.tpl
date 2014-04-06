<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Chat
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: language.tpl 6509 2010-06-22 23:49:13Z shaun $
 * @author     Steve
 */
?>

if (!$type(translate_suggestion))
    var translate_suggestion = {};
    translate_suggestion['Please select at-least one entry above to send suggestion to.'] = '<?php echo $this->string()->escapeJavascript($this->translate('Please select at-least one entry above to send suggestion to.'));?>';
		
		translate_suggestion['Search Members'] = '<?php echo $this->string()->escapeJavascript($this->translate('Search Members'));?>';

   translate_suggestion['Selected'] = '<?php echo $this->string()->escapeJavascript($this->translate('Selected'));?>';

   translate_suggestion['Importing Contacts'] = '<?php echo $this->string()->escapeJavascript($this->translate('Importing Contacts'));?>';

   translate_suggestion['Sending Request'] = '<?php echo $this->string()->escapeJavascript($this->translate('Sending Request'));?>';

   translate_suggestion['Uploading file'] = '<?php echo $this->string()->escapeJavascript($this->translate('Uploading file'));?>';
   
