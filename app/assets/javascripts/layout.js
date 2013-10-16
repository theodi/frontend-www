// Get Masonry layout going on any element with a class of 'grid'
$('.grid').imagesLoaded(function() {

    $('.grid').masonry({

        itemSelector: '.home-module',
        transitionDuration: 0

    });

});

new AnimOnScroll( document.getElementById('grid2'), {
    minDuration : 0.4,
    maxDuration : 0.7,
    viewportFactor : 0.2
});
