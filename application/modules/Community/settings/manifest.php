<?php

return array(
    'package' =>
    array(
        'type' => 'module',
        'name' => 'community',
        'version' => '4.0.03',
        'path' => 'application/modules/Community',
        'meta' =>
        array(
            'title' => 'community',
            'description' => 'community',
            'author' => 'haidq',
        ),
        'callback' =>
        array(
            'class' => 'Engine_Package_Installer_Module',
        ),
        'actions' =>
        array(
            0 => 'install',
            1 => 'upgrade',
            2 => 'refresh',
            3 => 'enable',
            4 => 'disable',
        ),
        'directories' =>
        array(
            0 => 'application/modules/Community',
        ),
        'files' =>
        array(
            0 => 'application/languages/en/community.csv',
        ),
    ),
);
?>