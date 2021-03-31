### 详情请关注公众号 生物信息分析学习

### 本文待发表，请引用：https://github.com/Yuan-SW-F/callCEs_v1.0/； https://github.com/Yuan-SW-F/callCEs_v1.0/callDBs
## 发表后请因为文章

#cns注释程序，全基因组注释信息包括mRNA，CDS，注释后信息如图所示：
annotation_cns.py species.gff cns.bed
#cns序列比对程序，准备好的某CNS的各物种比对结果作为输入文件，获得不同物种的该CNS序列的一致性比对结果。
bedsortmerge.sh
#本程序所需要调用的部分软件
bin
#鉴定CNEs的主程序
callCEs.py
callCEs-v0.py #副本
call_CNS.py #前期版本
callCons.py #前期版本
change_gff_ID.py #将下载的基因组注释文件（gff文件）格式化
changeID.py #将下载的基因组序列文件格式化
choice_CNS4maf.py #将所选CNS多序列比对结果（maf）导出
CNSanner.py #cns注释脚本
CNSanner.py2
CNSannerV1.py
cns_stat.sh #cns统计脚本
distribution_CEs_species.py #cne画图
download_genome.py #下载基因组脚本
FDR.R #fdr计算
format_gff.py #gff格式化脚本
gerp.sh #gerp 检测cne脚本
get_chr_maf.py #染色体
get_gg_file.py #获得gg文件，用于genefamily分析
getque4mref.py #
kaks-fy.py
lastz-axt.sh #
maf2bed.py
mergebed.py
obtain_4d_phase1.pl
RBH_format.py
RBH_format_ref.py
score-for-bases-fy.py
score-for-bases.py
splitbyNs.py
split_chromosome.py
