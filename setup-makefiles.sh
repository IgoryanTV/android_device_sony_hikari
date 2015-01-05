#!/bin/bash

VENDOR=sony
DEVICE=hikari
OUTDIR=vendor/$VENDOR/$DEVICE
MAKEFILE=../../../$OUTDIR/device-partial.mk

(cat << EOF) > $MAKEFILE
#
# Copyright 2014-2015, BPaul
#

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`cat proprietary-files.txt | grep -v ^# | grep -v ^$ | wc -l | awk {'print $1'}`
for FILE in `cat proprietary-files.txt | grep -v ^# | grep -v ^$`; do
    COUNT=`expr $COUNT - 1`
    if [ $COUNT = "0" ]; then
        LINEEND=""
    fi

    # Split the file from the destination (format is "file[:destination]")
    OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
    FILE=${PARSING_ARRAY[0]}
    DEST=${PARSING_ARRAY[1]}
    if [ -z "$DEST" ]; then
        DEST=$FILE
    fi

    echo "    $OUTDIR/proprietary/$FILE:system/$DEST$LINEEND" >> $MAKEFILE
done

(cat << EOF) > ../../../$OUTDIR/device-vendor.mk
#
# Copyright 2014-2015, BPaul
#

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_STEM := $DEVICE/device-partial.mk

\$(call inherit-product-if-exists, vendor/sony/\$(LOCAL_STEM))
EOF
