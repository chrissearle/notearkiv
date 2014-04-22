jQuery ->
  $('main').on('click', '.alert button.close', ->
    id = $(this).parents('.alert-dismissable').data('id')

    if(id)
      date = new Date()
      date.setTime(date.getTime() + (30 * 60 * 1000))
      $.cookie('alert-' + id, 'closed', { path: '/', expires: date })
  )

  $('.alert').each( ->
    id = $(this).data('id')

    if($.cookie('alert-' + id))
      $(this).hide()
  )
