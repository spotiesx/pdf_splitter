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

if [[ $1 = "-h" ]]; then
    echo "Short help instructions :)"
elif [[ $1 = "-v" ]]; then
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "          Version: 1.0.3"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Milosz (spoties.wojcik@gmail.com)"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
elif [[ $1 = "" ]]; then
    option(){
        OPTION=`zenity --list --column=Menu "${MENU[@]}" --width 400 --height 500`
    }

    _SCRIPTPATH = pwd
    SIZE="0"
    FILE=""
    PAGE="1"
    OUTPUTNAME=""

    while [ "$OPTION" != "Finish" ] ; do
        MENU=("Pick a file: $FILE"
            "Output PDF name: $OUTPUTNAME"  
            "Page number: $PAGE"
            "Execute"
            "Finish")
        clear
        option
        re='^[0-9]+$'
            case $OPTION in
                "Pick a file: $FILE")
                    FILE=`zenity --file-selection --file-filter="*.pdf" --title="Select a File"`
                    SIZE="`qpdf --show-npages $FILE`";;
                "Output PDF name: $OUTPUTNAME")
                    OUTPUTNAME=`zenity --entry --text "Enter output PDF name: "`;;
                "Page number: $PAGE")
                    PAGE=`zenity --entry --text "Enter page number: "`;;
                "Execute")
                    if [[ $FILE == "" ]]; then
                        zenity --error --width=400 --height=200 --text "You did not pick any file!"
                    elif ! [[ $PAGE =~ $re ]]; then
                        PAGE=""
                        zenity --error --width=400 --height=200 --text "Page number is not an integer!"
                    elif [[ $PAGE > $SIZE ]]; then
                        PAGE=""
                        zenity --error --width=400 --height=200 --text "There are no pages with this index!"
                    else
                        if [[ $OUTPUTNAME == "" ]]; then
                            OUTPUTNAME="extracted"
                        fi
                        qpdf $FILE --pages . $PAGE -- `pwd`/result_pdfs/$OUTPUTNAME.pdf   
                    fi
            esac
    done
else 
    echo "Unknown option"
fi

