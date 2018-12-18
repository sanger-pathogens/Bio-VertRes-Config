#!/usr/bin/env perl
package Bio::VertRes::Config::Tests;
use Moose;
use Data::Dumper;
use File::Temp;

use File::Find;
use Test::Most;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
with 'TestHelper';

my $script_name = 'Bio::VertRes::Config::CommandLine::PacbioRegister';

my %scripts_and_expected_files = (
    '-a ABC '                  => ['command_line.log'],
    '-t study -i ZZZ' => [
        'command_line.log',
		'pathogen_pacbio_track/annotate_assembly/annotate_assembly_ZZZ_canu.conf',
		'pathogen_pacbio_track/annotate_assembly/annotate_assembly_ZZZ_hgap.conf',
        'pathogen_pacbio_track/annotate_assembly/annotate_assembly_ZZZ_pacbio.conf',
        'pathogen_pacbio_track/assembly/assembly_ZZZ_hgap.conf',
        'pathogen_pacbio_track/import_cram/import_cram_global.conf',
        'pathogen_pacbio_track/pathogen_pacbio_track.ilm.studies',       
        'pathogen_pacbio_track/pathogen_pacbio_track_annotate_assembly_pipeline.conf',
        'pathogen_pacbio_track/pathogen_pacbio_track_assembly_pipeline.conf',
        'pathogen_pacbio_track/pathogen_pacbio_track_import_cram_pipeline.conf',  
    ],
    '-t study -i ZZZ --no_annotation' => [
        'command_line.log',
        'pathogen_pacbio_track/assembly/assembly_ZZZ_hgap.conf',
        'pathogen_pacbio_track/import_cram/import_cram_global.conf',
        'pathogen_pacbio_track/pathogen_pacbio_track.ilm.studies',       
        'pathogen_pacbio_track/pathogen_pacbio_track_assembly_pipeline.conf',
        'pathogen_pacbio_track/pathogen_pacbio_track_import_cram_pipeline.conf',  
    ],
);

mock_execute_script_and_check_output_ignore_regex( $script_name, \%scripts_and_expected_files,'permission' );


# Check the format of assembly and annotate config file
%scripts_and_expected_files = (
    '-t study -i ZZZ --no_circularise' => [
        'pathogen_pacbio_track/assembly/assembly_ZZZ_hgap.conf',
        't/data/expected/assembly_ZZZ_hgap.conf'
    ],
     '-t study -i ZZZ' => [
        'pathogen_pacbio_track/assembly/assembly_ZZZ_hgap.conf',
        't/data/expected/assembly_ZZZ_hgap_circularise.conf'
    ],
     '-t study -i ZZZ --genome_size 2000000' => [
        'pathogen_pacbio_track/assembly/assembly_ZZZ_hgap.conf',
        't/data/expected/assembly_ZZZ_hgap_genome_size.conf'
    ],
    '-t study -i ZZZ' => [
        'pathogen_pacbio_track/annotate_assembly/annotate_assembly_ZZZ_pacbio.conf',
        't/data/expected/annotate_assembly_ZZZ_pacbio.conf'
    ],
    '-t study -i ZZZ' => [
        'pathogen_pacbio_track/annotate_assembly/annotate_assembly_ZZZ_hgap.conf',
        't/data/expected/annotate_assembly_ZZZ_hgap.conf'
    ],
    '-t study -i ZZZ' => [
        'pathogen_pacbio_track/annotate_assembly/annotate_assembly_ZZZ_canu.conf',
        't/data/expected/annotate_assembly_ZZZ_canu.conf'
    ],
	
);


mock_execute_script_create_file_and_check_output( $script_name,
    \%scripts_and_expected_files );


done_testing();

