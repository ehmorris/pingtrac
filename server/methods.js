Meteor.methods({
  add_player: function(name) {
    if (Players.find({}).count() >= 2) {
      throw new Meteor.Error('max-players', 'There can only be two players per game')
    }
    Players.insert({
      name: name,
      score: 0
    })
  },

  increase_player_score: function(player) {
    Players.update(player._id, {$set: {'score': player.score + 1}})
  },

  remove_all_players: function() {
    Players.remove({})
  }
})
