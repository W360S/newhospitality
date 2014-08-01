<h2><?php echo $this->translate('Questions'); ?></h2>
<?php
    
    $cnt_pending = 0;
    $cnt_answered = 0;
    $cnt_closed = 0;
    $cnt_cancelled = 0;
    
    $current_pending = "";
    $current_answered = "";
    $current_closed = "";
    $current_cancelled = "";
    
    if(isset($this->status)){
         if($this->status == 1) { $current_pending = "current"; }
         if($this->status == 2) { $current_answered = "current"; }
         if($this->status == 3) { $current_closed = "current"; }
         if($this->status == 4) { $current_cancelled = "current"; }
    }
    
    if(count($this->data)){
        foreach($this->data as $item){
            // pendding
            if($item->status == 1) { $cnt_pending = $item->cnt_status; }
            // answered
            if($item->status == 2) { $cnt_answered = $item->cnt_status; }
            // closed
            if($item->status == 3) { $cnt_closed = $item->cnt_status; }
            // cancelled
            if($item->status == 4) { $cnt_cancelled = $item->cnt_status; }
        }
    } 
?>

<ul class="list_function_questions">
	<li><a class="<?php echo $current_pending; ?>" href="<?php echo $this->baseUrl().'/experts/my-experts/index/status/1'; ?>"><?php echo $this->translate('Pending'); ?>(<span><?php  echo $cnt_pending; ?></span>)</a></li>
	<li><a class="<?php echo $current_answered; ?>"  href="<?php echo $this->baseUrl().'/experts/my-experts/index/status/2'; ?>"><?php echo $this->translate('Answered'); ?>(<span><?php echo $cnt_answered; ?></span>)</a></li>
	<li><a class="<?php echo $current_closed; ?>"  href="<?php echo $this->baseUrl().'/experts/my-experts/index/status/3'; ?>"><?php echo $this->translate('Resolved'); ?>(<span><?php echo $cnt_closed; ?></span>)</a></li>
	<li><a class="<?php echo $current_cancelled; ?>"  href="<?php echo $this->baseUrl().'/experts/my-experts/index/status/4'; ?>"><?php echo $this->translate('Cancelled'); ?>(<span><?php echo $cnt_cancelled; ?></span>)</a></li>
</ul>