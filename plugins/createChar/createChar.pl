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
		my $char_name = GenerateName("cv(r,c)(en)cv( ,c)vcv(c,#)##");
		message "[CreateChar] Creating Character\n", "system";
		message "[CreateChar] Name : " . $char_name . "\n", "system";
		$hooks = Plugins::addHooks(
			['character_creation_failed', \&failed],
			['character_creation_successful', \&successful],
		);
		$messageSender->sendCharCreate(2, $char_name ,(1 + int rand(10)) ,(1 + int rand(5)) ,0 ,(int rand(2)) );
		$timeout{'charlogin'}{'time'} = time;
		$args->{return} = 2;
	}
}

sub failed {
	my (undef, $args) = @_;
	Plugins::delHooks($hooks);
	$hooks = Plugins::addHooks(
		['charSelectScreen', \&create],
	);
}

sub successful {
	my (undef, $args) = @_;
	Plugins::delHooks($hooks);
	$hooks = Plugins::addHooks(
		['charSelectScreen', \&login],
	);
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
	my $generated = "";
	if ( $pattern =~ m/\(/ and $pattern =~ m/\)/ ) {
		my @Array;
		my @Groups = ( $pattern =~ m/\((.*?)\)/g );
		my $PlaceHolder = $pattern;
		for(my $index=0;$index<=$#Groups;$index++){
			$PlaceHolder =~ s/$Groups[$index]/$index/g;
		}
		my @chars = split("", $PlaceHolder);
		foreach my $val (@chars) {
			$generated = $generated . gen_char($val);
	  	}
	  	for(my $index=0;$index<=$#Groups;$index++){
	  		my $chr = "";
	  		if( $Groups[$index] =~ m/\,/ ){
	  			my @choices = split(",", $Groups[$index]);
	  			$chr = gen_char($choices[rand @choices]);
	  		}else{
	  			$chr = $Groups[$index];
	  		}
			$generated =~ s/\($index\)/$chr/g;
	    }
	} else {
		my @chars = split("", $pattern);
		foreach my $val (@chars) {
			$generated = $generated . gen_char($val);
	  	}
  	}
  	return lc $generated;
}

sub gen_char {
	my ($char) = @_;
	my @Consonants = ("B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z");
	my @Vowels = ("A","E","I","O","U");
	if ($char eq "c" )
	{
		return $Consonants[rand @Consonants];
	} elsif ( $char eq "v" ) {
		return $Vowels[rand @Vowels];
	} elsif ( $char eq "#" ) {
		return (int rand(10))
	} else {
		return $char;
	}
}
1;