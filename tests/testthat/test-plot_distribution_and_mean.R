# test dataset
test_dataset <- data.frame(Student_ID = letters[1:20],
                                Grade = c(90,70,70,75,80,NA,65,100,67,89,89,89,75,89,NA,100,100,89,89,NA))
mean_test_dataset <- mean(test_dataset$Grade, na.rm = TRUE)
# test 1
test_that("mean value still outputs with NAs", {
  expect_equal(plot_distribution_and_mean(test_dataset, Grade)$mean_var, "The mean of Grade is 83.882")
})

# test 2
test_that("function throws error when input variable is not numeric", {
  expect_error(plot_distribution_and_mean(plot_distribution_and_mean(test_dataset, Student_ID)$mean_var, Student_ID, 10), "variable needs to be numeric")
})

# test 3
# manually create plot to replicate function
test3_plot <- ggplot(test_dataset, aes(x = Grade)) +
  geom_histogram(bins = 20, position = "identity", fill = "lightblue") +
  geom_vline(xintercept = mean_test_dataset, colour = "darkblue", linewidth = 1) +
  xlab("Grade Distribution") +
  ylab("Count of Grade") +
  ggtitle("Histogram for Distribution of Grade") +
  theme_minimal()

# determine x variables of test3_plot
x_var <- rlang::as_name(test3_plot$mapping$x)
# determine plot components (graph type, stat type) of test3_plot to ensure it is a histogram
geom_type <- class(test3_plot$layers[[1]]$geom)[1]
stat_type <- class(test3_plot$layers[[1]]$stat)[1]

test3_function_plot <- plot_distribution_and_mean(test_dataset, Grade)$plot

test_that("ggplot has the correct axis labels and is a histogram", {
  expect_equal(rlang::as_name(test3_function_plot$mapping$x), x_var)
  expect_equal(class(test3_function_plot$layers[[1]]$geom)[1], geom_type)
  expect_equal(class(test3_function_plot$layers[[1]]$stat)[1], stat_type)
})

# remove objects
rm(test_dataset,
   mean_test_dataset,
   test3_plot,
   x_var,
   geom_type,
   stat_type,
   test3_function_plot)


