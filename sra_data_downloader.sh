#!/bin/bash
#WARNING: The author is not responsible for anything that happens as a result of using this script
help_=$1

if [ "$help_" == "help" ] || [ "$help_" == "--help" ]
then
echo "welcome to the sra data downloader wrapper script"
echo "script usage:"
echo "  ./sra_data_downloader.sh <id_file> <fasterq-dump options>"
echo "     or      "
echo "  ./sra_data_downloader.sh <id_file> t <threads> <fasterq-dump options>"
echo " "
echo "  <id_file>:               is a textfile containing accession numbers of the data to be downloaded"
echo "  t:                       is an indication that the script should use GNU parallel to download the files"
echo "  <threads>:               indicates the number of threads to use. this should be an integer value"
echo "  <fasterq-dump options>:  contains fasterq-dump options to be used." 
echo "                           to learn more about the options, please refer to the sratoolkit wiki" 
echo "                           fasterq-dump options should be separated with a space character"
echo " "
echo "example usage:"
echo "  ./sra_data_downloader.sh textfile.txt --skip-technical --split-files"
echo "  ./sra_data_downloader.sh textfile.txt t 4 --skip-technical"
exit

else


#get current working directory
cwd=$(pwd)

#get the text file 
textfile=$1


#get the accession numbers in the text file
ids=($(cat "$textfile"))



if [ "$2" == "t" ]

then
    batch_downloader="$cwd"/batch_downloader.txt

    threads="$3"


    fasterqdump_options=$(echo "${@:4}")

    echo "id_file:              $textfile"
    echo "number of threads:    $threads"
    echo "fasterq-dump options: $fasterqdump_options"

    if [ -f "$batch_downloader" ]
    then
        rm "$batch_downloader"
    fi

    echo "downloading files using $threads threads"

    for id in ${ids[@]}
    do


       echo $"fasterq-dump $id $fasterqdump_options">>"$batch_downloader"
     done
    parallel --jobs "$threads" < "$batch_downloader"
    rm "$batch_downloader"

else

    fasterqdump_options=$(echo "${@:2}")   
    echo "id_file:              $textfile"
    echo "fasterq-dump options: $fasterqdump_options"

    for id in ${ids[@]}
    do
      echo "downloading $id"
     fasterq-dump $id $fasterqdump_options
    done

fi








fi











