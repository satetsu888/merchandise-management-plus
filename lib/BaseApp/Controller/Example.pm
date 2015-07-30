package BaseApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use URI;
use URI::QueryParam;
use JSON;
use LWP::UserAgent;


use constant {
    AUTH_ENDPOINT  => 'https://api.thebase.in/1/oauth/authorize',
    TOKEN_ENDPOINT => 'https://api.thebase.in/1/oauth/token',
};

# This action will render a template
sub welcome {
  my $self = shift;
  my $config = $self->config;


  my $auth_uri = URI->new(AUTH_ENDPOINT);
  $auth_uri->query_form({
    response_type => 'code',
    client_id     => $config->{client_id},
    redirect_uri  => $config->{redirect_uri},
    scope         => 'read_items write_items',
    state         => 'state',
  });

  $self->redirect_to($auth_uri->as_string);

}

sub callback {
  my $self = shift;
  my $config = $self->config;

  my $code = $self->param('code');

  my $token_uri = URI->new(TOKEN_ENDPOINT);
  my $post_params = +{
    grant_type    => 'authorization_code',
    client_id     => $config->{client_id},
    client_secret => $config->{client_secret},
    code          => $code,
    redirect_uri  => $config->{redirect_uri},
  };

  my $ua = LWP::UserAgent->new;
  my $response = $ua->post($token_uri->as_string, $post_params);
  my $token = decode_json($response->content);

  # Render template "example/welcome.html.ep" with message
  $self->render(
      code => $self->param('code'),
      msg  => 'コールバックページ',
  );
}

1;
