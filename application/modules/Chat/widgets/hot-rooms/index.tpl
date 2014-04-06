<div id="load_ajax_hot_room">
<dt><a class="active" href="<?php echo $this->url(array('module'=>'chat','controller'=>'index','action'=>'index'),'default',true); ?>"><?php echo $this->translate('hot rooms'); ?></a></dt>
<?php
    $rooms= $this->rooms;
    $user_id= $this->user_id;
?>
<dd>
	<ul>
	<?php foreach($rooms as $room){ ?>   
		<li>
		
			<a href="<?php echo $this->baseUrl()?>/chat/room/<?php echo $room->room_id;?>"><?php echo $room->title;?></a>
			<p><?php echo $this->translate('Created: ');?><?php echo $room->modified_date; ?></p>
            <p><?php echo $this->translate('Mems: ');?><?php echo $room->user_count; ?></p>
		</li>
	<?php }?>
	</ul>
</dd>
</div>
<script type="text/javascript">
$('global_page_user-profile-index').setProperty('onUnload', "timeout();")
function load_hot_room(){
    var url= "<?php echo $this->baseUrl().'/chat/index/room'?>";
    jQuery('#load_ajax_hot_room').load(url).fadeIn("slow");
} 
function timeout(){
    clearInterval(auto_refresh);
}
var auto_refresh = setInterval(
function (){
    load_hot_room();
}, 300000); // refresh every 10000 milliseconds

</script>