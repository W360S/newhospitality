<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: mix-info.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
foreach ($this->sugg_object as $row_mix_key => $row_mix_value) {
    switch ($row_mix_key) {
        // Display Video.	
        case 'video':
            ?>
            <?php
            if ($row_mix_value[0] != 'msg') {
                ?>
                <script type="text/javascript">
                    var add_id = "<?php echo 'video_' . $row_mix_value[0]->video_id; ?>";
                    // Suggestion which are "Disply" in the widget.
                    display_sugg += ',' + add_id;
                </script>						

                <div class="suggestion_list">						
                    <div class="item_photo">
                        <?php
                        if ($row_mix_value[0]->photo_id)
                            echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal'));
                        else
                            echo '<img alt="" src="application/modules/Video/externals/images/video.png">';
                        ?>
                    </div>								
                    <div class="item_details">
                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->video_id . ', \'' . $this->div_id . '\', \'video\', \'' . $this->page_name . '\');"></a>'; ?>
                        <b><?php
                            if ($this->page_name == 'new') {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                            } else {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                            }
                            ?></b>
                        <div class="item_members">
                            <?php
                            echo $this->translate('by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
                            echo '<div>' . $this->translate(array(' %s view', ' %s views', $row_mix_value[0]->view_count), $this->locale()->toNumber($row_mix_value[0]->view_count)) . '</div>';
                            ?>
                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Video'), array('class' => 'buttonlink notification_type_video_suggestion')); ?>
                        </div>		
                    </div>
                </div>

                <div style="clear:both"></div>
                <?php
            }
            // If no suggestion available.
            else {
                $current_display_sugg = --$this->display_suggestion;
                // In widget if no record available then show message.
                if ($current_display_sugg == 0) {
                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                }
                // Decrement in "Display suggestion in Widget".
                else {
                    // Decrement in "Video Widget" Java-script variable.
                    if ($this->page_name == 'video') {
                        ?>
                        <script type="text/javascript">
                            video_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                    // Decrement in "Mix Widget" Java-script variable.
                    elseif ($this->page_name == 'mix') {
                        ?>
                        <script type="text/javascript">
                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                    // Decrement in "Explore Friend Widget" Java-script variable.
                    elseif ($this->page_name == 'new') {
                        ?>
                        <script type="text/javascript">
                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                }
            }
            break;

        // Display Album.	
        case 'album':
            ?>
            <?php
            if ($row_mix_value[0] != 'msg') {
                ?>
                <script type="text/javascript">
                    var add_id = "<?php echo 'album_' . $row_mix_value[0]->album_id; ?>";
                    // Suggestion which are "Disply" in the widget.
                    display_sugg += ',' + add_id;
                </script>						
                <div class="suggestion_list">						
                    <div class="item_photo">
                        <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
                    </div>								
                    <div class="item_details">
                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->album_id . ', \'' . $this->div_id . '\', \'album\', \'' . $this->page_name . '\');"></a>'; ?>
                        <b><?php
                            if ($this->page_name == 'new') {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                            } else {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                            }
                            ?></b>								
                        <div class="item_members">
                            <?php
                            echo $this->translate('By ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
                            echo '<div>' . $this->translate(array(' %s photo ', ' %s photos ', $row_mix_value[0]->count()), $this->locale()->toNumber($row_mix_value[0]->count())) . '</div>';
                            echo '<div>' . $this->timestamp($row_mix_value[0]->modified_date) . '</div>';
                            ?>
                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Album'), array('class' => 'buttonlink notification_type_album_suggestion')); ?>
                        </div>
                    </div>
                </div>

                <div style="clear:both"></div>
                <?php
            }
            // If no suggestion available.
            else {
                $current_display_sugg = --$this->display_suggestion;
                // In widget if no record available then show message.
                if ($current_display_sugg == 0) {
                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                }
                // Decrement in "Display suggestion in Widget".
                else {
                    // Decrement in "Album Widget" Java-script variable.
                    if ($this->page_name == 'album') {
                        ?>
                        <script type="text/javascript">
                            album_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                    // Decrement in "Mix Widget" Java-script variable.
                    elseif ($this->page_name == 'mix') {
                        ?>
                        <script type="text/javascript">
                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                    // Decrement in "Explore Friend Widget" Java-script variable.
                    elseif ($this->page_name == 'new') {
                        ?>
                        <script type="text/javascript">
                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                }
            }
            break;

        // Display Group.	
        case 'group':
            ?>
            <?php
            if ($row_mix_value[0] != 'msg') {
                ?>
                <script type="text/javascript">
                    var add_id = "<?php echo 'group_' . $row_mix_value[0]->group_id; ?>";
                    // Suggestion which are "Disply" in the widget.
                    display_sugg += ',' + add_id;
                </script>						

                <div class="suggestion_list">						
                    <div class="item_photo">
                        <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
                    </div>								
                    <div class="item_details">
                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->group_id . ', \'' . $this->div_id . '\', \'group\', \'' . $this->page_name . '\');"></a>'; ?>
                        <b><?php
                            if ($this->page_name == 'new') {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                            } else {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                            }
                            ?></b>								
                        <div class="item_members">
                            <?php
                            echo $this->translate(array('%s member', '%s members', $row_mix_value[0]->membership()->getMemberCount()), $this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
                            echo $this->translate(' led by ');
                            echo $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
                            ?>
                        </div>
                        <div>
                            <?php
                            //Add group option.
                            if ($this->viewer()->getIdentity()):
                                if (!$row_mix_value[0]->membership()->isMember($this->viewer(), null)):
                                    echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Group'), array('class' => 'buttonlink smoothbox icon_group_join', 'style' => 'clear:both;'));
                                endif;
                            endif;
                            ?>
                        </div>
                    </div>

                </div>

                <div style="clear:both"></div>
                <?php
            }
            // If no suggestion available.
            else {
                $current_display_sugg = --$this->display_suggestion;
                // In widget if no record available then show message.
                if ($current_display_sugg == 0) {
                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                }
                // Decrement in "Display suggestion in Widget".
                else {
                    // Decrement in "group Widget" Java-script variable.
                    if ($this->page_name == 'group') {
                        ?>
                        <script type="text/javascript">
                            group_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                    // Decrement in "Mix Widget" Java-script variable.
                    elseif ($this->page_name == 'mix') {
                        ?>
                        <script type="text/javascript">
                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                    // Decrement in "Explore Friend Widget" Java-script variable.
                    elseif ($this->page_name == 'new') {
                        ?>
                        <script type="text/javascript">
                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                        </script>			
                        <?php
                    }
                }
            }
            break;

        // Display event.	
        case 'event':
            ?>
            <?php
            if ($row_mix_value[0] != 'msg') {
                ?>
                <script type="text/javascript">
                    var add_id = "<?php echo 'event_' . $row_mix_value[0]->event_id; ?>";
                    // Suggestion which are "Disply" in the widget.
                    display_sugg += ',' + add_id;
                </script>						

                <div class="suggestion_list">						
                    <div class="item_photo">
                        <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
                    </div>							
                    <div class="item_details">
                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->event_id . ', \'' . $this->div_id . '\', \'event\', \'' . $this->page_name . '\');"></a>'; ?>
                        <b><?php
                            if ($this->page_name == 'new') {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                            } else {
                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                            }
                            ?></b>
                        <div class="item_members">
                            <?php
                            echo $this->dateTime($row_mix_value[0]->starttime) . ' | ';
                            echo $this->translate(array('%s guest', '%s guests', $row_mix_value[0]->membership()->getMemberCount()), $this->locale()->toNumber($row_mix_value[0]->membership()->getMemberCount()));
                            echo $this->translate(' led by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
                            ?>
                        </div>
                        <div>	
                            <?php
                            //Event Relationship.
                            if (($this->filter != "past") && $this->viewer()->getIdentity() && !$row_mix_value[0]->membership()->isMember($this->viewer(), null)):
                                echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'member', 'action' => 'join', 'event_id' => $row_mix_value[0]->getIdentity()), $this->translate('Join Event'), array('class' => 'buttonlink smoothbox icon_event_join'));
                            endif;
                            ?>
                        </div>

                        <div style="clear:both"></div>
                        <?php
                    }
                    // If no suggestion available.
                    else {
                        $current_display_sugg = --$this->display_suggestion;
                        // In widget if no record available then show message.
                        if ($current_display_sugg == 0) {
                            echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                        }
                        // Decrement in "Display suggestion in Widget".
                        else {
                            // Decrement in "event Widget" Java-script variable.
                            if ($this->page_name == 'event') {
                                ?>
                                <script type="text/javascript">
                                    event_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                </script>			
                                <?php
                            }
                            // Decrement in "Mix Widget" Java-script variable.
                            elseif ($this->page_name == 'mix') {
                                ?>
                                <script type="text/javascript">
                                    mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                </script>			
                                <?php
                            }
                            // Decrement in "Explore Friend Widget" Java-script variable.
                            elseif ($this->page_name == 'new') {
                                ?>
                                <script type="text/javascript">
                                    explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                </script>			
                                <?php
                            }
                        }
                    }
                    break;

                // Display friend.	
                case 'friend':
                    ?>
                    <?php
                    if ($row_mix_value[0] != 'msg') {
                        ?>
                        
                        <?php $path_info = $row_mix_value[0]; ?>
                        <div class="pt-user-post">				
                            <a href="<?php echo $path_info->getHref() ?>">
                                <span class="pt-avatar">
                                    <?php echo $this->itemPhoto($path_info, 'thumb.icon') ?>
                                </span>
                            </a>
                            <div class="pt-how-info-user-post">
                                <h3><a href="<?php echo $path_info->getHref() ?>"><?php echo $path_info->getTitle() ?></a></h3>
                                <p>
                                    <?php
                                    if (!empty($this->mutual_friend_array[$path_info->user_id])) :
                                        echo '<a class="smoothbox" style="color:#656565" href="' . $this->url(array('module' => 'suggestion', 'controller' => 'index', 'action' => 'mutualfriend', 'sugg_friend_id' => $path_info->user_id), 'default', true) . '">' . $this->translate(array('%s mutual friend', '%s mutual friends', $this->mutual_friend_array[$path_info->user_id]), $this->locale()->toNumber($this->mutual_friend_array[$path_info->user_id])) . '</a>';
                                    endif;
                                    ?>
                                </p>

                            </div>
                            <?php echo $this->userFriendship($path_info, null, " pt-link-add"); ?>
                            <div style="display:none">
                                <form enctype="application/x-www-form-urlencoded" id="ajax-add-friend-<?php echo $path_info->user_id ?>" action="/members/friends/add/user_id/<?php echo $path_info->user_id ?>">

                                </form>
                            </div>			
                        </div>

                        						

                        
                                <?php
                            }
                            // If no suggestion available.
                            else {
                                $current_display_sugg = --$this->display_suggestion;
                                // In widget if no record available then show message.
                                if ($current_display_sugg == 0) {
                                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                                }
                                // Decrement in "Display suggestion in Widget".
                                else {
                                    // Decrement in "friend Widget" Java-script variable.
                                    if ($this->page_name == 'friend') {
                                        ?>
                                        <script type="text/javascript">
                                            friend_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Mix Widget" Java-script variable.
                                    elseif ($this->page_name == 'mix') {
                                        ?>
                                        <script type="text/javascript">
                                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Explore Friend Widget" Java-script variable.
                                    elseif ($this->page_name == 'new') {
                                        ?>
                                        <script type="text/javascript">
                                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                }
                            }
                            break;

                        // Display blog.	
                        case 'blog':
                            ?>
                            <?php
                            if ($row_mix_value[0] != 'msg') {
                                ?>
                                <script type="text/javascript">
                                    var add_id = "<?php echo 'blog_' . $row_mix_value[0]->blog_id; ?>";
                                    // Suggestion which are "Disply" in the widget.
                                    display_sugg += ',' + add_id;
                                </script>						

                                <div class="suggestion_list">						
                                    <div class="item_photo">
                                        <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.icon')); ?>
                                    </div>								
                                    <div class="item_details">
                                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->blog_id . ', \'' . $this->div_id . '\', \'blog\', \'' . $this->page_name . '\');"></a>'; ?>
                                        <b><?php
                                            if ($this->page_name == 'new') {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                            } else {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                            }
                                            ?></b>								
                                        <div class="item_members">
                                            <div>
                                                <?php
                                                echo $this->translate(' Posted ') . $this->timestamp(strtotime($row_mix_value[0]->creation_date));
                                                echo $this->translate(' by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
                                                ?></div>
                                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Blog'), array('class' => 'buttonlink notification_type_blog_suggestion')); ?>
                                        </div>
                                    </div>
                                </div>						
                                <div style="clear:both"></div>
                                <?php
                            }
                            // If no suggestion available.
                            else {
                                $current_display_sugg = --$this->display_suggestion;
                                // In widget if no record available then show message.
                                if ($current_display_sugg == 0) {
                                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                                }
                                // Decrement in "Display suggestion in Widget".
                                else {
                                    // Decrement in "blog Widget" Java-script variable.
                                    if ($this->page_name == 'blog') {
                                        ?>
                                        <script type="text/javascript">
                                            blog_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Mix Widget" Java-script variable.
                                    elseif ($this->page_name == 'mix') {
                                        ?>
                                        <script type="text/javascript">
                                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Explore Friend Widget" Java-script variable.
                                    elseif ($this->page_name == 'new') {
                                        ?>
                                        <script type="text/javascript">
                                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                }
                            }
                            break;

                        // Display classified.	
                        case 'classified':
                            ?>
                            <?php
                            if ($row_mix_value[0] != 'msg') {
                                ?>
                                <script type="text/javascript">
                                    var add_id = "<?php echo 'classified_' . $row_mix_value[0]->classified_id; ?>";
                                    // Suggestion which are "Disply" in the widget.
                                    display_sugg += ',' + add_id;
                                </script>						

                                <div class="suggestion_list">						
                                    <div class="item_photo">
                                        <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal')); ?>
                                    </div>								
                                    <div class="item_details">
                                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->classified_id . ', \'' . $this->div_id . '\', \'classified\', \'' . $this->page_name . '\');"></a>'; ?>
                                        <b><?php
                                            if ($this->page_name == 'new') {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                            } else {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                            }
                                            ?></b>
                                        <div class="item_members">
                                            <div>
                                                <?php
                                                echo $this->translate('Posted ') . $this->timestamp(strtotime($row_mix_value[0]->creation_date));
                                                echo $this->translate(' by ') . $this->htmlLink($row_mix_value[0]->getOwner()->getHref(), $row_mix_value[0]->getOwner()->getTitle());
                                                ?></div>
                                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Classified'), array('class' => 'buttonlink notification_type_classified_suggestion')); ?>
                                        </div>
                                    </div>
                                </div>

                                <div style="clear:both"></div>
                                <?php
                            }
                            // If no suggestion available.
                            else {
                                $current_display_sugg = --$this->display_suggestion;
                                // In widget if no record available then show message.
                                if ($current_display_sugg == 0) {
                                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                                }
                                // Decrement in "Display suggestion in Widget".
                                else {
                                    // Decrement in "classified Widget" Java-script variable.
                                    if ($this->page_name == 'classified') {
                                        ?>
                                        <script type="text/javascript">
                                            classified_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Mix Widget" Java-script variable.
                                    elseif ($this->page_name == 'mix') {
                                        ?>
                                        <script type="text/javascript">
                                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Explore Friend Widget" Java-script variable.
                                    elseif ($this->page_name == 'new') {
                                        ?>
                                        <script type="text/javascript">
                                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                }
                            }
                            break;

                        // Display music.	
                        case 'music':
                            ?>
                            <?php
                            if ($row_mix_value[0] != 'msg') {
                                ?>
                                <script type="text/javascript">
                                    var add_id = "<?php echo 'music_' . $row_mix_value[0]->playlist_id; ?>";
                                    // Suggestion which are "Disply" in the widget.
                                    display_sugg += ',' + add_id;
                                </script>						

                                <div class="suggestion_list">						
                                    <div class="item_photo">
                                        <?php
                                        if ($row_mix_value[0]->photo_id)
                                            echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.normal'));
                                        else
                                            echo '<img alt="" src="application/modules/Music/externals/images/nophoto_playlist_thumb_icon.png" />';
                                        ?>
                                    </div>								
                                    <div class="item_details">
                                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->playlist_id . ', \'' . $this->div_id . '\', \'music\', \'' . $this->page_name . '\');"></a>'; ?>
                                        <b><?php
                                            if ($this->page_name == 'new') {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                            } else {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                            }
                                            ?></b>
                                        <div class="item_members">
                                            <div>
                                                <?php echo $this->translate('Created %s by ', $this->timestamp($row_mix_value[0]->creation_date)) . $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle());
                                                ?>
                                            </div>
                                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('Listen to Music'), array('class' => 'buttonlink notification_type_music_suggestion')); ?>
                                        </div>
                                    </div>
                                </div>

                                <div style="clear:both"></div>
                                <?php
                            }
                            // If no suggestion available.
                            else {
                                $current_display_sugg = --$this->display_suggestion;
                                // In widget if no record available then show message.
                                if ($current_display_sugg == 0) {
                                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                                }
                                // Decrement in "Display suggestion in Widget".
                                else {
                                    // Decrement in "music Widget" Java-script variable.
                                    if ($this->page_name == 'music') {
                                        ?>
                                        <script type="text/javascript">
                                            music_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Mix Widget" Java-script variable.
                                    elseif ($this->page_name == 'mix') {
                                        ?>
                                        <script type="text/javascript">
                                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Explore Friend Widget" Java-script variable.
                                    elseif ($this->page_name == 'new') {
                                        ?>
                                        <script type="text/javascript">
                                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                }
                            }
                            break;

                        // Display poll.	
                        case 'poll':
                            ?>
                            <?php
                            if ($row_mix_value[0] != 'msg') {
                                ?>
                                <script type="text/javascript">
                                    var add_id = "<?php echo 'poll_' . $row_mix_value[0]->poll_id; ?>";
                                    // Suggestion which are "Disply" in the widget.
                                    display_sugg += ',' + add_id;
                                </script>						

                                <div class="suggestion_list">						
                                    <div class="item_photo">
                                        <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0]->getOwner(), 'thumb.icon', $row_mix_value[0]->getOwner()->username)); ?>
                                    </div>								
                                    <div class="item_details">
                                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->poll_id . ', \'' . $this->div_id . '\', \'poll\', \'' . $this->page_name . '\');"></a>'; ?>
                                        <b><?php
                                            if ($this->page_name == 'new') {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                            } else {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                            }
                                            ?></b>
                                        <div class="item_members">
                                            <?php echo $this->translate('Posted by %s ', $this->htmlLink($row_mix_value[0]->getOwner(), $row_mix_value[0]->getOwner()->getTitle()));
                                            ?><div><?php
                                                echo $this->timestamp($row_mix_value[0]->creation_date);
                                                echo $this->translate(array(' - %s vote', ' - %s votes', $row_mix_value[0]->voteCount()), $this->locale()->toNumber($row_mix_value[0]->voteCount()));
                                                echo $this->translate(array(' - %s view', ' - %s views', $row_mix_value[0]->views), $this->locale()->toNumber($row_mix_value[0]->views));
                                                ?></div>
                                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('Vote on Poll'), array('class' => 'buttonlink notification_type_poll_suggestion')); ?>
                                        </div>	
                                    </div>
                                </div>

                                <div style="clear:both"></div>
                                <?php
                            }
                            // If no suggestion available.
                            else {
                                $current_display_sugg = --$this->display_suggestion;
                                // In widget if no record available then show message.
                                if ($current_display_sugg == 0) {
                                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                                }
                                // Decrement in "Display suggestion in Widget".
                                else {
                                    // Decrement in "poll Widget" Java-script variable.
                                    if ($this->page_name == 'poll') {
                                        ?>
                                        <script type="text/javascript">
                                            poll_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Mix Widget" Java-script variable.
                                    elseif ($this->page_name == 'mix') {
                                        ?>
                                        <script type="text/javascript">
                                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Explore Friend Widget" Java-script variable.
                                    elseif ($this->page_name == 'new') {
                                        ?>
                                        <script type="text/javascript">
                                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                }
                            }
                            break;

                        // Display forum.	
                        case 'forum':
                            ?>
                            <?php
                            if ($row_mix_value[0] != 'msg') {
                                ?>
                                <script type="text/javascript">
                                    var add_id = "<?php echo 'forum_' . $row_mix_value[0]->topic_id; ?>";
                                    // Suggestion which are "Disply" in the widget.
                                    display_sugg += ',' + add_id;
                                </script>						
                                <div class="suggestion_list">					
                                    <?php $forum_name = Engine_Api::_()->getItem('forum_forum', $row_mix_value[0]->forum_id); ?>	
                                    <div class="item_photo">
                                        <?php $photo_obj = Engine_Api::_()->getItem('user', $row_mix_value[0]->user_id); ?>
                                        <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($photo_obj->getOwner(), 'thumb.icon')); ?>
                                    </div>										
                                    <div class="item_details">
                                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->topic_id . ', \'' . $this->div_id . '\', \'forum\', \'' . $this->page_name . '\');"></a>'; ?>
                                        <b><?php
                                            if ($this->page_name == 'new') {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                            } else {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                            }
                                            ?></b>
                                        <div class="item_members">
                                            <?php
                                            if ($this->page_name == 'new') {
                                                echo $this->translate(' in ') . $this->htmlLink($forum_name->getHref(), $forum_name->getTitle(), array('title' => $forum_name->getTitle()));
                                            } else {
                                                echo $this->translate(' in ') . $this->htmlLink($forum_name->getHref(), Engine_Api::_()->suggestion()->truncateTitle($forum_name->getTitle()), array('title' => $forum_name->getTitle()));
                                            }
                                            ?>
                                            <div>
                                                <?php
                                                echo $this->translate(array('%s Reply', '%s Replies', $row_mix_value[0]->post_count), $this->locale()->toNumber($row_mix_value[0]->post_count)) . ' | ' . $this->translate(array('%s View', '%s Views', $row_mix_value[0]->view_count), $this->locale()->toNumber($row_mix_value[0]->view_count)) . '<br/>';
                                                $category_title = Engine_Api::_()->getItem('forum_category', $forum_name->category_id)->title;
                                                echo $this->translate('Category : ') . $category_title;
                                                ?>		
                                            </div>
                                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->translate('View Forum Topic'), array('class' => 'buttonlink notification_type_forum_suggestion')); ?>
                                        </div>	
                                    </div>
                                </div>
                                <div style="clear:both"></div>
                                <?php
                            }
                            // If no suggestion available.
                            else {
                                $current_display_sugg = --$this->display_suggestion;
                                // In widget if no record available then show message.
                                if ($current_display_sugg == 0) {
                                    echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                                }
                                // Decrement in "Display suggestion in Widget".
                                else {
                                    // Decrement in "forum Widget" Java-script variable.
                                    if ($this->page_name == 'forum') {
                                        ?>
                                        <script type="text/javascript">
                                            forum_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Mix Widget" Java-script variable.
                                    elseif ($this->page_name == 'mix') {
                                        ?>
                                        <script type="text/javascript">
                                            mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                    // Decrement in "Explore Friend Widget" Java-script variable.
                                    elseif ($this->page_name == 'new') {
                                        ?>
                                        <script type="text/javascript">
                                            explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                        </script>			
                                        <?php
                                    }
                                }
                            }
                            break;

                        // Display MessageFriend.	
                        case 'messagefriend':
                            ?>
                            <?php
                            if ($row_mix_value[0] != 'msg') {
                                ?>
                                <script type="text/javascript">
                                    var add_id = "<?php echo 'messagefriend_' . $row_mix_value[0]->user_id; ?>";
                                    // Suggestion which are "Disply" in the widget.
                                    display_sugg += ',' + add_id;
                                </script>						
                                <div class="suggestion_list">									
                                    <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.icon'), array('class' => 'item_photo')); ?>
                                    <div class="item_details">
                                        <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->user_id . ', \'' . $this->div_id . '\', \'messagefriend\', \'' . $this->page_name . '\');"></a>'; ?>
                                        <b><?php
                                            if ($this->page_name == 'new') {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                            } else {
                                                echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                            }
                                            ?></b>
                                        <div class="item_members">
                                            <?php
                                            $site_name = Engine_Api::_()->getApi('settings', 'core')->getSetting('core.general.site.title');
                                            echo $this->translate("You haven't talked on") . ' ' . $site_name . ' ' . $this->translate(" lately.");
                                            ?>
                                        </div>
                                        <div><a style="background-image: url('application/modules/Messages/externals/images/send.png');" class="buttonlink" href="<?php echo $this->sugg_baseUrl; ?>/messages/compose/to/<?php echo $row_mix_value[0]->user_id; ?>"><?php echo $this->translate('Send Message'); ?></a></div>
                                    </div>
                                </div>
                            </div>
                            <div style="clear:both"></div>
                            <?php
                        }
                        // If no suggestion available.
                        else {
                            $current_display_sugg = --$this->display_suggestion;
                            // In widget if no record available then show message.
                            if ($current_display_sugg == 0) {
                                echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                            }
                            // Decrement in "Display suggestion in Widget".
                            else {
                                if ($this->page_name == 'mix') {
                                    ?>
                                    <script type="text/javascript">
                                        mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                    </script>			
                                    <?php
                                }
                                // Decrement in "Explore Friend Widget" Java-script variable.
                                elseif ($this->page_name == 'new') {
                                    ?>
                                    <script type="text/javascript">
                                        explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                    </script>			
                                    <?php
                                }
                            }
                        }
                        break;

                    // Display MessageFriend.	
                    case 'friendfewfriend':
                        ?>
                        <?php
                        if ($row_mix_value[0] != 'msg') {
                            ?>
                            <script type="text/javascript">
                                var add_id = "<?php echo 'friendfewfriend_' . $row_mix_value[0]->user_id; ?>";
                                // Suggestion which are "Disply" in the widget.
                                display_sugg += ',' + add_id;
                            </script>						
                            <div class="suggestion_list">									
                                <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.icon'), array('class' => 'item_photo')); ?>
                                <div class="item_details">
                                    <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->user_id . ', \'' . $this->div_id . '\', \'friendfewfriend\', \'' . $this->page_name . '\');"></a>'; ?>
                                    <b><?php
                                        if ($this->page_name == 'new') {
                                            echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                        } else {
                                            echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                        }
                                        ?></b>
                                    <div class="item_members">
                                        <?php echo $this->translate('Help ') . $row_mix_value[0]->displayname . $this->translate(' find more friends.'); ?>
                                    </div>
                                    <div><?php
                                        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
                                        // Check that if friend have at least 1 suggestion then open popup else popup will not open.											
                                        $check_network_friend = Engine_Api::_()->suggestion()->few_friend_suggestion($user_id, $row_mix_value[0]->user_id, '', 1, '');
                                        echo '<a href="javascript:void(0);" onclick="fewPopup(' . $row_mix_value[0]->user_id . ');" class="buttonlink notification_type_friend_suggestion">' . $this->translate("Suggest Friends") . '</a>';
                                        ?></div>
                                </div>
                            </div>
                        </div>
                        <div style="clear:both"></div>
                        <?php
                    }
                    // If no suggestion available.
                    else {
                        $current_display_sugg = --$this->display_suggestion;
                        // In widget if no record available then show message.
                        if ($current_display_sugg == 0) {
                            echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                        }
                        // Decrement in "Display suggestion in Widget".
                        else {
                            if ($this->page_name == 'mix') {
                                ?>
                                <script type="text/javascript">
                                    mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                </script>			
                                <?php
                            }
                            // Decrement in "Explore Friend Widget" Java-script variable.
                            elseif ($this->page_name == 'new') {
                                ?>
                                <script type="text/javascript">
                                    explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                                </script>			
                                <?php
                            }
                        }
                    }
                    break;

                // Display MessageFriend.	
                case 'friendphoto':
                    ?>
                    <?php
                    if ($row_mix_value[0] != 'msg') {
                        ?>
                        <script type="text/javascript">
                            var add_id = "<?php echo 'friendphoto_' . $row_mix_value[0]->user_id; ?>";
                            // Suggestion which are "Disply" in the widget.
                            display_sugg += ',' + add_id;
                        </script>						
                        <div class="suggestion_list" >									
                            <?php echo $this->htmlLink($row_mix_value[0]->getHref(), $this->itemPhoto($row_mix_value[0], 'thumb.icon'), array('class' => 'item_photo')); ?>
                            <div class="item_details">
                                <?php echo '<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $row_mix_value[0]->user_id . ', \'' . $this->div_id . '\', \'friendphoto\', \'' . $this->page_name . '\');"></a>'; ?>
                                <b><?php
                                    if ($this->page_name == 'new') {
                                        echo $this->htmlLink($row_mix_value[0]->getHref(), $row_mix_value[0]->getTitle(), array('title' => $row_mix_value[0]->getTitle()));
                                    } else {
                                        echo $this->htmlLink($row_mix_value[0]->getHref(), Engine_Api::_()->suggestion()->truncateTitle($row_mix_value[0]->getTitle()), array('title' => $row_mix_value[0]->getTitle()));
                                    }
                                    ?></b>
                                <div class="item_members">
                                    <?php echo $row_mix_value[0]->getTitle() . ' ' . $this->translate('needs a profile picture.'); ?>
                                </div>
                                <div><?php echo $this->htmlLink(array('route' => 'default', 'module' => 'suggestion', 'controller' => 'index', 'action' => 'profile-picture', 'id' => $row_mix_value[0]->user_id), $this->translate('Suggest Picture'), array('class' => 'buttonlink notification_type_picture_suggestion smoothbox')); ?></div>
                            </div>
                        </div>
                    </div>
                    <div style="clear:both"></div>
                    <?php
                }
                // If no suggestion available.
                else {
                    $current_display_sugg = --$this->display_suggestion;
                    // In widget if no record available then show message.
                    if ($current_display_sugg == 0) {
                        echo "<div class='tip'><span> " . $this->translate("You do not have any more ") . $this->page_name . $this->translate(" suggestions.") . "</span></div>";
                    }
                    // Decrement in "Display suggestion in Widget".
                    else {
                        if ($this->page_name == 'mix') {
                            ?>
                            <script type="text/javascript">
                                mix_suggestion_display = '<?php echo $current_display_sugg; ?>';
                            </script>			
                            <?php
                        }
                        // Decrement in "Explore Friend Widget" Java-script variable.
                        elseif ($this->page_name == 'new') {
                            ?>
                            <script type="text/javascript">
                                explore_suggestion_display = '<?php echo $current_display_sugg; ?>';
                            </script>			
                            <?php
                        }
                    }
                }
                break;
        }
    }
    ?>