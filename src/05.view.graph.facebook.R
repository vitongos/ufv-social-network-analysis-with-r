library(Rfacebook) 
library(igraph)

###
# 1. Conexión a Facebook
###

# Generar el token en: https://developers.facebook.com/tools/explorer 
token <- 'XXXXXXX'


###
# 2. Visualización del grafo
###

# Obtener matriz de adyacencia de las relaciones de los amigos
network <- getNetwork(token, format = "adj.matrix")
social_graph <- graph.adjacency(network)
social_graph

# Dibujar el grafo
layout <- layout.drl(social_graph, 
		options=list(simmer.attraction=0))
plot(social_graph, vertex.size=10, vertex.color="green",
		vertex.label=NA,
		vertex.label.cex=0.5,
		edge.arrow.size=0, edge.curved=TRUE,
		layout=layout)

# Dibujar el grafo interactivo y con etiquetas en los nodos
tkplot(social_graph, vertex.size=22, vertex.color="red",
     vertex.label=V(social_graph)$name,
     vertex.label.cex=1,
		 vertex.label.dist=1,
     edge.arrow.size=1, 
		 edge.curved=TRUE,
     layout=layout.kamada.kawai)

# Determinar el diámetro del grafo
diameter(social_graph)

# Encontrar los nodos dentro del diámetro
d <- get.diameter(social_graph) 

# Crear layout
l <- layout.fruchterman.reingold(social_graph, niter = 500)

# Cambiar parámetros de visualización
V(social_graph)$size <- 4
E(social_graph)$width <- 1
E(social_graph)$color <- 'dark grey'
E(social_graph, path=d)$width <- 3
E(social_graph, path=d)$color <- 'red'

# Dibujar el grafo
plot(social_graph, 
		layout=l, 
		edge.arrow.size = 0, 
		vertex.label = NA)
		
