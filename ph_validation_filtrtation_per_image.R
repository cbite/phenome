
ph_filter_comparison_per_image("repeat method 2 validation surface 1427 high ratio left",cell.ftrs.f.scaled,
                      cell.ftrs.reprod, 1427)

ph_filter_comparison_per_image("cell area perimeter validation 1 in min perimeter ",cell.area,
                               cell.area.f, 1)

ph_filter_comparison_per_image("cell density validation 461 max images re,oved ",cell.density,
                               cell.dns.f, 461)

ph_filter_comparison_per_image("comparison reproducible repeats correlation corr=0.7 feat 345",cell.ftrs.f.scaled,
                               cell.ftrs.reprod, 345)



ph_filter_comparison_per_image<-function(name, beforefilter, afterfilter, feature)
{
  load("ph_raw_data.RData")
  htmlfilepath<-paste('D:/projects/phenome_project/imageverification/',
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
  formatspec_h22<-'<h2> Surface number '
  formatspec_h23<-'</h2>\r\n'
  formatspec_filt<-'<h2> Filtered cells </h2>\r\n'
  formatspec_left<-'<h2> Remaining cells </h2>\r\n'
  formatspec_linke<-' width="300" align="middle"></body> \r\n \r\n' 
  formatspec_<-'<hr>' ########
  ## writing data in html file=======
  cat(formatspec_head,file = htmlfile, append=T)
  cat(formatspec_h1,file = htmlfile, append=T)
  cat(formatspec_,file = htmlfile, append=T)
  #=====
  ## write all
  cat(paste(formatspec_h22,feature,formatspec_h23,sep=""),file = htmlfile, append=T)
  ## calculating images that reamins and that was filtered out
  left<-afterfilter[afterfilter$FeatureIdx==feature, c("FeatureIdx", "ImageNumber")]
  filtered<-beforefilter[!beforefilter$ImageNumber%in%afterfilter$ImageNumber&beforefilter$FeatureIdx==feature, 
                         c("FeatureIdx","ImageNumber")]
  ##first plotting filtered data
  cat(formatspec_filt,file = htmlfile, append=T)
  tempp<-image.data[with(image.data, ImageNumber %in% filtered$ImageNumber),]
  for  (ii in unique(tempp$ImageNumber)){
    pth<-paste("../unsupervised_single_cell/", tempp[tempp$ImageNumber==ii,
             "Image_Metadata_FileName_Actin_w_array_name"], sep="") 
      cat(paste(formatspec_links,pth,formatspec_linke,sep=""),file = htmlfile, append=T);
    } 
  ##second plotting remaining  data
  cat(formatspec_left,file = htmlfile, append=T)
  tempp<-image.data[with(image.data, ImageNumber %in% left$ImageNumber),]
  for  (ii in unique(tempp$ImageNumber)){

  pth<-paste("../unsupervised_single_cell/", 
             tempp[tempp$ImageNumber==ii,
                   "Image_Metadata_FileName_Actin_w_array_name"], sep="") 
cat(paste(formatspec_links,pth,formatspec_linke,sep=""),file = htmlfile, append=T);
 } 
  
  cat(formatspec_end,file = htmlfile, append=T)
} 