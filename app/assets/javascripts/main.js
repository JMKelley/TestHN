$(document).on('ajax:success', 'a.vote', function(status, data, xhr) {
  $(".hover-actual-score[data-id=" + data.id + "]").text(data.count);
});
