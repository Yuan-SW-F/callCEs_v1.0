#!/bin/bash
# File Name: sed.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2019-09-29 15:51:25
source ~/.bashrc

cat $1 |
sed s/Ochetophila_trinervis/Discaria_trinervis/ | \
sed s/Pyrus_x_bretschneideri/Pyrus_bretschneideri/ | \
sed s/Malus_domestica/Malus_x_domestica/ | \
sed s/Trema_orientale/Trema_orientalis/
