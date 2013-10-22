
$(document).ready(function () {
	$('iframe').iframeAutoHeight({
		animate: true,
		callback: function (callbackObject) { 
			$('.grid').masonry();
		},
		triggerFunctions: [
			function (resizeFunction, iframe) {
				$(window).resize(function () {
					resizeFunction(iframe);
				});
			}
		]
	});
});
