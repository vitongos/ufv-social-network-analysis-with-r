library(twitteR) 
library(tm)
library(plyr)
library(stringr)
 
###
# 1. Conexión a Twitter
###

# Conectar mediante OAuth (directo)
api_key <- "XXXXXXXXX"
api_secret <- "XXXXXXXXX"
access_token <- "XXXXXXXXX"
access_token_secret <- "XXXXXXXXX"
setup_twitter_oauth(
		api_key,
		api_secret,
		access_token,
		access_token_secret)

# Obtener los tweets
tweets <- userTimeline("POTUS", n = 200)
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

# Crear un data frame de contenidos de tweets
dataframe <- data.frame(
		text = unlist(sapply(myCorpus, `[`, "content")), 
    stringsAsFactors=F)
dataframe$text


###
# 3. Análisis de sentimientos
###

# Importar los términos positivos y negativos
setwd("/home/cloudera/sna-r-src/src")
opinion.lexicon.pos = scan('data/positive-words.txt',
		what='character', 
		comment.char=';')
head(opinion.lexicon.pos, n = 5)
opinion.lexicon.neg = scan('data/negative-words.txt',
		what='character', 
		comment.char=';')
head(opinion.lexicon.neg, n = 5)
	
# Función de clasificación de términos
getSentimentScore = function(sentences, 
		words.positive,
		words.negative)
{
		scores = laply(sentences,
				function(sentence, words.positive, words.negative) {
						words = unlist(str_split(sentence, '\\s+'))
						
						pos.matches = !is.na(match(words, words.positive))
						neg.matches = !is.na(match(words, words.negative))
						
						score = sum(pos.matches) - sum(neg.matches)
						return(score)
				},
				words.positive, 
				words.negative)
		
		return(data.frame(text = sentences, score = scores))
}

tweets <- getSentimentScore(dataframe$text, 
		opinion.lexicon.pos, 
		opinion.lexicon.neg)
tweets
aggregate(text ~ score, tweets, function(x) length(unique(x)))

# Dibujar gráfico de resultados
hist(tweets$score, 
		xlab = "Sentiment Score",
		main = "Barack's sentiments",
		prob = TRUE)
