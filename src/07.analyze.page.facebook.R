library(Rfacebook) 
library(sna)
library(igraph)
library(sqldf)
library(ggplot2)
library(scales)

###
# 1. Conexión a Facebook
###

# Generar el token en: https://developers.facebook.com/tools/explorer 
token <- 'XXXXXXX'


###
# 2. Obtención de datos de la página de Barack Obama
###

# Obtener posts de la página
page <- getPage("barackobama", token, n = 20)
head(page, n=2)

# Obtener el post con más likes
page[which.max(page$likes_count), ]

# Obtener los 5 posts más populares de este mes
pageRecent <- page[which(page$created_time > "2016-03-01"), ]
top <- pageRecent[order(- pageRecent$likes),]
head(top, n = 5)


###
# 3. Análisis de tendencias de un post
###

# Obtener los 20 comentaristas más influyentes
post_id <- head(top$id, n = 1)
post <- getPost(post_id, token, 
		n = 1000, 
		likes = TRUE,
		comments = TRUE)
head(post$comments, n=20)

# Consultar los comentarios usando sqldf
comments <- post$comments
influentialusers <- sqldf("select from_name, sum(likes_count)
as totlikes from comments group by from_name")
head(influentialusers)

# Ver los 10 usuarios con comentarios más populares
influentialusers$totlikes <- as.numeric(influentialusers$totlikes)
top <- influentialusers[order(- influentialusers$totlikes),]
head(top, n=10)


###
# 4. Análisis de tendencias de muchos posts
###

# Agregar los comentarios de todos los posts
allcomments <- ""
for (i in 1:nrow(page))
{
		# Tomar 1000 comentarios de cada post
		post <- getPost(page$id[i], token, 
				n = 1000,
				likes = TRUE, 
				comments = TRUE)
		comments <- post$comments
		
		# Agregar los comentarios en un mismo data frame
		allcomments <- rbind(allcomments, comments)
}
length(allcomments$id)

# Agrupar los comentarios influyentes
influentialusers <- sqldf("select from_name, sum(likes_count) as
totlikes from allcomments group by from_name")
influentialusers$totlikes <- as.numeric(influentialusers$totlikes)
top <- influentialusers[order(- influentialusers$totlikes),]
head(top, n=20)


###
# 5. Comparación de métricas de los posts
###

# Función para convertir la fecha a timestamp
format.facebook.date <- function(datestring) {
		date <- as.POSIXct(
				datestring,
				format = "%Y-%m-%dT%H:%M:%S+0000", 
				tz = "GMT")
}

# Función para agregar una métrica por mes
aggregate.metric<- function(metric) {
		m <- aggregate(
				page[[paste0(metric, "_count")]],
				list(month = page$month),
				mean)
		m$month <- as.Date(paste0(m$month, "-15"))
		m$metric <- metric
		return(m)
}

# Obtener 30 posts de la página de Arturo Pérez Reverte
page <- getPage("perezreverte", token, n = 30)
page$datetime <- format.facebook.date(page$created_time)
page$month <- format(page$datetime, "%Y-%m")

# Contar las métricas de likes, comentarios y shares
df.list <- lapply(
		c("likes", "comments", "shares"),
		aggregate.metric)
df <- do.call(rbind, df.list)
df

# Visualizar las tendencias

ggplot(df, aes(x = month, y = x, group = metric))
geom_line(aes(color = metric))
scale_x_date(breaks = "years", labels = date_format("%Y"))
scale_y_log10("Average count per post", breaks =
c(10, 100, 1000, 10000, 50000))
theme_bw()
theme(axis.title.x = element_blank())
ggtitle("Facebook Page Performance")
ggsave(file="/tmp/trends-perez-reverte.png",
dpi=500)
