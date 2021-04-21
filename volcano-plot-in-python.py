
#import libraries

import pandas as pd
from bioinfokit import analys,visuz

#set data_path
data_path="testvolcano.csv"
df=pd.read_csv(data_path)

#show first five data points
print(df.head())

#plot and save. Plot will be saved in the current working directory
visuz.gene_exp.volcano(df=df,lfc='log2FC',pv='p-value')

#plot and open . This will not save the image
visuz.gene_exp.volcano(df=df,lfc='log2FC',pv='p-value',show=True)

#plot and rotate x-axis labels
visuz.gene_exp.volcano(df=df,lfc='log2FC',pv='p-value',ar=0,show=True)

#show statistically significant differentially expressed genes based on thresholds
visuz.gene_exp.volcano(df=df,lfc='log2FC',pv='p-value',ar=0,show=True,plotlegend=True,
                        legendpos='upper right',lfc_thr=(1,2),pv_thr=(0.05,0.01))

#change plot color
visuz.gene_exp.volcano(df=df,lfc='log2FC',pv='p-value',ar=0,color=('blue','grey','green'),show=True)


#Add gene labels
visuz.gene_exp.volcano(df=df,lfc="log2FC",pv="p-value",geneid="GeneNames"
                        ,genenames=("LOC_Os09g01000.1", "LOC_Os01g50030.1", 
                                    "LOC_Os06g40940.3"),ar=0,show=True)

