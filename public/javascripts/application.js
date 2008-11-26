// Common JavaScript code across your application goes here.
$(document).ready(function() {
	// TODO: Create a form element and submit it, instead of using the delete_button view helper.
	$('.delete-link').click(function() {
		var answer = confirm('Are you sure?');
		return answer;
	});

	// Close link on the message boxes.
	$('.message-close').click(function(){
		$(this.rel).fadeOut();
		return false;
	});

	// Toggles the form for creating a Detail manually or from a URL.
	$('.content-option-link').click(function() {
		if ($(this).attr("id") == "from-url-link") {
			$("#manual-content-link").show();
			$("#manual-content-container").fadeOut();
			$("#content-type-container").fadeOut();
		} else {
			$("#from-url-link").show();
			$("#from-url-container").fadeOut();
			$("#content-type-container").fadeIn();
		}
		$(this).hide();
		$(this.rel).fadeIn();
		return false;
	});
});
