require 'slop'
require 'saxon-xslt'

require_relative 'kaf_to_json/version'
require_relative 'kaf_to_json/server'
require_relative 'kaf_to_json/cli'

module Opener
  ##
  # Component for converting KAF documents to JSON objects.
  #
  class KafToJson
    ##
    # This method takes a single argument that is ignored to ensure
    # compatibility with all the other OpeNER components.
    #
    def initialize(*); end

    ##
    # Processes the input KAF document and returns a String containing the JSON
    # output.
    #
    # @param [String] input The input to process.
    # @return [String]
    #
    def run(input)
      doc  = Saxon::XML(input)
      xslt = Saxon::XSLT(File.read(xsl))

      return xslt.transform(doc).to_s
    end

    alias tag run

    ##
    # The output type to use in the webservices.
    #
    # @return [Symbol]
    #
    def output_type
      return :json
    end

    private

    ##
    # @return [String]
    #
    def config_dir
      return File.expand_path('../../../config', __FILE__)
    end

    ##
    # @return [String]
    #
    def xsl
      return File.join(config_dir, 'kaf2json.xsl')
    end
  end # KafToJson
end # Opener
