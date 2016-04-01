library(Rfacebook) 
library(sna)
library(igraph)

###
# 1. Conexión a Facebook
###

# Generar el token en: https://developers.facebook.com/tools/explorer 
token <- 'XXXXXXX'


###
# 2. Análisis del grafo
###

# Obtener matriz de adyacencia de las relaciones de los amigos
network <- getNetwork(token, format = "adj.matrix")
social_graph <- graph.adjacency(network)

# Obtener los grados de los nodos
degree(social_graph, 
		v=V(social_graph), 
		mode = c("all", "out", "in", "total"),
		loops = TRUE, 
		normalized = FALSE)
degree.distribution(social_graph, cumulative = FALSE)

# Obtener las medidas de intermediación
igraph::betweenness(social_graph, 
		v = V(social_graph), 
		directed = TRUE,
		weights = NULL, 
		nobigint = TRUE, 
		normalized = FALSE)
sna::betweenness(network)

# Obtener las medidas de cercanía
igraph::closeness(social_graph, 
		vids = V(social_graph), 
		mode = c("out", "in", "all", "total"), 
		weights = NULL, 
		normalized = FALSE)
sna::closeness(network)		
		
# Obtener la centralidad de vector propio
igraph::evcent(social_graph)
sna::evcent(network)		

# Analizar los clusters
is.connected(social_graph, 
		mode=c("weak", "strong"))
clusters(social_graph, 
		mode=c("weak", "strong"))		

# Analizar las comunidades
network_Community <- walktrap.community(social_graph)
modularity(network_Community)
plot(network_Community, 
		social_graph, 
		vertex.size=10,
		vertex.label.cex=0.5, 
		vertex.label=NA, 
		edge.arrow.size=0,
		edge.curved=TRUE,
		layout=layout.fruchterman.reingold)
		
