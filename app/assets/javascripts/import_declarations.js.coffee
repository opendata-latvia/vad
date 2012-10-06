# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#import_declarations .action_details").click ->
    $details = $(this).next(".details")
    if $details.text().length
      $details.toggle()
    else
      id = $details.closest("tr").data("id")
      $.getJSON "/import_declarations/#{id}", (importDeclaration) ->
        $details.text importDeclaration.pretty_data
        $details.show()
    false

  $("#import_declarations .action_delete").click ->
    $tr = $(this).closest("tr")
    id = $tr.data("id")
    $.ajax
      url: "/import_declarations/#{id}"
      type: "DELETE"
      success: ->
        $tr.hide "slow", -> $tr.remove()
      dataType: "json"
    false

