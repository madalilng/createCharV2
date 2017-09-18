package createChar;

use strict;
use Plugins;
use Globals;
use Network::Send;
use Misc;
use AI;
use Utils;
use Log qw(message error warning debug);
use Commands;

my $hooks = Plugins::addHooks(
	['charSelectScreen', \&create],
);

Plugins::register('charCreate_test', 'Automatically Create character', sub { Plugins::delHooks($hooks) });

sub create {
	my (undef, $args) = @_;
	Plugins::delHooks($hooks);
	if ($config{char} != 1 ) {
		message "[CreateChar] Creating Character\n", "system";
		$hooks = Plugins::addHooks(
			['charSelectScreen', \&login],
		);
		$messageSender->sendCharCreate(1, GenerateName("cvcrrc cvcrv"));
		$timeout{'charlogin'}{'time'} = time;
		$args->{return} = 2;
	}
}

sub login {
	my (undef, $args) = @_;
	Plugins::delHooks($hooks);
	configModify("char", "1");
	$messageSender->sendCharLogin(1);
	$timeout{'charlogin'}{'time'} = time;
	$args->{return} = 1;
}

sub GenerateName {
	my ($pattern) = @_;
	my @chars = split("", $pattern);
	my $generated = "";
	my @Consonants = ("B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z");
	my @Vowels = ("A","E","I","O","U");

	foreach my $val (@chars) {
    	if ($val eq "c" )
    	{
    		$generated = $generated . $Consonants[rand @Consonants];
    	} elsif ( $val eq "v" ) {
    		$generated = $generated . $Vowels[rand @Vowels];
    	} elsif ( $val eq " "){
    		$generated = $generated . " ";
    	}
    	else {
    		my $r = int(rand(2));
    		if ($r eq 1){
    			$generated = $generated . $Consonants[rand @Consonants];
    		} else {
    			$generated = $generated . $Vowels[rand @Vowels];
    		}
    	}
  	}
  	return lc $generated;
}
1;
