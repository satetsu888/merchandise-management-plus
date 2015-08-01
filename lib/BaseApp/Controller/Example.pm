package BaseApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use Net::OAuth2::Client;
use Net::OAuth2::AccessToken;
use Net::OAuth2::Profile::WebServer;

sub welcome {
    my $self = shift;

    if($self->_has_valid_token){
        $self->redirect_to($self->req->url->base.'/main');
    } else {
        $self->redirect_to($self->_auth->authorize);
    }
}

sub callback {
    my $self = shift;

    my $code = $self->param('code');
    unless($code){
        $self->redirect_to($self->req->url->base.'/');
        return;
    }

    my $error = $self->param('error');
    if($error){
        $self->redirect_to($self->req->url->base.'/');
        return;
    }

    my $token  = $self->_auth->get_access_token($code);
    $self->psession->{token} = $token->session_freeze;

    $self->redirect_to($self->req->url->base.'/');
}

sub main {
    my $self = shift;

    $self->render(
        msg  => 'メインページ',
    );

}

sub _auth {
    my $self = shift;
    return Net::OAuth2::Profile::WebServer->new(
        name           => 'BASE API Client',
        client_id      => $self->config->{client_id},
        client_secret  => $self->config->{client_secret},
        redirect_uri   => $self->config->{redirect_uri},
        site           => 'https://api.thebase.in/',
        scope          => 'read_items write_items',
        authorize_path    => '/1/oauth/authorize',
        access_token_path => '/1/oauth/token',
    );
}

sub _has_valid_token {
    my $self = shift;

    my $psession = $self->psession;
    return 0 unless $self->psession;

    my $token_data = $self->psession->{token};
    return 0 unless $token_data;

    my $token = Net::OAuth2::AccessToken->session_thaw($token_data, profile => $self->_auth);
    return 0 unless $token;

    if($token->expired){
        warn "token expired";
        $token = $token->refresh();
    };
    return 0 unless $token;

    $self->psession->{token} = $token->session_freeze;

    return 1;
}

1;
