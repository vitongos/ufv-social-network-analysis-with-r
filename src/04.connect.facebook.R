library(Rfacebook) 
 
 
###
# 1. Conexión a Facebook mediante OAuth
###

# Conectar mediante OAuth
app_id <- "XXXXXXX"
app_secret <- "XXXXXXX"
fb_oauth <- fbOAuth(app_id = app_id, app_secret = app_secret)
save(fb_oauth, file="fb_oauth")
load("fb_oauth")
me <- getUsers("me", token = fb_oauth)
me$name


###
# 2. Conexión a Facebook mediante token
###

# Generar el token en: https://developers.facebook.com/tools/explorer 
token <- 'XXXXXXX'
me <- getUsers("me", token, private_info = TRUE)
me$name


###
# 3. Obtención de datos básicos desde Facebook
###

# Obtener lista de amigos
friends <- getFriends(token)
friends

# Obtener matriz de adyacencia de las relaciones de los amigos
mat <- getNetwork(token, format = "adj.matrix")
mat

# Recuperar el news feed
news <- getNewsfeed(token)
news





