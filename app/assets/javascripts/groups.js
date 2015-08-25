$(document).ready(function(){

  $(document).on('click', '.add-members', function() {
    $('.invitation-box').slideDown();
    $(this).hide();
  });

  $(document).on('click', '.close-invitation-box', function() {
    $('.invitation-box').slideUp();
    $('.add-members').show();
  });

  $(document).on('click', '.add-more', function() {
    last_field = $('.clonable-field:last');
    clone = last_field.clone();
    clone.find('input[type=text]').val('');
    clone.insertAfter(last_field);
    $('.close').removeClass('hidden').show();
  });

  $(document).on('click', '.close', function() {
    $(this).closest('.clonable-field').remove();
    if($('.clonable-field').length == 1) {
      $('.close').hide();
    }
  });

  $(document).on('click', '.edit-link', function() {
    $(this).closest('.member').find('.edit-member').stop().slideToggle();
  });

  $(document).on('click', 'body', function(event) {
    target = $(event.target);
    
    if (!target.hasClass('edit') && !target.hasClass('edit-member') && !target.hasClass('edit-link')) {
      $('.edit-member').fadeOut();
    }
  });

  $('.draw_names').click(function() {
    $(this).hide();
    $('.draw-notice').hide();
    $('.draw-loading').removeClass('hidden').fadeIn();
  });

  $(document).on('click', '.show-who', function() {
    $('#confidential').fadeOut(100);
    $('#who').removeClass('hidden').fadeIn();
  });
  
});