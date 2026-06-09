wd=/D/AAProject/MAG/seq/MAG-diff/itol
# 设置脚本所在目录(Script Directory)，系统为win/mac/linux
sd=/D/AAProject/EasyMicrobiome/script
PATH=$PATH:$sd/../win:$sd
# 进入结果目录
cd $wd

## 基因组进化树注释table2itol

```
cd ./
  ## 方案1. 分类彩带、数值热图、种标签
  # -a 找不到输入列将终止运行（默认不执行）-c 将整数列转换为factor或具有小数点的数字，-t 偏离提示标签时转换ID列，-w 颜色带，区域宽度等， -D输出目录，-i OTU列名，-l 种标签替换ID
Rscript ${sd}/table2itol.R -a -c double -D plan1 -i ID -l Species -t %s -w 0.5 drep95_annotation_bac.txt
# 生成注释文件中每列为单独一个文件

## 方案2. 数值柱形图，树门背景色，属标签
Rscript ${sd}/table2itol.R -a -d -c none -D plan2 -b Phylum -i ID -l Genus -t %s -w 0.5 drep95_annotation_bac.txt

## 方案3.分类彩带、整数为柱、小数为热图
Rscript ${sd}/table2itol.R -c keep -D plan3 -i ID -t %s drep95_annotation_bac.txt

## 方案4. 将整数转化成因子生成注释文件
Rscript ${sd}/table2itol.R -a -c factor -D plan4 -i ID -l Genus -t %s -w 0 drep95_annotation_bac.txt
