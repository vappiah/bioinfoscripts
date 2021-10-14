#!/bin/bash
#WARNING: The author is not responsible for anything that happens as a result of using this script
help_=$1

if [ "$help_" == "help" ] || [ "$help_" == "--help" ]
then
echo "welcome to the sra data downloader wrapper script"
echo "script usage:"
echo "  ./sra_data_downloader.sh <id_file> b <no_of_files_per_batch> < <fasterq-dump options>"
echo "  or "
echo " ./sra_data_downloader.sh <id_file> p <no_of_jobs> <fasterq-dump options>"

echo " "
echo "  <id_file>:               is a textfile containing accession numbers of the data to be downloaded."
echo "  b:                       is an indication that the script should download the data in batches."
echo "  <no_of_files_per_batch>: indicates the number of files to download per batch." 
echo "                           this should be an integer value."
echo "                           eg. if no_of_files_per_batch is 5, every batch to be downloaded will"
echo "                           will comprise of 5 files." 
echo "  p:                       indicates that GNU parallel should be used for downloading the data."
echo "                           the files to be downloaded will be distributed among the cpus."
echo " <no_of_jobs>:             this indicates the number of jobs to be distributed."
echo "                           eg. if no_of_jobs of 5 means that the task will be split in 5"
echo "                           and distributed among the cpus on the system"
echo "                           this should be an integer value."
echo "  <fasterq-dump options>:  contains fasterq-dump options to be used." 
echo "                           to learn more about the options, please refer to the sratoolkit wiki." 
echo "                           fasterq-dump options should be separated with a space character."
echo " "
echo "example usage:"
echo "  ./sra_data_downloader.sh textfile.txt"
echo "  ./sra_data_downloader.sh textfile.txt b 4 --skip-technical --split-files"
echo "  ./sra_data_downloader.sh textfile.txt p 4 --skip-technical"

exit

else

    set -e
    #get current working directory
    cwd=$(pwd)


    #get all bash arguments
    allargs=("$@")


    #get the text file that contains the accesssion numbers
    textfile=$1

 
    #get the accession numbers in the text file
    ids=($(cat "$textfile"))



    if [ "$2" == "b" ]

    then
        nfiles=$3
    #if [ ! -n "$3" ]
        if ! echo "$3" | grep -qE '^[0-9]+$';
        then
            echo "please specify the number of files per batch."
            echo "the value should be an integer." 
            echo "$nfiles files was specified. this is a wrong entry" 
            exit
    
        else
      
            number_of_files_per_batch="$3"
            fasterqdump_options=(${allargs[@]:3})
        fi

    elif [ "$2" == "p" ]
    then
        batch_downloader="$cwd"/batch_downloader.txt
        njobs="$3"
        if ! echo "$3" | grep -qE '^[0-9]+$';
        then
            echo "please specify the number of jobs."
            echo "the value should be an integer." 
            echo "\"$njobs\" jobs was specified. this is a wrong entry"
       	    exit
        else
            fasterqdump_options=(${allargs[@]:3})
            echo "number of jobs: $njobs "
            foptions=$(IFS=" " ; echo "${fasterqdump_options[*]}")
            echo "id_file:              $textfile"
            echo "fasterq-dump options: $foptions"

            if [ -f "$batch_downloader" ]
            then
                rm "$batch_downloader"
            fi

          
            for id in ${ids[@]}
            do
            echo $"fasterq-dump $id $foptions">>"$batch_downloader"
            done
           
           
            parallel --jobs "$njobs" < "$batch_downloader"
            rm "$batch_downloader"
            exit
         fi


            


    else
        declare -i number_of_files_per_batch=1
        fasterqdump_options=(${allargs[@]:1})

    

    #fasterqdump_options=$(echo "${@:2}")   
    fi

   
    echo "number of files per batch: $number_of_files_per_batch"
  

    foptions=$(IFS=" " ; echo "${fasterqdump_options[*]}")
    echo "id_file:              $textfile"
    echo "fasterq-dump options: $foptions"


    b="$number_of_files_per_batch"

    for((i=0; i < ${#ids[@]}; i+=b))
    do
       part=( "${ids[@]:i:b}" )
       allids=$(IFS=" "  ; echo "${part[*]}")
       
       batch_ids="$allids "
       echo "Downloading $batch_ids"

       cmd="fasterq-dump $batch_ids $foptions"
       echo $cmd
       eval $cmd
       #fasterq-dump ${batch_ids} ${foptions}
       done

fi











