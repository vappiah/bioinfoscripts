
mkdir scripts
mkdir tmp
wget https://github.com/ParBLiSS/FastANI/releases/download/v1.33/fastANI-Linux64-v1.33.zip
unzip fastANI-Linux64-v1.33.zip 
mv fastANI /home/manager/bacterial_genomics/scripts

echo "export PATH=$PATH:/home/manager/bacterial_genomics/scripts" >> $HOME/.bashrc 
source $HOME/.bashrc

wget https://github.com/vappiah/bioinfoscripts/raw/main/workshopfiles.zip
unzip workshopfiles.zip -d tmp
mv tmp/finalscripts/* scripts
cp scripts/environment.yml ./

conda init bash
conda config --set auto_activate_base false
source /home/manager/.bashrc

conda config --add channels conda-forge
conda config --add channels bioconda

conda env create -f environment.yaml
conda create -n prokka -c bioconda -c conda-forge -c defaults prokka

