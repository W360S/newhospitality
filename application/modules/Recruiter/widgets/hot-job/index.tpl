<div class="block_content">
<!--<div class="jobs_promotion"><a href="http://www.vinpearlluxury-nhatrang.com/" target='_blank'><img src="application/modules/Job/externals/images/companies/vinpearlluxury.png" alt="Image" /></a>
</div>
-->
<div class="pt-block">

<h3 style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 10px 0;  text-transform: uppercase;"><?php echo $this->translate('Hot Jobs'); ?></h3><a style="color: rgb(79, 193, 233); display: inline-block; float: right; font-size: 12px; text-transform: none; position: relative; margin-right: 21px; margin-top: -28px;" ><?php echo $this->translate('All');?></a>
<div id="ajax_hot_job">
<?php 
    if( $this->hot_paginator->getTotalItemCount() ): 
?>
<ul class="pt-list-right">
    <?php foreach ($this->hot_paginator as $item): ?>
    <li>
    	<div class="pt-user-post">	    	
	        <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
	        
			<?php
				$photo_id = $this->company($item->user_id)->photo_id;
				$recruiter_id=$this->company($item->user_id)->recruiter_id;
				if($photo_id==''){
									$photo_id='12345';
								}
								$filecheck="http://test.hospitality.vn/public/recruiter/1000000/1000/".$recruiter_id."/".$photo_id.".png";						
								$url = getimagesize($filecheck);
    							//if(is_array($url))
								if(is_array($url)){
									$duoifile='png';
								} 
								else $duoifile='jpg';
								
								$file_image_them='/public/recruiter/1000000/1000/'.$recruiter_id.'/'.$photo_id.'.'.$duoifile;
								$testt=getimagesize($file_image_them);
								if(is_array($testt)){
									$file_image_them='application/modules/User/externals/images/nophoto_user_thumb_icon.png';
								}
			?>	
			<a href="#"><span class="pt-avatar"><img src="<?php echo $file_image_them; ?>" alt="Image"></span></a>        
	        <div class="pt-how-info-user-post">
	        <?php $text= $item->position;
			$txt			=	$text;
			$qty=7;
		$arr_replace	=	array("<p>","</p>","<br>","<br />","  ");
		$text			=	str_replace($arr_replace,"",$text);
		$dem			=	0;
		for ( $i=0 ; $i < strlen($text) ; $i++ )
		{
			if ($text[$i] == ' ') $dem++;
			if ($dem == $qty)	break;
		}
		$text		=	substr($text,0,$i);
		if ($i	<	strlen($txt))
			$text .= " ...";
		$result_text=	$text;
			?>
	        		<h3 style="font-size:12px"><?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $result_text) ?></h3>
	             	<!--<p><?php if($this->company($item->user_id))echo $this->company($item->user_id)->company_name;?></p>	             	
	        				<p>
	                            <?php //echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?>,
	                            <?php //echo $this->translate('Salary: ')?><?php echo $item->salary;?>,<br />
	                            
	                       </p>-->
             		<p><?php echo $this->translate('Date Posted: ')?><?php echo date('d F Y', strtotime($item->creation_date));?> </p>
             		<p><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></p>
	            
	
	        </div>
        </div>
    </li>
    <?php endforeach; ?>
</ul>
<?php 
    if( $this->hot_paginator->count() > 1 ): 
?>
<div class="paging">
    <?php echo $this->paginationControl($this->hot_paginator, null, "application/modules/Recruiter/views/scripts/hot_pagination.tpl"); ?>
</div>
<?php endif; ?>
<?php endif; ?>
</div>
</div>
</div>
<style>
	.block_content{
		width:273px;
	}
	.pt-user-post .pt-how-info-user-post h3 a{
		font-size:12px;
	}
</style>