<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Payment
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Transactions.php 9747 2012-07-26 02:08:08Z john $
 * @author     John Boehr <j@webligo.com>
 */

/**
 * @category   Application_Core
 * @package    Payment
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Payment_Model_DbTable_Transactions extends Engine_Db_Table
{
  protected $_rowClass = 'Payment_Model_Transaction';

  public function getBenefitStatus(User_Model_User $user = null)
  {
    // Get benefit setting
    $benefitSetting = Engine_Api::_()->getApi('settings', 'core')->getSetting('payment.benefit');
    if( !in_array($benefitSetting, array('all', 'some', 'none')) ) {
      $benefitSetting = 'all';
    }

    switch( $benefitSetting ) {
      default:
      case 'all':
        return true;
        break;

      case 'some':
        if( !$user ) {
          return false;
        }
        return (bool) $this->select()
          ->from($this, new Zend_Db_Expr('TRUE'))
          ->where('user_id = ?', $user->getIdentity())
          ->where('type = ?', 'payment')
          ->where('status = ?', 'okay')
          ->limit(1);
        break;

      case 'none':
        return false;
        break;
    }

    return false;
  }
}