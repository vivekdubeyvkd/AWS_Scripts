AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
BUCKET_ROOT=""
BUCKET_NAME="${BUCKET_ROOT}/"

aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}

 aws s3 ls ${BUCKET_NAME}/ --recursive | while read line
 do
     fileName="\$(echo \${line}|cut -d' ' -f4-)"
     if [[ "\${fileName}" != "" ]]
     then
         aws s3 ls "${BUCKET_ROOT}/\${fileName}"
         if [ \$? -eq 0 ]
         then
             fileCreateDateRaw=\$(echo \$line|awk '{print \$1" "\$2}')
             fileCreateDate=\$(date -d"\$fileCreateDateRaw" +%s)
             olderThan=\$(date --date "25 days ago" +%s)
                  
             if [[ \$fileCreateDate -lt \$olderThan ]]
             then
                 echo "removing ${BUCKET_ROOT}/\${fileName} with create date \${fileCreateDateRaw}"
                 aws s3 rm "${BUCKET_ROOT}/\${fileName}"
             fi
         fi
     fi
 done  
