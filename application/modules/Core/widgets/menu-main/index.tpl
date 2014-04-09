<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<?php if ($this->viewer->getIdentity()) : ?>
    <?php /*
      <?php
      echo $this->navigation()
      ->menu()
      ->setContainer($this->navigation)
      ->setPartial(null)
      ->setUlClass('navigation')
      ->render();
      ?>
     * 
     */ ?>
    <ul class="pt-menu-header-line">
        <li>
            <a href="<?php echo rtrim($this->baseUrl(), '/')?>" class="pt-active">
                <span class="pt-icon-menu-header-line pt-icon-community"></span>
                <p>Cộng Đồng</p>
            </a>
        </li>
        <li>
            <a href="<?php echo rtrim($this->baseUrl(), '/')?>/resumes">
                <span class="pt-icon-menu-header-line pt-icon-jobs"></span>
                <p>việc làm</p>
            </a>
        </li>
        <li>
            <a href="<?php echo rtrim($this->baseUrl(), '/')?>/experts">
                <span class="pt-icon-menu-header-line pt-icon-answer"></span>
                <p>Hỏi Đáp</p>
            </a>
        </li>
        <li>
            <a href="javascript:void(0)">
                <span class="pt-icon-menu-header-line pt-icon-fair"></span>
                <p>Chợ Phiên</p>
            </a>
        </li>
        <li>
            <a href="<?php echo rtrim($this->baseUrl(), '/')?>/library">
                <span class="pt-icon-menu-header-line pt-icon-library"></span>
                <p>Thư Viện</p>
            </a>
        </li>
    </ul>
<?php endif; ?>