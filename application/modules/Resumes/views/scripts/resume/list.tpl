<?php $resumes= $this->resumes; ?>
<?php if(!empty($resumes)){?>
        
       <table cellspacing="0" cellpadding="0">
            

            <tr>
                <th style="width:270px"><?php echo $this->translate('Resume Title')?></th>
                <th style="width:120px"><?php echo $this->translate('Status');?></th>
                <th style="width:92px"><?php echo $this->translate('Date Modified')?></th>
                <th><?php echo $this->translate('Options ')?></th>
            </tr>    
           <?php foreach($resumes as $resume){?>
          <tr>
            <td>
            <?php echo $resume->title;?>
            </td>
            <td>
                <?php if($resume->approved==1){
                    echo "<span style='color: #64A700;font-style:italic;font-size:10px;'>".$this->translate('Approved')."</span>";?><img src="<?php echo $this->baseUrl().'/application/modules/Resumes/externals/images/approve.gif'?>" />
                <?php } else if($resume->approved==0){
                        echo "<span style='color:red;font-style:italic;font-size:10px;'>".$this->translate('Incomplete')."</span>";?>  
                <?php } else{
                    echo "<span style='font-style:italic;font-size:10px;'>".$this->translate('Wait to approved')."</span>";
                }
                ?>
            </td>
            <td>
            <?php echo date('d F Y', strtotime($resume->modified_date));?>
            </td>
            <td>
            <a class="edit" href="<?php echo $this->baseUrl().'/resumes/index/preview/resume_id/'.$resume->resume_id ?>"></a>
    
            <a href="javascript:void(0);" onclick="javascript:delete_resume('<?php echo $resume->resume_id ?>');"></a>
            </td>
       </tr>
            <?php }?>
        </table>

    <?php } else{
        echo $this->translate('You have not create resume.');
    }?>