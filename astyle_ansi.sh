#!/bin/bash

if [[ $# < 1 ]]
then
    echo ex:astyle_ansi.sh style dir1 dir2 ...
        echo ex:style, google/ansi/kr/....
            exit;
            fi
            
            for dir in $@
            do
                echo $dir
                    for path in `find $dir -type f -name "*.cpp" -o -name "*.[ch]" -o -name "*.java"`
                        do
                                echo $path
                                        #astyle --style=ansi -p --suffix=none $path
                                                #astyle --style=stroustrup $path -A4
                                                        #astyle --style=stroustrup --pad-header --attach-inlines --indent-classes $path -A4 -H -xl -C
                                                                astyle --style=linux --pad-header --attach-inlines --indent-modifiers --attach-closing-while --indent-switches $path -A4 -H -xl -xG -xV -S
                                                                        #astyle --style=linux --pad-header --attach-inlines --indent-modifiers --indent-switches $path -A4 -H -xl -xG -S
                                                                                #astyle --style=google -A14 $path
                                                                                    done
                                                                                    done
                                                                                    
            
