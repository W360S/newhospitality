<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: content.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 * 
 */
return array(
    array(
        'title' => 'Upcoming Events',
        'description' => 'Displays the logged-in member\'s upcoming events.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.home-upcoming',
        'adminForm' => array(
            'elements' => array(
                array(
                    'Text',
                    'title',
                    array(
                        'label' => 'Title'
                    )
                ),
                array(
                    'Radio',
                    'type',
                    array(
                        'label' => 'Show',
                        'multiOptions' => array(
                            '1' => 'Any upcoming events.',
                            '2' => 'Current member\'s upcoming events.',
                            '0' => 'Any upcoming events when member is logged out, that member\'s events when logged in.',
                        ),
                        'value' => '0',
                    )
                ),
            )
        ),
    ),
    array(
        'title' => 'Profile Events',
        'description' => 'Displays a member\'s events on their profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-events',
        'defaultParams' => array(
            'title' => 'Events',
            'titleCount' => true,
        ),
    ),
    array(
        'title' => 'Event Profile Discussions',
        'description' => 'Displays a event\'s discussions on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-discussions',
    ),
    array(
        'title' => 'Event Profile Info',
        'description' => 'Displays a event\'s info (creation date, member count, etc) on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-info',
    ),
    array(
        'title' => 'Event Profile Members',
        'description' => 'Displays a event\'s members on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-members',
    ),
    array(
        'title' => 'Event Profile Options',
        'description' => 'Displays a menu of actions (edit, report, join, invite, etc) that can be performed on a event on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-options',
    ),
    array(
        'title' => 'Event Profile Photo',
        'description' => 'Displays a event\'s photo on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-photo',
    ),
    array(
        'title' => 'Event Profile Photos',
        'description' => 'Displays a event\'s photos on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-photos',
    ),
    array(
        'title' => 'Event Profile RSVP',
        'description' => 'Displays options for RSVP\'ing to an event on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-rsvp',
    ),
    array(
        'title' => 'Event Profile Status',
        'description' => 'Displays a event\'s title on it\'s profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-status',
    ),
    array(
        'title' => 'List Event',
        'description' => 'Display event home.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.list-events',
    ),
    array(
        'title' => 'List event my page',
        'description' => 'Display event my page.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.mypage-events',
    ),
    array(
        'title' => 'Ad Event',
        'description' => 'Display ad.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.ad',
    ),
    array(
        'title' => 'Event Detail left advertisement',
        'description' => 'Event Detail left advertisement',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.event-left-ads',
    ),
    array(
        'title' => 'Feature Event',
        'description' => 'Display feature event.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.feature',
    ),
    array(
        'title' => 'Navigation Event',
        'description' => 'Display navigation event.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.navigation',
    ),
    array(
        'title' => 'Profile Feature Event',
        'description' => 'Display event in profile.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.profile-featured',
    ),
    array(
        'title' => 'Detail Event',
        'description' => 'Display detail event.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.detail-event',
    ),
    array(
        'title' => 'Category',
        'description' => 'Display category.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.categories',
    ),
    array(
        'title' => 'Category',
        'description' => 'categories.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.my-categories',
    ),
    array(
        'title' => 'Search',
        'description' => 'Search event.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.search',
    ),
    array(
        'title' => 'Search',
        'description' => 'Search event.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.search-my-events',
    ),
    array(
        'title' => 'Upcoming Events',
        'description' => 'Displays upcoming events.',
        'category' => 'Event',
        'type' => 'widget',
        'name' => 'event.upcoming-events',
    ),
        )
?>