
mkdir /home/manager/bacterial_genomics/scripts

wget https://github.com/ParBLiSS/FastANI/releases/download/v1.33/fastANI-Linux64-v1.33.zip
unzip fastANI-Linux64-v1.33.zip -d /home/manager/bacterial_genomics/scripts

echo "export PATH=$PATH:/home/manager/bacterial_genomics/scripts" >> $HOME/.bashrc 
source $HOME/.bashrc

wget https://github.com/vappiah/bioinfoscripts/raw/main/workshopfiles.zip
unzip workshopfiles.zip -d /home/manager/bacterial_genomics/scripts
cp /home/manager/bacterial_genomics/scripts/environment.yml ./

conda init bash
conda config --set auto_activate_base false
source /home/manager/.bashrc

conda config --add channels conda-forge
conda config --add channels bioconda

conda env create -f environment.yml
conda create -n prokka -c bioconda -c conda-forge -c defaults -q prokka

