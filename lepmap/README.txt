This directory serves as an outline for generating high-density
linkage maps using the Lep-MAP3 software suite. It contains all 
files and scripts required to generate maps from genotype calls 
representing an F2 mapping population. The files and scripts here
are meant to supplement a workshop on linkage mapping and do not
contain background about the process of linkage mapping or the 
specifics of each step in that process.

Genotypes are in VCF format in the file
./datafiles/SFxIM767_plate1.scaf6scaf10.vcf

The pedigree file (pedigree.txt) is required by Lep-MAP3 and 
contains information on the genetic relatedness of all samples
present in the VCF. 

The Lep-MAP3 suite itself is all written in Java. It consists of
multiple 'modules' that each perform a step in map creation. For
convenience, the entire suite is provided here in the lepMAP3
directory.

The only dependency for this tutorial is Java version 1.8.x, which
can be installed from java.com. If you are unsure about your 
version of Java, open a Terminal window or terminal emulator and 
type the following command (without the $):

$ java -version

The simplest way to run the tutorial is to: 

1) download the tarball 'lepmap.tar.gz' from
www.github.com/thomnelson/tutorials/
into a directory on your computer.

2) extract from that archive using the command
$ tar xfz ./lepmap.tar.gz

3) and navigate into the new directory
$ cd ./lepmap/

All modules can then be run using the numbered scripts, e.g.:

$ bash ./1.parentcall.sh
$ bash ./2.filtering.sh
... etc

Alternatively, the script 'whole_shebang.sh' will run the entire pipeline:
$ bash ./whole_shebang.sh
