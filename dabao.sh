#!/bin/bash
#�ýű����Զ���ȡ�����汾֮���ļ��ı仯��������������ڵ��ļ����Զ�����
#ע��:�ýű�ֻ����git����Ч�ұ������git�ֿ�ĸ�Ŀ¼��
if [ "$1" == "" ] || [ "$2" == "" ] || [ "$1" == "$2" ]
then
    echo "error,input hash1 hash2 ";
        exit
        fi
        
        path=$(pwd)
        #echo $path
        time=$(date +%Y%m%d_%H_%M_%S)
        updateoldname="update_"$time"_old.tar.gz"
        updatenewname="update_"$time"_new.tar.gz"
        array=($(git diff $1 $2 --name-only ./))
        #array=($(git log --pretty=format:"" --name-only --after="$1" ./))
        declare -A filemap
        for i in ${array[@]}
        do
            #�ļ��Ƿ����
                echo $i;
                    if [ -z "${filemap[$i]}" ] && [ -f "$i" ]
                        then
                                filemap[$i]=1
                                    fi
                                    done
                                    
                                    for i in ${!filemap[@]}
                                    do
                                        data=$data$i"\n"
                                        done
                                        echo -e $data | xargs tar -czf $updatenewname
                                        git reset --hard $2
                                        echo -e $data | xargs tar -czf $updateoldname
                                        git reset --hard $1
                                        
