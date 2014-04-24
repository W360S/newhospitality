<?php
    $resume= $this->resume; 
    $works= $this->works;
    $total_year= $this->total_year;
    $educations= $this->educations;
    $languages= $this->languages;
    $group_skills= $this->group_skill;
    $references= $this->references;
    $user_id= $this->user_id;
    $user_resume= $this->user_resume;
    $re_candidate= $this->re_candidate;
    $rated= $this->rated;
    
?>

<div class="resume_preview_main">
    <div id="video_rating" class="rating" onmouseout="rating_out();">
      <span id="rate_1" class="rating_star_big_generic" onclick="rate(1);"onmouseover="rating_over(1);"></span>
      <span id="rate_2" class="rating_star_big_generic" onclick="rate(2);" onmouseover="rating_over(2);"></span>
      <span id="rate_3" class="rating_star_big_generic" onclick="rate(3);" onmouseover="rating_over(3);"></span>
      <span id="rate_4" class="rating_star_big_generic" onclick="rate(4);"onmouseover="rating_over(4);"></span>
      <span id="rate_5" class="rating_star_big_generic" onclick="rate(5);" onmouseover="rating_over(5);"></span>
      <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate');?></span>
    </div>
    <div class="subsection">
    
    <table class="last_resume">
        <tr>
            <td style="color: #F90; padding-left: 11px;" width="30%">
           
            <ul>
                <li> <?php echo $this->translate("Work Experience");?></li>
                <li>
                    <?php echo $this->translate("Total: ")?> <?php echo $total_year. " year(s)";?>
                </li>
                                
            </ul>
            </td>
            <td>
                <div>
                    <?php 
                        foreach($works as $work){?>
                            <ul>
                                <li><strong><?php echo $work->title; ?></strong></li>
                                <li><strong><?php echo $this->level($work->level_id)->name;?> - <?php echo $this->category($work->category_id)->name;?></strong>
                                </li>
                                <li><?php echo $work->company_name;?></li>
                                <li><?php echo $this->city($work->city_id)->name; ?> - <?php echo $this->country($work->country_id)->name;?>
                                
                                </li>
                                <li>
                                    <label><?php echo $this->translate('<u>Related Information</u>')?>:</label>
                                    <?php echo $work->description;?>
                                </li>
                            </ul>
                            
                        <?php }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    <table class="last_resume">
        <tr>
            <td width="30%" style="color: #F90; padding-left: 11px;">
            
            <ul>
                <li><?php echo $this->translate("Education");?></li>
                
            </ul>
            </td>
            <td >
                <div>
                    <?php 
                        foreach($educations as $education){?>
                            <ul>
                                <li><strong><?php echo $this->degree($education->degree_level_id)->name;?></strong> </li>
                                <li><strong><?php echo $education->school_name; ?></strong></li>
                                
                                <li><?php echo $education->major;?></li>
                                <li><?php echo $this->country($education->country_id)->name;?>
                                
                                </li>
                                <li class="last_resume">
                                    <label><?php echo $this->translate('<u>Related Information</u>')?>:</label>
                                    <?php echo $education->description;?>
                                </li>
                            </ul>
                        <?php }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    <table class="last_resume">
        <tr>
            <td width="31%" style="color: #F90; padding-left: 11px;">
            
            <ul>
                <li><?php echo $this->translate("Skills");?></li>
                
            </ul>
            </td>
            <td>
                <div>
                <?php if(count($languages)>0){?>
                    <h4><?php echo $this->translate("Language")?></h4>
                    <?php 
                        foreach($languages as $language){?>
                            <ul>
                                <li>
                                    <?php echo $this->language($language->language_id)->name;?> - <?php echo $this->groupSkill($language->group_skill_id)->name;?>
                                </li>
                                
                               
                                
                            </ul>
                        <?php } }
                    ?>
                    <?php if(count($group_skills)>0){?>
                    <h4><?php echo $this->translate("Other Skills")?></h4>
                    <?php 
                        foreach($group_skills as $group_skill){?>
                            <ul>
                                <li><strong><?php echo $group_skill->name;?></strong></li>
                                
                                <li><?php echo $group_skill->description;?></li>
                                
                            </ul>
                        <?php } }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td width="30%" style="color: #F90; padding-left: 11px;">
            
            <ul>
                <li><?php echo $this->translate("Reference");?></li>
               
            </ul>
            </td>
            <td>
                <div>
                    <?php 
                        foreach($references as $reference){?>
                            <ul>
                                <li><strong><?php echo $reference->name;?> </strong>- <?php echo $reference->title;?></li>
                                
                                <li><?php echo $this->translate('Phone: ').$reference->phone;?> </li>
                                <li><?php echo $this->translate('Email: '). $reference->email;?> </li>
                                <li><?php echo $this->translate('<u>Related Information</u>: ').$reference->description;?> </li>
                            </ul>
                        <?php }
                    ?>
                </div>
            </td>
        </tr>
    </table>
    </div>
    
</div>
<script type="text/javascript">
var pre_rate = <?php echo $re_candidate->rating;?>;
var applyjob_id= <?php echo $re_candidate->applyjob_id;?>;
var rated= <?php echo $rated;?>;
function set_rating() {
    var rating = pre_rate;
    
    if (rated >0){
        $('rating_text').innerHTML = "<?php echo $this->translate('you already rated');?>";
      
      }else{
        $('rating_text').innerHTML = "<?php echo $this->translate('click to rate');?>";
      }
    for(var x=1; x<=parseInt(rating); x++) {
      $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big');
    }

    for(var x=parseInt(rating)+1; x<=5; x++) {
      $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big_disabled');
    }

    var remainder = Math.round(rating)-rating;
    if (remainder <= 0.5 && remainder !=0){
      var last = parseInt(rating)+1;
      $('rate_'+last).set('class', 'rating_star_big_generic rating_star_big_half');
    }
  }
  function rating_over(rating) {
    
      //if (rated >0){
        //$('rating_text').innerHTML = "<?php echo $this->translate('you already rated');?>";
      
      //}else{
        $('rating_text').innerHTML = "<?php echo $this->translate('click to rate');?>";
        for(var x=1; x<=5; x++) {
            if(x <= rating) {
              $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big');
            } else {
              $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big_disabled');
            }
        }
      //}
  }
  function rating_out() {
    
    //$('rating_text').innerHTML = " <?php echo $this->translate(array('%s rating', '%s ratings', $this->rating_count),$this->locale()->toNumber($this->rating_count)) ?>";
    if (pre_rate != 0){
      set_rating();
    }
    else {
      for(var x=1; x<=5; x++) {
        $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big_disabled');
      }
    }
  }
  function rate(rating) {
    $('rating_text').innerHTML = "<?php echo $this->translate('Thanks for rating!');?>";
    for(var x=1; x<=5; x++) {
      $('rate_'+x).set('onclick', '');
    }
    (new Request.JSON({
      'format': 'json',
      'url' : '<?php echo $this->url(array('module' => 'recruiter', 'controller' => 'job', 'action' => 'rate'), 'default', true) ?>',
      'data' : {
        'format' : 'json',
        'rating' : rating,
        'applyjob_id': applyjob_id
      },
      'onRequest' : function(){ 
        pre_rate = rating;
        set_rating();
      },
      'onSuccess' : function(responseJSON, responseText)
      {
        rated=1; 
      }
    })).send();
    
  }
window.addEvent('domready', function(){
   set_rating(); 
});
</script>
