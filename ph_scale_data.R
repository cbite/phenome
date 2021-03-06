rm(list=ls())
#library(data.table)
load("ph_raw_data.RData")
load("Cell_image reprod.RData")
load("Cell_shape_corr.RData")
##changing orientation parameter
cell.ftrs$Cells_AreaShape_Orientation<-abs(cell.ftrs$Cells_AreaShape_Orientation)

#applying previous filters
image.data.f<-image.data[image.data$ImageNumber%in%cell.ftrs.reprod$ImageNumber,]

cell.ftrs.f<-cell.ftrs[cell.ftrs$ImageNumber%in%cell.ftrs.reprod$ImageNumber&
                              row.names(cell.ftrs) %in% row.names(cell.shape.f),]
#make small comparison
#plot(density(cell.ftrs[cell.ftrs$FeatureIdx==975,"Cells_AreaShape_Eccentricity"]))
#plot(density(cell.ftrs.f[cell.ftrs.f$FeatureIdx==975,"Cells_AreaShape_Eccentricity"]))
rm(list=c("cell.ftrs","image.data","cell.ftrs.reprod","cell.shape.f"))
##aggregating data to image number
##Function for finding mode 
# find.mode <- function(x) {
#   ux <- unique(x)
#   ux[which.max(tabulate(match(x, ux)))]
# }
# data_t = data.table(data_tab)
# image.ftrs.f = data_t[,list(A = sum(count), B = mean(count)), by = c('PID, Time, Site')]

##based on median
image.ftrs.f<-aggregate(.~ImageNumber, data=cell.ftrs.f, median)

##based on trimmed mean
#image.ftrs.f<-aggregate(.~ImageNumber, data=cell.ftrs.f, function(x) mean(x,trimm=0.2))

##based on mode
#image.ftrs.f<-aggregate(.~ImageNumber, data=cell.ftrs.f, find.mode)

##merging 2data sets
image.allftrs.temp<-merge(image.ftrs.f, image.data.f,  by=c("ImageNumber","FeatureIdx"))
##selecting only numerik variables
image.allftrs<-image.allftrs.temp[sapply(image.allftrs.temp, is.numeric)]
## scaling data
#scale all the features
image.allftrs.data<-image.allftrs[,!(colnames(image.allftrs) %in% c("ImageNumber", "ObjectNumber",
                                                           "FeatureIdx"))]
cntr<-apply(image.allftrs.data,2,function(x) median(x))
scl<-apply(image.allftrs.data,2,function(x) mad(x))
image.allftrs.data.scale<- scale(image.allftrs.data,
                    center=cntr,scale=scl);
image.allftrs.scale<-cbind(image.allftrs[, c("ImageNumber", "ObjectNumber",
                               "FeatureIdx")],image.allftrs.data.scale)
image.allftrs.scale<-image.allftrs.scale[ , ! apply( image.allftrs.scale , 2 , function(x) all(is.na(x)) ) ]

save(image.allftrs.scale,image.allftrs, file="joined scaled data.RData")