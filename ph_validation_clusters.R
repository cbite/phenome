
ph_validation_clusters("24 clusters all simple after filtration of correlated surfaces",surface.data.clust)
ph_validation_clusters("clusters all data Moutliers",surface.data.clust.mo)
ph_validation_clusters("50 clusters",surface.data.clust)
ph_validation_clusters("4 clusters",clust.medoids)


pcabas<-read.csv2("medians_28_clusters_ver3_0.csv")

ph_validation_clusters("medians_28_clusters_ver3_0t",pcabas)

ph_validation_clusters<-function(name, cluster.data)
{
  load("ph_raw_data.RData")
  load("joined scaled data.RData")
  htmlfilepath<-paste('D:/projects/phenome_project/imageverification/clusters/',
                      name,".html", sep = "") 
  ## creating html file
  htmlfile<-file.path(htmlfilepath)
  #specification of html ############################################
  formatspec_head<-'<!DOCTYPE html> \r\n <html> \r\n <body>' 
  formatspec_end<-'</html>' 
  formatspec_h1<-paste('<h1>', name, '</h1>', sep = "")
  formatspec_h1_1<-'<h1> <font color="blue"> ICAm median Intensity </h1>' 
  formatspec_h1_2<-'<h1> Surfaces </h1>' 
  formatspec_h1_3<-'<h1> <font color="blue"> @ </h1>' 
  formatspec_h1_b<-'<h1> <font color="default"> # </h1>' 
  formatspec_h1_n<-'<h1> <font color="red"> 666 </h1>' 
  formatspec_h2<-paste("<h2> Feature number ", name, "</h2>\r\n", sep="")   # specify feature number
  formatspec_links<-'<img src='
  formatspec_h22<-'<h2> Class '
  formatspec_h23<-'</h2>\r\n'
  formatspec_h24<-'<h2> Surface Nr '
  formatspec_h25<-'</h2>\r\n'
  formatspec_filt<-'<h2> Filtered cells </h2>\r\n'
  formatspec_left<-'<h2> Remaining cells </h2>\r\n'
  formatspec_left<-'<h2> Remaining cells </h2>\r\n'
  formatspec_linke<-' width="300" align="middle"></body> \r\n \r\n' 
  formatspec_<-'<hr>' ########
  ## writing data in html file=======
  cat(formatspec_head,file = htmlfile, append=T)
  cat(formatspec_h1,file = htmlfile, append=T)
  cat(formatspec_,file = htmlfile, append=T)
  #=====
  ## write all
  cat(paste(formatspec_h22,"Clusters",formatspec_h23,sep=""),file = htmlfile, append=T)
  #create path info
  pathinfo<-image.data[image.data$ImageNumber%in%image.allftrs$ImageNumber,c("ImageNumber", "FeatureIdx",
                                                                             "Image_Metadata_FileName_Actin_w_array_name" )]
  ##iterate evrything by class
  for  (cc in unique(cluster.data$Cluster)){
    cat(paste(formatspec_h22,cc,formatspec_h23,sep=""),file = htmlfile, append=T)
    cluster.temp.t<-cluster.data[cluster.data$Cluster==cc,]
    cluster.temp <- cluster.temp.t[sample(1:nrow(cluster.temp.t), 20, replace=T),] 
    tempp<-pathinfo[with(pathinfo, FeatureIdx %in% cluster.temp$FeatureIdx),]
    for  (ij in unique(tempp$FeatureIdx)){
      cat(paste(formatspec_h24,ij," ",cc,formatspec_h25,sep=""),file = htmlfile, append=T) 
      temppp<-tempp[tempp$FeatureIdx==ij,]
      for  (ii in unique(temppp$ImageNumber)){
        pth<-paste("../../unsupervised_single_cell/", temppp[temppp$ImageNumber==ii,
                                                             "Image_Metadata_FileName_Actin_w_array_name"], sep="") 
        cat(paste(formatspec_links,pth,formatspec_linke,sep=""),file = htmlfile, append=T);                                                
      } 
    }
    
  }
  
  cat(formatspec_end,file = htmlfile, append=T)
} 