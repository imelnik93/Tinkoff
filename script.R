#create dataframes from the provided .csv files
#write.csv2(read.csv2('https://static.tinkoff.ru/documents/olymp/SAMPLE_ACCOUNTS.csv'),
#          file = "df_acc_raw.csv",row.names = F)
#write.csv2(read.csv2('https://static.tinkoff.ru/documents/olymp/SAMPLE_CUSTOMERS.csv'),
#           file = "df_cust_raw.csv", row.names = F)
#df_acc_raw <- read.csv2("df_acc_raw.csv")
#df_cust_raw <- read.csv2("df_cust_raw.csv")
#filter data
df_cust <- subset(df_cust_raw, sample_type=='train')[,-3]
ids <- df_cust$tcs_customer_id
test_id <- sample(ids,5000)
keep <- c('tcs_customer_id','type','status','credit_limit','currency','curr_balance_amt',
          'ttl_delq_5','ttl_delq_5_29','ttl_delq_30','ttl_delq_30_59','ttl_delq_60_89',
          'ttl_delq_90_plus','delq_balance','max_delq_balance','current_delq',
          'interest_rate','pmt_freq')
df_acc <- subset(df_acc_raw, relationship==1 & type %in% c(1,6,7,9,10),
                 select = which(names(df_acc_raw) %in% keep))