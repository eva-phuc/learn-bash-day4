#!/bin/bash
NUM=$1
URL="https://s3-ap-northeast-1.amazonaws.com/aucfan-tuningathon/dataset/"
PREF="result.day"
POSTF=".log"
GZF=".gz"
FILE=
if [ -f "t.txt" ]
then
rm t.txt
fi

# download file
for((i=1;i<=$NUM;i++))
do
	if [ $i -lt 10 ]
	then
		num="0"$i
	else
		num=$i
	fi

	file=$PREF$num$POSTF	
	gzfile=$file$GZF
	link=$URL$gzfile
	if [ ! -f $file ]
	then
		wget --no-check-certificate $link -O $gzfile
		gzip -d $gzfile
	fi
done

# calculate
START=$(date +%s)
for((j=1;j<=$NUM;j++))
do
	if [ $j -lt 10 ]
	then
		num="0"$j
	else
		num=$j
	fi
	newfile=$PREF$num$POSTF
	FILE=$FILE"	$newfile"
	echo "The number of unique user in day $num is: `cut -f 3 $newfile | sort | uniq | wc -l`."
done

cat $FILE | cut -f 2,3 | sort | uniq > total.log
echo "The number of unique user in total is: `cut -f 2 total.log | sort | uniq | wc -l`."

for i in $(cut -f 1 total.log | sort | uniq)
do
	echo "The number of unique user in $i : `grep $i total.log | wc -l`."
done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"

