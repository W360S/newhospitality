<?php echo $this->form->render($this) ?> 
<style>
    body#global_page_bang-index-create{padding: 10px}
    #global_page_bang-index-create .form-elements {min-width: 450px}
    #global_page_bang-index-create .form-label {width: 29%; float: left;}
    #global_page_bang-index-create .form-element {width: 69%; float: left;}
    #global_page_bang-index-create ul.errors {display: none;}
</style>
<script>
	jQuery("document").ready(function($){
		console.log("registered");
		
		$("input#ad_end-date").on("change paste keyup", function() {
		   alert($(this).val()); 
		});

		var rate = [60000, 50000, 30000, 30000];

		$("#ad_start-hour").val(0);
		$("#ad_start-minute").val(0);
		$("#ad_end-hour").val(0);
		$("#ad_end-minute").val(0);

		$("#ad_start-hour").hide();
		$("#ad_start-minute").hide();
		$("#ad_end-hour").hide();
		$("#ad_end-minute").hide();
        
        var ad_position_element = $("#ad_position-element ul.form-options-wrapper > li");

		function checkVal(){
			setTimeout(function() {

				console.log("checking value");

				var start = $("#ad_start-date").val();
				var end = $("#ad_end-date").val();
				if (start==="" || end ==="") {
					$("#ad_total").val("0");
				}else{
					if(start > end){
						$("#ad_total").val("0");
					}else{
						var str1= start.split('/');
						var str2= end.split('/');
						var t1 = new Date(str1[2], str1[1], str1[0]-1);
						var t2 = new Date(str2[2], str2[1], str2[0]-1);

						var datediff = (t2 - t1);
						datediff = datediff / (24 * 60 * 60 * 1000);

						var selected_plan = $("#ad_position").val();
                        
                        console.log(selected_plan);
                        
                        var sum = 0;
                        if(selected_plan.length > 0){
                            for (i=0; i<selected_plan.length; i++){
                                sum += rate[selected_plan[i] - 1];
                            }
                        }
                        
                        var ad_position_element = $("#ad_position-element ul.form-options-wrapper > li");
                        
                        
						$("#ad_total").val(datediff * sum);
					}

					
				}

				checkVal();

			}, 2000);
		}

		checkVal();
	});

	

	

</script>