<?php
    $paginator= $this->paginator; 
    $industry_id= $this->industry_id;
    
?>
<div class="pt-list-job">
    <ul class="pt-list-job-ul">
            <?php if( count($paginator)>0 ): ?>
                <?php foreach($paginator as $item): ?>

                    <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                    
                    <li class="news">
                        <div class="pt-lv1"><span class="pt-fulltime">Full Time</span></div>
                        <div class="pt-lv2">
                            <h3>
                                 <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?>
                            </h3>
                            <span><?php if($this->company($item->user_id)) echo $this->company($item->user_id)->company_name;?></span>
                        </div>
                        <div class="pt-lv3">
                            <p class="pt-address"><span></span><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></p>
                        </div>
                        <div class="pt-lv4">
                            <div class="pt-user-name">
                                <a href="#" class="pt-avatar"><img src="img/thumb/img-05.jpg" alt="Image"></a>
                                <strong>Đăng bởi:</strong>
                                <p><a href="#">Vinh Bui</a><span>- 2 giờ trước</span></p><p></p>
                            </div>
                        </div>
                    </li>
                    
                <?php endforeach; ?>
            <?php else: ?>
                    There is no results based on your search..
            <?php endif;?>        
    </ul>
    <div class="pt-paging">
        <ul class="pagination-flickr">
            <li class="previous-off">«Previous</li>
            <li class="active">1</li>
            <li><a href="?page=2">2</a></li>
            <li><a href="?page=3">3</a></li>
            <li class="next"><a href="?page=2">Next »</a></li>
        </ul>
    </div>
</div>