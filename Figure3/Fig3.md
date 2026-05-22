[TOC]

Title: "Centenarian2026-Fig 3"
Author: Zhihao Hao
Date: "2026/03/25"

# Fig 3A.Diagram of CGBB construction
   
    This figure is manually drawn by Biorender (https://app.biorender.com/)
    
# Fig 3B.Phylogenetic tree of 16S rDNA

    #16S analysis process follows the EasyAmplicon pipeline (https://doi.org/10.1002/imt2.83)
    
    #Tree editing using online websites iTOL (https://itol.embl.de)

# Fig 3C.Phylogenetic tree of 1557 genomes

     #Genome analysis process follows the EasyMetagenome pipeline (https://doi.org/10.1002/imt2.83) and EasyGenome (unpublished)
     
     #Tree editing using online websites iTOL (https://itol.embl.de)

# Fig 3D.Species Venn diagram of CGBB, CGR2 and HGG

    This figure is manually drawn by Evenn (https://www.bic.ac.cn/test/venn/#/)

# Fig 3E.Phylogenetic tree of CGBB endemic species

    #Tree editing using online websites iTOL (https://itol.embl.de)

# Fig 3F.Genome collinearity analysis

    #0.Venn diagram

    This figure is manually drawn by Evenn (https://www.bic.ac.cn/test/venn/#/)

    #1.Creating conda envitnoment

    #python 3.9
    conda create --name jcvi python=3.9

    #2.Software installation

    #install jcvi prokka
    pip install jcvi
    conda install -c biocnda prokka last
    jcvi --version #jcvi 1.5.11
    prokka --version #prokka 1.15.6

    #3.Genome annotation

    #rename
    sed -E 's/^(>[^_]+_[^_]+)_.*/\1/' Y120.fasta > Y120.fa
    
    #prokka for genome annotation
    for genome_file in *.fa; do
        base_name=$(basename "$genome_file" .fa)
        prokka "$genome_file" \
            --outdir "${base_name}" \
            --prefix "${base_name}" \
            --kingdom Bacteria \
            --cpus 8 \
            --addgenes
    done

    #4.Convert gff to BED

    for f in *.fa; do
        base_name=$(basename "$f" .fa)
        python3 -m jcvi.formats.gff bed \
            --type=CDS \
            --key=ID \
            "${base_name}/${base_name}.gff" \
            -o "${base_name}.bed"
    done
    
    python3 -m jcvi.formats.bed merge Y120.bed Y293.bed Y294.bed -o All.bed

    #5.Identifying homologous regions

    for base_name in Y120 Y293 Y294; do \
        ln -s "${base_name}/${base_name}.ffn" "${base_name}.cds"; \
    done
   
    python3 -m jcvi.compara.catalog ortholog Y293 Y120 --cscore=.99 --no_strip_names
    python3 -m jcvi.compara.catalog ortholog Y293 Y294 --cscore=.99 --no_strip_names
    python3 -m jcvi.compara.catalog ortholog Y120 Y294 --cscore=.99 --no_strip_names
    
    #6.Generate simple file

    python3 -m jcvi.compara.synteny screen --simple Y293.Y294.anchors Y293.Y294.anchors.new
    python3 -m jcvi.compara.synteny screen --simple Y293.Y120.anchors Y293.Y120.anchors.new
    python3 -m jcvi.compara.synteny screen --simple Y120.Y294.anchors Y120.Y294.anchors.new
    
    #7.Preparing the layout file
    
    vim layout 
    # y, xstart, xend, rotation, color, label, va, bed
     .70,    .1,    .88,     0, #2E5F8A, Y120, top, Y120.bed
     .50,    .1,    .88,     0, #D95319, Y293, top, Y293.bed
     .30,    .1,    .88,     0, #77AC30, Y294, top, Y294.bed
    # edges
    e, 0, 1, Y293.Y120.anchors.simple
    e, 0, 2, Y120.Y294.anchors.simple
    e, 1, 2, Y293.Y294.anchors.simple
    
    #8.Prepating the seqids file
    
    for genome in Y120 Y293 Y294; do
        grep ">" "${genome}/${genome}.fna" | sed 's/>//' | awk -v ORS=',' '{print $1}' | sed 's/,$//' >> seqid.txt
        echo "" >> seqid.txt
    done

    #9.Collinearity visualization
    python3 -m jcvi.graphics.karyotype --format=pdf --figsize=15x10 seqid.txt layout.txt

