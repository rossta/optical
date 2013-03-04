App.Calendar = Ember.Object.extend
  id: (->
    @get('screenname')
  ).property('screenname')
  screenname: null
  data: []

  fetch: ->
    Ember.$.ajax "/calendars/#{@get('screenname')}",
      dataType: 'json'
      success: (response) =>
        console.log(response, this)
        @setProperties(response.calendar)

App.Calendar.reopenClass
  find: (screenName) ->
    calendar = App.Calendar.create(screenname: screenName)
    calendar.fetch()
    calendar
