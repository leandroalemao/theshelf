$ ->
  $('.side-content').on 'click', '#close-menu, #menu-toggle', ->
    $('.menu-wrap').toggleClass("collapsed")
    $('#menu-toggle').toggleClass("close")
