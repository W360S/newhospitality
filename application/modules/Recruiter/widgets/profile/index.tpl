<div class="subsection">
    <div class="member">
        <div class="avatar"><?php echo $this->itemPhoto($this->candidate,"thumb.profile",null);?></div>
        <h3><?php echo $this->candidate->username; ?></h3>
        <p><?php echo $this->translate("Birthday: ")?><?php echo date('d-F-Y', strtotime($this->birthday));?></p>
        <p><?php echo $this->translate("Gender: ")?> <?php echo $this->gender;?></p>
    </div>
</div> 
<div class="function_extra">
	<a href="<?php echo $this->baseUrl().'/messages/compose/to/'.$this->candidate->user_id?>"><?php echo $this->translate('Send a message')?></a>
	<a class="network_profile" href="<?php echo $this->baseUrl().'/profile/'.$this->candidate->username ?>"><?php echo $this->translate('Go to network profile')?></a>
    <a class="save_candidate" href="javascript:void(0);" onclick="save_candidate();"><?php echo $this->translate('Save this candidate')?></a>
</div>
