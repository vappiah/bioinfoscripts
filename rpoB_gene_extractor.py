#This script was written by Vincent Appiah
#This program extracts the sequence of rpoB gene from genbank files
#Don't forget to like my github page (vappiah) and my youtube channel(Bioinformatics Coach)
#You are free to use, modify and distribute this script
#I am not responsible for any anything that happens as a result of using this script
#Before using this script , make sure you are OK with the codes 


from Bio import SeqIO
import os
from glob import glob
import sys

gene_of_interest='rpoB'

file_directory=sys.argv[1]

file_names=glob('%s/*.gb'%file_directory)

sequences=[]


def extract_sequence(genbank_file,gene_of_interest):
    '''This script will extract rpoB gene sequences from genbank files
    All the extracted sequences will be placed into a single multi-fasta file.
    The multi-fasta file will be found in the same directory as your genbank files'''
    
    gb_obj=SeqIO.read(genbank_file,'gb')
    genes=[]
    for feature in gb_obj.features:
        if feature.type=='gene':
            genes.append(feature)
    hits=[]
    for gene in genes:
        if 'gene' in gene.qualifiers.keys():
            if gene_of_interest == gene.qualifiers['gene'][0]:
                hits.append(gene)
                print('gene found')
    rpoB=hits[0]
    extracted_sequence=rpoB.extract(gb_obj)
    
    return extracted_sequence

for file_ in file_names:
    sequence=extract_sequence(file_,gene_of_interest)
    name=os.path.split(file_)[-1]
    name=name.strip('.gb')
    sequence.id=name
    sequence.description=''
    sequences.append(sequence)
    
outputfile='%s/rpoB.fasta'%file_directory
SeqIO.write(sequences,outputfile,'fasta')

    
