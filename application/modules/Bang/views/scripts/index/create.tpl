<?php echo $this->form->render($this) ?> 
<style>
    body#global_page_bang-index-create{padding: 10px}
    #global_page_bang-index-create .form-elements {min-width: 450px}
    #global_page_bang-index-create .form-label {width: 29%; float: left;}
    #global_page_bang-index-create .form-element {width: 69%; float: left;}
</style>
<script>
	jQuery("document").ready(function($){
		console.log("registered");
		
		$("input#ad_end-date").on("change paste keyup", function() {
		   alert($(this).val()); 
		});

		function checkVal(){
		setTimeout(function() {

				console.log("checking value");
				console.log($("#ad_start-date").val());
				console.log($("#ad_end-date").val());

				var start = $("#ad_start-date").val();
				var end = $("#ad_end-date").val();
				if (start==="" || end ==="") {
					$("#ad_total").val(0);
				}else{
					if(start > end){
						$("#ad_total").val("start > end");
					}else{
						$("#ad_total").val(end - start);
					}
					console.log(start > end);
				}

				checkVal();

			}, 2000);
		}

		checkVal();
	});

	

	

</script>