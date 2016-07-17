#start after data_filtering.R
#loading the data.frame we saved in the previous script
df <- read.csv2('df.csv')
#fit a logit with all variables+summary
reg <- glm(formula = bad ~ ., family = binomial(link = "logit"), data = df)
summary(reg)
#fit a logit with chosen variables (see section 5)
df$pmt_freq_sq <- df$pmt_freq^2 #create a squared frequency variable
reg2 <- glm(formula = bad ~ credit_limit + ttl_delq_30 + ttl_delq_60_89 +
            interest_rate + typecard + typemort + pmt_freq + pmt_freq_sq + 
            currencyEUR + currencyUSD, family = binomial(link = "logit"), 
            data = df)
summary(reg2)
#fit the last logit
reg3 <- glm(formula = bad ~ credit_limit + ttl_delq_30 + ttl_delq_60_89 +
            interest_rate + typecard + typemort + pmt_freq + pmt_freq_sq + 
            currencyUSD, family = binomial(link = "logit"), data = df)
summary(reg3)