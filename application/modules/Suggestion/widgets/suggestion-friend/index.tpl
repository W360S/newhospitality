<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: index.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<style type="text/css">
.tip > span {
margin-bottom:0;
}
</style>
<?php
$this->headScript()->appendFile('application/modules/Suggestion/externals/scripts/core.js');
//MAKE STRING OF CURRENT USER DISPLAY
$suggestion_home_user_array = $this->suggestion_level_array;
$suggestion_message = count($this->suggestion_level_array);
$suggestion_home_array = '';
foreach ($suggestion_home_user_array as $row_friend_id)
{
	$suggestion_home_array .= ',' . 'friend_' . $row_friend_id;
}
$suggestion_home_array = ltrim($suggestion_home_array, ',');
?>
<script type="text/javascript">	
	var friend_suggestion_display = "<?php echo $suggestion_message; ?>";	
	display_sugg += ',' + '<?php echo $suggestion_home_array; ?>';
</script>
<div class="pt-block">
<h3 class="pt-title-right" style="font-size:14px"><?php  echo $this->translate('you may know') ?><a class="all_sussgettion" style="color:#4FC1E9;" href="<?php echo PATH_SERVER_INDEX ?>/suggestions/friends_suggestions">Tất cả</a></h3>
<style>
	
	
</style>
    <!--<div class="suggestion_friends">-->
    <ul class="pt-list-right pt-list-right-fix">
	<?php
	$div_id = 1;
	foreach( $this->path_information as $path_info ):?>
	<li id="suggestion_friend_<?php echo $div_id; ?>">
			<div class="pt-user-post">				
				<?php echo $this->htmlLink($path_info->getHref(), $this->itemPhoto($path_info, 'thumb.icon'), array('class' => 'pt-avatar')); ?>
				<div class="pt-how-info-user-post">
					<?php //echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $path_info->user_id . ', \'suggestion_friend_' . $div_id . '\', \'friend\', \'friend\');"></a>'; ?>
					<h3 style="font-size:12px"><a href="<?php echo $path_info->getHref() ?>"><?php echo $path_info->getTitle() ?></a></h3>
					<b><?php	//echo $this->htmlLink($path_info->getHref(), Engine_Api::_()->suggestion()->truncateTitle($path_info->getTitle()), array('title' => $path_info->getTitle())); ?></b>
					<p><?php
					 if(!empty($this->mutual_friend_array[$path_info->user_id]))
					 {
					 		echo '<a class="smoothbox" style="color:#656565" href="' . $this->url(array('module' => 'suggestion', 'controller' => 'index', 'action' => 'mutualfriend', 'sugg_friend_id' => $path_info->user_id), 'default', true) . '">' . $this->translate(array('%s mutual friend', '%s mutual friends', $this->mutual_friend_array[$path_info->user_id]),$this->locale()->toNumber($this->mutual_friend_array[$path_info->user_id])) . '</a>'; }?></p>
					<div><?php //echo $this->userFriendship($path_info); ?></div>
					
				</div>
				<div class="pt-link-add">	<?php echo $this->userFriendship($path_info); ?></div>
				<div style="display:none">
						<form enctype="application/x-www-form-urlencoded" id="ajax-add-friend-<?php echo $path_info->user_id ?>" action="/members/friends/add/user_id/<?php echo $path_info->user_id ?>">

						</form>
					</div>			
			</div>
	</li>
		<?php
		$div_id++;
	endforeach;
	 ?>
	 </ul>
 <div style="clear:both"></div>
 <!--
 <div class="books"><div class="more"><a href="<?php echo $this->url(array(), 'friends_suggestions_viewall' ) ?>" title="<?php echo $this->translate("Find your Friends"); ?>">
	 <?php 
	 	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
	 	if(!empty($suggestion_field_cat))
	 	{
	 		echo $this->translate("More") . ' &raquo;'; 
	 	}
	 ?></a>
  </div></div>-->
</div>
			<?php
	$currenturl=$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
	//echo $currenturl;
	$urlarray=explode('/',$currenturl);
	$here= $urlarray[2];
	if($here=='community'){ 
			$host = "localhost";
			$dbuser = "new_hospitality";
			$dbpass = "abcde12345-";
			$csdl = "new_hospitality";
			//$link = mysql_connect('localhost', 'user', 'password');
			$marTViet=array("à","á","ạ","ả","ã","â","ầ","ấ","ậ","ẩ","ẫ","ă",
"ằ","ắ","ặ","ẳ","ẵ","è","é","ẹ","ẻ","ẽ","ê","ề"
,"ế","ệ","ể","ễ",
"ì","í","ị","ỉ","ĩ",
"ò","ó","ọ","ỏ","õ","ô","ồ","ố","ộ","ổ","ỗ","ơ"
,"ờ","ớ","ợ","ở","ỡ",
"ù","ú","ụ","ủ","ũ","ư","ừ","ứ","ự","ử","ữ",
"ỳ","ý","ỵ","ỷ","ỹ",
"đ",
"À","Á","Ạ","Ả","Ã","Â","Ầ","Ấ","Ậ","Ẩ","Ẫ","Ă"
,"Ằ","Ắ","Ặ","Ẳ","Ẵ",
"È","É","Ẹ","Ẻ","Ẽ","Ê","Ề","Ế","Ệ","Ể","Ễ",
"Ì","Í","Ị","Ỉ","Ĩ",
"Ò","Ó","Ọ","Ỏ","Õ","Ô","Ồ","Ố","Ộ","Ổ","Ỗ","Ơ"
,"Ờ","Ớ","Ợ","Ở","Ỡ",
"Ù","Ú","Ụ","Ủ","Ũ","Ư","Ừ","Ứ","Ự","Ử","Ữ",
"Ỳ","Ý","Ỵ","Ỷ","Ỹ",
"Đ");
 
$marKoDau=array("a","a","a","a","a","a","a","a","a","a","a"
,"a","a","a","a","a","a",
"e","e","e","e","e","e","e","e","e","e","e",
"i","i","i","i","i",
"o","o","o","o","o","o","o","o","o","o","o","o"
,"o","o","o","o","o",
"u","u","u","u","u","u","u","u","u","u","u",
"y","y","y","y","y",
"d",
"A","A","A","A","A","A","A","A","A","A","A","A"
,"A","A","A","A","A",
"E","E","E","E","E","E","E","E","E","E","E",
"I","I","I","I","I",
"O","O","O","O","O","O","O","O","O","O","O","O"
,"O","O","O","O","O",
"U","U","U","U","U","U","U","U","U","U","U",
"Y","Y","Y","Y","Y",
"D");

			$link=mysql_connect($host,$dbuser,$dbpass) or die("connect error");
			mysql_set_charset('utf8',$link);
			mysql_select_db($csdl);
		?>
			<div class="pt-block">
					<h3 class="pt-title-right" style="font-size:14px"><?php echo $this->translate("Jobs") ?><a style="color:#4FC1E9;"  href="/<?php echo PATH_SERVER_INDEX; ?>/resumes"><?php echo $this->translate("All") ?></a></h3>
					<ul class="pt-list-right">
					<?php 
					$today=date("Y/m/d");
						$sql="select * from engine4_recruiter_jobs where status=2 order by job_id desc limit 5";
						$qr=mysql_query($sql);
						while($r=mysql_fetch_array($qr)){
					 ?>
						<li>
							<div class="pt-user-post">
							<?php
								$sql1="select recruiter_id, photo_id from engine4_recruiter_recruiters where user_id=".$r['user_id']." limit 1";
								$qr1=mysql_query($sql1);
								while($r1=mysql_fetch_array($qr1)){
									$recruiter_id=$r1['recruiter_id'];
									$photo_id=$r1['photo_id'];		
								}
								$sql2="select * from engine4_users where user_id=".$r['user_id'];
								$qr2=mysql_query($sql2);
								while($r2=mysql_fetch_array($qr2)){
									$user_name=$r2['displayname'];
									$user_name_profile=$r2['username'];
								}
								$sql3="select * from engine4_resumes_cities where city_id=".$r['city_id'];
								$qr3=mysql_query($sql3);
								while($r3=mysql_fetch_array($qr3)){
									$city_name=$r3['city_id'];
								}
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
							
								<a href="/<?php echo PATH_SERVER_INDEX; ?>/recruiter/jobs/<?php echo $r['job_id'] ?>/slug/<?php echo str_replace($marTViet,$marKoDau,str_replace(" ","-",$r['position'])); ?>"><span class="pt-avatar"><!--<img src="/public/recruiter/1000000/1000/<?php echo $recruiter_id;?>/<?php echo $photo_id; ?>.<?php echo $duoifile; ?>" alt="Image">--><img src="<?php echo $file_image_them;?>" alt="Image"></span></a>
								<div class="pt-how-info-user-post">
									<h3><a href="/<?php echo PATH_SERVER_INDEX; ?>/recruiter/jobs/<?php echo $r['job_id'] ?>/slug/<?php echo str_replace($marTViet,$marKoDau,str_replace(" ","-",$r['position'])); ?>"><?php echo $r['position']; ?> </a></h3>
									<p><?php echo date('Y-m-d', strtotime(str_replace('.', '/', $r['creation_date']))); ?><?php echo $r['$city_name'];  ?></p>
									<p>Bởi:<a href="/<?php echo PATH_SERVER_INDEX; ?>/profile/<?php echo $user_name_profile; ?>"><?php echo $user_name; ?></a> </p>
								</div>
								<a href="/<?php echo PATH_SERVER_INDEX; ?>/recruiter/jobs/<?php echo $r['job_id'] ?>/slug/<?php echo str_replace($marTViet,$marKoDau,str_replace(" ","-",$r['position'])); ?>" class="pt-link-add" style="padding:3px 8px"><?php echo $this->translate("See") ?></a>
							</div>
						</li>
						<?php } ?>
					</ul>
				</div>
				<?php } ?>
<?php $ajaxloaderimg = $this->baseUrl() ."/externals/smoothbox/ajax-loader.gif" ; ?>
<script type="text/javascript">
function openUrl(url){
    Smoothbox.open(url);
}
function sendAjaxAddfriend(id, isAjax, object){
	var form_id = '#ajax-add-friend-' + id;
	var form = jQuery(form_id);
	var url = form.attr("action");

	var parentObject = jQuery(object).parent();
	//mixInfo(id, parentObject.parent().parent().attr('id'), 'friend', 'friend');

	var item_response = new Array();
	
	var refresh_item = jQuery.ajax({
    	type: "POST",
    	url : en4.core.baseUrl + 'suggestion/main/mix-info',
    	data : {
	      format : 'html',
	      sugg_id : id,     
	      widget_div_id : parentObject.parent().parent().parent().attr('id'),
	      fun_name : 'friend',
	      display_suggestion : friend_suggestion_display,
	      displayed_sugg : '',
	      page_name : 'friend'
	    },
	    beforeSend: function ( xhr ) {
			    //xhr.overrideMimeType("text/plain; charset=x-user-defined");
			    parentObject.html('Sending... <img src="<?php echo $ajaxloaderimg ?>"/>');		
			    //mixInfo(id, parentObject.parent().parent().parent().attr('id'), 'friend', 'friend');
		},
	    success: function( response ) {
			//console.log(response);
			item_response[id] = response;
			jQuery.ajax( {
				type: "POST",
				url: url,
				data: form.serialize(),
				beforeSend: function ( xhr ) {
				    //xhr.overrideMimeType("text/plain; charset=x-user-defined");
				    //parentObject.html('Sending your request <img src="<?php echo $ajaxloaderimg ?>"/>');		
				    //mixInfo(id, parentObject.parent().parent().parent().attr('id'), 'friend', 'friend');
				},
				success: function( response ) {
					//parentObject.parent().parent().parent().remove();
					//mixInfo(id, parentObject.parent().parent().parent().attr('id'), 'friend', 'friend');
					parentObject.parent().parent().parent().html(item_response[id]);
					var count = jQuery("div.suggestion_friends").children().length;
					if(count == 0){
						//jQuery("div.suggestion_friends").parent().remove();console.log("removeed");
					}else{
						//parentObject.parent().parent().parent().remove();
					}
				},
				complete: function(){
				}
			});
		},
    });
}
</script>