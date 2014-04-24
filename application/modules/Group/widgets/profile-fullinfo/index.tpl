<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7250 2010-09-01 07:42:35Z john $
 * @author		 John
 */
?>
<div class="group-fullinfo-wrapper">
<div class="pt-how-info-event">
    <div class="pt-conent-info-event">
        <div class="pt-conent-info-event-img">
            <img src="img/thumb/img-event-detail-02.jpg" alt="Image">
        </div>
        <div class="pt-link-event pt-link-group">
            <div class="pt-how-info-user-post">
                <h3><a href="#">Neque porro quisquam est</a></h3>
                <p class="pt-info-group">69 thành viên trong nhóm<a href="#">Ẩm thực/ Bar/ Bàn</a></p>
            </div>
            <div class="pt-how-link">
                <a href="#pt-fancybox-01" class="pt-adherence"><span></span>Tham gian</a>
                <a href="#" class="pt-share"><span></span>Chia sẻ</a>
                <div class="pt-none">
                    <div id="pt-fancybox-01" class="pt-approve">
                        <p>Bạn có muốn tham gia sự kiện này</p>
                        <button type="submit" title="" class="button">Tham gia</button>
                        <button type="submit" title="" class="button">Hủy</button>
                    </div>
                </div>
                <a href="#" class="pt-editing">Editing</a>
                <div class="pt-toggle-layout">
                    <div class="pt-icon-arrow"><span></span></div>
                    <div class="pt-toggle-layout-content">
                        <ul class="pt-edit">
                            <li>
                                <a href="#">Mời thành viên</a>
                            </li>
                            <li>
                                <a href="#">Gửi tin nhắn</a>
                            </li>
                            <li>
                                <a href="#">Chỉnh sửa thông tin</a>
                            </li>
                            <li>
                                <a href="#">Rời nhóm</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="pt-conent-info-group-text">
            <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa</p>
        </div>
        <div class="clear-both"></div>
    </div>
</div>
</div>

<?php /*
  <style type="text/css">

  ul.groups_profile_tab>li{
  border-bottom:1px solid #EAEAEA;
  padding-bottom:10px;
  }
  </style>

  <div class="group-info">
  <ul>
  <li class="group_stats_title">
  <span>
  <?php //echo $this->group->getTitle() ?>
  </span>
  <?php if( !empty($this->group->category_id) ): ?>
  <?php echo $this->translate("Category: ");?><?php echo $this->htmlLink(array('route' => 'group_general', 'action' => 'browse', 'category' => $this->group->category_id), $this->translate($this->group->getCategory()->title)) ?>
  <?php endif; ?>
  </li>
  <?php if( '' !== ($description = $this->group->description) ): ?>
  <li class="group_stats_description">
  <?php echo $this->viewMore($description) ?>
  </li>
  <?php endif; ?>
  <li class="group_stats_staff">
  <ul>
  <?php foreach( $this->staff as $info ): ?>
  <li>
  <?php echo $info['user']->__toString() ?>
  <?php if( $this->group->isOwner($info['user']) ): ?>
  (<?php echo ( !empty($info['membership']) && $info['membership']->title ? $info['membership']->title : $this->translate('owner') ) ?>)
  <?php else: ?>
  (<?php echo ( !empty($info['membership']) && $info['membership']->title ? $info['membership']->title : $this->translate('officer') ) ?>)
  <?php endif; ?>
  </li>
  <?php endforeach; ?>
  </ul>
  </li>
  <li class="group_stats_info">
  <ul>
  <li><?php echo $this->translate(array('%s total view', '%s total views', $this->group->view_count), $this->locale()->toNumber($this->group->view_count)) ?></li>
  <li><?php echo $this->translate(array('%s total member', '%s total members', $this->group->member_count), $this->locale()->toNumber($this->group->member_count)) ?></li>
  <li><?php echo $this->translate('Last updated %s', $this->timestamp($this->group->modified_date)) ?></li>
  </ul>
  </li>
  </ul>
  </div>
 */ ?>
