Players = new Mongo.Collection('players')

if (Meteor.isClient) {
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
}
