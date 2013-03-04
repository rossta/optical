App.CalendarView = Ember.View.extend({
  didInsertElement: function() {
    console.log("CalendarView#didInsertElement");
  }
});

App.CalendarIndexView = Ember.View.extend({
  classNames: ["block"],

  data: function() {
    return this.get('controller.data');
  }.property('controller.data.length'),

  didInsertElement: function() {
    this.renderCalendar();
  },

  renderCalendar: function() {
    console.log("CalendarIndexView#didInsertElement");

    if (!this.get('data')) {
      console.log("Data undefined");
      return;
    }

    if (!this.get('data').length) {
      console.log("No data");
      return;
    }

    var width = 960,
        height = 136,
        cellSize = 17;

    var day = d3.time.format("%w"),
        week = d3.time.format("%U"),
        percent = d3.format(".1%"),
        format = d3.time.format("%Y-%m-%d");

    var data = d3.nest()
      .key(function(d) { return format(new Date(d.posted_at.split(" ")[0])); })
      .rollup(function(d) { return 1 / d.length; })
      .map(this.get('controller.data'));

    var color = d3.scale.quantize()
      .domain([0, 1])
      .range(d3.range(8).map(function(d) { return "q"+d+"-11"; }));

    var dates = d3.extent(d3.keys(data));

    var minYear = +d3.min(dates).split("-")[0];
    var maxYear = +d3.max(dates).split("-")[0];

    var svg = d3.select(".block").selectAll("svg")
      .data(d3.range(minYear, maxYear+1))
      .enter().append("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("class", "rgb");

    var g = svg.append("g")
      .attr("transform", "translate("+((width-cellSize * 53) / 2)+","+(height-cellSize * 7 - 1)+")");

    svg.append("text")
      .attr("transform", "translate(12,"+ cellSize * 4.5 +")rotate(-90)")
      .style("text-anchor", "middle")
      .text(function(d) { return d; });

    var rect = g.selectAll(".day")
      .data(function(d) { return d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
      .enter().append("rect")
      .attr("class", "day")
      .attr("width", cellSize)
      .attr("height", cellSize)
      .attr("x", function(d) { return week(d) * cellSize; })
      .attr("y", function(d) { return day(d) * cellSize; })
      .datum(format);

    // svg.selectAll(".month")
    //   .data(function(d) { return d3.time.months(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
    //   .enter().append("path")
    //   .attr("class", "month")
    //   .attr("d", monthPath)

    rect.filter(function(d) { return d in data; })
      .attr("class", function(d) { return "day " + color(data[d]); })
      .append("svg:title")
      .text(function(d) { return d + ": " +1/data[d]+ " tweets"; });

  }.observes('data')
});
