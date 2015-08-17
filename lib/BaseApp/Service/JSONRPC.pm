package BaseApp::Service::JSONRPC;
use Mojo::Base 'MojoX::JSON::RPC::Service';

my @methods = qw/
    getItems
    setItem
    getUser
/;

use JSON;
use Net::OAuth2::AccessToken;
use Net::OAuth2::Profile::WebServer;

use URI::Escape;

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

sub setItem {
    my $self = shift;
    my $params = shift;

    my $token = Net::OAuth2::AccessToken->session_thaw($self->psession->{token}, profile => $self->auth);

    my $item = $params->{data};
    my $nested_variations = delete $item->{variations};

    for(1..5){
        my $key = 'img'.$_.'_origin';
        delete $item->{$key};
    }

    my $update_params = {
        %$item,
        @{flatten_variations($nested_variations)},
    };

    my $content = join '&', map {
        my $key = $_;
        my $value = $update_params->{$_} // '';
        $value = uri_escape_utf8($value) if $value;
        "$key=$value";
    } keys %$update_params;

    my $response =$token->post(
        '1/items/edit',
        ["Content-Type" => "application/x-www-form-urlencoded"],
        $content
    );
    my $result = decode_json($response->content);
    return $result;
}

sub flatten_variations {
    my $nested_variations = shift;

    my @flattend;
    my $index = 0;
    for my $variation (@$nested_variations){

        push @flattend, map {
            $_.'['.$index.']' => $variation->{$_}
        } keys $variation;
        $index++;
    }

    return \@flattend;
};

sub getUser {
    my $self = shift;
    my $params = shift;

    my $token = Net::OAuth2::AccessToken->session_thaw($self->psession->{token}, profile => $self->auth);

    my $user = $token->get('/1/users/me')->content;
    return decode_json($user);
}

1;
