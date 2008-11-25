// Common JavaScript code across your application goes here.
$(document).ready(function() {
	// TODO: Create a form element and submit it, instead of using the delete_button view helper.
	$('.delete-link').click(function() {
		var answer = confirm('Are you sure?');
		return answer;
	});

	// Close link on the message boxes.
	$('.message-close').click(function(){
		var box = $(this).attr("rel");
		$(box).fadeOut();
		return false;
	});
});
