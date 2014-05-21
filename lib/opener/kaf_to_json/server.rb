require 'sinatra/base'
require 'opener/webservice'

module Opener
  class KafToJson
    ##
    # POS Tagger server powered by Sinatra.
    #
    class Server < Webservice
      set :views, File.expand_path('../views', __FILE__)
      text_processor KafToJson
      accepted_params :input
    end # Server
  end # KafToJson
end # Opener
