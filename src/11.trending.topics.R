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


###
# 2. Obtención de los datos
###

# Obtener la localización
locs <- availableTrendLocations()
woeid <- subset(locs, name == "Miami")$woeid

# Obtener los trends
trends <- getTrends(woeid = woeid)
trends
