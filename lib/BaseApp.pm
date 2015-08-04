package BaseApp;
use Mojo::Base 'Mojolicious';

use BaseApp::Service::JSONRPC;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  $self->plugin('Config');

  $self->plugin(
      'json_rpc_dispatcher',
      services => {
          '/jsonrpc' => BaseApp::Service::JSONRPC->new,
      }
  );

  $self->helper(
      psession => sub {
          my $self = shift;
          my $env = $self->req->env;
          return $env->{'psgix.session'};
      }
  );


  $self->helper(
      auth => sub {
          my $self = shift;
          return Net::OAuth2::Profile::WebServer->new(
              name           => 'BASE API Client',
              client_id      => $self->config->{client_id},
              client_secret  => $self->config->{client_secret},
              redirect_uri   => $self->config->{redirect_uri},
              site           => 'https://api.thebase.in/',
              scope          => 'read_items write_items',
              authorize_path     => '/1/oauth/authorize',
              access_token_path  => '/1/oauth/token',
              refresh_token_path => '/1/oauth/token',
          );
      }
  );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->get('/callback')->to('example#callback');
  $r->get('/main')->to('example#main');
}


1;
