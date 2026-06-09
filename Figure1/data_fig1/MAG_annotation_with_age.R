library(readxl)
library(Hmisc)
library(ggplot2)
Data<-read.delim("MAG_Anno_clean.txt",stringsAsFactors = FALSE,sep="\t")
Data$Annotation_rate<-100*(1-Data$Unannotation_rate)
# Calculate the p-value and the correlation coefficient
res <- rcorr(Data$Age, Data$Annotation_rate)
p_value <- round(res$P[1,2],13)
cor_value <- round(res$r[1,2], 2)
p<-ggplot(Data,aes(Age, Annotation_rate))+
  geom_point(color = "steelblue")+
  geom_smooth(method = "lm", formula = y ~ x, 
              # Set the colors for the confidence interval and the fitted line
              fill = "#b2e7fa", color = "orange", alpha = 0.8)+
  theme_bw()+
  scale_x_continuous(breaks=seq(from=20,to=112,by=20))+
  # xlim(20,112)+
  ylim(60,100)+
  theme(
    # remove the gridlines
    panel.grid = element_blank(),
    # set the axis title
    axis.title = element_text(face = "bold"),
    # set the main position to middle
    plot.title = element_text(hjust = 0.5)
  )+
  labs(x="Age(years old)",y="Annotation rate(%)",title = paste0("r = ", cor_value, ", p = ", p_value))
p
ggsave("2C-Gene annotation rate with Age.pdf", p, width = 89, height = 59, units = "mm")
