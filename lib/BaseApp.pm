package BaseApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  $self->plugin('Config');

  $self->helper(
      psession => sub {
          my $self = shift;
          my $env = $self->req->env;
          return $env->{'psgix.session'};
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
