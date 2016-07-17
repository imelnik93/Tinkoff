#run this first
#create data files from the provided .csv files (online). over 40 Mb
urlAcc <- 'https://static.tinkoff.ru/documents/olymp/SAMPLE_ACCOUNTS.csv'
urlCust <- 'https://static.tinkoff.ru/documents/olymp/SAMPLE_CUSTOMERS.csv'
write.csv2(read.csv2(urlAcc), file = "df_acc_raw.csv",row.names = F)
write.csv2(read.csv2(urlCust), file = "df_cust_raw.csv", row.names = F)
#create dfs from downloaded files
dfAccRaw <- read.csv2("df_acc_raw.csv")
dfCustRaw <- read.csv2("df_cust_raw.csv")
#create the final dataset. discussed in section 3 of the report
#delete the training part of the data
dfCust <- subset(dfCustRaw, sample_type == 'train')[, -3]
#create a vector of remaining ids
ids <- dfCust$tcs_customer_id
#create a vector of variables that we want to keep (see section 4)
keep <- c('tcs_customer_id', 'type', 'credit_limit', 'currency', 'ttl_delq_5',
          'ttl_delq_5_29', 'ttl_delq_30', 'ttl_delq_30_59', 'ttl_delq_60_89',
          'ttl_delq_90_plus', 'interest_rate', 'pmt_freq')
#create vector of factors that we will delete from pmt_freq
freqExclude <- as.factor(c('', 0, 5, 7, 'A', 'B'))
#subsetting our dataframe. we filter pmt_freq, leave only people, exclude 
#unusual types. also: we need only IDs from ids vector and select only variables
#from the list we determined
dfAcc <- subset(dfAccRaw, !(pmt_freq %in% freqExclude) & relationship==1 & 
                !(type %in%c(4,12,13,14,99)) & tcs_customer_id %in% ids, 
                select = which(names(dfAccRaw) %in% keep))
#merge 2 dataframes by IDs, delete tcs_customer_id since we don't need it anymore
df <- merge(dfCust, dfAcc, 'tcs_customer_id')[, -1]
#variables transformation
#create a function that will transfrom codes of frequency into the number of 
#payments per year
TransformFreq <- function(x){
    if (x==1){x <- 52}
    else if (x==2){x <- 26}
    else if (x==3){x <- 12}
    else if (x==4){x <- 4}
    else if (x==6){x <- 1}
}
#apply our function to pmt_freq
df$pmt_freq <- sapply(as.integer(as.character(df$pmt_freq)), TransformFreq)
#get rid of type levels that we deleted
df$type <- as.factor(df$type)
#create new labels that we can understand
levels(df$type) <- c('auto','mort','card','cons','bus','ca')
#get rid of type levels that we deleted
df$currency <- factor(df$currency)
#expand factors into dummies
df <- cbind(df, model.matrix(~type-1,df), 
            model.matrix(~currency-1,df))[, -c(2,4)]
#write a clean datafile
write.csv2(df,'df.csv',row.names = F)
