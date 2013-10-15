// Get Masonry layout going on any element with a class of 'grid'
$('.grid').imagesLoaded(function() {

    $('.grid').masonry({

        itemSelector: '.home-module',
        transitionDuration: 0

    });

});

// Top grid on section landing pages
if ($('#grid1').length) {

    new AnimOnScroll( document.getElementById('grid1'), {
        minDuration : 0.4,
        maxDuration : 0.7,
        viewportFactor : 0.2
    });

}

// Lower grid on section landing pages
if ($('#grid2').length) {

    new AnimOnScroll( document.getElementById('grid2'), {
        minDuration : 0.4,
        maxDuration : 0.7,
        viewportFactor : 0.2
    });

}

// Grids on people page
if ($('#grid-people-team-board').length) {

    new AnimOnScroll( document.getElementById('grid-people-team-board'), {
        minDuration : 0.4,
        maxDuration : 0.7,
        viewportFactor : 0.2
    });

}

if ($('#grid-people-team-executive').length) {

    new AnimOnScroll( document.getElementById('grid-people-team-executive'), {
        minDuration : 0.4,
        maxDuration : 0.7,
        viewportFactor : 0.2
    });

}

if ($('#grid-people-team-commercial').length) {

    new AnimOnScroll( document.getElementById('grid-people-team-commercial'), {
        minDuration : 0.4,
        maxDuration : 0.7,
        viewportFactor : 0.2
    });

}

if ($('#grid-people-team-technical').length) {

    new AnimOnScroll( document.getElementById('grid-people-team-technical'), {
        minDuration : 0.4,
        maxDuration : 0.7,
        viewportFactor : 0.2
    });

}

if ($('#grid-people-team-operations').length) {

    new AnimOnScroll( document.getElementById('grid-people-team-operations'), {
        minDuration : 0.4,
        maxDuration : 0.7,
        viewportFactor : 0.2
    });

}
