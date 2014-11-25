require 'opener/webservice'

module Opener
  class KafToJson
    ##
    # POS Tagger server powered by Sinatra.
    #
    class Server < Webservice::Server
      set :views, File.expand_path('../views', __FILE__)

      self.text_processor  = KafToJson
      self.accepted_params = [:input]
    end # Server
  end # KafToJson
end # Opener
