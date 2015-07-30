#!/usr/bin/env plackup
use Mojo::Server::PSGI;
use Plack::Builder;

use Cache::Memcached::Fast;

builder {
    enable 'Session::Simple',
        store => Cache::Memcached::Fast->new( { servers => [qw/127.0.0.1:11211/] } ),
        cookie_name => 'base_app_session'
    ;
    my $server = Mojo::Server::PSGI->new;
    $server->load_app('./script/base_app');
    $server->to_psgi_app;
};
