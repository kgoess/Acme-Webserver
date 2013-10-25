#!/usr/bin/perl -Tw
use strict;
use Socket;
use Carp;

my $EOL = "\015\012";

sub logmsg { print "$0 $$: @_ at ", scalar localtime, "\n" }

my $port = shift || 2345;
my $proto = getprotobyname('tcp');

($port) = $port =~ /^(\d+)$/                        or die "invalid port";

my $socket;

socket($socket, PF_INET, SOCK_STREAM, $proto)        || die "socket: $!";
setsockopt($socket, SOL_SOCKET, SO_REUSEADDR,
                                    pack("l", 1))   || die "setsockopt: $!";
bind($socket, sockaddr_in($port, INADDR_ANY))        || die "bind: $!";
listen($socket,SOMAXCONN)                            || die "listen: $!";

logmsg "server started on port $port";

my $paddr;

$SIG{CHLD} = \&REAPER;

my $client_fh;

while (my $paddr = accept($client_fh, $socket)) { 
	my($port,$iaddr) = sockaddr_in($paddr);
	my $name = gethostbyaddr($iaddr,AF_INET);
	logmsg "connection from $name [", inet_ntoa($iaddr), "] at port $port";

	# $client_fh is now available for reading and writing

	# ...
	# ...
	# ...
	
	close $client_fh;
}

