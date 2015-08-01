package BaseApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use Net::OAuth2::Client;
use Net::OAuth2::Profile::WebServer;

sub welcome {
  my $self = shift;
  my $config = $self->config;

  $self->redirect_to($self->_auth->authorize);
}

sub callback {
  my $self = shift;
  my $config = $self->config;

  my $code = $self->param('code');

  my $token  = $self->_auth->get_access_token($self->param('code'));
  $self->psession->{token} = $token->session_freeze;

  $self->render(
      code => $self->param('code'),
      msg  => 'コールバックページ',
  );
}

sub _auth {
    my $self = shift;
    return Net::OAuth2::Profile::WebServer->new(
        name           => 'Google Contacts',
        client_id      => $self->config->{client_id},
        client_secret  => $self->config->{client_secret},
        redirect_uri   => $self->config->{redirect_uri},
        site           => 'https://api.thebase.in/',
        scope          => 'read_items write_items',
        authorize_path    => '/1/oauth/authorize',
        access_token_path => '/1/oauth/token',
    );
}

1;
