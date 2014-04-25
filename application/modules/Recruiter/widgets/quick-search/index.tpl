<div class="subsection">
 <h2>
      <?php echo $this->translate('Quick Job Search') ?>
 </h2>
 <div class="subcontent">
	<div class="content_online_resume">
    <form method="post" action="<?php echo $this->baseUrl().'/recruiter/search/search-quick'?>" id="quick_search">
		<input id="quicksearch" name="quicksearch" type="text" value="<?php echo $this->translate('Enter keyword');?>" onfocus='if(this.value=="<?php echo $this->translate('Enter keyword');?>") this.value="";' onblur='if(this.value=="") this.value="<?php echo $this->translate('Enter keyword');?>"' class="input_text" />
		<a class="bt_create bt_quick_search" href="javascript:void(0);" onclick="quicksearch();"><?php echo $this->translate("Search Now");?></a>
    </form>
		<!--<p><a href="<?php echo $this->baseUrl().'/recruiter/search/search-advanced' ?>"><?php echo $this->translate('Advanced Search');?></a></p>-->
	</div>	
</div>
 
</div>
<script type="text/javascript">
function quicksearch(){
    jQuery('#quick_search').submit();
}
</script>