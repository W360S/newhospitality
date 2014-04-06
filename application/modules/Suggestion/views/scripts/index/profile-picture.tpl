<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: profile-picture.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>

<div class="global_form suggestion-profile-image">
	<div>
		<div>
			<?php
			  $this->headScript()
			    ->appendFile($this->baseUrl().'/externals/mootools/mootools-1.2.2-core-nc.js')
			    ->appendFile($this->baseUrl().'/externals/moolasso/Lasso.js')
			    ->appendFile($this->baseUrl().'/externals/moolasso/Lasso.Crop.js')
			?>
			<h4><?php echo $this->translate("Suggest profile picture for ") . $this->displayname; ?></h4>
			<?php
			  	// Big Image 
			    if (isset($this->image_name)){
			      echo '<img src="' . $this->baseUrl() . '/public/temporary/p_' . $this->image_name . '" alt="" id="lassoImg" />';
			    }
			    else
			      echo '<img src="application/modules/User/externals/images/nophoto_user_thumb_profile.png" alt="" id="lassoImg" />';
			 ?>

			<br/>
  		<div id="thumbnail-controller" class="thumbnail-controller"></div>
		  <script type="text/javascript">
		    var loader = new Element('img',{ src:'application/modules/Core/externals/images/loading.gif'});
		    var orginalThumbSrc;
		    var originalSize;
		    var lassoCrop;
		
		    var lassoSetCoords = function(coords)
		    {
		      var delta = (coords.w - 48) / coords.w;
		
		      $('coordinates').value =
		        coords.x + ':' + coords.y + ':' + coords.w + ':' + coords.h;
		
		      $('previewimage').setStyles({
		        top : -( coords.y - (coords.y * delta) ),
		        left : -( coords.x - (coords.x * delta) ),
		        height : ( originalSize.y - (originalSize.y * delta) ),
		        width : ( originalSize.x - (originalSize.x * delta) )
		      });
		    }
		    var myLasso;
		    var lassoStart = function()
		    {
		      if( !orginalThumbSrc ) orginalThumbSrc = $('previewimage').src;
		      originalSize = $("lassoImg").getSize();
		
		      //this.style.display = 'none';
		      myLasso = new Lasso.Crop('lassoImg',{
					ratio : [1, 1],
					preset : [10,10,58,58],
					min : [48,48],
					handleSize : 8,
					opacity : .6,
					color : '#7389AE',
					border : '<?php echo $this->baseUrl().'/externals/moolasso/crop.gif' ?>',
					onResize : lassoSetCoords
		      });
		
		
		      var sourceImg = $('lassoImg').src;
		      $('previewimage').src = $('lassoImg').src;
		      $('coordinates').value = 10 + ':' + 10 + ':' + 58+ ':' + 58;
		      $('thumbnail-controller').innerHTML = '<a href="javascript:void(0);" onclick="lassoEnd();"><?php echo $this->translate('Apply Changes');?></a>';
		    }
		
		    var uploadProfilePhoto =function(){
		      $('uploadPhoto').value = true;
		      $('thumbnail-controller').innerHTML = "<div><img class='loading_icon' src='application/modules/Core/externals/images/loading.gif'/><?php echo $this->translate('Loading...');?></div>";
		      $('profileform').submit();
		      $('Filedata-wrapper').innerHTML = "";
		      
		    }
		    var lassoEnd = function(){
		      $('lassoImg').setStyle('display', 'block');
		      $('thumbnail-controller').innerHTML = '<a href="javascript:void(0);" onclick="lassoStart();"><?php echo $this->translate('Edit Thumbnail');?></a>';
		      $('lassoMask').destroy();
		    }
		
		  </script>
		  <br>
			<?php echo $this->form->render($this) ?>
			<form method="post" style="margin-top:10px;">
				<input type="hidden" name="image" value="<?php echo $this->image_name; ?>" />
		  	<button type="submit" id="done" name="done"><?php echo $this->translate("Suggest Photo"); ?></button> <?php echo $this->translate("or"); ?> <a href="javascript:void(0);" onclick="parent.Smoothbox.close();"><?php echo $this->translate("Cancel") ?></a>
		 	</form>
 		</div>
 	</div>
</div>
<script type="text/javascript">
var catdiv = $('current-wrapper'); 
 var catarea = catdiv.parentNode;
 catarea.removeChild(catdiv);
</script>
