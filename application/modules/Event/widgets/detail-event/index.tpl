<style type="text/css">
    .profile_event_info {
        border:0 none;
        border-collapse:collapse;
        border-spacing:0;
        width:100%;
    }
    .profile_event_info th.label, .view_more_event, .after_view_more {
        color:#999999;
        font-weight:bold;
        line-height:15px;
        text-align:left;
        vertical-align:top;
        width:100px;
    }
    .profile_event_info td.data {
        line-height:15px;
    }
    .profile_event_info tr.space hr {
        background:#E9E9E9 none repeat scroll 0 0;
        border-bottom:0 solid;
        border-style:solid;
        color:#E9E9E9;
    }
    hr {
        border-width:0;
        height:1px;
    }
    div .view_more_event {
        padding-right:10px;
    }

    .more_info_display{
        display:block;
    }
    .more_info{
        padding-bottom: 10px;
    }
</style>
<script type="text/javascript">
    window.addEvent('domready', function(){
    $('view_more').addEvent('click', function(event){
    $('more_info').removeClass('more_info').addClass('more_info_display');
    $('view_more').removeClass('view_more_event').addClass('after_view_more');
});	
});
</script>
<div class="contentArea">
    <div class="event_info_section">
        <?php
        // Convert the dates for the viewer
        $startDateObject = new Zend_Date(strtotime($this->subject->starttime));
        $endDateObject = new Zend_Date(strtotime($this->subject->endtime));
        if( $this->viewer() && $this->viewer()->getIdentity() ) {
	        $tz = $this->viewer()->timezone;
	        $startDateObject->setTimezone($tz);
	        $endDateObject->setTimezone($tz);
        }
        ?>
        <?php ?>
        <table class="profile_event_info">
            <?php if( $this->subject->starttime == $this->subject->endtime ): ?>  
            <tr>
                <th class="label">
                    <?php echo $this->translate('Date') ?>
                </th>
                <td class="data">
                    <?php echo  date('D, d F Y',strtotime($this->subject->starttime)); ?>
                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <tr>
                <th class="label">
                    <?php echo $this->translate('Time') ?>
                </th>
                <td class="data">
                    <?php echo  date('g:i:a',strtotime($this->subject->starttime)); ?>
                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <?php elseif( $startDateObject->toString('y-MM-dd') == $endDateObject->toString('y-MM-dd') ): ?>
            <tr>
                <th class="label">
                    <?php echo $this->translate('Date')?>
                </th>
                <td class="data">
                    <?php echo  date('D, d F Y',strtotime($this->subject->starttime)); ?>
                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <tr>
                <th class="label">
                    <?php echo $this->translate('Time') ?>   
                </th>
                <td class="data">
                    <?php echo  date('g:i:a',strtotime($this->subject->starttime)); ?>
                    -
                    <?php echo  date('g:i:a',strtotime($this->subject->endtime)); ?>
                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <?php else: ?>
            <tr>
                <th class="label">
                    <?php echo $this->translate('Start')?>
                </th>
                <td class="data">
                    <?php //echo  date('d F Y, g:i:a',strtotime($this->subject->starttime)); ?>
                    <?php echo  date('d m Y, g:i:a',strtotime($this->subject->starttime)); ?>

                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <tr>
                <th class="label">
                    <?php echo $this->translate('End')?>
                </th>
                <td class="data">
                    <?php echo  date('d m Y, g:i:a',strtotime($this->subject->endtime)); ?>

                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <?php endif ?>
            <?php if (!empty($this->subject()->location)):?>
            <tr>
                <th class="label">
                    <?php echo $this->translate('Place')?>
                </th>
                <td class="data">
                    <?php echo $this->subject()->location; ?> <?php echo $this->htmlLink('http://maps.google.com/?q='.urlencode($this->subject()->location), $this->translate('Map'), array('target' => 'blank')) ?>
                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <?php endif;?> 
            <?php if (!empty($this->subject()->host)):?>
            <?php if ($this->subject()->host != $this->subject()->getParent()->getTitle()):?>
            <tr>
                <th class="label">
                    <?php echo $this->translate('Host');?>
                </th>
                <td class="data">
                    <?php echo $this->subject()->host; ?>
                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <?php endif;?>
            <tr>
                <th class="label">
                    <?php echo $this->translate('Led by');?>
                </th>
                <td class="data">
                    <?php echo $this->subject()->getParent()->__toString(); ?>
                </td>
            </tr>
            <tr class="space">
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <?php endif;?>
        </table>
        <a id="view_more"><?php echo $this->translate('More info');?></a>   

        <div id="more_info" class="more_info">
            <table class="profile_event_info">
                <?php if (!empty($this->subject()->description)):?>

                <tr>
                    <th class="label"> </th>
                    <td>
                        <div class="description">
                            <?php echo nl2br($this->subject()->description);?>
                        </div>
                    </td>

                </tr>
                <tr class="space">
                    <td colspan="2">
                        <hr />
                    </td>
                </tr>
                <?php endif ?> 

                <tr>
                    <th class="label">
                        <?php echo $this->translate('RSVPs');?>
                    </th>
                    <td>
                        <div class="event_stats_content">
                            <ul>
                                <li>
                                    <?php echo $this->locale()->toNumber($this->subject()->getAttendingCount()) ?>
                                    <span><?php echo $this->translate('attending');?></span>
                                </li>
                                <li>
                                    <?php echo $this->locale()->toNumber($this->subject()->getMaybeCount()) ?>
                                    <span><?php echo $this->translate('maybe attending');?></span>
                                </li>
                                <li>
                                    <?php echo $this->locale()->toNumber($this->subject()->getNotAttendingCount()) ?>
                                    <span><?php echo $this->translate('not attending');?></span>
                                </li>
                                <li>
                                    <?php echo $this->locale()->toNumber($this->subject()->getAwaitingReplyCount()) ?>
                                    <span><?php echo $this->translate('awaiting reply');?></span>
                                </li>
                            </ul>
                        </div>
                    </td>
                </tr>
            </table>
        </div>

    </div>
    <div>
        <?php /*
    	<?php if($this->subject->event_id == 500):?>
    	<a href="http://newaysvietnam.com">
	    	<img src="popup-events/20130620_newwaylogo.jpg" />
	    </a>
	    <?php endif;?> */ ?>
    </div>
</div>
<br />