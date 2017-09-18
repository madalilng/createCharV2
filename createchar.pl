package OpenKore::Plugins::createChar;

use strict;
use Plugins;
use Globals;
use Network::Send;
use Misc;
use AI;
use Utils;
use Log qw(message debug);
use Commands;

our $name = 'createChar';

Plugins::register($name, "$name plugin", \&onUnload);
my $hooks = Plugins::addHooks(['charSelectScreen', undef]);

sub onUnload {
	Plugins::delHooks($hooks);
}

sub create {
	my (undef, $args) = @_;
	Plugins::delHooks($hooks);
	$hooks = Plugins::addHooks(['charSelectScreen', \&login, undef]);
	$messageSender->sendCharCreate(0, $config{CharName}, 1, 1, 'novice', 'F');
	$timeout{'charlogin'}{'time'} = time;
	$args->{return} = 2;
}

sub login {
	my (undef, $args) = @_;
	Plugins::delHooks($hooks);
	$hooks = Plugins::addHooks(['charSelectScreen', \&delete, undef]);
	$messageSender->sendCharLogin(0);
	$timeout{'charlogin'}{'time'} = time;
	$args->{return} = 1;
}
