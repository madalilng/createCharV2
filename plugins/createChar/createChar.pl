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
		my $char_name = GenerateName("cv(r,v)(en)cv( ,c)vcvcv");
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
	my @Consonants = ("B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z");
	my @Vowels = ("A","E","I","O","U");

	if ( $pattern =~ m/\(/ and $pattern =~ m/\)/ ) {
		
		my @Array;
    	my @Groups = ( $pattern =~ m/\((.*?)\)/g );
    	my $PlaceHolder = $pattern;

    	for(my $index=0;$index<=$#Groups;$index++){
	      $PlaceHolder =~ s/$Groups[$index]/$index/g;
	    }

	    my @chars = split("", $PlaceHolder);
	    foreach my $val (@chars) {
	    	if ($val eq "c" )
	    	{
	    		$generated = $generated . $Consonants[rand @Consonants];
	    	} elsif ( $val eq "v" ) {
	    		$generated = $generated . $Vowels[rand @Vowels];
	    	} else {
	    		$generated = $generated . $val;
	    	}
	  	}

	  	for(my $index=0;$index<=$#Groups;$index++){
	  		my $chr = "";
	  		if( $Groups[$index] =~ m/\,/ ){
	  			my @choices = split(",", $Groups[$index]);
	  			$chr = $choices[rand @choices];
	  		}else{
	  			$chr = $Groups[$index];
	  		}
	      	$generated =~ s/\($index\)/$chr/g;
	    }

	} else {
		my @chars = split("", $pattern);
		foreach my $val (@chars) {
	    	if ($val eq "c" )
	    	{
	    		$generated = $generated . $Consonants[rand @Consonants];
	    	} elsif ( $val eq "v" ) {
	    		$generated = $generated . $Vowels[rand @Vowels];
	    	} else {
	    		$generated = $generated . $val;
	    	}
	  	}
  	}
  	return lc $generated;
}
1;