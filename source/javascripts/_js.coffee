class Game
  constructor: (@total_score) ->
    @total_score = 0

  is_next_server: ->
    @total_score % 5 == 0

  win_condition: ->
    @total_score > 20

  show_next_server_message: ->
    $('.next_server').addClass('active')

  show_win_message: ->
    $('.win_message').addClass('active')

  update: (amount = 1) ->
    @total_score = @total_score + amount
    this

  render: ->
    if this.is_next_server()
      this.show_next_server_message()
    if this.win_condition()
      this.show_win_message()

class Player extends Game
  constructor: (@score, @$text) ->
    this.render()

  update: (amount = 1) ->
    @score = @score + amount
    this

  render: ->
    @$text.text(@score)

$ ->
  score1 = new Player(0, $('.score1 .number'))
  score2 = new Player(0, $('.score2 .number'))

  $('.score1').on 'touchend', ->
    score1.update(1).render()

  $('.score2').on 'touchend', ->
    score2.update(1).render()
