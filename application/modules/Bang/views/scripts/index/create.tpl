<div id="ad-preview" style="display:none">
	<div class="preview-element">
		<div class="preview-label">
			<p>Tiêu đề</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-title">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Subtitle</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-subtitle">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>File</p>
		</div>
		<div class="preview-text">
			<p>Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Link</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-link">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Mô tả</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-description">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Vị trí</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-position">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Thời gian bắt đầu</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-start">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Thời gian kết thúc</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-end">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Thành tiền</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-total">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Fullname</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-fullname">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Email</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-email">Nội dung tiêu đề</p>
		</div>
	</div>
	<div class="preview-element">
		<div class="preview-label">
			<p>Phone</p>
		</div>
		<div class="preview-text">
			<p id="preview-ad-phone">Nội dung tiêu đề</p>
		</div>
	</div>
</div>
<?php echo $this->form->render($this) ?> 
<style>
    body#global_page_bang-index-create{padding: 10px}
    #global_page_bang-index-create .form-elements {min-width: 450px}
    #global_page_bang-index-create .form-label {width: 29%; float: left;}
    #global_page_bang-index-create .form-element {width: 69%; float: left;}
    #global_page_bang-index-create ul.errors {display: none;}
    #global_page_bang-index-create #global_content_simple {width: 100%}
	#ad-preview{width: 100%}
	.preview-element{width: 100%}
	.preview-element p{padding: 0px; margin: 0px}
	.preview-label {width: 30%;float: left;}
	.preview-text {width: 69%;float: left;}
</style>
<script>
	jQuery("document").ready(function($){
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

        var start, end;

		function checkVal(){

			setTimeout(function() {

				start = $("#ad_start-date").val();
				end = $("#ad_end-date").val();
				console.log(start);
				console.log(end);
				if (start==="" || end ==="") {
					$("#ad_total").val("0");
				}else{
					var str1= start.split('/');
					var str2= end.split('/');
					var t1 = new Date(str1[2], str1[1], str1[0]-1);
					var t2 = new Date(str2[2], str2[1], str2[0]-1);

					if(t1 > t2){
						console.log("start > end");
						$("#ad_total").val("0");
					}else{
						console.log("start end");
					
						var datediff = (t2 - t1);
						datediff = datediff / (24 * 60 * 60 * 1000);

						var selected_plan = $("#ad_position").val();
                        
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

		var ad_title, ad_subtitle, ad_link, ad_description, ad_total, ad_name, ad_email, ad_phone, ad_position, ad_start, ad_end;

		var realvalues = [];
		var textvalues = [];
		

		function formIsValid(){

			ad_title 		= $("#ad_title").val();
			ad_subtitle 	= $("#ad_subtitle").val();
			ad_link 		= $("#ad_link").val();
			ad_description 	= $("#ad_description").val();

			ad_position 	= $("#ad_position").val();
			ad_start 		= $("#calendar_output_span_ad_start-date").text();
			ad_end 			= $("#calendar_output_span_ad_end-date").text();

			ad_total 	= $("#ad_total").val();
			ad_name 	= $("#ad_name").val();
			ad_email 	= $("#ad_email").val();
			ad_phone 	= $("#ad_phone").val();

			$('#ad_position :selected').each(function(i, selected) {
			    realvalues[i] = $(selected).val();
			    textvalues[i] = $(selected).text();
			});

			if (ad_title == "" || ad_subtitle=="" || ad_link=="" || ad_description=="" || ad_total=="0" || ad_name=="" || ad_email=="" || ad_phone=="" ) {
				return false;
			}

			$("#preview-ad-title").html(ad_title);
			$("#preview-ad-subtitle").html(ad_subtitle);
			$("#preview-ad-link").html(ad_link);
			$("#preview-ad-description").html(ad_description);

			$("#preview-ad-position").html(textvalues);
			$("#preview-ad-start").html(ad_start);
			$("#preview-ad-end").html(ad_end);

			$("#preview-ad-total").html(ad_total);
			$("#preview-ad-fullname").html(ad_name);
			$("#preview-ad-email").html(ad_email);
			$("#preview-ad-phone").html(ad_phone);

			return true;
		}

		$("div#buttons-wrapper").hide();

		$("#vsubmit").click(function(){

			if (formIsValid()) {
				$("#global_page_bang-index-create > #global_content_simple > form").hide();
				$("#ad-preview").show();

				$("#vsubmit").click(function(){
					console.log("clicked");
					console.log($("form-ad-request-create"));
					// jQuery("form-ad-request-create").submit();
					// var form = document.getElementById("form-ad-request-create");
					document.getElementById("form-ad-request-create").submit();
				});

			}else{
				alert("Please complete the form");
			}
			
		});

	});
</script>
<div class="form-wrapper" id="buttons-wrapper-virtual">
	<fieldset id="fieldset-buttons-virtual">
		<button name="vsubmit" id="vsubmit" type="button">Preview</button>
		 hoặc <a name="vcancel" id="vcancel" type="button" onclick="javascript:parent.Smoothbox.close();" href="javascript:void(0);">hủy</a>
	 </fieldset>
</div>