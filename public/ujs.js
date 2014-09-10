$(function(){
  $(document).on('submit', 'form[data-remote]', function(e){
    e.preventDefault();
    var $form = $(this);
    $.ajax({
      url: $form.attr('action'),
      method: $form.attr('method'),
      data: $form.serialize()
    }).done(function(res){
      $form.trigger('ajax:done', res);
    });
  });
});
