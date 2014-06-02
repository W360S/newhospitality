<style type="text/css">
#global_content .layout_middle, .layout_left{padding-right: 0;}
.layout-about-us ul.left-menu-about li a.contact{color:#fff;font-size:13px;text-transform:uppercase;background: url(<?php echo "/application/modules/Statistics/externals/images/help/title-about-us.gif" ?>) repeat-x;font-weight:bold}

.form-elements .errors li{display: none;}
</style>

<?php
    $status= $this->status;
    $message= $this->message;
    $data= $this->data;
    $form= $this->form; 
?>
<div id="content">
    <div class="section layout-about-us">
        <div class="layout_left">
            <?php echo $this->content()->renderWidget('statistics.panel-left');?>
        </div>
        <div class="layout_middle">
            <h3><?php echo $this->translate('Contact')?></h3>
            <div>
                Nếu bạn có bất kỳ nhu cầu cầu liên hệ với hospitality.vn, xin vui lòng điền thông tin vào form phía dưới
            </div>
            <?php if($status ): ?>
              <?php //echo $message; ?>
            <?php else: ?>
              <?php if($data){ 
              //echo $data['body'];
              } ?>
              <?php echo $form->render($this) ?>
            <?php endif; ?>
            
        </div>
        <?php echo $this->content()->renderWidget('statistics.footer');?>
    </div>
</div>