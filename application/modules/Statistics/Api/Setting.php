<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Statistics
 
 * @version    1.0
 * @author     huynhnv
 * @status     progress
 */
class Statistics_Api_Setting extends Core_Api_Abstract
{

  public function getCategories()
  {
    $table = Engine_Api::_()->getDbTable('categories', 'statistics');
    return $table->fetchAll($table->select()->order('priority ASC'));
  }

  /**
   * Returns a category item
   *
   * @param Int category_id
   * @return Zend_Db_Table_Select
   */
  public function getCategory($category_id)
  {
    return Engine_Api::_()->getDbtable('categories', 'statistics')->find($category_id)->current();
  }
  /**
   * Returns a categories created by a given user
   *
   * @param Int user_id
   * @return Zend_Db_Table_Select
   */
  public function getUserCategories($user_id)
  {
    $table  = Engine_Api::_()->getDbtable('categories', 'news');
    $uName = Engine_Api::_()->getDbtable('news', 'news')->info('name');
    $iName = $table->info('name');

    $select = $table->select()
      ->setIntegrityCheck(false)
      ->from($iName, array('name'))
      ->joinLeft($uName, "$uName.category_id = $iName.category_id")
      ->group("$iName.category_id")
      ->where($uName.'.user_id = ?', $user_id)
      ;

    return $table->fetchAll($select);
  }
  public function getNewsPaginator($params = array())
  {
    return Zend_Paginator::factory($this->getNewsSelect($params));
  }
  public function getNewsSelect($params = array())
  {
    $table = Engine_Api::_()->getItemTable('news_new'); 
    $select = $table->select()->order('created DESC');
    // Search
    /*
    if( isset($params['search']) )
    {
      $select->where('search = ?', (bool) $params['search']);
    }
    // User-based
    if( !empty($params['owner']) && $params['owner'] instanceof Core_Model_Item_Abstract )
    {
      $select->where('user_id = ?', $params['owner']->getIdentity());
    }
    else if( !empty($params['user_id']) )
    {
      $select->where('user_id = ?', $params['user_id']);
    }
    else if( !empty($params['users']) && is_array($params['users']) )
    {
      foreach( $params['users'] as &$id ) if( !is_numeric($id) ) $id = 0;
      $params['users'] = array_filter($params['users']);
      $select->where('user_id IN(\''.join("', '", $params['users']).'\')');
    }
    */
    // Category
    //Zend_Debug::dump($params['users']);exit();
    if( !empty($params['category_id']) )
    {
      $select->where('category_id = ?', $params['category_id']);
    }
    // Order
    /*
    if( !empty($params['order']) )
    {
      $select->order($params['order']);
    }
    */
    //Zend_debug::dump($params['order']);exit();
    return $select;
  }
  
  function strip_html_tags( $text )
  {
    	// PHP's strip_tags() function will remove tags, but it
    	// doesn't remove scripts, styles, and other unwanted
    	// invisible text between tags.  Also, as a prelude to
    	// tokenizing the text, we need to insure that when
    	// block-level tags (such as <p> or <div>) are removed,
    	// neighboring words aren't joined.
    	$text = preg_replace(
		array(
			// Remove invisible content
			'@<head[^>]*?>.*?</head>@siu',
			'@<style[^>]*?>.*?</style>@siu',
			'@<script[^>]*?.*?</script>@siu',
			'@<object[^>]*?.*?</object>@siu',
			'@<embed[^>]*?.*?</embed>@siu',
			'@<applet[^>]*?.*?</applet>@siu',
			'@<noframes[^>]*?.*?</noframes>@siu',
			'@<noscript[^>]*?.*?</noscript>@siu',
			'@<noembed[^>]*?.*?</noembed>@siu',

			// Add line breaks before & after blocks
			'@<((br)|(hr))@iu',
			'@</?((address)|(blockquote)|(center)|(del))@iu',
			'@</?((div)|(h[1-9])|(ins)|(isindex)|(p)|(pre))@iu',
			'@</?((dir)|(dl)|(dt)|(dd)|(li)|(menu)|(ol)|(ul))@iu',
			'@</?((table)|(th)|(td)|(caption))@iu',
			'@</?((form)|(button)|(fieldset)|(legend)|(input))@iu',
			'@</?((label)|(select)|(optgroup)|(option)|(textarea))@iu',
			'@</?((frameset)|(frame)|(iframe))@iu',
		),
		array(
			' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
			"\n\$0", "\n\$0", "\n\$0", "\n\$0", "\n\$0", "\n\$0",
			"\n\$0", "\n\$0",
		),
		$text );

    	// Remove all remaining tags and comments and return.
    	return strip_tags( $text );
   }
   
   /**
     * Truncates text.
     *
     * Cuts a string to the length of $length and replaces the last characters
     * with the ending if the text is longer than length.
     *
     * @param string  $text String to truncate.
     * @param integer $length Length of returned string, including ellipsis.
     * @param mixed $ending If string, will be used as Ending and appended to the trimmed string. Can also be an associative array that can contain the last three params of this method.
     * @param boolean $exact If false, $text will not be cut mid-word
     * @param boolean $considerHtml If true, HTML tags would be handled correctly
     * @return string Trimmed string.
     */
	function truncate($text, $length = 100, $ending = '...', $exact = true, $considerHtml = false) {
		if (is_array($ending)) {
			extract($ending);
		}
		if ($considerHtml) {
			if (mb_strlen(preg_replace('/<.*?>/', '', $text)) <= $length) {
				return $text;
			}
			$totalLength = mb_strlen($ending);
			$openTags = array();
			$truncate = '';
			preg_match_all('/(<\/?([\w+]+)[^>]*>)?([^<>]*)/', $text, $tags, PREG_SET_ORDER);
			foreach ($tags as $tag) {
				if (!preg_match('/img|br|input|hr|area|base|basefont|col|frame|isindex|link|meta|param/s', $tag[2])) {
					if (preg_match('/<[\w]+[^>]*>/s', $tag[0])) {
						array_unshift($openTags, $tag[2]);
					} else if (preg_match('/<\/([\w]+)[^>]*>/s', $tag[0], $closeTag)) {
						$pos = array_search($closeTag[1], $openTags);
						if ($pos !== false) {
							array_splice($openTags, $pos, 1);
						}
					}
				}
				$truncate .= $tag[1];

				$contentLength = mb_strlen(preg_replace('/&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};/i', ' ', $tag[3]));
				if ($contentLength + $totalLength > $length) {
					$left = $length - $totalLength;
					$entitiesLength = 0;
					if (preg_match_all('/&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};/i', $tag[3], $entities, PREG_OFFSET_CAPTURE)) {
						foreach ($entities[0] as $entity) {
							if ($entity[1] + 1 - $entitiesLength <= $left) {
								$left--;
								$entitiesLength += mb_strlen($entity[0]);
							} else {
								break;
							}
						}
					}

					$truncate .= mb_substr($tag[3], 0 , $left + $entitiesLength);
					break;
				} else {
					$truncate .= $tag[3];
					$totalLength += $contentLength;
				}
				if ($totalLength >= $length) {
					break;
				}
			}

		} else {
			if (mb_strlen($text) <= $length) {
				return $text;
			} else {
				$truncate = mb_substr($text, 0, $length - strlen($ending));
			}
		}
		if (!$exact) {
			$spacepos = mb_strrpos($truncate, ' ');
			if (isset($spacepos)) {
				if ($considerHtml) {
					$bits = mb_substr($truncate, $spacepos);
					preg_match_all('/<\/([a-z]+)>/', $bits, $droppedTags, PREG_SET_ORDER);
					if (!empty($droppedTags)) {
						foreach ($droppedTags as $closingTag) {
							if (!in_array($closingTag[1], $openTags)) {
								array_unshift($openTags, $closingTag[1]);
							}
						}
					}
				}
				$truncate = mb_substr($truncate, 0, $spacepos);
			}
		}

		$truncate .= $ending;

		if ($considerHtml) {
			foreach ($openTags as $tag) {
				$truncate .= '</'.$tag.'>';
			}
		}

		return $truncate;
	}
    
    function getNews($news_id)
    {
        $table = Engine_Api::_()->getItemTable('news_new');
		
		$select = $table->select()
			         ->from($table)			
			         ->where('new_id = ?', $news_id);
	    return $table->fetchRow($select);
    }
    
    // get other News
    function getOtherNews($news_id, $cat_id){
        $table = Engine_Api::_()->getItemTable('news_new');
		
		$select1 = $table->select()
			  ->from($table, new Zend_Db_Expr('new_id, title'))
			  ->order('created DESC')
			  ->where('category_id =?', $cat_id)
			  ->where('new_id <?', $news_id)
			  ->limit(2);
	    $old = $table->fetchAll($select1);
	    
	     
	    $select2 = $table->select()
			  ->from($table,new Zend_Db_Expr('new_id, title'))
			  ->order('created DESC')                        
			  ->where('category_id =?', $cat_id)
			  ->where('new_id >?', $news_id)
			  ->limit(8);
	    $new = $table->fetchAll($select2);
        
	    return array("new"=>$new, "old"=>$old);
	    
    }
    
    // delete image
    function deleteFile($file_id){
        $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        
        try
        {
           $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($file_id)->current();
           $file_path = $path.$storage->storage_path;
           $storage->delete();
           $db->commit();
           @unlink($file_path);
        }
        catch( Exception $e )
        {
          $db->rollBack();
          throw $e;
        }
    }
  
}