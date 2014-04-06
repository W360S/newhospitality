<dt><a class="active" href="#">hot rooms</a></dt>
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