function float_open(){


$('.floating-open').on('click', function () {
  var $this = $(this);
  $this.parents('.clickable-button').addClass('clicked');
  $this.parents('.clickable-button').next('.layered-content').addClass('active');

  setTimeout(function () {
    $this.parents('.card-heading').css('overflow', 'hidden');
  }, 100);

});

$('.floating-close').on('click', function () {
  var $this = $(this);
  $this.parents('.layered-content').prev('.clickable-button').removeClass('clicked');
  $this.parents('.layered-content').removeClass('active');

  setTimeout(function () {
    $this.parents('.card-heading').css('overflow', 'initial');
  }, 600);

});
}