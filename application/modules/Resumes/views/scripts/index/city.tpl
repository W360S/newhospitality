<?php 
if($this->city){
    foreach($this->city as $city){?>
        <option value="<?php echo $city->city_id ?>"><?php echo $city->name; ?></option>
    <?php }
}
?>