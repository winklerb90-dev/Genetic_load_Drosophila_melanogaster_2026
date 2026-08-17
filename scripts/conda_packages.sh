# This can (/should) be run directly through the command console inside the slurm environment.
# Inside a .sh script just activate the conda environment in case the module is not available via module avail.
# The modules starting with '#' are used in the attic section.

module load lang/Anaconda3/2024.06-1
conda create --name >choose_env_name<
source activate base
conda activate >insert_env_name<
conda install bioconda::phast==1.9.7
conda install bioconda::gerp==2.1 # in gerp section 'tvkent download' is described too
conda install bioconda::bedtools==2.31.1
conda install conda-forge::r-bigsnpr==1.12.21
conda install bioconda::beagle==5.4_22Jul22.46e
conda install bioconda::plink==1.90b6.21

# conda install bioconda::bwa-mem2==2.3
# conda install bioconda::trimal==1.5.1
# conda install bioconda::iqtree==3.1.2
