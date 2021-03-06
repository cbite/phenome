##loading data
load("ph_raw_data.RData")
#filtering images based on cell number
cell.density<-image.data[,c("ImageNumber", "Image_Count_Cells", "FeatureIdx" )]
rm(list=c("cell.ftrs","image.data"))
cell.dns.f<-c()
for(i in unique(cell.density[,"FeatureIdx"])){
  temp2<-cell.density[cell.density$FeatureIdx==i,]
  tempcn.temp<-unique(temp2[,c("ImageNumber","Image_Count_Cells")])
  tempcn<-tempcn.temp[tempcn.temp$Image_Count_Cells!=0,]
  lbnd<-as.numeric(quantile(tempcn[,"Image_Count_Cells"], probs = 0.25))
  ubnd<-as.numeric(quantile(tempcn[,"Image_Count_Cells"], probs = 0.75))
  iud<-ubnd-lbnd
  rsltc<-temp2[temp2[,"Image_Count_Cells"]<(ubnd+1.5*iud)&
                 temp2[,"Image_Count_Cells"]>(lbnd-1.5*iud)&
                 temp2[,"Image_Count_Cells"]!=0,]
  cell.dns.f<-rbind(cell.dns.f,rsltc) 
}
cell.dns.f<-as.data.frame(cell.dns.f)

#doing plots
#for unfiltered data
par(mfrow=c(2,2))
library(plyr)
data_for_hist<-ddply(cell.density, "FeatureIdx", summarise, 
                     Image_Count_Cells = sum(Image_Count_Cells))

hist(data_for_hist$Image_Count_Cells, breaks = 100,xlab = "Number of cells per surface",
     main="Total cell number per surface")

hist(cell.density$Image_Count_Cells, breaks = 100,xlab = "Number of cells per repeat",
     main="Total cell number per repeat")
#for filtered data
library(plyr)
data_for_hist_f<-ddply(cell.dns.f, "FeatureIdx", summarise, 
                     Image_Count_Cells = sum(Image_Count_Cells))

hist(data_for_hist_f$Image_Count_Cells, breaks = 100,xlab = "Number of cells per surface",
     main="Total cell number per surface")

hist(cell.dns.f$Image_Count_Cells, breaks = 100,xlab = "Number of cells per repeat",
     main="Total cell number per repeat")

save(cell.density,cell.dns.f,file="cell_density_filter_plot.RData")
save(cell.dns.f,file="Cell_dens_corr.RData")
 