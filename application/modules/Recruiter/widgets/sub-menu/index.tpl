<div class="pt-block">
    <div class="pt-contents-response">
        <p>Mauris iaculis porttitor posuere. Praesent id metus massa, ut blandit odio. Proin quis tortor orci.</p>
        <a class="bt_create" href="<?php echo $this->baseUrl() . '/recruiter/job/create' ?>">ĐĂNG TUYỂN DỤNG</a>
        <?php if (count($this->profile) == 0) : ?>
            <a style="" class="company_profile" href="<?php echo $this->baseUrl() . '/recruiter/index/create-profile' ?>"><?php echo $this->translate("Create Company Profile") ?></a>
        <?php else: ?>
            <?php 
            $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($this->profile->company_name);
            echo $this->htmlLink(array('route' => 'view-profile', 'id' => $this->profile->recruiter_id, 'slug' => $slug), $this->translate("My Company Profile"), array('class' => 'company_profile'));
            ?>
        <?php endif;?>   
    </div>
</div>
<?php /*
  <style type="text/css">
  .create_resume ul li{position: relative; left:250px; border: 1px solid; width: 150px;}
  .create_resume .subsection ul{overflow: visible;}
  .create_resume .subsection{border: none;}
  </style>
  <div class="subsection">
  <h2><?php echo $this->translate("My Company");?></h2>
  <div class="subcontent">
  <div class="content_online_resume">
  <a class="bt_create" href="<?php echo $this->baseUrl().'/recruiter/job/create' ?>"><?php echo $this->translate("POST A JOB")?></a>

  <?php if(count($this->profile)==0){?>
  <a style="padding: 0 72px;" class="company_profile" href="<?php echo $this->baseUrl().'/recruiter/index/create-profile' ?>"><?php echo $this->translate("Create Company Profile")?></a>

  <?php } else{
  $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($this->profile->company_name);
  echo $this->htmlLink(array('route' => 'view-profile', 'id' => $this->profile->recruiter_id, 'slug'=>$slug), $this->translate("My Company Profile"), array('class'=>'company_profile'));
  }?>

  </div>
  </div>
  </div>
 * 
 */ ?>
