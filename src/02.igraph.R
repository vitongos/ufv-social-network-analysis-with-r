library(igraph) 

###
# 1. Carga y preparación de datos
###
 
setwd("/home/cloudera/sna-r-src/src")
advice_data_frame <- read.table('data/edgelist-advice.txt')
advice_data_frame
colnames(advice_data_frame) <- c('from', 'to', 'advice_tie')
head(advice_data_frame) 
 
# Eliminar las filas que no representan aristas
graph_nonzero_edges <- subset(advice_data_frame, (advice_tie > 0))
head(graph_nonzero_edges)
 
# Crear el grafo
graph <- graph.data.frame(graph_nonzero_edges) 
graph
get.edge.attribute(graph, 'advice_tie')

# Cargar los atributos
attributes <- read.csv('data/attributes.csv', header=T)
attributes
for (i in V(graph)) {
	for (j in names(attributes)) {
		graph <- set.vertex.attribute(graph, j, index=i, attributes[i+1,j])
	}
}
summary(graph)

 
###
# 2. Análisis del grafo
###

# Obtener los grados
deg_full_in <- degree(graph, mode="in") 
deg_full_out <- degree(graph, mode="out") 
deg_full_in
deg_full_out

# Obtener longitudes de los caminos más cortos
sp_full_in <- shortest.paths(graph, mode='in')
sp_full_out <- shortest.paths(graph, mode='out')
sp_full_in
sp_full_out

# Obtener la transitividad promedio
transitivity(graph)

# Obtener los cliques y el mayor de los cliques
cliques(graph)
largest.cliques(graph)

# Agrupar comunidades
g <- as.undirected(graph)
fastgreedy.community(g)
spinglass.community(g)
