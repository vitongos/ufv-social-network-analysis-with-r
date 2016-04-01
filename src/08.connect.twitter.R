library(twitteR) 
 
 
###
# 1. Conexión a Twitter
###

# Conectar mediante OAuth (directo)
api_key <- "XXXXXXX"
api_secret <- "XXXXXXX"
access_token <- "XXXXXXX"
access_token_secret <- "XXXXXXX"
setup_twitter_oauth(
		api_key,
		api_secret,
		access_token,
		access_token_secret)
barackTweets = searchTwitter("POTUS", since='2016-01-01')
head(barackTweets, n = 10)


###
# 2. Obtención de datos básicos desde Twitter
###

# Buscar un usuario
tuser <- getUser('geoffjentry')
tuser$name
tuser$description

# Buscar varios usuarios
users <- lookupUsers(c('geoffjentry', 'whitehouse', 'POTUS'))
is.list(users)
summary(users)
users[[1]]$description
users[[2]]$description
users[[3]]$description
