#!/bin/bash
for i in {111,121,131,132,141,151,161,162,171,211,21,31,41,42,43};do
    ssh-copy-id -i root@172.189.10.$i
done


