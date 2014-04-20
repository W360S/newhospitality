<?php
class Engine_View_Helper_Substring extends Zend_View_Helper_HtmlElement{
	function substring($chuoi,$gioihan){
	    // nếu độ dài chuỗi nhỏ hơn hay bằng vị trí cắt
	    // thì không thay đổi chuỗi ban đầu
	    if(strlen($chuoi)<=$gioihan)
	    {
	        return $chuoi;
	    }
	    else{
	        /* 
	        so sánh vị trí cắt 
	        với kí tự khoảng trắng đầu tiên trong chuỗi ban đầu tính từ vị trí cắt
	        nếu vị trí khoảng trắng lớn hơn
	        thì cắt chuỗi tại vị trí khoảng trắng đó
	        */
	        if(strpos($chuoi," ",$gioihan) > $gioihan){
	            $new_gioihan=strpos($chuoi," ",$gioihan);
	            $new_chuoi = substr($chuoi,0,$new_gioihan)."...";
	            return $new_chuoi;
	        }
	        // trường hợp còn lại không ảnh hưởng tới kết quả
	        $new_chuoi = substr($chuoi,0,$gioihan)."...";
	        return $new_chuoi;
	    }
	}
}