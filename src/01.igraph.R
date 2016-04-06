library(igraph) 
 
###
# 1. Carga de datos
###
 
# Obtener los data frames de estructura del grafo
setwd("/home/cloudera/sna-r-src/src")
advice_data_frame <- read.table('data/edgelist-advice.txt')
friendship_data_frame <- read.table('data/edgelist-friendship.txt')
reports_to_data_frame <- read.table('data/edgelist-reportsTo.txt')
 
# Inspeccionar los data frames
advice_data_frame
head(friendship_data_frame)
tail(reports_to_data_frame)
fix(reports_to_data_frame)

# Cargar los atributos
attributes <- read.csv('data/attributes.csv', header=T)
attributes
 
 
###
# 2. Creación de los grafos
###
 
# Renombrar las columnas de los data frames
colnames(advice_data_frame) <- c('from', 'to', 'advice_tie')
head(advice_data_frame)
 
colnames(friendship_data_frame) <- c('from', 'to', 'friendship_tie')
head(friendship_data_frame)
 
colnames(reports_to_data_frame) <- c('from', 'to', 'reports_to_tie')
head(reports_to_data_frame)
 
# Comparar ordenación de los datos
advice_data_frame$from == friendship_data_frame$from
 
# Comparar
which(advice_data_frame$from != friendship_data_frame$from)
which(advice_data_frame$to != friendship_data_frame$to)

which(reports_to_data_frame$to != friendship_data_frame$to)
which(reports_to_data_frame$from != friendship_data_frame$from)
 
# Combinar 
combined_data_frame <- cbind(advice_data_frame, 
	friendship_data_frame$friendship_tie, 
	reports_to_data_frame$reports_to_tie)
head(combined_data_frame)
 
# Renombrar las variables
names(combined_data_frame)[4:5] <- c("friendship_tie", 
	"reports_to_tie")  
head(combined_data_frame)
 
# Combinar usando data.frame
combined_data_frame <- data.frame(
  from = advice_data_frame[,1],
	to = advice_data_frame[,2],
	advice_tie = advice_data_frame[,3],
	friendship_tie = friendship_data_frame[,3], 
	reports_to_tie = reports_to_data_frame[,3])
head(combined_data_frame)
 
# Eliminar las filas con todos los enlaces a 0
graph_nonzero_edges <- subset(combined_data_frame, 
	(advice_tie > 0 | friendship_tie > 0 | reports_to_tie > 0))
head(graph_nonzero_edges)
 
# Crear el grafo
graph <- graph.data.frame(graph_nonzero_edges) 
graph
 
# Inspeccionar las aristas de cierto tipo
get.edge.attribute(graph, 'advice_tie')
get.edge.attribute(graph, 'friendship_tie')
get.edge.attribute(graph, 'reports_to_tie')
 
 
###
# 3. Manipulación de nodos
###
 
# Adicionar atributos recorriendo la colección de nodos
for (i in V(graph)) {
    for (j in names(attributes)) {
        graph <- set.vertex.attribute(graph, 
                                           j, 
                                           index = i, 
                                           attributes[i + 1, j])
    }
}
summary(graph)
 
# O leer los atributos al crear el grafo
attributes = cbind(1:length(attributes[,1]), attributes)
graph <- graph.data.frame(d = graph_nonzero_edges, 
                               vertices = attributes) 
summary(graph)
 
# Recuperar el valor de un atributo para todos los nodos
get.vertex.attribute(graph, 'AGE')
get.vertex.attribute(graph, 'TENURE')
get.vertex.attribute(graph, 'LEVEL')
get.vertex.attribute(graph, 'DEPT')
 
 
###
# 4. Visualización de los datos
###
 
# Mostrar el grafo (exportando a PDF)
pdf("1.1_Full.pdf")
plot(graph)
dev.off()
 
# Mostrar sólo las aristas "advice"
graph_advice_only <- delete.edges(graph, 
    E(graph)[get.edge.attribute(graph,
    name = "advice_tie") == 0])
summary(graph_advice_only)
pdf("1.2_Advice.pdf")
plot(graph_advice_only)
dev.off()
 
# Mostrar sólo las aristas "friendship"
graph_friendship_only <- delete.edges(graph, 
    E(graph)[get.edge.attribute(graph, 
    name = "friendship_tie") == 0])
summary(graph_friendship_only)
pdf("1.3_Friendship.pdf")
plot(graph_friendship_only)
dev.off()

# Mostrar sólo las aristas "reports-to"
graph_reports_to_only <- delete.edges(graph, 
    E(graph)[get.edge.attribute(graph, 
    name = "reports_to_tie") == 0])
summary(graph_reports_to_only)
pdf("1.4_Reports.pdf")
plot(graph_reports_to_only)
dev.off()
 
# Usar el layout Fruchterman-Rheingold (otras opciones: ?layout)
reports_to_layout <- layout.fruchterman.reingold(graph_reports_to_only)
pdf("1.5_Reports_Fruchterman_Reingold.pdf")
plot(graph_reports_to_only, 
     layout=reports_to_layout)
dev.off()
 
# Colorear los nodos de acuerdo al atributo DEPT 
dept_vertex_colors = get.vertex.attribute(graph,"DEPT")
colors = c('Black', 'Red', 'Blue', 'Yellow', 'Green')
dept_vertex_colors[dept_vertex_colors == 0] = colors[1]
dept_vertex_colors[dept_vertex_colors == 1] = colors[2]
dept_vertex_colors[dept_vertex_colors == 2] = colors[3]
dept_vertex_colors[dept_vertex_colors == 3] = colors[4] 
dept_vertex_colors[dept_vertex_colors == 4] = colors[5]
pdf("1.6_Reports_Color.pdf") 
plot(graph_reports_to_only, 
    layout=reports_to_layout, 
    vertex.color=dept_vertex_colors, 
    vertex.label=NA, 
    edge.arrow.size=.5)
dev.off() 

# Cambiar el tamaño de acuerdo al atrubuto TENURE
tenure_vertex_sizes = get.vertex.attribute(graph,"TENURE")
pdf("1.7_Reports_Vertex_Size.pdf") 
plot(graph_reports_to_only, 
     layout=reports_to_layout, 
     vertex.color=dept_vertex_colors, 
     vertex.label=NA, 
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes)
dev.off() 
 
# Colorear las aristas advice en rojo y friendship en azul
tie_type_colors = c(rgb(1,0,0,.5), rgb(0,0,1,.5), rgb(0,0,0,.5))
E(graph)$color[ E(graph)$advice_tie==1 ] = tie_type_colors[1]
E(graph)$color[ E(graph)$friendship_tie==1 ] = tie_type_colors[2]
E(graph)$color[ E(graph)$reports_to_tie==1 ] = tie_type_colors[3]
E(graph)$arrow.size=.5 
V(graph)$color = dept_vertex_colors
V(graph)$frame = dept_vertex_colors
pdf("1.8_Overlayed_Ties.pdf")
plot(graph, 
     layout=reports_to_layout, 
     vertex.color=dept_vertex_colors, 
     vertex.label=NA, 
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes)
		 
# Adicionar una leyenda al gráfico
legend(1, 
       1.25,
       legend = c('Advice', 
                  'Friendship',
                  'Reports To'), 
       col = tie_type_colors, 
       lty=1,
       cex = .7)
dev.off() 
 
 
###
# 5. Exportación de los datos
###
 
# Observar que se pierden los datos de atributos
write.graph(graph, file='graph.dl', format="pajek")
write.graph(graph, file='graph.txt', format="edgelist")
