# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).on 'ready page:change', ->
  $body = $('#question_body')

  $counter = $('#js-body-count')

  determineChange = ->
    remainingChars = 140 - $body.val().length
    if remainingChars isnt 140
      $counter.text remainingChars
    else
      $counter.text ""

  $body.keyup determineChange
  $body.keypress (e) ->
    setTimeout ->
      determineChange
    , 0

  _secretHelperSender = (url, type, callback) ->
    $.ajax
      url: url
      type: type
      success: (data) ->
        callback(undefined, data)
      error: (data) ->
        callback(data, undefined)

  $(document).on 'click', '[data-action=vote]', ->
    $this = $(@)
    _secretHelperSender $this.attr('href'), "POST", (err, data) ->
      # vote count is "near" the click handler
      $this.parent().find('.vote-count').html("#{data.vote_count} votes")
    false # prevent default from click
