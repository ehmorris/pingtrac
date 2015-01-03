Players = new Mongo.Collection('players')

if (Meteor.isClient) {
  Template.body.helpers({
    players: function() {
      return Players.find({}, {limit: 2})
    },

    total_score: function() {
      var total = 0
      Players.find({}).forEach(function(player) {
        total = total + player.score
      })
      return total
    }
  })

  Template.body.events({
    'submit .new-player': function(event) {
      Meteor.call('add_player', event.target.name.value)
      return false
    },

    'click .reset': function() {
      Meteor.call('remove_all_players')
    }
  })

  Template.player.events({
    'click .increase': function() {
      Meteor.call('increase_player_score', this)
    }
  })
}

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
