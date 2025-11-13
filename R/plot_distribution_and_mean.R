# copied directly from assignment b1
#' @title Plot the Histogram of Numerical Variable and Bin Adjustment
#'
#' @description
#' This purpose of this function is to construct a histogram based on a numerical variable that the user
#' inputs from a specific dataframe, and adjust the number of bins as necessary to make the graph
#' readable. A x-intercept line is added to show the user the mean value for the numerical variable based
#' on the histogram distribution, and the mean value of the variable is outputted
#' as a sentence along with the plot.
#'
#' @param dataframe any dataframe that has at least one numerical variable. The param name 'dataframe' is used to make it clear that the input must be a dataframe, not a vector.
#' @param num_variable any numerical variable in the dataframe that the user wants to plot. The param name 'num_variable' demonstrates that the input should be a numeric variable, though there is a if statement that does check for this.
#' @param bin_number the number of bins the user wants to assign that works best for the distribution of the variable. This must be a positive integer greater than 0. The param name 'bin_number' is used to ensure that that it is clear that the input for this variable is a number of bins. A default is set to 30 as this is the default number of bins set by ggplot geom_histogram().
#' @param decimals the number of digits to round the mean value to in the output. The default is set to 3 digits (decimals). Must be a positive integer.
#' @return the histogram plot (plot_data) and the mean value for the variable, outputted in a sentence
#' ("The mean of <variable> is <mean value>"). The list is used so that the outputs are assigned as components.
#' @import ggplot2
#' @import dplyr
#' @examples
#' plot_distribution_and_mean(mtcars, wt, 10, 4)
#' plot_distribution_and_mean(mtcars, mpg)
#' @export
plot_distribution_and_mean <- function(dataframe, num_variable, bin_number = 30, decimals = 3) { # function that takes in dataframe, variable from the dataframe, the number of bins, and decimal places for the mean of the variable. A default bin number is set to 30 (as per the ggplot geom_histogram usage), and the number of decimal places is set to a default of 3.

  variable_name <- deparse(substitute(num_variable)) # convert variable name to string prior to error statements

  ####### error statements

  ### dataframe checks
  # checks if dataframe has the variable name inputted
  if(!variable_name %in% colnames(dataframe)) { # if num_variable (variable_name) is not a column in the dataframe
    stop("variable does not exist in inputted dataframe") # show this error
  }
  # checks if the dataframe has at least one row (i.e. not zero rows)
  if(nrow(dataframe) == 0) { # if the dataframe has zero rows
    stop("dataframe must have at least 1 row") # show this error
  }
  # checks if the class of the dataframe is a dataframe or tibble
  if(!(any(class(dataframe) %in% c("data.frame", "tbl_df", "tbl")))) { # if the dataframe class is not data.frame, tbl_df, or tbl
    stop("dataframe must be one of class data.frame, tbl_df, tbl") # show this error
  }

  ### num_variable checks
  # checks if variable is a numeric vector
  if(!is.numeric(dataframe[[variable_name]])) { # if variable (from dataframe) is not numeric
    stop("variable needs to be numeric") # show this error
  }
  # checks if variable vector has at least a length of 1
  if(length(dataframe[[variable_name]]) == 0) { # if the variable has a length of 0
    stop("variable must have a length greater than 0") # show this error
  }

  ### bin_number checks
  # checks if bin_number is numeric
  if(!is.numeric(bin_number)) { # if bin_number is not numeric
    stop("bin_number needs to be numeric") # show this error
  }
  # checks if bin_number is a whole number
  if(bin_number %% 1 != 0) { # if bin_number mod 1 isn't zero
    stop("bin_number needs to be an integer") # show this error
  }
  # checks if bin_number is greater than 1
  if(bin_number < 1) { # if bin_number is a negative number or zero
    stop("bin_number needs to be a positive integer and greater than zero") # show this error
  }

  ### decimals checks
  # checks if decimals is numeric
  if(!is.numeric(decimals)) { # if decimals is not numeric
    stop("decimals needs to be numeric") # show this error
  }
  # checks if 'decimals' is a whole number
  if(decimals %% 1 != 0) { # if decimals mod 1 isn't zero
    stop("decimals needs to be an integer") # show this error
  }
  # checks if 'decimals' is greater than 0
  if(decimals < 0) { # if decimals is a negative number
    stop("decimals needs to be a positive integer") # show this error
  }

  ##### function
  mean_of_var <- dataframe %>% dplyr::pull(variable_name) %>% mean(na.rm = TRUE)  # calculates mean of variable. na.rm = TRUE so that NAs are dropped.
  rounded_mean_of_var <- round(mean_of_var, digits = decimals)

  plot_data <- ggplot2::ggplot(dataframe, ggplot2::aes({{num_variable}})) + # creates plot using the dataframe and variable
    ggplot2::geom_histogram(bins = bin_number, position = "identity", fill = "lightblue") + # histogram where bins are set based on bin_number as input, position (default), and fill colour (light blue)
    ggplot2::geom_vline(xintercept = rounded_mean_of_var, colour = "darkblue", linewidth = 1) + # adds a vertical line to represent the x intercept, which corresponds to the mean_of_var
    ggplot2::xlab(paste0(variable_name," Distribution")) +  # assigns x axis label using variable name
    ggplot2::ylab(paste0("Count of ", variable_name)) + # assigns y axis label using variable name
    ggplot2::ggtitle(paste0("Histogram for Distribution of ", variable_name)) + # adds plot title using variable name
    ggplot2::theme_minimal() # uses minimal theme

  mean_var_print <- paste0("The mean of ", variable_name, " is ", rounded_mean_of_var) # sentence to say what the mean is of the variable

  return(list(plot = plot_data, mean_var = mean_var_print)) # returns plot and mean of the variable as two components that can be accessed separately.

}
