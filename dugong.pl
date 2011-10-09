#!/usr/bin/perl6
# SIMPLE perl6 file fuzzer
# Written by Eldar "Wireghoul" Marcussen

use v6;
my $VERSION = 0.1;

my $count = @*ARGS[1];
say "Making $count files";
loop (my $file = 1; $file <= $count; $file++) {
  &mix_file( @*ARGS[0], $file );
}

sub pick_parent {
    my ($dir, $exclude) = @_;
    my @files = dir( "$dir" );
	if ($exclude) {
	    @files = @files.grep: {$_ ne $exclude};
	}
	return @files[rand * @files.elems];
}

sub mix_file {
    my ($dir, $outfile) = @_;
    my $patFN = pick_parent( $dir );
    my $matFN = pick_parent( $dir, $patFN );
	my $patFH = slurp "$dir/$patFN";
	my $matFH = slurp "$dir/$matFN";
	# TODO: interpolate function calls and add configurable chunking
	my @father = $patFH.split('');
	my @mother = $matFH.split('');
	my $chunks = [min]  @father.elems, @mother.elems;
	$chunks = $chunks + rand * (([max] @father.elems, @mother.elems) - $chunks);
	my $outFH = open $outfile, :w;
	for 0..$chunks -1 {
	    my @choice = ();
	    push @choice, @father[$_] if @father[$_];
		push @choice, @mother[$_] if @mother[$_];
		#say "$_ :: Picked: {@choice[rand * @choice.elems]} out of {@choice.elems} options";
		#print "{@choice[rand * @choice.elems]}";
		$outFH.print(@choice[rand * @choice.elems]);
	}
	$outFH.close;
}
