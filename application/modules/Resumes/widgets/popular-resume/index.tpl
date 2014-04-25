<div class="subsection">
    <h2><?php echo $this->translate("Popular resumes");?></h2>
    <div class="popular_resumes">
    <div class="subcontent">
        <ul class="resume-list">
        <?php foreach($this->paginator as $paginator){?>
            <li>
                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($paginator->title);?>
                <?php echo $this->itemPhoto($this->user($paginator->user_id), "thumb.icon");?>
                <h3><a href="<?php echo $this->baseUrl().'/resumes/resume/view/resume_id/'.$paginator->resume_id.'/'.$slug ?>"><?php echo $paginator->title;?></a></h3>
                
                <p><?php echo $this->user($paginator->user_id)?></p>
                
            </li>
        <?php }?>
        </ul>
        
    </div>
    </div>
</div>