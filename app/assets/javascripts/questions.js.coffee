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
