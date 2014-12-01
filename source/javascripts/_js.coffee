class Game
  total_score: 0
  players: new Array

  new_player: (container) ->
    @players.push(new Player(container))

  is_next_server: ->
    @total_score % 5 == 0 and @total_score > 0

  sorted_scores: ->
    scores = new Array
    scores.push player.score for player in @players
    scores.sort (a, b) ->
      a - b
    .reverse()

  win_condition: ->
    scores = this.sorted_scores()
    highest = scores[0]
    second_highest = scores[1]

    highest >= 21 and (highest - second_highest >= 2)

  show_next_server_message: ->
    $('.next_server').addClass('active').on 'touchend', ->
      $(@).removeClass('active')

  show_win_message: ->
    $('.win_message').addClass('active').on 'touchend', ->
      window.location.reload()

  increment: (player, amount = 1) ->
    @total_score = @total_score + amount
    player.increment(amount)
    this

  render: (player) ->
    this.show_next_server_message() if this.is_next_server()
    this.show_win_message() if this.win_condition()
    player.render()

class Player extends Game
  score: 0

  constructor: (@container) ->
    @$container = $(@container)
    this.render()

  increment: (amount = 1) ->
    @score = @score + amount

  render: ->
    @$container.find('.number').text(@score)

$ ->
  window.pingtrac_game = new Game

  pingtrac_game.new_player('.player1')
  pingtrac_game.new_player('.player2')

  attach_render_event = (player) ->
    player.$container.on 'touchend', ->
      pingtrac_game.increment(player).render(player)

  attach_render_event(player) for player in pingtrac_game.players
