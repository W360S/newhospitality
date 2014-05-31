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
                <?php echo $this->itemPhoto($this->subject(), 'thumb.profile') ?>
            </div>
            <div class="pt-link-event pt-link-group">
                <div class="pt-how-info-user-post">
                    <h3><a href="#"><?php echo $this->group->getTitle() ?></a></h3>
                    <p class="pt-info-group"><?php echo $this->group->member_count ?> thành viên trong nhóm
                        <?php if (!empty($this->group->category_id)): ?>
                            <?php echo $this->htmlLink(array('route' => 'group_general', 'action' => 'browse', 'category' => $this->group->category_id), $this->translate($this->group->getCategory()->title)) ?>
                        <?php endif; ?>
                    </p>
                </div>
                <div class="pt-how-link">
                    <?php $group_actions = $this->actions();?>
                    <?php if (!isset($group_actions['label'])): ?>
                        <?php foreach ($group_actions as $actions): ?>
                            <?php echo $this->htmlLink(array('route' => $actions['route'], 'controller' => $actions['params']['controller'], 'action' => $actions['params']['action'], 'group_id' => $actions["params"]['group_id']), $actions['label'], array('class' => "pt-adherence buttonlink smoothbox")) ?>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <?php $actions = $group_actions; ?>
                        <?php if ($actions['label'] == "Request") $actions['label'] = "Tham gia" ?>
                        <?php if ($actions['label'] == "Leave Group") $actions['label'] = "Rời nhóm" ?>
                        <!-- <?php if ($actions['label'] == "Request") $actions['label'] = "Tham gia" ?> -->
                        <?php echo $this->htmlLink(array('route' => $actions['route'], 'controller' => $actions['params']['controller'], 'action' => $actions['params']['action'], 'group_id' => $actions["params"]['group_id']), $actions['label'], array('class' => "pt-adherence buttonlink smoothbox")) ?>
                    <?php endif; ?>

                    <a href="/activity/index/share/type/group/id/<?php echo $this->group->group_id ?>/format/smoothbox" class="pt-share buttonlink smoothbox menu_group_profile group_profile_share">Chia sẻ nhóm</a>
                    <a href="#" class="pt-editing">Editing</a>
                    <div class="pt-toggle-layout">
                        <div class="pt-icon-arrow"><span></span></div>
                        <div class="pt-toggle-layout-content">
                            <ul class="pt-edit">
                                <li>
                                    <a href="/groups/member/invite/group_id/<?php echo $this->group->group_id ?>/format/smoothbox" class="buttonlink smoothbox menu_group_profile group_profile_invite" >Mời thành viên</a>
                                </li>
                                <li>
                                    <a href="javascript:void(0)">Gửi tin nhắn</a>
                                </li>
                                <li>
                                    <a href="/activity/index/share/type/group/id/<?php echo $this->group->group_id ?>/format/smoothbox" class="buttonlink smoothbox menu_group_profile group_profile_share">Chia sẻ nhóm</a>
                                </li>
                                <?php /*
                                <li>
                                    <a href="/groups/member/leave/group_id/<?php echo $this->group->group_id ?>" class="buttonlink smoothbox menu_group_profile group_profile_member">Leave Group</a>
                                </li>
                                */ ?>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pt-conent-info-group-text">
                <?php if ('' !== ($description = $this->group->description)): ?>
                    <?php echo $this->viewMore($description) ?>
                <?php endif; ?>
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
