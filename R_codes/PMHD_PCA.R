# Example 1
# Step 1: Create a contingency table
set.seed(123)
table <- matrix(sample(1:10, 9, replace=TRUE), nrow=3)
colnames(table) <- c("Category 1", "Category 2", "Category 3")
rownames(table) <- c("Factor A", "Factor B", "Factor C")
table

# Step 2: Calculate row and column totals
rowTotals <- apply(table, 1, sum)
colTotals <- apply(table, 2, sum)
total <- sum(table)

# Step 3: Compute the expected frequencies
expected <- outer(rowTotals, colTotals) / total

# Step 4: Center the data
centered <- table - expected

# Step 5: Compute the SVD of the centered data matrix
svd <- svd(centered)

# Step 6: Compute the eigenvalues
eigenvals <- (svd$d)^2 / (total - 1)

# Step 7: Compute the principal components
principal_components <- svd$u %*% diag(svd$d)

# Step 8: Normalize the principal components
norm_components <- principal_components / sqrt(eigenvals)

# Step 9: Compute the scores
scores <- centered %*% norm_components

# Step 10: Plot the results
plot(scores[,1], scores[,2], xlab="Dimension 1", ylab="Dimension 2", 
     main="Correspondence Analysis Biplot")
text(scores[,1], scores[,2], labels=colnames(table), pos=3)

# Example 2
# Step 1: Create a contingency table
data("mtcars")
table <- table(mtcars$gear, mtcars$cyl)
table

# Step 2: Calculate row and column totals
rowTotals <- apply(table, 1, sum)
colTotals <- apply(table, 2, sum)
total <- sum(table)

# Step 3: Compute the expected frequencies
expected <- outer(rowTotals, colTotals) / total

# Step 4: Center the data
centered <- table - expected

# Step 5: Compute the SVD of the centered data matrix
svd <- svd(centered)

# Step 6: Compute the eigenvalues
eigenvals <- (svd$d)^2 / (total - 1)

# Step 7: Compute the principal components
principal_components <- svd$u %*% diag(svd$d)

# Step 8: Normalize the principal components
norm_components <- principal_components / sqrt(eigenvals)

# Step 9: Compute the scores
scores <- centered %*% norm_components

# Step 10: Plot the results
plot(scores[,1], scores[,2], xlab="Dimension 1", ylab="Dimension 2", 
     main="Correspondence Analysis Biplot")
text(scores[,1], scores[,2], labels=colnames(table), pos=3)
