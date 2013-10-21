
$(document).ready(function () {
	$('iframe').iframeAutoHeight({
		animate: true,
		callback: function (callbackObject) { 
			$('.grid').masonry();
		}
	});
});
