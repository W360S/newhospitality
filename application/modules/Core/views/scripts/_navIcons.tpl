<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: _navIcons.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<ul>
  <?php foreach( $this->container as $link ): ?>
    <li>
      <?php echo $this->htmlLink($link->getHref(), $this->translate($link->getLabel()), array(
        'class' => 'buttonlink' . ( $link->getClass() ? ' ' . $link->getClass() : '' ),
        'style' => 'background-image: url('.$link->get('icon').');',
        'target' => $link->get('target'),
      )) ?>
    </li>
  <?php endforeach; ?>
</ul>