package BaseApp::Service::JSONRPC;
use Mojo::Base 'MojoX::JSON::RPC::Service';

my @methods = qw/
    getItems
/;

use JSON;
use Net::OAuth2::AccessToken;
use Net::OAuth2::Profile::WebServer;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    for(@methods){
        $self->register(
            $_ => \&{$_},
            {
                with_self => 1.
            }
        );
    }

    return $self;
}

sub getItems {
    my $self = shift;

    my $token = Net::OAuth2::AccessToken->session_thaw($self->psession->{token}, profile => $self->auth);

    my $items = $token->get('/1/items')->content;
    return decode_json($items);
}

1;
