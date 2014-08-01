<br/></a>
<?php if( $this->subject()->url !== null ): ?>
  <div>
    <?php
        $pos = strpos($this->subject()->url,'.');
        $url = $this->baseUrl().'/public/library_book/files/' . base64_decode(substr($this->subject()->url,0,$pos)) . '.' . substr($this->subject()->url,$pos+1);
    ?>
    <a href="<?php echo $url ?>"><?php echo $this->subject()->title; ?></a>
    
  </div>
<?php endif; ?>
