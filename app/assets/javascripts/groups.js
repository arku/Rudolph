$('.add-more').click(function() {
  last_field = $('.invite-friend:last');
  clone = last_field.clone();
  clone.find('input[type=text]').val('');
  clone.insertAfter(last_field);
});