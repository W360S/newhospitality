<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<?php /*
<?php echo $this->translate('Copyright &copy;%s', date('Y')) ?>
<?php foreach( $this->navigation as $item ):
  $attribs = array_diff_key(array_filter($item->toArray()), array_flip(array(
    'reset_params', 'route', 'module', 'controller', 'action', 'type',
    'visible', 'label', 'href'
  )));
  ?>
  &nbsp;-&nbsp; <?php echo $this->htmlLink($item->getHref(), $this->translate($item->getLabel()), $attribs) ?>
<?php endforeach; ?>

<?php if( 1 !== count($this->languageNameList) ): ?>
    &nbsp;-&nbsp;
    <form method="post" action="<?php echo $this->url(array('controller' => 'utility', 'action' => 'locale'), 'default', true) ?>" style="display:inline-block">
      <?php $selectedLanguage = $this->translate()->getLocale() ?>
      <?php echo $this->formSelect('language', $selectedLanguage, array('onchange' => '$(this).getParent(\'form\').submit();'), $this->languageNameList) ?>
      <?php echo $this->formHidden('return', $this->url()) ?>
    </form>
<?php endif; ?>
*/ ?>
<div class="pt-footer-left">
  <ul class="pt-menu-footer">
    <li><a href="/statistics/index/about-us">Giới thiệu</a></li>
    <li><a href="/statistics/index/terms-of-services">Điều khoản sử dụng</a></li>
    <!-- <li><a href="#">Đối tác</a></li> -->
    <li><a href="/statistics/index/privacy">Chính sách bảo mật</a></li>
    <li><a href="/statistics/index/coupon">Coupon</a></li>
    <li class="last"><a href="/statistics/index/contact-us">Liên hệ</a></li>
  </ul>
  <p>Bản quyền © 2014 <a href="Hospitality.vn">Hospitality.vn</a> . Đang chờ cấp phép mạng xã hội</p>
</div>
<div class="pt-footer-right">
  <ul>
    <li><a href="#"><img src="application/themes/newhospitality/images/front/icon-01.png" alt="Image"></a></li>
    <li><a href="#"><img src="application/themes/newhospitality/images/front/icon-02.png" alt="Image"></a></li>
    <li><a href="#"><img src="application/themes/newhospitality/images/front/icon-03.png" alt="Image"></a></li>
    <li><a href="#"><img src="application/themes/newhospitality/images/front/icon-04.png" alt="Image"></a></li>
  </ul>
</div>