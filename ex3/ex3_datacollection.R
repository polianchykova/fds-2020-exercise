library(yaml)
library(GuardianR)

guardian_creds <- yaml.load_file("/home/philipp/Documents/keys/guardian_api/api_key1.yaml")

for (y in 2015:2019){
  for (m in 1:12){
    start_day <-  1
    end_day <- ifelse(m %in% c(1,3,5,7,8,10,12), 31, ifelse(m == 2, 28, 30))
    month <- ifelse(m < 10, paste("0",m, sep=""), as.character(m))
    gres <- GuardianR::get_guardian(keywords = c("uk"),
                                    from.date = paste(y,month,start_day, sep="-"),
                                    to.date = paste(y,month,end_day, sep="-"),
                                    api.key = guardian_creds$api_key)
    save(gres, file = paste("../data/ex3/subdata/guardianapi_uknews",y,month,".RDa",sep="_"))
    Sys.sleep(5)
  }
}

# Errors in May (5) 2015, August (8) 2017
y <- 2017
for (m in 9:12){
  start_day <-  1
  end_day <- ifelse(m %in% c(1,3,5,7,8,10,12), 31, ifelse(m == 2, 28, 30))
  month <- ifelse(m < 10, paste("0",m, sep=""), as.character(m))
  gres <- GuardianR::get_guardian(keywords = c("uk"),
                                  from.date = paste(y,month,start_day, sep="-"),
                                  to.date = paste(y,month,end_day, sep="-"),
                                  api.key = guardian_creds$api_key)
  save(gres, file = paste("../data/ex3/subdata/guardianapi_uknews",y,month,".RDa",sep="_"))
  Sys.sleep(5)
}

# Combine the various data sets

directory <- "../data/ex3/subdata/"
gres_comb <- data.frame()
for (file in list.files(directory)){
  load(paste(directory,file,sep="/"))
  if(grepl("2018", file)){
    gres_comb <- rbind.data.frame(gres_comb, gres)
  }
}
garticles <- gres_comb
garticles$wordcount <- as.numeric(as.character(garticles$wordcount))
garticles$newspaperPageNumber <- as.numeric(as.character(garticles$newspaperPageNumber))
garticles$webPublicationDate <- as.character(garticles$webPublicationDate)
save(garticles, file = "../data/ex3/guardianapi_uknews_combined.Rda")
rm(list = ls())
