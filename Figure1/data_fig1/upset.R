
df<-read.table("eggnogAnno01.tsv",header=T)
df<-df[,-1]
df$Genes<-paste0("G",1:nrow(df))
rownames(df)<-paste0("G",1:nrow(df))

df<-data.frame(df)
db<-colnames(df)[1:5]
db
library(ggplot2)
library(ComplexUpset)
df[db]=df[db]==1
t(head(df[db],3))
df[df$Genes=="","Genes"]=NA
###############
set_size = function(w, h, factor=1.5) {
  s = 1 * factor
  options(
    repr.plot.width=w * s,
    repr.plot.height=h * s,
    repr.plot.res=100 / factor,
    jupyter.plot_mimetypes='image/png',
    jupyter.plot_scale=1
  )
}
#####################
set_size(8,3)
p1<-upset(df,db,width_ratio = .1,sort_sets="ascending")
ggsave("Database_annotation.pdf",p1,width = 183*1.5,height = 119*1.5,units="mm")
dim(df) # 4406251 6
