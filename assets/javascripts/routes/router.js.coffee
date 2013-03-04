App.Router.map ->

  @resource 'welcome', path: '/'
  @resource 'calendar', path: '/:screenname', ->

App.ApplicationRoute = Ember.Route.extend()

App.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo('welcome')

App.WelcomeRoute = Ember.Route.extend
  events:
    timeline: ->
      @transitionTo("calendar", App.Calendar.find(@controller.get('screenname')))

App.CalendarRoute = Ember.Route.extend
  serialize: (model) ->
    { screenname: model.screenname }

  model: (params) ->
    App.Calendar.find(params.screenname)

App.CalendarIndexRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('calendar')
