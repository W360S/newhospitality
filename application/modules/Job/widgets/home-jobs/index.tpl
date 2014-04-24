<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0; width: 101%;}
img { vertical-align: top; }

.wd-tab .wd-item li{background-color:#f2f2f2;float:left;font-weight:bolder;margin-right:2px;padding:.5em 1em;}
.wd-tab .wd-item li.wd-current{background-color:#F1F8FC;}
.wd-tab .wd-item li.wd-current a{ color:#009ECF !important;}
.wd-tab .wd-item li a:link, .wd-tab .wd-item li a:visited{color:#686868;}
.wd-tab .wd-item li a:hover{color:#c00;}
.wd-tab .wd-item li a{font-size:1.2em; text-transform:uppercase;}
.wd-tab .wd-panel{padding:1em;}
.wd-tab .wd-panel h3, .wd-tab .wd-panel h4, .wd-tab .wd-panel h5, .wd-tab .wd-panel ul, .wd-tab .wd-panel ol, .wd-tab .wd-panel p{margin-bottom:1em;}
.wd-tab .wd-panel h3, .wd-tab .wd-panel h4, .wd-tab .wd-panel h5{font-size:1em;}
.wd-tab .wd-panel ul, .wd-tab .wd-panel ol{margin-left:3em;margin-right:3em;}
.wd-tab .wd-panel li{padding:.1em 0;}
.wd-tab .wd-panel ul{list-style:disc;}
.wd-tab .wd-panel ol{list-style:decimal;}
</style>
<div id="content">
        <div class="section jobs">

            <div style="width:282px;float:right">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
                <?php echo $this->content()->renderWidget('recruiter.hot-job');?>
                <?php echo $this->content()->renderWidget('recruiter.articals');?>
                <!-- end -->
                <!-- job tools -->
                <?php //echo $this->content()->renderWidget('recruiter.job-tools');?>
                <!-- end -->
                <!-- feature employers -->
                <?php echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                <!-- insert some advertising -->
                <?php //include 'ads/right-column-ads.php'; ?>
            </div>

            <div style="width:784px;float:left">
            <div >
<script type="text/javascript">
  var tabContainerSwitch = function(element) {
    if( element.tagName.toLowerCase() == 'a' ) {
      element = element.getParent('li');
    }
    var myContainer = element.getParent('.tabs_parent').getParent();
    myContainer.getChildren('div:not(.tabs_alt)').setStyle('display', 'none');
    myContainer.getElements('ul; li').removeClass('active');
    element.get('class').split(' ').each(function(className){
      className = className.trim();
      if( className.match(/^tab_[0-9]+$/) ) {
        myContainer.getChildren('div.' + className).setStyle('display', null);
        element.addClass('active');
        
       
        //alert(jQuery('#main_tabs').find("li.more_tab").attr('class').split(' '));
        var st= $$('.tab_pulldown_contents_wrapper').getParent();
        st.removeClass('tab_open');
        //alert(st);
      }
    });
    
    //jQuery('#main_tabs').find("li.more_tab").removeClass("tab_open").addClass("tab_closed");
  }
  
</script>
<style>
.tab_1{
	 background: none repeat scroll 0 0 #F9F9F9;
    border-color: #CCCCCC #CCCCCC -moz-use-text-color;
    border-style: solid solid none;
    border-width: 1px 1px medium;
    color: #000000;
    padding: 11px;
    font-size:14px;
    text-transform: uppercase;
    border: 1px solid #CCCCCC;
}
.tab_1.active{
	 background: none repeat scroll 0 0 #4FC1E9;
    /*border: 1px solid #4FC1E9;*/
    color: #FFFFFF;
    padding: 11px;
    border: 1px solid #4FC1E9;
}
.tab_2{
	 background: none repeat scroll 0 0 #F9F9F9;
    border-color: #CCCCCC #CCCCCC -moz-use-text-color;
    border-style: solid solid none;
    border-width: 1px 1px medium;
    color: #000000;
    padding: 11px;
    font-size:14px;
      text-transform: uppercase;
       border: 1px solid #CCCCCC;
}
.tab_2.active{
	 background: none repeat scroll 0 0 #4FC1E9;
    border: 1px solid #4FC1E9;
    color: #FFFFFF;
    padding: 11px;
}
.tab_3{
	 background: none repeat scroll 0 0 #F9F9F9;
    border-color: #CCCCCC #CCCCCC -moz-use-text-color;
    border-style: solid solid none;
    border-width: 1px 1px medium;
    color: #000000;
    padding: 11px;
    font-size:14px;
      text-transform: uppercase;
       border: 1px solid #CCCCCC;
}
.tab_3.active{
	 background: none repeat scroll 0 0 #4FC1E9;
    border: 1px solid #4FC1E9;
    color: #FFFFFF;
    padding: 11px;
}
.tab_1.active > a {    
    border:none;
    color: #fff;
    outline: medium none;
    padding: 5px 7px;
    text-decoration: none;
}
.tab_2.active > a { 
	border:none;
    color: #fff;
    outline: medium none;
    padding: 5px 7px;
    text-decoration: none;
}
.tab_1 > a {    
    border:none;
    border-style: none;
}
.tab_2 > a { 
	border:none;
    border-style: none;
}
.tab_3.active > a { 
	border:none;
    color: #fff;
    outline: medium none;
    padding: 5px 7px;
    text-decoration: none;
}
.tab_3 > a {    
    border:none;
    border-style: none;
}
.tabs_alt > ul > li > a{
	border-style: none;
}
.tabs_alt > ul > li > a:hover{
	border-style: none;
}
.tab_2.current{
	 background: none repeat scroll 0 0 #4FC1E9;
    margin-top:0px;
    color: #FFFFFF;
    padding: 8px 21px;
    font-size:12px;
    text-transform: none;
    border: 1px solid #4FC1E9;
}
.tab_3.current{
	 background: none repeat scroll 0 0 #4FC1E9;
    margin-top:0px;
    color: #FFFFFF;
    padding: 25px 21px;
    font-size:12px;
    text-transform: none;
    border: 1px solid #4FC1E9;
}
.tab_1.current{
	 background: none repeat scroll 0 0 #4FC1E9;
    margin-top:0px;
    color: #FFFFFF;
    padding: 8px 21px;
    font-size:12px;
    text-transform: none;
    border: 1px solid #4FC1E9;
}

ul.list_category li a {
    color: #fff;
    line-height: 17px;
}
ul.list_category li a:hover {
    color: #fff;
    line-height: 17px;
    text-decoration: underline;
}

.subcontent .filter .select_sort {
    color: #FFFFFF;
    float: right;
}
.filter .input input {
    padding: 2px;
    width: 114px;
}
input, select {
    padding: 9px 4%;
}
.pt-content-searching ul li .wd-adap-select {
    margin: 0;
    width: 100%;
}
.button:hover{
	background:#48CFAD;
}
.layout_middle .tabs_alt .item {
    height: 42px;
    overflow: hidden;
}
.layout_middle .tabs_alt .item li.active a{
	background:none;
}
.layout_middle .tabs_alt .item li a{
	border-style:none;
	background:none;
}
.layout_middle .tabs_alt .item{
	height:42px;
	color:#000;
}
.jobs .subsection{
	background:none;
}
.subsection{
	border:none;
}
ul.list_category li{
	background:url("../img/front/icon-areas.png") no-repeat scroll left 11px rgba(0, 0, 0, 0);
	padding: 4px 0 4px 16px;
}
ul.list_category li a span{
	background:#fff;
	border-radius:50%;
	padding:0 5px;
	color:#4FC1E9;
	font-size:11px;
}
</style>
<div class="tabs_alt tabs_parent">
  <ul class="item" id="main_tabs">
  <li class="tab_3 active"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Search jobs')?></a></li>
                        <li class="tab_1 "><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Careers')?></a></li>
                        <li class="tab_2"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Industries')?></a></li>
						                             
      
  </ul>
</div>

<div class=" tab_2 current" style="display: none;">
<?php echo $this->content()->renderWidget('recruiter.categories');?>
</div>
<div class="tab_1 current" style="display: none;">
<?php echo $this->content()->renderWidget('recruiter.industry-job');?>
</div>
<div class="tab_3 current" >
<?php echo $this->content()->renderWidget('recruiter.search-job');?>
</div>
</div>
                <!--show all jobs here-->
                <?php
	$currenturl=$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
	//echo $currenturl;
	$urlarray=explode('/',$currenturl);
	$here= $urlarray[2];	 
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
			<div class="pt-list-job">
							<ul class="pt-list-job-ul">
					<?php 
						$today=date("Y/m/d");
if ( !$_GET['page'] )
{
    $page = 0 ;
}
else $page=$_GET['page'];
$today=date('Y-m-d');
$baitren_mottrang = 10;
//$sodu_lieu=mysql_num_rows(mysql_query("select * from engine4_recruiter_jobs where status=2 and deadline>'".$today."' limit 150") ) or die(mysql_error());
$sodu_lieu=mysql_num_rows(mysql_query("select * from engine4_recruiter_jobs where status=2  limit 150") ) or die(mysql_error());
$sotrang = $sodu_lieu/$baitren_mottrang;
//$sql="select * from engine4_recruiter_jobs where status=2 and deadline>'".$today."'  order by job_id desc limit ". $page*$baitren_mottrang." , ".$baitren_mottrang;
$sql="select * from engine4_recruiter_jobs where status=2  order by job_id desc limit ". $page*$baitren_mottrang." , ".$baitren_mottrang;

						//echo $sql;
						$qr=mysql_query($sql);
						$coutns=1;
						
						while($r=mysql_fetch_array($qr)){
							
					 ?>
						<li <?php if($coutns<3) echo 'class="news"'; ?>>
							<?php
								$sql_jobtype="select type_id from engine4_recruiter_jobtypes where job_id=".$r['job_id']." limit 1";
								$qr_jobtype=mysql_query($sql_jobtype);								
								while($r_jobtype=mysql_fetch_array($qr_jobtype)){
									$jobtype_id=$r_jobtype['type_id'];											
								}
								$sql1="select recruiter_id, photo_id from engine4_recruiter_recruiters where user_id=".$r['user_id']." limit 1";
								$qr1=mysql_query($sql1);
								//$coutns=1;
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
								
								$sqlcompany="select * from engine4_recruiter_recruiters where user_id=".$r['user_id'];
								$qrcompany=mysql_query($sqlcompany);
								while($rcompany=mysql_fetch_array($qrcompany)){
									$company=$rcompany['company_name'];
								}
								$sql3="select * from engine4_resumes_cities where city_id=".$r['city_id'];
								$qr3=mysql_query($sql3);
								while($r3=mysql_fetch_array($qr3)){
									//print_r($r3);
									$city_name=$r3['city_id'];
									$city_names=$r3['name'];
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
								//print_r($r);				
							?>
								<?php
									$job_type_names='';
									$class_jobtype='';
									if($jobtype_id==1){
										$job_type_names='Full time';
										$class_jobtype='pt-fulltime';
									}
									else if($jobtype_id==2){
										$job_type_names='temporary';
										$class_jobtype='pt-temporary';										
									}
									else if($jobtype_id==3){
										$job_type_names='PART TIME';
										$class_jobtype='pt-parttime';
									}
									else if($jobtype_id==4){
										$job_type_names='temporary';
										$class_jobtype='pt-temporary';
									}
									else if($jobtype_id==5){
										$job_type_names='contrack';
										$class_jobtype='pt-temporary';
									}
									else if($jobtype_id==6){
										$job_type_names='intership';
										$class_jobtype='pt-intership';
									}
									else {
										$job_type_names='other';
										$class_jobtype='pt-fulltime';
									}
								?>
								<div class="pt-lv1"><span class="<?php echo $class_jobtype; ?>"><?php echo $job_type_names; ?></span></div>
									<div class="pt-lv2">
										<h3><a style="font-size:13px" href="/<?php echo PATH_SERVER_INDEX; ?>/recruiter/jobs/<?php echo $r['job_id'] ?>/slug/<?php echo str_replace($marTViet,$marKoDau,str_replace(" ","-",$r['position'])); ?>" target="_blank"><?php echo $r['position']; ?></a></h3>
										<span><?php echo $company; ?></span>
									</div>
									<div class="pt-lv3">
										<p class="pt-address"><span></span><?php echo $city_names;  ?></p>
									</div>
									<div class="pt-lv4">
										<div class="pt-user-name">
											<a href="#" class="pt-avatar"><img src="<?php echo $file_image_them;?>" alt="Image"></a>
											<strong>Đăng bởi:</strong>
											<p><a href="/<?php echo PATH_SERVER_INDEX; ?>/profile/<?php echo $user_name_profile; ?>"><?php echo $user_name; ?></a><span>- <?php echo date('Y-m-d', strtotime(str_replace('.', '/', $r['creation_date']))); ?></span></p><p></p>
										</div>
									</div>
							
						</li>
						<?php 
						$coutns++;
						//echo $coutns.'aaaaaaaaaaaaaaaaaaa';
						} ?>
					</ul>

<div class="pages">
    <ul class="paginationControl">
		<?php $i=1;?> 
			<?php if($page>0){ ?>                    
	           <li>
	          		<a href="/index.php/resumes/?page=0">First » </a>        
			  </li>
		  <?php } ?>   	
          <?php if($page>0){ ?>                    
	           <li>
	          		<a href="/index.php/resumes/?page=<?php echo $_GET['page']-1; ?>">Trước » </a>        
			  </li>
		  <?php } ?>
    	<?php
			for ( $i=$page+1; $i <= $page+5; $i ++ ){
				if($i+1>$sotrang){
			  	break;
				  }
		?>
    		<li class="<?php if($i==$page) echo 'selected'; ?>">
            	<a href="/index.php/resumes/?page=<?php echo $i; ?>"><?php echo $i; ?></a>
          	</li>
          	<?php 
			  
			  } ?>
          	<?php if($page+5<$sotrang){ ?>                    
	           <li>
	          		<a > ... </a>        
			  </li>
		  <?php } ?>
            <?php if($_GET['page']+1<$sotrang){ ?>                    
	           <li>
	          		<a href="/index.php/resumes/?page=<?php echo $_GET['page']+1; ?>">Sau » </a>        
			  </li>
		  <?php } ?>
		  <?php if($_GET['page']<$sotrang){ ?>                    
	           <li>
	          		<a href="/index.php/resumes/?page=<?php echo round($sotrang); ?>">Final » </a>        
			  </li>
		  <?php } ?>
    </ul>
  </div>
				</div>
				
                <!-- newest jobs -->
                <?php //echo $this->content()->renderWidget('recruiter.new-job');?>
                <!-- end -->
                <!-- hot jobs -->
                <?php //echo $this->content()->renderWidget('recruiter.hot-job');?>
                <!-- end -->
                <!-- artical -->
                <?php //echo $this->content()->renderWidget('recruiter.articals');?>
                <!-- end -->
                <div class="clear"></div>
            </div>

            <div class="clear"></div>

        </div>
</div>
<style>
	.pt-list-job {overflow:hidden; width:100%; float:left}

.pt-list-job ul.pt-list-job-ul {}
.pt-list-job ul.pt-list-job-ul li  {padding:20px 5px; overflow:hidden; border-left:5px solid #fff; background-color:#fff; border-bottom:1px solid #cccccc}
.pt-list-job ul.pt-list-job-ul li.news {border-left-color:#00a9e0; background-color:#fafafa}
.pt-list-job ul.pt-list-job-ul li  div {float:left; margin-right:5px}
.pt-list-job .pt-lv1 { width:135px; margin-right:10px }
.pt-list-job .pt-lv1 span {display:block; font-size:11px; font-weight:bold; color:#ffffff;text-transform: uppercase;border-radius: 2px; text-align:center; margin:0px 8px; margin-top:10px}
.pt-list-job .pt-lv1 span.pt-fulltime {background-color:#4edec2}
.pt-list-job .pt-lv1 span.pt-parttime {background-color:#ff7878}
.pt-list-job .pt-lv1 span.pt-intership {background-color:#ac92ec}
.pt-list-job .pt-lv1 span.pt-temporary {background-color:#ffce54}
.pt-list-job .pt-lv2 { width:269px; }
.pt-list-job .pt-lv2 h3 a {font-size:15px; font-weight:bold; color:#555555}
.pt-list-job .pt-lv2 h3 a:hover { text-decoration:underline}
.pt-list-job .pt-lv2 span { font-size:13px; color:#999999}
.pt-list-job .pt-lv3 { width:134px; }
.pt-list-job .pt-lv3 p { font-size:13px; color:#9c9c9c;margin:10px 0px; line-height:14px;}
.pt-list-job .pt-lv3 p span{ display:block; float:left; margin-right:5px; width:16px; height:16px;background: url(../img/front/pt-sprite.png) no-repeat -191px -272px;}
.pt-list-job .pt-lv4 { width:210px; }
.pt-list-job .pt-lv4  .pt-user-name {overflow:hidden;width:100%}
.pt-list-job .pt-lv4  .pt-user-name .pt-avatar {display:block; float:left; width:30px; height:30px;border-radius:50%; margin-right:10px }
.pt-list-job .pt-lv4  .pt-user-name .pt-avatar img {display:block;  width:30px; height:30px;border-radius:50%; }
.pt-list-job .pt-lv4  .pt-user-name strong {color:#2c2c2c; font-size:11px; font-weight:normal;line-height:13px;}
.pt-list-job .pt-lv4  .pt-user-name p {color:#99a3b1; font-size:11px; font-weight:normal; line-height:13px;}
.pt-list-job .pt-lv4  .pt-user-name p a {color:#61c6e9;margin-right:4px }
.pt-list-job .pt-lv4  .pt-user-name p a:hover {text-decoration:underline}

.pt-right-job {width:270px; float:right;margin-top:64px}
.pt-right-job .pt-list-right .pt-user-post .pt-how-info-user-post {width: 191px;}
.pt-list-logo {overflow:hidden; margin:20px 0px 10px}
.pt-list-logo li {overflow:hidden; width:50%; float:left;text-align:center; margin-bottom:10px}
.pt-list-logo li img {width:100px; height:50px}


.wd-full-content-fix { padding-top:10px}
.wd-full-content-fix .pt-title-event { border:none}
.wd-full-content-fix .pt-right-job { margin-top:0px}
.wd-full-content-fix .pt-left-job {margin-top:0px}
.pt-content-info {background-color:#fff;min-height:1140px;}

.pt-from-01 span.pt-vd {float:left; font-size:12px; color:#8c8c8c;margin-left: 126px;margin-top:4px}
.pt-from-01 .login-checkout ul li input {width: 425px;}
.pt-content-sigup-02 .pt-from-01 .login-checkout ul li label {font-weight:bold}
.pt-from-01 .pt-fix-w {float: left; width: 462px;margin-top:10px}
.pt-content-sigup-02 .pt-from-01 ul li .pt-fix-w p {width:100%;margin:0px 0px 10px 0px}
.pt-content-sigup-02 .pt-from-01 .pt-fix-w p input  {width:auto; float:left;}
.pt-content-sigup-02 .pt-from-01 ul li .pt-fix-w p label {font-weight:normal; padding-top:0px; text-align:left; width:425px}
.pt-from-01 .login-checkout ul li button {margin-right:10px !important}


.pt-list-cbth {}
.pt-list-cbth  li {padding:10px; overflow:hidden}
.pt-list-cbth  li span{ display:block; float:left}
.pt-list-cbth  li  .pt-number-1 { color:#fff; background-color:#bec7ca; padding:2px 6px;border-radius: 3px;}
.pt-list-cbth  li  .pt-text { color:#707070; font-size:13px; margin:2px 0px 0px 10px}
.pt-list-cbth  li .pt-icon-oky {float:right; width:20px; height:20px;background: url(../img/front/icon-oky.png) no-repeat ; display:none;}
.pt-list-cbth  li.pt-active  .pt-icon-oky {display:block;}
.pt-list-cbth  li.pt-active .pt-number-1 { color:#fff; background-color:#4fc0e8;}

.pt-title-from-02  {overflow:hidden; margin:5px 100px}
.pt-title-from-02 ol {list-style: initial; margin-left: 16px;}
.pt-title-from-02 a.pt-supplementary-report {display:block;margin:3px 0px; padding-left:15px;background: url(../img/front/icon-+.png) no-repeat 0px 4px; font-size:12px; color:#3d7cbf; text-decoration:underline }
.pt-title-from-02 a.pt-supplementary-report:hover {text-decoration:none}
.pt-title-from-02 p {margin:6px 0px}
.pt-title-from-02 span {padding:5px 0px; display:block}
.pt-title-from-02 button {float:left;width: auto;border-radius:2px; padding:0px 10px; margin-top:6px; margin-right:10px; height: 37px; color:#fff; display:block;background-color:#50c1e9; border:none;margin-left: 0px;cursor: pointer;}
.pt-title-from-02 button span{margin:0px 5px 0px 0px;padding:0px; display:block; width:19px; height:19px; float:left; background:url(../img/front/pt-sprite.png) no-repeat -93px -275px;}
.pt-title-from-02 button:hover {background-color: #2F95B9;}

.pt-title-from-02 p a {color:#3d7cbf;text-decoration:underline}
.pt-title-from-02 p a:hover {text-decoration:none}

.pt-from-02 .login-checkout {border:1px solid #d8d8d8; background-color:#f8f8f8; padding:30px 30px 30px 40px}
.pt-from-02 .login-checkout h4 {text-align:center; margin:0px 0px 20px}
.pt-from-02 .login-checkout ul li input {background-color:#fff}
.pt-from-02 .login-checkout ul li input {width: 349px;}
.pt-from-02 .login-checkout ul li .wd-adap-select-01  {width: 369px;}
.pt-from-02 .login-checkout ul li .wd-adap-select-02  {margin-right:5px; float:left}
.pt-from-02 .login-checkout ul li .wd-adap-select-02 input  {width:auto; float:left;margin-top:14px;}
.pt-from-02 .login-checkout ul li .wd-adap-select-02 label {font-weight:normal; text-align:left; width:auto;padding-top:11px;padding-left:3px}
.pt-from-01 .pt-fix-w textarea {width: 349px;padding:10px}


.pt-content-file-record {overflow:hidden; padding:20px;}
.pt-content-file-record .pt-title-file-record h3 {font-size:20px; color:#30aee9; float:left; margin-top:6px;}
.pt-content-file-record .pt-title-file-record h3 a {display:inline-block; width:11px; height:12px; background:url(../img/front/icon-edit.png) no-repeat;margin-left:10px}
.pt-content-file-record .pt-title-file-record .pt-finger-prints {line-height:32px; ;display:block; float:right; font-size:13px; color:#3d7cbf}
.pt-content-file-record .pt-title-file-record .pt-finger-prints:hover {text-decoration:underline}
.pt-content-file-record .pt-title-file-record .pt-finger-prints  img {float:left; margin-right:10px; width:28px; height:32px;}

.pt-title-file-record {overflow:hidden; width:100%; float:left}
.pt-lv-01 {width:210px; float:left; min-height:50px}
.pt-lv-01 p {text-align:center;margin-bottom:10px}
.pt-lv-01 p.last {margin-bottom:0px}
.pt-lv-01 p img {width:140px; height:140px;}
.pt-lv-01 .pt-edit { padding-left:15px;background:url(../img/front/icon-edit.png) no-repeat 0px 3px;font-size:12px; color:#3d7cbf; text-decoration:underline; }
.pt-lv-01 .pt-edit:hover  {text-decoration:none}
.pt-lv-02 {width:590px; float:left}
.pt-lv-02 h3 { font-size:15px; color:#656565}
.pt-lv-02 h3 a {font-weight:normal; font-size:12px; color:#3d7cbf; text-decoration:underline;padding-left:8p}
.pt-lv-02 h3 a:hover  {text-decoration:none}
.pt-lv-02 p {font-size:13px; color:#656565; margin:5px 0px}
.pt-lv-02 p a {font-weight:none; font-size:12px; color:#3d7cbf; text-decoration:underline;padding-left:8px}
.pt-lv-02 p a:hover  {text-decoration:none}

.pt-content-file {float:left; width:100%; margin-top:15px}
.pt-content-file-title {padding:20px; background-color:#f6f6f6; overflow:hidden;}
.pt-content-file-title .pt-lv-01 {width:auto; margin-right:44px}
.pt-content-file-title .pt-lv-01 {width:auto}
.pt-content-file-title .pt-lv-01 p {text-align:center;}

.pt-content-file-block {overflow:hidden; padding:40px 0px; border-bottom:1px solid #ececec}
.pt-content-file-block  .pt-lv-01  h3 {color:#30aee9; font-size:15px; padding-bottom:5px}
.pt-content-file-block  h3.pt-fix-mt { margin-top:20px}
.pt-lv-02 button {float:left;width: auto;border-radius:2px; padding:0px 10px; margin-top:6px; margin-right:10px; height: 37px; color:#fff; display:block;background-color:#50c1e9; border:none;margin-left: 0px;cursor: pointer;}
.pt-lv-02 button span{margin:0px 5px 0px 0px;padding:0px; display:block; width:19px; height:19px; float:left; background:url(../img/front/pt-sprite.png) no-repeat -93px -275px;}
.pt-lv-02 button:hover {background-color: #2F95B9;}
.pt-content-file-button {padding:10px 0px 0px; border:none}
.pt-content-file-button  img {display:block; float:left; margin-top:8px}


.pt-job-detail {padding:20px; background-color:#fff; overflow:hidden}
.pt-job-detail h3 { font-size:20px; color:#30aee9}
.pt-job-detail-title {overflow:hidden; padding:10px 15px; background-color:#f6f6f6;margin-top:20px}
.pt-job-detail-title img { width:95px; height:50px; float:left; margin-right:10px}
.pt-job-detail .pt-job-detail-title h4 { font-size:15px; color:#666666;margin:0px; margin-bottom:5px}
.pt-job-detail-title span { font-size:13px; color:#666666; display:block; margin-bottom:10px}
.pt-job-detail-title p { font-size:13px; color:#666666; width:100%;margin:10px 0px; float:left}
.pt-job-detail-title p a {font-weight:none; font-size:13px; color:#3d7cbf; text-decoration:underline}
.pt-job-detail-title p a:hover  {text-decoration:none}

.pt-list-content { overflow:hidden; float:right; background-color:#f6f6f6; padding:10px 20px;margin-top:20px; margin-left:20px}
.pt-list-content li { overflow:hidden; margin-bottom:10px}
.pt-list-content li strong { display:block; color:#666666; font-size:13px;}
.pt-list-content li span { display:block; color:#666666; font-size:13px;}
.pt-list-content li a { display:block; color:#3d7cbf; font-size:13px; text-decoration:underline}
.pt-list-content li a:hover  {text-decoration:none}

.pt-job-detail h4 { font-size:14px; color:#30aee9; margin:10px 0px 5px}
.pt-job-detail p { font-size:13px; color:#666666; margin:10px 0px 10px}
.pt-job-detail p span {display:block; float:left; width:150px;}

.pt-job-detail .pt-lv-02 {width:100%; float:left; margin-top:20px}
.pt-job-detail .pt-lv-02 img {padding-top:8px}
.pt-job-detail  .pt-lv-02 button.icon-01 span {background:url(../img/front/icon-tai.png) no-repeat 2px 2px;}
.pt-job-detail  .pt-lv-02 button.icon-02 span {background:url(../img/front/icon-tai.png) no-repeat 2px -37px;}
.pt-content-sigup-02 .pt-signin .login-checkout ul li button.icon-02 span {background:url(../img/front/icon-tai.png) no-repeat 2px -37px;}
.pt-from-03 .login-checkout {background-color:transparent; border:none; padding-top:0px}

.pt-list-table table td  button {padding:5px 10px}
.pt-list-table table td a.pt-icon-detele {display:inline-block; width:15px; height:15px;background:url(../img/front/icon-14.png) no-repeat 0px 0px; margin:0px 5px; }
.pt-list-table table td a.pt-icon-edit {display:inline-block; width:15px; height:15px;background:url(../img/front/icon-15.png) no-repeat 0px 0px;margin:0px 5px}
.pt-list-table table td span { }
.pt-list-table table td span.pt-span-1 {color:#90c960;font-style:italic}
.pt-list-table table td span.pt-span-2 {color:#fcdd8b;font-style:italic}
.pt-list-table table td span.pt-span-3 {color:#db6868;font-style:italic}
.pt-list-table table td span.pt-no {color:#db6868;font-style:normal }
.pt-to-news { display:block; float:left; padding:8px 12px; background-color:#4fc1e9; color:#fff !important; font-size:13px;border-radius: 3px;}
.pt-to-news:hover {background-color: #48cfad;}
.pt-fix-title {margin-top:11px}
 

</style>
<script type="text/javascript">
window.addEvent('domready', function(){
jQuery('.wd-tab').each(function(){
	jQuery(this).find('.wd-section').hide();

	var current = jQuery(this).find('.wd-item').children('.wd-current');
	if (current.length == 0){
		jQuery(this).find('.wd-item').children(':first-child').addClass('wd-current');
		jQuery(jQuery(this).find('.wd-item').children(':first-child').find('a').attr('href')).show();
	}

	jQuery(this).find('.wd-item').find('a').click(function(){
		var current = jQuery(this).parent().hasClass('wd-current');
		if (current == false){
			jQuery(this).parent()
				.addClass('wd-current')
				.siblings().each(function(){
					jQuery(this).removeClass('wd-current');
					jQuery(jQuery(this).find('a').attr('href')).hide();
				});
			jQuery(jQuery(this).attr('href')).fadeIn();
		}
		return false;
	});
});
});
</script>