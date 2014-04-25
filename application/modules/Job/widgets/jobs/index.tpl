<!-- 
    @date: 2011-09-12
    @author: huynhnv
    @des:
    thay đổi id của job và hotel supplier để hợp với giao diện(lúc này tạm thời khóa chức năng hotel supplier lại) 
-->
<style type="text/css">
#extras .section{background:none;}
#hotel-suppliers{width: 100%;}
</style>
<div id="hotel-suppliers">
    <h3><?php echo $this->translate('Jobs')?></h3>
    <ul>
    <?php
        if(count($this->jobs)>0){
            
             
            foreach($this->jobs as $job){?>
                <li>
                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($job->position);?>
		<?php if(Engine_String::strlen($job->position)>64){
			$strings= Engine_String::substr($job->position, 0, 64) . $this->translate('... &nbsp;');
			}
		else{
			$strings= $job->position;
		}
		?>
                    <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $job->job_id, 'slug'=>$slug), $strings) ?>
                    <em></em>
                    <span>
                        <?php if($this->company($job->user_id)) echo $this->company($job->user_id)->company_name;?>
                        - <?php echo $this->city($job->city_id)->name?> , <?php echo $this->country($job->country_id)->name;?>
                    </span>
                </li>
            <?php }
        }
    ?>
    <?php if(count($this->jobs)%2 !=0){?>
        <li style="background: none;"></li>
    <?php } ?>
    </ul>
    <div class="all"><a href="<?php echo $this->baseUrl().'/resumes'?> "><?php echo $this->translate('View All')?></a></div>
</div>
