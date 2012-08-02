#!/bin/bash

while [ 1 ]
do
    echo 'Updating user statistics...'
    rake resque:daily
    sleep 300
done
