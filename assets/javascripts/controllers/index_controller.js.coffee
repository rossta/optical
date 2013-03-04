App.IndexController = Ember.ObjectController.extend()

App.WelcomeController = Ember.ObjectController.extend
  needs: 'calendar'
  screenname: null

