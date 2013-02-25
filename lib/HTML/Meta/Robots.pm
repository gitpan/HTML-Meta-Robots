package HTML::Meta::Robots;
############################################################################
# A simple HTML meta tag "robots" generator.
# @copyright © 2013, BURNERSK. Some rights reserved.
# @license http://www.perlfoundation.org/artistic_license_2_0 Artistic License 2.0
# @author BURNERSK <burnersk@cpan.org>
############################################################################
# Perl pragmas.
use strict;
use warnings FATAL => 'all';
use utf8;
use version 0.77; our $VERSION = version->new('v0.1');

############################################################################
# Class constructor.
sub new {
  my ( $class, %params ) = @_;
  my $self = bless {
    index   => 1,
    follow  => 1,
    archive => 1,
    odp     => 1,
    ydir    => 1,
    snippet => 1,
  }, $class;
  $self->index( $params{index} )     if exists $params{index};
  $self->follow( $params{follow} )   if exists $params{follow};
  $self->archive( $params{archive} ) if exists $params{archive};
  $self->open_directory_project( $params{open_directory_project} )
    if exists $params{open_directory_project};
  $self->yahoo( $params{yahoo} )     if exists $params{yahoo};
  $self->snippet( $params{snippet} ) if exists $params{snippet};
  return $self;
}

############################################################################
sub index { ## no critic (ProhibitBuiltinHomonyms)
  my ( $self, $state ) = @_;
  if ( $#_ >= 0 ) {
    ## no critic (ProhibitLongChainsOfMethodCalls)
    if ($state) {
      $self->{index} = 1;
      $self->follow(1)->archive(1)->open_directory_project(1)->yahoo(1)->snippet(1);
    }
    else {
      $self->{index} = 0;
      $self->follow(0)->archive(0)->open_directory_project(0)->yahoo(0)->snippet(0);
    }
  }
  return $self;
}

############################################################################
sub follow {
  my ( $self, $state ) = @_;
  $self->{follow} = $#_ >= 0 ? $state ? 1 : 0 : $self->{follow};
  return $#_ >= 0 ? $self : $self->{follow};
}

############################################################################
sub archive {
  my ( $self, $state ) = @_;
  $self->{archive} = $#_ >= 0 ? $state ? 1 : 0 : $self->{archive};
  return $#_ >= 0 ? $self : $self->{archive};
}

############################################################################
sub open_directory_project {
  my ( $self, $state ) = @_;
  $self->{odp} = $#_ >= 0 ? $state ? 1 : 0 : $self->{odp};
  return $#_ >= 0 ? $self : $self->{odp};
}

############################################################################
sub yahoo {
  my ( $self, $state ) = @_;
  $self->{ydir} = $#_ >= 0 ? $state ? 1 : 0 : $self->{ydir};
  return $#_ >= 0 ? $self : $self->{ydir};
}

############################################################################
sub snippet {
  my ( $self, $state ) = @_;
  $self->{snippet} = $#_ >= 0 ? $state ? 1 : 0 : $self->{snippet};
  return $#_ >= 0 ? $self : $self->{snippet};
}

############################################################################
sub content {
  my ($self) = @_;
  return join ',',
    map { $self->{$_} ? $_ : "no$_" } qw( index follow archive odp ydir snippet );
}

############################################################################
sub meta {
  my ( $self, $no_xhtml ) = @_;
  if ( !$no_xhtml ) {
    return sprintf '<meta name="robots" content="%s"/>', $self->content;
  }
  else {
    return sprintf '<meta name="robots" content="%s">', $self->content;
  }
}

############################################################################
1;
__END__
=pod

=encoding utf8

=head1 NAME

HTML::Meta::Robots - A simple HTML meta tag "robots" generator.

=head1 VERSION

v0.1

=head1 SYNOPSIS

    use HTML::Meta::Robots;
    
    # Default "robots" as meta tag element.
    my $robots = HTML::Meta::Robots->new;
    print sprintf '<html><head>%s</head></html>', $robots->meta;
    
    # Default "robots" as meta tag content.
    my $robots = HTML::Meta::Robots->new;
    printf '<html><head><meta name="robots" content="%s"/></head></html>', $robots->content;
    
    # Do not "allow" creation of google snippets.
    my $robots = HTML::Meta::Robots->new;
    $robots->snippet(0);
    
    # Do not "allow" creation of google snippets and indexing by the Yahoo crawler.
    my $robots = HTML::Meta::Robots->new;
    $robots->snippet(0);
    $robots->yahoo(0);
    # on as one-liner:
    $robots->snippet(0)->yahoo(0);
    
    # What is the indexing state of the Open Directory Project?
    my $robots = HTML::Meta::Robots->new;
    printf "It's %s\n", $robots->open_directory_project ? 'allowed' : 'denied';

=head1 DESCRIPTION

HTML::Meta::Robots is a simple helper object for generating HTML "robot"
meta tags such as:

    <meta name="robots" content="index,allow"/>

HTML::Meta::Robots currently supports the following "robots" attributes:

=over

=item (no)index

Allows or denies any search engine to index the page.

=item (no)follow

Allows or denies any search engine to follow links on the page.

=item archive

Allows or denies the L<Internet Archive|http://www.archive.org/> to cache
the page.

=item odp

Allows or denies the L<Open Directory Project|http://www.dmoz.org/> search
engine to index the page.

=item ydir

Allows or denies the L<Yahoo|http://www.yahoo.com/> search engine to index
the page.

=item snippet

Allows or denies the L<Google|http://www.google.com/> search engine to
display an abstract of the page and at the same time to cache the page.

=back

=head2 Why don't use Moo(se)?

Yes, I could reduce a lot of the code by using Moo(se). However I decided to
not use Moo(se) because of my own experience in "more strict" corporation.
The problem is that some corporation have to review the code they use for
security reasons including all dependencies. Some handlers require this in
order to handle corporation data such as credit cards (PCI-DSS). Doing a
security review is kind of boring and take a lot of valuable time for the
corporation so I have written this Module with no-deps.

=head1 METHODS

=head2 new

Creates and returns a new HTML::Meta::Robots object. For example:

    my $robots = HTML::Meta::Robots->new;

Optional parameters are:

=over

=item index => (1|0)

See L</"index"> for details.

=item follow => (1|0)

See L</"follow"> for details.

=item archive => (1|0)

See L</"archive"> for details.

=item open_directory_project => (1|0)

See L</"open_directory_project"> for details.

=item yahoo => (1|0)

See L</"yahoo"> for details.

=item snippet => (1|0)

See L</"snippet"> for details.

=back

=head2 index

Get or set the index state. For example:

    # Retrieve index state:
    my $state = $robots->index;
    
    # Set index state to allow:
    $robots->index(1);
    
    # Set index state to deny:
    $robots->index(0);

B<Note>, that C<index> will apply its state to all the other attributes when
called as setter!

=head2 follow

Get or set the follow state. For example:

    # Retrieve follow state:
    my $state = $robots->follow;
    
    # Set follow state to allow:
    $robots->follow(1);
    
    # Set follow state to deny:
    $robots->follow(0);

=head2 archive

Get or set the archive state. For example:

    # Retrieve archive state:
    my $state = $robots->archive;
    
    # Set archive state to allow:
    $robots->archive(1);
    
    # Set follow state to deny:
    $robots->archive(0);

=head2 open_directory_project

Get or set the open_directory_project state. For example:

    # Retrieve archive state:
    my $state = $robots->open_directory_project;
    
    # Set open_directory_project state to allow:
    $robots->open_directory_project(1);
    
    # Set open_directory_project state to deny:
    $robots->open_directory_project(0);

=head2 yahoo

Get or set the yahoo state. For example:

    # Retrieve yahoo state:
    my $state = $robots->yahoo;
    
    # Set yahoo state to allow:
    $robots->yahoo(1);
    
    # Set yahoo state to deny:
    $robots->yahoo(0);

=head2 snippet

Get or set the snippet state. For example:

    # Retrieve snippet state:
    my $state = $robots->snippet;
    
    # Set snippet state to allow:
    $robots->snippet(1);
    
    # Set snippet state to deny:
    $robots->snippet(0);

=head2 content

Returns the content part of an HTML robots meta tag. For example:

    printf '<html><head><meta name="robots" content="%s"/></head></html>', $robots->content;

=head2 meta

Returns a string representing a full HTML robots meta tag. For example:

    printf '<html><head>%s</head></html>', $robots->meta;

=head1 BUGS AND LIMITATIONS

Report bugs and feature requests as a
L<GitHub Issue|https://github.com/burnersk/HTML-Meta-Robots/issues>, please.

=head1 AUTHOR

=over

=item BURNERSK E<lt>L<burnersk@cpan.org|mailto:burnersk@cpan.org>E<gt>

=back

=head1 LICENSE AND COPYRIGHT

HTML::Meta::Robots by BURNERSK is licensed under a
L<Artistic 2.0 License|http://www.perlfoundation.org/artistic_license_2_0>.

Copyright © 2013, BURNERSK. Some rights reserved.

=cut
