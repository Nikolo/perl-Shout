# NAME

Shout - Perl glue for libshout MP3 streaming source library

# SYNOPSIS

    use Shout        qw{};

    my $conn = new Shout
          host        => 'localhost',
          port        => 8000,
          mount       => 'testing',
          nonblocking => 0,
          password    => 'pa$$word!',
          user        => 'username',
          dumpfile    => undef,
          name        => 'Wir sind nur Affen',
          url         => 'http://stream.io/'
          genre       => 'Monkey Music',
          description => 'A whole lotta monkey music.',
          format      => SHOUT_FORMAT_MP3,
          protocol    => SHOUT_PROTOCOL_HTTP,
          public      => 0;

    # - or -

    my $conn = Shout->new();

    $conn->host('localhost');
    $conn->port(8000);
    $conn->mount('testing');
    $conn->nonblocking(0);
    $conn->set_password('pa$$word!');
    $conn->set_user('username');
    $conn->dumpfile(undef);
    $conn->name('Test libshout-perl stream');
    $conn->url('http://www.icecast.org/');
    $conn->genre('perl');
    $conn->format(SHOUT_FORMAT_MP3);
    $conn->protocol(SHOUT_PROTOCOL_HTTP);
    $conn->description('Stream with icecast at http://www.icecast.org');
    $conn->public(0);

    ### Set your stream audio parameters for YP if you want
    $conn->set_audio_info(SHOUT_AI_BITRATE => 128, SHOUT_AI_SAMPLERATE => 44100);

    ### Connect to the server
    $conn->open or die "Failed to open: ", $conn->get_error;

    ### Set stream info
    $conn->set_metadata('song' => 'Scott Joplin - Maple Leaf Rag');

    ### Stream some data
    my ( $buffer, $bytes ) = ( '', 0 );
    while( ($bytes = sysread( STDIN, $buffer, 4096 )) > 0 ) {
        $conn->send( $buffer ) && next;
        print STDERR "Error while sending: ", $conn->get_error, "\n";
        last;
    } continue {
        $conn->sync
    }

    ### Now close the connection
    $conn->close;

# EXPORTS

Nothing by default.

## :constants

The following error constants are exported into your package if the
'`:constants`' tag is given as an argument to the `use` statement.

        SHOUT_FORMAT_MP3 SHOUT_FORMAT_VORBIS
        SHOUT_PROTOCOL_ICY SHOUT_PROTOCOL_XAUDIOCAST SHOUT_PROTOCOL_HTTP
        SHOUT_AI_BITRATE SHOUT_AI_SAMPLERATE SHOUT_AI_CHANNELS
        SHOUT_AI_QUALITY

## :functions

The following functions are exported into your package if the '`:functions`'
tag is given as an argument to the `use` statement.

        shout_open
        shout_get_connected
        shout_close
        shout_metadata_new
        shout_metadata_free
        shout_metadata_add
        shout_set_metadata
        shout_send_data
        shout_sync
        shout_delay
        shout_set_host
        shout_set_port
        shout_set_mount
        shout_set_nonblocking
        shout_set_password
        shout_set_user
        shout_set_icq
        shout_set_irc
        shout_set_dumpfile
        shout_set_name
        shout_set_url
        shout_set_genre
        shout_set_description
        shout_set_public
        shout_get_host
        shout_get_port
        shout_get_mount
        shout_get_nonblocking
        shout_get_password
        shout_get_user
        shout_get_icq
        shout_get_irc
        shout_get_dumpfile
        shout_get_name
        shout_get_url
        shout_get_genre
        shout_get_description
        shout_get_public
        shout_get_error
        shout_get_errno
        shout_set_format
        shout_get_format
        shout_set_protocol
        shout_get_protocol
        shout_set_audio_info
        shout_get_audio_info
        shout_queuelen

They work almost identically to their libshout C counterparts. See the libshout
documentation for more information about how to use the function interface.

## :all

All of the above symbols can be imported into your namespace by giving the
'`:all`' tag as an argument to the `use` statement.

# DESCRIPTION

This module is an object-oriented interface to libshout, an Ogg Vorbis
and MP3 streaming library that allows applications to easily
communicate and broadcast to an Icecast streaming media server. It
handles the socket connections, metadata communication, and data
streaming for the calling application, and lets developers focus on
feature sets instead of implementation details.

# METHODS

- Constructor

    None of the keys are mandatory, and may be set after the connection object
    is created. This method returns the initialized icecast server
    connection object. Returns the undefined value on failure.

    Parameters

    - host

        destination ip address

    - port

        destination port

    - mount

        stream mountpoint

    - nonblocking

        use nonblocking IO

    - password

        password to use when connecting

    - user

        username to use when connecting

    - dumpfile

        dumpfile for the stream

    - name

        name of the stream

    - url

        url of stream's homepage

    - genre

        genre of the stream

    - format

        SHOUT\_FORMAT\_MP3|SHOUT\_FORMAT\_VORBIS

    - protocol

        SHOUT\_PROTOCOL\_ICY|SHOUT\_PROTOCOL\_XAUDIOCAST|SHOUT\_PROTOCOL\_HTTP

    - description

        stream description

    - public

        list the stream in directory servers?

- _open( undef )_

    Connect to the target server. Returns undef and sets the object error
    message if the open fails; returns a true value if the open
    succeeds.

- _description( $descriptionString )_

    Get/set the description of the stream.

- _close( undef )_

    Disconnect from the target server. Returns undef and sets the object error
    message if the close fails; returns a true value if the close
    succeeds.

- _dumpfile( $filename )_

    Get/set the name of the icecast dumpfile for the stream.  The dumpfile is a
    special feature of recent icecast servers. When dumpfile is not
    undefined, and the x-audiocast protocol is being used, the icecast
    server will save the stream locally to a dumpfile (a dumpfile is just a
    raw mp3 stream dump). Using this feature will cause data to be written
    to the drive on the icecast server, so use with caution, or you will
    fill up your disk!

- _get\_error( undef )_

    Returns a human-readable error message if one has occurred in the
    object. Returns the undefined value if no error has occurred.

- _get\_errno( undef )_

    Returns a machine-readable error integer if an error has occurred in the
    object. Returns the undefined value if no error has occurred.

- _genre( $genreString )_

    Get/set the stream's genre.

- _host( \[$newAddress\] )_

    Get/set the target host for the connection. Argument can be either an
    address or a hostname. It is a fatal error is the argument is a
    hostname, and the numeric address cannot be resolved from it.

- _mount( $mountPointName )_

    Get/set the mountpoint to use when connecting to the server.

- _name( $nameString )_

    Get/set the name of the stream.

- _password( $password )_

    Get/set the password to use when connecting to the Icecast server.

- _user( $username )_

    Get/set the username to use when connecting to the Icecast server.

- _port( $portNumber )_

    Get/set the port to connect to on the target Icecast server.

- _public( $boolean )_

    Get/set the connection's public flag. This flag, when set to true, indicates
    that the stream may be listed in the public directory servers.

- _send( $data\[, $length\] )_

    Send the specified data with the optional length to the Icecast
    server. Returns a true value on success, and returns the undefined value
    after setting the per-object error message on failure.

- _sync( undef )_

    Sleep until the connection is ready for more data. This function should be
    used only in conjuction with `send_data()`, in order to send data at the
    correct speed to the icecast server.

- _delay( undef )_

    Tell how much time (in seconds and fraction of seconds) must be
    waited until more data can be sent. Use instead of sync() to
    allow you to do other things while waiting.

- _set\_metadata( $newMetadata )_

    Update the metadata for the connection. Returns a true value if the update
    succeeds, and the undefined value if it fails.

- _url( $urlString )_

    Get/set the url of the stream's homepage.

## Proxy Methods

- _AUTOLOAD( @args )_

    Provides a proxy for functions and methods which aren't explicitly defined.

# AUTHOR

Jack Moffitt <jack@icecast.org>

# COPYRIGHT

Copyright 2020- Nikolay Shulyakovskiy

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
