module Opener
  class KafToJson
    ##
    # CLI wrapper around {Opener::KafToJson} using Slop.
    #
    # @!attribute [r] parser
    #  @return [Slop]
    #
    class CLI
      attr_reader :parser

      def initialize
        @parser = configure_slop
      end

      ##
      # @param [Array] argv
      #
      def run(argv = ARGV)
        parser.parse(argv)
      end

      ##
      # @return [Slop]
      #
      def configure_slop
        return Slop.new(:strict => false, :indent => 2, :help => true) do
          banner 'Usage: kaf2json [OPTIONS]'

          separator <<-EOF.chomp

About:

    Component that converts a given KAF document into a JSON object.
    This command reads input from STDIN.

Example:

    cat some_file.kaf | kaf2json
          EOF

          separator "\nOptions:\n"

          on :v, :version, 'Shows the current version' do
            abort "kaf2json v#{VERSION} on #{RUBY_DESCRIPTION}"
          end

          run do |opts, args|
            converter = KafToJson.new
            input     = STDIN.tty? ? nil : STDIN.read

            puts converter.run(input)
          end
        end
      end
    end # CLI
  end # KafToJson
end # Opener
