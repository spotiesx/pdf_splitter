#!/bin/bash

# Author           : Milosz ( spoties.wojcik@gmail.com )
# Created On       : 15.01.2021
# Last Modified By : Milosz ( spoties.wojcik@gmail.com )
# Last Modified On : 18.01.2021 
# Version          : 1.0.3
#
# Description      : 
# 
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more # details or contact the Free Software Foundation for a copy)
# 2.   Code should have comments.

# 3.   Script should be immune to various “unwanted” scenarios   of usage

# 4. Each script should have at least two options:

#    -h – short help

#    -v – version and author’s info

# while getopts hvf:q OPT; do
#     case $OPT in
#         h) help;;
#         v) version;;
#         f) FILE=$OPTARG;;
#         q) echo "Text"
#             exit;;
#         *) echo "Unknown option";;
#     esac
# done
if [[ $1 = "-h" ]]; then
    echo "Short help instructions :)"
elif [[ $1 = "-v" ]]; then
    # _LINE="someline content"
    # LAST="${_LINE: -1}"
    # echo $LAST
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "          Version: 1.0.3"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Milosz (spoties.wojcik@gmail.com)"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
else
    option(){
        OPTION=`zenity --list --column=Menu "${MENU[@]}" --width 400 --height 500`
    }
    _SCRIPTPATH=""
    _INPUTNAME=""
    _OUTPUTNAME=""
    _DIR1=""
    _DIR2="~/Desktop/studies/operating_systems/pdf_splitter/result_pdfs"
    _PAGE=""

    while [ "$OPTION" != "Finish" ] ; do
        MENU=("Path to input PDF file directory: $DIR1"
            "Input file name (without .pdf extension): $INPUTNAME"
            "Output file name (without .pdf extension): $OUTPUTNAME"
            "Page number: $PAGE"
            "Execute"
            "Finish")

        if [[ ${_INPUTNAME: -4} -ne ".pdf" ]]; then
            _INPUTNAME="${_INPUTNAME}.pdf"
        fi
        clear
        option
            case $OPTION in
                "Path to input PDF file directory: $DIR1")
                    DIR1=`zenity --entry --text "Enter the path to the file: "`;;
                "Input file name (without .pdf extension): $INPUTNAME")
                    INPUTNAME=`zenity --entry --text "Enter the path to the file: "`'';;
                "Output file name (without .pdf extension): $OUTPUTNAME")
                    OUTPUTNAME=`zenity --entry --text "Enter the path to the file: "`;;
                "Page number: $PAGE")
                    PAGE=`zenity --entry --text "Enter the path to the file: "`;;
                "Execute")
                    # if [[ ${_INPUTNAME: -4} -ne ".pdf" ]]; then
                    #     _INPUTNAME="${_INPUTNAME}.pdf"
                    # fi;;
                    _SCRIPTPATH = pwd
                    cd $DIR2
                    qpdf $DIR1/$INPUTNAME.pdf --pages . $PAGE -- $OUTPUTNAME.pdf
                    cd $_SCRIPTPATH
            esac
    done
fi

