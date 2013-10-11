// Get Masonry layout going on any element with a class of 'grid'
$('.grid').imagesLoaded(function() {

    $('.grid').masonry({

        itemSelector: '.home-module',
        transitionDuration: 0

    });

});
