class Mapper.Models.Instrument extends Backbone.Model
  paramRoot: 'instrument'

  defaults:
    prefix: null
    port: null
    study: null

class Mapper.Collections.InstrumentsCollection extends Backbone.Collection
  model: Mapper.Models.Instrument
  url: '/instruments'
