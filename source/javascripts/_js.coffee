class Game
  total_score: 0
  players: new Array
  score_history: new Array

  new_player: (container) ->
    @players.push(new Player(container))

  is_next_server: ->
    @total_score % 5 == 0 and @total_score > 0

  is_surpassed: ->
    most_recent_three = @score_history[-3..]

    return @score_history.length >= 3 and
           Math.abs(@players[0].score - @players[1].score) == 1 and
           most_recent_three[0].container == most_recent_three[1].container and
           most_recent_three[1].container == most_recent_three[2].container

  sorted_scores: ->
    scores = new Array
    scores.push(player.score for player in @players)
    scores.sort (a, b) ->
      a - b
    .reverse()

  is_game_won: ->
    scores = this.sorted_scores()
    highest = scores[0]
    second_highest = scores[1]

    highest >= 21 and (highest - second_highest >= 2)

  next_server_message: ->
    $next_server = $('.next_server')
    $next_server.find('audio').get(0).play()
    $next_server.addClass('active').on 'touchend', ->
      $(@).removeClass('active')

  surpassed_message: ->
    $('.surpassed').find('audio').get(0).play()

  win_message: ->
    $win_message = $('.win_message')
    $win_message.find('audio').get(0).play()
    $win_message.addClass('active').on 'touchend', ->
      window.location.reload()

  increment: (player, amount = 1) ->
    player.increment(amount)
    @total_score = @total_score + amount
    @score_history.push
      'player': player.container
      'score': player.score
    this

  render: (player) ->
    player.render()
    this.next_server_message() if this.is_next_server()
    this.surpassed_message() if this.is_surpassed()
    this.win_message() if this.is_game_won()

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
