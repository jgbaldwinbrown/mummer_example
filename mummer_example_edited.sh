#!/bin/bash
set -e

# temp/mummer/mel2sim/mummer_out_mel2sim.delta:
nucmer -l 100 -prefix mummer_out_mel2sim \
    /home/jgbaldwinbrown/Documents/work_stuff/drosophila/homologous_hybrid_mispairing/mummer/melref2sim/for_ridges/genomes/2/ncbi-genomes-2021-06-09/GCF_003018035.1_ASM301803v1_genomic.fna \
    /home/jgbaldwinbrown/Documents/work_stuff/drosophila/homologous_hybrid_mispairing/mummer/melref2sim/for_ridges/genomes/1/ncbi-genomes-2021-06-09/GCF_003018035.1_ASM301803v1_genomic.fna



# temp/mummer/mel2sim/mummer_out_mel2sim.rq.delta: temp/mummer/mel2sim/mummer_out_mel2sim.delta
	delta-filter -i 95 -r -q mummer_out_mel2sim.delta > mummer_out_mel2sim.rq.delta

# temp/mummer/melref2sim/mummer_out_melref2sim.coords: temp/mummer/melref2sim/mummer_out_melref2sim.rq.delta
	show-coords -o -l -r mummer_out_mel2sim.rq.delta > mummer_out_mel2sim.coords
# temp/mummer/melref2sim/mummer_out_melref2sim.coords.tsv: temp/mummer/melref2sim/mummer_out_melref2sim.rq.delta
	show-coords -o -l -r -T mummer_out_mel2sim.rq.delta > mummer_out_mel2sim.coords.tsv
# temp/mummer/melref2sim/mummer_out_melref2sim.coords.2l.tsv: temp/mummer/melref2sim/mummer_out_melref2sim.coords.tsv
	cat mummer_out_mel2sim.coords.tsv | grep "2L" > mummer_out_mel2sim.coords.2l.tsv
# temp/mummer/melref2sim/mummer_out_melref2sim.coords.2l.mini.bed: temp/mummer/melref2sim/mummer_out_melref2sim.coords.2l.tsv
	cat mummer_out_mel2sim.coords.2l.tsv | awk '{ print $$11, $$2, $$4 }' | tr ' ' '\t' | grep '2L' > mummer_out_mel2sim.coords.2l.bed
temp/mummer/melref2sim/mummer_out_melref2sim.aligns: temp/mummer/melref2sim/mummer_out_melref2sim.rq.delta

show-aligns \
    -r mummer_out_mel2sim.rq.delta \
    "NZ_CP027390.1" \
    "NZ_CP027390.1" \
> mummer_out_mel2sim.aligns

./mummerplot -p out_rq --postscript mummer_out_mel2sim.rq.delta
./mummerplot -p out_raw --postscript mummer_out_mel2sim.delta
cat out_rq.gp | grep -v 'mouse' > out_rq_final.gp
cat out_raw.gp | grep -v 'mouse' > out_raw_final.gp
gnuplot out_rq_final.gp
gnuplot out_raw_final.gp
