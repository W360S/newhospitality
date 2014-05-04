//check number
function checkNumber(field_id){
    var intRegex = /^\d+$/;
    var str = jQuery(field_id).val();
    if(intRegex.test(str)) {
        return true;
    }
    else{ 
        
        return false;
    }
}
//check valid
function checkValid(field_id, max){
    var value= jQuery(field_id).val();
    
    if(value.length>0 && value.length <=max){
        return true
    }
    else{
        return false;
    }
}
function checkStarttime(start, hour, min, start_ampm){
    var starttime= start.split('/');
    if(start_ampm=='PM'){
        hour+= 12;
    }
    starttime= starttime[2]+'-'+starttime[0]+'-'+starttime[1]+' '+hour+':'+min;
    return starttime;
    
}
function checkEndtime(end, hour_end, min_end, end_ampm){
    var endtime= end.split('/');
    if(end_ampm=='PM'){
        hour_end+=12;
    }
    endtime= endtime[2]+'-'+endtime[0]+'-'+endtime[1]+' '+hour_end+':'+min_end;
    return endtime;
}