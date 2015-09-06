$(document).ready(function(){

  $(document).on('click', '.add', function() {
    $('.sliding-box').slideDown();
    $(this).hide();
  });

  $(document).on('click', '.close-sliding-box', function() {
    $('.sliding-box').slideUp();
    $('.add').show();
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

  $(document).on('click', '.confirm-drawing', function() {
    $('.reveal-modal-bg').hide();
    $('.reveal-modal').hide();
    $('.draw_names').hide();
    $('.draw-notice').hide();
    $('.draw-loading').removeClass('hidden').fadeIn();
  });

  $(document).on('click', '.show-who', function() {
    $('#confidential').fadeOut(100);
    $('#who').removeClass('hidden').fadeIn();
  });

  if($('#datetimepicker').length > 0 && $('#group_date').length > 0)  {
    $('#datetimepicker').datetimepicker({
      format:'Y-m-d H:i:00',
      inline:true,
      todayButton: false,
      value: $('#group_date').val().replace(' UTC',''),
      onShow: function(dp, $input){
        $('.xdsoft_time.xdsoft_current').trigger('click');
      },
      onChangeDateTime: function(dp, $input){
        $('#group_date').val($input.val());
      }
    });
  }
  
  function initialize(latitude, longitude) {
    var map;
    var mapOptions = {
          zoom: 15,
          center: new google.maps.LatLng(latitude, longitude),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };

    map = new google.maps.Map(document.getElementById('map'),mapOptions);

    var position = new google.maps.LatLng(latitude, longitude);
    var marker = new google.maps.Marker({
        position: position, 
        title:"0"
      });

    marker.setMap(map);
  }

  if($('#map').length > 0) {
    $.ajax({
      url: window.location.href + '/get_coordinates',
        success: function(response){
          google.maps.event.addDomListener(window, 'load', initialize(response['latitude'], response['longitude']));
        }, 
      type: "GET", 
      dataType: "json"
    });
  }
});