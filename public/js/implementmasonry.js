let $grid = $('.grid').masonry({
  itemSelector: '.grid-item',
  percentWidth: true,
  columnWidth: '.grid-sizer',
  transitionDuration: '0.8s'
});

$grid.imagesLoaded().progress( function() {
  $grid.masonry('layout');
});
