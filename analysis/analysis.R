df <- read.table("results2_1586430909.txt")

col <- rgb(df[,3]/255, df[,4]/255, df[,5]/255)

plot(df[,3], df[,4], col = col, cex=2, pch=16, xlab="red", ylab="green")

plot(df[,3], df[,5], col = col, cex=2, pch=16, xlab="red", ylab="blue")

plot(df[,5], df[,4], col = col, cex=2, pch=16, xlab="blue", ylab="green")

coldf <- df[,3:5]
rownames(coldf) <- paste(df[,2], df[,3], df[,4], df[,5], df[,6], sep=":")

plot(hclust(dist(coldf)))

