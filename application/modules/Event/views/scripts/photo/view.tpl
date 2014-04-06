<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: view.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>

<?php
  $this->headScript()
    ->appendFile($this->baseUrl() . '/externals/moolasso/Lasso.js')
    ->appendFile($this->baseUrl() . '/externals/moolasso/Lasso.Crop.js')
    ->appendFile($this->baseUrl().'/externals/autocompleter/Observer.js')
    ->appendFile($this->baseUrl().'/externals/autocompleter/Autocompleter.js')
    ->appendFile($this->baseUrl().'/externals/autocompleter/Autocompleter.Local.js')
    ->appendFile($this->baseUrl().'/externals/autocompleter/Autocompleter.Request.js')
    ->appendFile($this->baseUrl() . '/externals/tagger/tagger.js');
?>

<script type="text/javascript">
  var taggerInstance;
  en4.core.runonce.add(function() {
    taggerInstance = new Tagger('media_photo_next', {
      'title' : '<?php echo $this->translate('ADD TAG');?>',
      'description' : '<?php echo $this->translate('Type a tag or select a name from the list.');?>',
      'createRequestOptions' : {
        'url' : '<?php echo $this->url(array('module' => 'core', 'controller' => 'tag', 'action' => 'add'), 'default', true) ?>',
        'data' : {
          'subject' : '<?php echo $this->subject()->getGuid() ?>'
        }
      },
      'deleteRequestOptions' : {
        'url' : '<?php echo $this->url(array('module' => 'core', 'controller' => 'tag', 'action' => 'remove'), 'default', true) ?>',
        'data' : {
          'subject' : '<?php echo $this->subject()->getGuid() ?>'
        }
      },
      'cropOptions' : {
        'container' : $('media_photo_next')
      },
      'tagListElement' : 'media_tags',
      'existingTags' : <?php echo $this->action('retrieve', 'tag', 'core', array('sendNow' => false)) ?>,
      'suggestParam' : <?php echo $this->action('suggest', 'friends', 'user', array('sendNow' => false, 'includeSelf' => true)) ?>,
      'guid' : <?php echo ( $this->viewer()->getIdentity() ? "'".$this->viewer()->getGuid()."'" : 'false' ) ?>,
      'enableCreate' : <?php echo ( $this->canEdit ? 'true' : 'false') ?>,
      'enableDelete' : <?php echo ( $this->canEdit ? 'true' : 'false') ?>
    });

    // Remove the href attrib while tagging
    var nextHref = $('media_photo_next').get('href');
    taggerInstance.addEvents({
      'onBegin' : function() {
        $('media_photo_next').erase('href');
      },
      'onEnd' : function() {
        $('media_photo_next').set('href', nextHref);
      }
    });
    
  });
</script>
<style type="text/css">
.layout_middle{
	padding:10px 0px;
}
.headline{margin-top:-10px;}
</style>
<style type="text/css">
    #tagger_form { width: 180px !important;}
    div.media_photo_tagform_container input[type="text"] { width: 160px !important; }
    .tagger_list { border: #bbb solid 1px; height: 130px; overflow: auto; padding: 4px; text-align: left; margin: 4px 0; }
    .tagger_list li.autocompleter-choices { height: 30px; overflow: hidden; margin: 0; list-style: none; }
    .tagger_list li.autocompleter-choices img { margin-right: 5px !important; }
    
    .headline{max-width:724px;}
    #global_content .layout_middle{overflow:visible;}
    div.event_photo_view .event_photo_nav{clear:none;}
    </style>
<?php 
	$event= $this->event;
	$photo= $this->photo;
	$album= $this->album;
    $canEdit= $this->canEdit;
?>
<div class="content">
<?php echo $this->content()->renderWidget('event.profile-featured');?>
<div class='layout_middle'>
<div class="headline">
<h2>
  <?php echo $event->__toString()." ".$this->translate("&#187; Photos") ?>
</h2>
</div>
<div class='event_photo_view'>
  <div class="event_photo_nav">
    <div>
      <?php echo $this->translate('Photo');?> <?php echo $photo->getCollectionIndex() + 1 ?>
      <?php echo $this->translate('of');?> <?php echo $album->count() ?>
    </div>
    <div>
      <?php if ($album->count() > 1): ?>
        <?php echo $this->htmlLink($photo->getPrevCollectible()->getHref(), $this->translate('Prev')) ?>
        <?php echo $this->htmlLink($photo->getNextCollectible()->getHref(), $this->translate('Next')) ?>
      <?php else: ?>
        &nbsp;
      <?php endif; ?>
    </div>
  </div>
  <div class='event_photo_info'>
    <div class='event_photo_container' id='media_photo_div'>
      <a id='media_photo_next'  href='<?php echo $photo->getNextCollectible()->getHref() ?>'>
        <?php echo $this->htmlImage($photo->getPhotoUrl(), $photo->getTitle(), array(
          'id' => 'media_photo'
        )); ?>
      </a>
    </div>
    <br />
    <a></a>
    <?php if( $photo->getTitle() ): ?>
      <div class="event_photo_title">
        <?php echo $photo->getTitle(); ?>
      </div>
    <?php endif; ?>
    <?php if( $photo->getDescription() ): ?>
      <div class="event_photo_description">
        <?php echo $photo->getDescription() ?>
      </div>
    <?php endif; ?>
    <div class="event_photo_owner">
      <?php echo $this->translate('By')?> <?php echo $this->htmlLink($photo->getOwner()->getHref(), $photo->getOwner()->getTitle()) ?>
    </div>
    <div class="event_photo_tags" id="media_tags" class="tag_list" style="display: none;">
      <?php echo $this->translate('Tagged:')?>
    </div>
    <div class="event_photo_date">
      <?php echo $this->translate('Added');?> <?php echo $this->timestamp($photo->creation_date) ?>
      <?php if( $canEdit ): ?>
        - <a href='javascript:void(0);' onclick='taggerInstance.begin();'><?php echo $this->translate('Add Tag');?></a>
        - <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'photo', 'action' => 'edit', 'photo_id' => $photo->getIdentity(), 'format' => 'smoothbox'), $this->translate('Edit'), array('class' => 'smoothbox')) ?>
        - <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'photo', 'action' => 'delete', 'photo_id' => $photo->getIdentity(), 'format' => 'smoothbox'), $this->translate('Delete'), array('class' => 'smoothbox')) ?>
      <?php endif; ?>

      - <?php echo $this->htmlLink(Array('module'=>'activity', 'controller'=>'index', 'action'=>'share', 'route'=>'default', 'type'=>$photo->getType(), 'id'=>$photo->getIdentity(), 'format' => 'smoothbox'), $this->translate("Share"), array('class' => 'smoothbox')); ?>
      - <?php echo $this->htmlLink(Array('module'=>'core', 'controller'=>'report', 'action'=>'create', 'route'=>'default', 'subject'=>$photo->getGuid(), 'format' => 'smoothbox'), $this->translate("Report"), array('class' => 'smoothbox')); ?>
      - <?php echo $this->htmlLink(array('route' => 'user_extended', 'module' => 'user', 'controller' => 'edit', 'action' => 'external-photo', 'photo' => $photo->getGuid(), 'format' => 'smoothbox'), $this->translate('Make Profile Photo'), array('class' => 'smoothbox')) ?>
    </div>
  </div>

  <?php echo $this->action("list", "comment", "core", array("type"=>"event_photo", "id"=>$photo->getIdentity())); ?>
</div>
</div>
</div>