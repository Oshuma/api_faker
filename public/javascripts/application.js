// Common JavaScript code across your application goes here.
$(document).ready(function() {
	// TODO: Create a form element and submit it, instead of using the delete_button view helper.
	$('.delete_link').click(function() {
		var answer = confirm('Are you sure?');
		return answer;
	});
});
