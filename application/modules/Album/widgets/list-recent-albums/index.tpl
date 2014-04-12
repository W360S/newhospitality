<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Album
 
 * @author     huynhnv
 */
?>
<style type="text/css">
.layout_album_list_recent_albums {
	clear:both;
	margin-bottom:15px;
	overflow:auto;
	width:100%;
}
.layout_album_list_recent_albums > ul {
	background-image:none;
	border:medium none;
	-moz-border-radius:3px 3px 3px 3px;
	background-color:#E9F4FA;
	background-repeat:repeat-x;
	padding: 5px;
}
.layout_album_list_recent_albums > ul > li {
	border-bottom:1px solid #EAEAEA;
	clear:both;
	overflow:hidden;
	padding:3px 5px;
}

.layout_album_list_recent_albums a.recentalbums_thumb {
	display:block;
	float:left;
}
.layout_album_list_recent_albums .recentalbums_info {
	overflow:hidden;
	padding:0 0 0 6px;
}
.layout_album_list_recent_albums .recentalbums_title {
	font-weight:bold;
}
.layout_album_list_recent_albums .recentalbums_count {
	font-size:0.8em;
}
.layout_album_list_recent_albums .recentalbums_owner {
	
	margin-top:2px;
}
</style>
<style>
	.featured-groups li{height: auto;}
</style>
<div class="featured-groups">
<?php $n= count($this->paginator); if($n): ?>
    <ul>
    <?php $dem = 0;  foreach($this->paginator as $item): $dem++;  ?>
    <?php  if((($dem-1) %10 == 0) && (($dem - 1) > 1)): ?>
    </ul>
    <ul>
    <?php endif; ?>
	    <li>
	      <?php echo $this->htmlLink($item->getHref(), $this->itemPhoto($item, 'thumb.icon'), array('class'=>'recentalbums_thumb')) ?>
	          <div class="recentalbums_info">
	          <div class='recentalbums_title'> 
	          	<?php echo $this->htmlLink($item->getHref(), $item->getTitle()) ?> 
	          </div>
	           <div class='recentalbums_owner'>
	           	<?php
	            $owner = $item->getOwner();
	            echo $this->translate('Posted by %1$s', $this->htmlLink($owner->getHref(), $owner->getTitle()));
	          ?>
	           </div>
	           <div class='recentalbums_count'>
	          	<?php echo $this->translate(array('%s view', '%s views', $item->view_count), $this->locale()->toNumber($item->view_count)) ?>   
	          </div>
	          </div>
	    </li>
    <?php endforeach; ?>
	</ul>
<?php endif; ?>
</div>