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

  incrementLikes = (url, callback = ->) ->
    _secretHelperSender(url, "POST", callback)

  decrementLikes = (url, callback = ->) ->
    _secretHelperSender(url, "DELETE", callback)

  window.fbAsyncInit = ->
    FB.Event.subscribe "edge.create", (href, widget) ->
      url = $(widget).data('like-url')
      incrementLikes url, (err, data) ->

    FB.Event.subscribe "edge.remove", (href, widget) ->
      url = $(widget).data('like-url')
      decrementLikes url, (err, data) ->
