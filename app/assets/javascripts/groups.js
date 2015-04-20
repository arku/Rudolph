$('.add-more').click(function() {
  last_field = $('.invite-friend:last');
  clone = last_field.clone();
  clone.find('input[type=text]').val('');
  clone.insertAfter(last_field);
});

$(document).on('click', '.edit-link', function() {
  $(this).closest('.member').find('.edit-member').slideToggle();
});

$(document).on('click', 'body', function(event) {
  target = $(event.target);
  
  if (!target.hasClass('edit') && !target.hasClass('edit-member') && !target.hasClass('edit-link')) {
    $('.edit-member').fadeOut();
  }
});