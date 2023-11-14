setwd('C:/Users/harve/OneDrive/Desktop/PMHD/Multivariate_methods_OThas')
# data with the counts of the 182 species in the 26 samples
load("GP.OTU.RData")
# data with information about the type of sample
load("GP.SampleData.RData")
# data with the Phylum and Class labels of the 182 species. 
# the rows of this matrix correspond to the rows in the GP.OTU matrix
load("GP.TaxData.RData")


# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("phyloseq", version = "3.16")


library("ggplot2")
library("FactoMineR")
library("factoextra")

res.ca <- CA(OTU, graph = FALSE)
get_eigenvalue(res.ca)
fviz_screeplot(res.ca, addlabels = T, ylim = c(0,50))
res.ca$eig

fviz_screeplot(res.ca) +
  geom_hline(yintercept=9.5, linetype=2, color="red")

fviz_ca_biplot(res.ca2, repel = TRUE)

Tfviz_ca_biplot(res.ca, map ="colgreen", arrow = c(TRUE, FALSE),
               repel = TRUE)

OTU <- GP.OTU
SampleType <- GP.SampleData
Taxonomy <- GP.TaxData


OTU_and_SampleType <- cbind(OTU, SampleType)

cont_table <- as.matrix(OTU)

# rowprofiles <- apply(cont_table, 1, prop.table)
# colprofiles <- apply(cont_table, 2, prop.table)


# Compute the row and column profiles
rowtotal <- apply(cont_table, 1, sum)
coltotal <- apply(cont_table, 2, sum)
ntotal <- sum(cont_table)
ntotal

X <- cont_table/4732
X

prop.tab <- prop.table(cont_table)
rowstotal <- rowSums(cont_table)
colstotal <- colSums(cont_table)

# compute the expected frequencies
r.i <- rowstotal/ntotal
c.i <- colstotal/ntotal


W <- X - r.i %*% t(c.i)

# row mass
D.r.half <- solve(diag(r.i))

# column mass
D.c.half <- solve(diag(c.i))

# center the data
center.new <- D.r.half %*% W %*% D.c.half

# decompose the matrix
s.v.d <- svd(center.new)

# calculate the eigenvalues and singular values from the SVD
eigenvalues <- s.v.d$d^2
singularvalues <- s.v.d$d

# display the most informed principal component
plot(singularvalues)

# calculate the contributions of each axis to the total inertia
contribution <- eigenvalues/ sum(eigenvalues)

# calculate the coordinates of the samples on the first two axes
samplecoordinates <- s.v.d$v[,1:2] * sqrt(singularvalues[1:2])
speciescoordinates <- s.v.d$u[,1:2] * sqrt(singularvalues[1:2])

# Number of dimensions to keep
k <- 2

# Extract the loadings
loadings <- s.v.d$u[, 1:k] %*% diag(s.v.d$d[1:k])


##### Factor Analysis ##########
# For dimensionality reduction
# Perform PCA with varimax rotation
library(psych)
fa <- principal(OTU, nfactors = 4, rotate = "varimax")

# Print the factor loadings
print(fa$loadings)

# Plot the scree plot
plot(fa$values, type = "b")

# Extract the factors
factors <- fa$scores

################
# Center the data matrix
centered_data <- scale(OTU, center = TRUE, scale = FALSE)

# Calculate the SVD of the centered data matrix
svd_data <- svd(centered_data)

plot(svd_data$d)



######################
# Calculate percentage of each singular value
s <- svd_data$d
percentage <- round((s^2 / sum(s^2)) * 100, 1)

# Create a histogram of explained variance by dimension
library(ggplot2)

df <- data.frame(Dimension = paste0("Dim.", 1:length(s)), Percentage = percentage)

# Order dimensions from highest to lowest
df <- df[order(-df$Percentage), ]

# Create histogram
ggplot(df, aes(x = Dimension, y = Percentage, fill = Percentage)) +
  geom_col() +
  scale_fill_viridis_c(option = "plasma", guide = FALSE) +
  labs(x = "Dimension", y = "Explained Percentage") +
  ggtitle("Scree Plot") +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


write.csv(OTU, "C:/Users/harve/OneDrive/Desktop/PMHD/Multivariate_methods_OThas/newdata.csv", row.names=TRUE)


########################################
# Load the FactoMineR package
library(FactoMineR)
library(vegan)

# Load your contingency table as a matrix
my_matrix <- as.matrix(OTU)


# calculate the row means
row_means <- rowMeans(my_matrix)

# calculate the column means
col_means <- colMeans(my_matrix)

# calculate the overall mean
overall_mean <- mean(my_matrix)

# calculate the double centered matrix
my_matrix_dc <- my_matrix - row_means - col_means + overall_mean

my_matrix_dc <- sweep(my_matrix_dc, 2, col_means, "-")

# Calculate the SVD of the double centered matrix
svd_data <- svd(my_matrix_dc)

plot(svd_data$d)

s <- svd_data$d
percentage <- round((s^2 / sum(s^2)) * 100, 1)




# is.na(my_matrix_dc) # check for missing values
# is.finite(my_matrix_dc) # check for infinite values

###############################################
# SampleType
new_otu <- data.frame(OTU)

# sum first, second, and third columns
new_otu$Soil <- rowSums(new_otu[, 1:3])

# sum fourth and fifth columns
new_otu$Feces <- rowSums(new_otu[, c(4, 5, 22, 23)])

# sum sixth, seventh, and eighth columns
new_otu$Skin <- rowSums(new_otu[, 6:8])

# sum nineth and tenth columns
new_otu$Tongue <- rowSums(new_otu[, c(9, 10)])

# sum eleven and twelve columns
new_otu$Freshwater <- rowSums(new_otu[, c(11,12)])

# sum eleven to fiften columns
new_otu$Freshwater_creek <- rowSums(new_otu[, 13:15])

# sum sixten, seventeen, and eighteen columns
new_otu$Ocean <- rowSums(new_otu[, 16:18])

# sum nineteen to twenty-one columns
new_otu$Sediment <- rowSums(new_otu[, 19:21])

# sum sixth, seventh, and eighth columns
new_otu$Mock <- rowSums(new_otu[, 24:26])

# only the last 8 columns
new_data <- new_otu[, (ncol(new_otu) - 8):ncol(new_otu)]

# change rownames
# rownames(new_data) <- Taxonomy$Class # cannot have rows with same names


# create new rows with summed values
# Taxonomy (Class)
Actinobacteria <- colSums(new_data[1:17,])
Chloroplast <- colSums(new_data[18:28,])
Oscillatoriophycideae <- new_data[29,]
Nostocophycideae <- colSums(new_data[c(30,31),])
Synechococcophycideae <- new_data[32,]
r4C0d_2 <- new_data[33,]
Epsilonproteobacteria <- new_data[34,]
Betaproteobacteria <- colSums(new_data[35:51,])
Gammaproteobacteria <- colSums(new_data[52:71,])
Alphaproteobacteria <- colSums(new_data[72:80,])
Deltaproteobacteria <- colSums(new_data[c(81,82,83,84,131),])
Flavobacteria <- colSums(new_data[85:104,])
Bacteroidia <- colSums(new_data[105:126,])
Sphingobacteria <- colSums(new_data[127:130,])
# Deltaproteobacteria <- new_data[131,]
Clostridia <- colSums(new_data[c(132, 133, 134, 135, 136, 137, 138, 139, 
                                 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 
                                 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 
                                 165, 166, 167, 168, 169, 170, 171, 172, 173, 180, 181, 182),])
Bacilli <- colSums(new_data[174:179,])



combined_dataset <- rbind(Actinobacteria, Chloroplast, Oscillatoriophycideae, Nostocophycideae, Synechococcophycideae,
                          r4C0d_2, Epsilonproteobacteria, Betaproteobacteria, Gammaproteobacteria, Alphaproteobacteria,
                          Deltaproteobacteria, Flavobacteria, Bacteroidia, Sphingobacteria, Clostridia,
                          Bacilli)
final.OTU1 <- data.frame(combined_dataset)
rownames(final.OTU1) <- c("Actinobacteria", "Chloroplast", "Oscillatoriophycideae", "Nostocophycideae", "Synechococcophycideae",
                             "r4C0d_2", "Epsilonproteobacteria", "Betaproteobacteria", "Gammaproteobacteria", "Alphaproteobacteria",
                             "Deltaproteobacteria", "Flavobacteria", "Bacteroidia", "Sphingobacteria", "Clostridia",
                             "Bacilli")

# res.ca1 <- CA(final.OTU1, graph = FALSE)
# get_eigenvalue(res.ca1)
# fviz_screeplot(res.ca1, addlabels = T, ylim = c(0,50))



# Taxonomy (Phylum)
Actinobacteria_phylum <- colSums(new_data[1:17,])
Cyanobacteria_phylum <- colSums(new_data[18:33,])
Proteobacteria_phylum <- colSums(new_data[c(34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
                                            52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
                                            70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 131),])
Bacteroidetes_phylum <- colSums(new_data[85:130,])

Firmicutes_phylum <- colSums(new_data[132:182,])


comb_dataset <- rbind(Actinobacteria_phylum, Cyanobacteria_phylum, Proteobacteria_phylum, Bacteroidetes_phylum, Firmicutes_phylum)

final.OTU2 <- data.frame(comb_dataset)

rownames(final.OTU2) <- c("Actinobacteria", "Cyanobacteria", "Proteobacteria", "Bacteroidetes", "Firmicutes")

# res.ca2 <- CA(final.OTU2, graph = FALSE)
# get_eigenvalue(res.ca2)
# fviz_screeplot(res.ca2, addlabels = T, ylim = c(0,50))

# final.OTU2
# final.OTU1
# test for independence
# Class


xlim <- range(c(row.coord[,1], col.coord[,1]))*1.1
ylim <- range(c(row.coord[,2], col.coord[,2]))*1.1
# Plot of rows
plot(row.coord, pch=19, col = "blue", xlim = xlim, ylim = ylim)
text(row.coord, labels =rownames(row.coord), pos = 3, col ="blue")
# plot off columns
points(col.coord, pch=17, col = "red")
text(col.coord, labels =rownames(col.coord), pos = 3, col ="red")
abline(v=0, h=0, lty = 2)

# Add arrows to the plot
for(i in 1:nrow(col.coord)){
  arrows(x0 = 0, y0 = 0, x1 = col.coord[i,1], y1 = col.coord[i,2], col = "red", length = 0.1)
}



xlim2 <- range(c(row.coord2[,1], col.coord2[,1]))*1.1
ylim2 <- range(c(row.coord2[,2], col.coord2[,2]))*1.1
# Plot of rows
plot(row.coord2, pch=19, col = "blue", xlim = xlim2, ylim = ylim2)
text(row.coord2, labels =rownames(row.coord2), pos = 3, col ="blue")
# plot off columns
points(col.coord2, pch=17, col = "red")
text(col.coord2, labels =rownames(col.coord2), pos = 3, col ="red")
abline(v=0, h=0, lty = 2)

# To add directions from the origin of the plot
for(i in 1:nrow(col.coord2)){
  arrows(x0 = 0, y0 = 0, x1 = col.coord2[i,1], y1 = col.coord2[i,2], col = "red", length = 0.1)
}























# Define xlim and ylim
xlim2 <- range(c(row.coord2[,1], col.coord2[,1]))*1.1
ylim2 <- range(c(row.coord2[,2], col.coord2[,2]))*1.1

# Plot rows
plot(row.coord2, pch = 19, col = "blue", xlim = xlim2, ylim = ylim2)
text(row.coord2, labels = rownames(row.coord2), pos = 3, col = "blue")

# Plot columns
points(col.coord2, pch = 17, col = "red")
text(col.coord2, labels = rownames(col.coord2), pos = 3, col = "red")

# Add arrows
for(i in 1:nrow(col.coord2)){
  arrows(x0 = 0, y0 = 0, x1 = col.coord2[i,1], y1 = col.coord2[i,2], 
         length = 0.1, col = "red", lwd = 2, angle = 15)
}
for(i in 1:nrow(row.coord2)){
  arrows(x0 = 0, y0 = 0, x1 = row.coord2[i,1], y1 = row.coord2[i,2], 
         length = 0.1, col = "blue", lwd = 2, angle = 15)
}

# Add abline
abline(v = 0, h = 0, lty = 2)
