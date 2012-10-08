# main application namespace
window.VAD = {}

$ ->
  # hide notice message after 10 seconds
  if ($notice = $("#messages .alert-success")).length > 0
    setTimeout ->
      $notice.hide "blind", -> $(this).remove()
    , 10000
