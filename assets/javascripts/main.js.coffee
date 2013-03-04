#= require_self
#= require_tree ./controllers
#= require_tree ./models
#= require_tree ./routes
#= require_tree ./templates
#= require_tree ./views

Application = Ember.Application.extend
  LOG_TRANSITIONS: true
  store: 'App.Store'

App = Application.create();

App.Store = DS.Store.extend
  revision: 11
  adapter: 'App.RESTAdapter'

App.RESTAdapter = DS.RESTAdapter.extend()

App.RESTAdapter.registerTransform 'array',
  deserialize: (serialized) ->
    if Em.isNone(serialized) then [] else serialized
  serialize: (deserialized) ->
    if Em.isNone(deserialized) then [] else deserialized

window.App = App
