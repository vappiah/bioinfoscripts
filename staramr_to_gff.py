from BCBio import GFF
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.SeqFeature import SeqFeature, FeatureLocation


import pandas as pd
df=pd.read_csv('staramr.filtered.tsv',sep='\t',header=None)
#filename,seqname , seqtype, phenotype, identity, overlap, hsp length,contigname,start,end,acccession
#id,source, type, start,end,score,strand, otherinfo

contignames=df[7].unique()
currentcontig=contignames[0]

allfeatures=[]


allgffs=[]
for currentcontig in contignames:
    seq=Seq("")
    rec=SeqRecord(seq,currentcontig)
    contig_info_=df[df[7]==currentcontig].values
    topfeature=SeqFeature()
    subfeatures=[]
    for subinfo in contig_info_:
        perc_identity=subinfo[4]
        feature_type='sequence_feature'
        seqtype=subinfo[2]
        start=subinfo[8]
        end=subinfo[9]
        phenotype=subinfo[3]

        qualifiers= {'source':seqtype,'score':perc_identity,
                     'Phenotype':phenotype,'ID':subinfo[10]}

        if start > end:
            tmp=start
            start=end
            end=tmp
            subfeatures.append(SeqFeature(FeatureLocation(start,end),type=feature_type,strand=None, qualifiers=qualifiers))
    rec.features=subfeatures
        #SeqFeature(FeatureLocation(start, end), type=seqtype, strand=-1, qualifiers=sub_qualifiers)
    allgffs.append(rec)


outfile='staramr_hits.gff'
with open(outfile, "w") as out_handle:
    GFF.write(allgffs, out_handle)     



