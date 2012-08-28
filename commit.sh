while [ $? -eq 0 ]
do
    git push &
    sleep 10
    kill -9 $!
done
