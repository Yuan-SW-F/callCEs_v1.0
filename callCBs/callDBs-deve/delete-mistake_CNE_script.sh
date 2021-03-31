#!/bin/bash
# File Name: delete-mistake_CNE.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2021-03-10 14:59:28
source ~/.bashrc

#grep cln miss-mistake.bed | cut -f 5 > miss-mistake.id

cat $1 | grep -vf /vol3/asbc/CHENGSHIFENG_GROUP/fuyuan/02.Nfix/00.81species_CNE/35.CNB/12.CNE_PAV/PAV-result/miss-mistake.id | perl -ne ' \
s/cLN/cLn/ if /CNE_079947/; \
s/cLN/cLn/ if /CNE_100756/; \
s/cLN/cLn/ if /CNE_280983/; \
s/CLN/cLN/ if /CNE_101441/; \
s/ClN/clN/ if /CNE_272871/; \
s/CLN/cLN/ if /CNE_300936/; \
s/cLN/clN/ if /CNE_450354/; \

print '



#s/CLN/cLN/ if /CNE_029360/; \
#s/CLN/cLN/ if /CNE_101441/; \
#s/ClN/clN/ if /CNE_272871/; \
#s/CLN/cLN/ if /CNE_300936/; \
#s/cLN/clN/ if /CNE_450354/; \
#s/CLN/cLN/ if /CNE_101444/; \
#s/CLN/cLN/ if /CNE_272868/; \
#s/CLN/cLN/ if /CNE_300933/; \
#s/CLN/cLN/ if /CNE_506660/; \
#print ' 





#cat miss-total.bed mis.mis.check.bed | grep -vf miss-mistake.id | perl -ne 's/cLN/cLn/ if /CNE_079947/; s/cLN/cLn/ if /CNE_100756/; s/cLN/cLn/ if /CNE_280983/; print ' > miss-corrected.bed
