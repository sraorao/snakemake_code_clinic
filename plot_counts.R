counts = read.table("redup_count.txt", sep = "\t", header = FALSE, col.names = c("count", "word"))
counts$letter = substr(counts$word, 1, 1)

pdf("counts_plot.pdf")
letter_freq = as.data.frame(table(counts$letter))
barplot(letter_freq$Freq, names.arg = letter_freq$Var1)
dev.off()