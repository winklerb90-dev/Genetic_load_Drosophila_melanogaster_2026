# This can (/should) be run directly through the command console inside the slurm environment.
# Inside a .sh script just activate the conda environment in case the module is not available via module avail.
# The modules starting with '#' are used in the attic section.

module load lang/Anaconda3/2024.06-1
conda create --name gerp_env
source activate base
conda activate gerp_env
conda install bioconda::phast==1.9.7
conda install gerp # in step 5 installation of original version is described
conda install bioconda::bedtools==2.31.1

#> conda install bioconda::trimal==1.5.1
#> conda install bioconda::iqtree==3.1.2
