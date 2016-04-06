library(twitteR) 
library(tm)
library(RColorBrewer)
library(wordcloud)
 
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

# Obtener los tweets
tweets <- userTimeline("POTUS", n=200)
(nDocs <- length(tweets))
tweets[11:15]

# Convertir a data frame
df <- twListToDF(tweets)
dim(df)


###
# 2. Preparación de los datos
###

# Obtener un corpus
myCorpus <- Corpus(VectorSource(df$text))

# Transformar todo el texto a minúsculas
myCorpus <- tm_map(myCorpus, content_transformer(tolower))

# Eliminar URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeURL))

# Eliminar puntuación y otros caracteres raros
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

# Quitar palabras comunes
myCorpus <- tm_map(myCorpus, removeWords, stopwords())

# Quitar espacios en blanco
myCorpus <- tm_map(myCorpus, stripWhitespace)

# Crear una term-document matrix
tdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))
tdm


###
# 3. Creación de una nube de tags
###

# Convertir tdm a una matriz
m <- as.matrix(tdm)

# Calcular la frecuencia de las palabras
wordFreq <- sort(rowSums(m), decreasing=TRUE)

# Colorear
pal <- brewer.pal(9, "BuGn")
pal <- pal[-(1:4)]

# Dibujar la nube de tags
set.seed(375)
grayLevels <- gray( (wordFreq+10) / (max(wordFreq)+10) )
wordcloud(words=names(wordFreq), 
		freq = wordFreq, 
		min.freq = 3, 
		max.words = 200,
		scale = c(4,.2),
		random.order = F,
		colors = pal)
