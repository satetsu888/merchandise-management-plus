package BaseApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use URI;
use URI::QueryParam;

use constant {
    AUTH_URI_BASE => 'https://api.thebase.in/1/oauth/authorize',
};

# This action will render a template
sub welcome {
  my $self = shift;


  my $auth_uri = URI->new(AUTH_URI_BASE);
  $auth_uri->query_form({
    response_type => 'code',
    client_id     => '4823f3464dc6ab2a9c354dcbb8874f4d',
    redirect_uri  => 'http://satetsu888.com/base_app/callback',
    scope         => 'read_items write_items',
    state         => 'state',
  });

  $self->redirect_to($auth_uri->as_string);

}

sub callback {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(
      code => $self->param('code'),
      msg  => 'コールバックページ',
  );
}

1;
