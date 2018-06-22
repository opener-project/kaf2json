# KAF to JSON

Even if KAF is the true OpeNER data representation format, it is not very
friendly for humans. It is also difficult to parse and work with it, specially
for new users that are not familiarized with KAF. This is part of the feedback
we got from the OpeNER hackathon held in Amsterdam during first days of July. To
ease the post-processing of the results by any potential user, we are designing
an alternative JSON format to output translate KAF, and turn its complexity into
a much more usable format. Although, the specification for this JSON is
currently work in progress, we have already a version that covers the most
relevant parts from the KAF representation.

## Confused by some terminology?

This software is part of a larger collection of natural language processing
tools known as "the OpeNER project". You can find more information about the
project at [the OpeNER portal](http://opener-project.github.io). There you can
also find references to terms like KAF (an XML standard to represent linguistic
annotations in texts), component, cores, scenario's and pipelines.

## Quick Use Example

Installing the kaf2json can be done by executing:

    gem install opener-kaf2json

Please keep in mind that all components in OpeNER take KAF as an input and
output KAF by default.

### Command line interface

You should now be able to call the kaf2json as a regular shell command: by its
name. Once installed the gem normally sits in your path so you can call it
directly from anywhere.

This aplication reads a text from standard input in order to convert it to JSON.

    cat some_kind_of_kaf_file.kaf | kaf2json

The output will look like the following JSON:

    {
        "text"      : "Beatrix Wilhelmina Armgard van Oranje -Nassau (Baarn , 31 januari 1938 ) is sinds 30 april 1980 koningin van het Koninkrijk der Nederlandén ",
        "language"  : "nl",
        "terms"     : {},
        "sentiments": [],
        "entities"  : {},
        "opinions"  : {}
    }

### Webservices

You can launch a webservice by executing:

    kaf2json-server

This will launch a mini webserver with the webservice. It defaults to port 9292,
so you can access it at <http://localhost:9292>.

To launch it on a different port provide the `-p [port-number]` option like
this:

    kaf2json-server -p 1234

It then launches at <http://localhost:1234>

Documentation on the Webservice is provided by surfing to the urls provided
above. For more information on how to launch a webservice run the command with
the `--help` option.

You can also launch the webservice via Docker:

    docker run -d -p 8080:80 cwolff/opener-docker-kaf2json

This launches the server at <http://localhost:8080>

### Daemon

Last but not least the kaf2json comes shipped with a daemon that can read jobs
(and write) jobs to and from Amazon SQS queues. For more information type:

    kaf2json-daemon -h

## Description of dependencies

This component runs best if you run it in an environment suited for OpeNER
components. You can find an installation guide and helper tools in the
[OpeNER installer](https://github.com/opener-project/opener-installer) and an
[installation guide on the Opener Website](http://opener-project.github.io/getting-started/how-to/local-installation.html)

At least you need the following system setup:

### Depenencies for normal use:

* JRuby 1.7.9 or newer
* libarchive, on Debian/Ubuntu based systems this can be installed using
  `sudo apt-get install libarchive-dev`

## Where to go from here

* [Check the project website](http://opener-project.github.io)
* [Checkout the webservice](http://opener.olery.com/kaf2json)

## Report problem/Get help

If you encounter problems, please email support@opener-project.eu or leave an
[issue tracker](https://github.com/opener-project/kaf2json/issues).

## Contributing

1. Fork it <http://github.com/opener-project/kaf2json/fork>
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
