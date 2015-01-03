Players = new Mongo.Collection("players")

if (Meteor.isClient) {
  Template.body.helpers({
    players: function() {
      return Players.find({}, {limit: 2})
    },
    total: function() {
      var total = 0
      Players.find({}).forEach(function(player) {
        total = total + player.score
      })
      return total
    }
  })

  Template.body.events({
    "submit .new-player": function(event) {
      if (Players.find({}).count() < 2) {
        Players.insert({
          name: event.target.name.value,
          score: 0
        })
      }
      event.target.name.value = ""
      return false
    }
  })

  Template.player.events({
    "click .increase": function(event) {
      Players.update(this._id, {$set: {"score": this.score + 1}})
      return false
    },
    "click .delete": function(event) {
      Players.remove(this._id)
      return false
    }
  })
}
