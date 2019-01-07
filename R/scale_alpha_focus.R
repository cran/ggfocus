#'  scale_color_focus
#'
#' @description    Alpha scale that focus specific factor levels. This is an alternative use of \link{ggfocus} function that uses the usual grammar of graphics.
#'
#' @param focus_levels character vector with levels to focus.
#' @param alpha_focus `alpha` for focused levels.
#' @param alpha_other `alpha` for other levels.
#'
#' @examples
#'  p <- ggplot(iris,aes(x = Petal.Length, y = Sepal.Length, alpha = Species)) + geom_point() +
#'   scale_alpha_focus(focus_levels = "versicolor")
#'  # Note this gives a warning because alpha doesn't always make sense with categorical variables.
#'
#' @export
scale_alpha_focus <- function(focus_levels,alpha_focus=1,alpha_other=0.05){
  structure(list(focus_levels = focus_levels,
                 alpha_focus = alpha_focus,
                 alpha_other = alpha_other),class="ggfocus_alpha")
}

#' @export
#' @method ggplot_add ggfocus_alpha
ggplot_add.ggfocus_alpha <- function(object, plot, object_name){
  p1 <- plot
  focus_levels <- object$focus_levels
  alpha_focus <- object$alpha_focus
  alpha_other <- object$alpha_other
  var <- p1$mapping$alpha
  if(is.null(var)){stop("'alpha' isn't mapped by any variable. Use '+ aes(alpha=...) + scale_alpha_focus(...)'.")}
  data <- p1$data
  var_column <- data %>% select(!!var) %>% lapply(as.character) %>% unlist
  if(".marker_alpha" %in% colnames(data)){data$.marker_alpha=NULL}
  .marker_alpha <- ifelse(var_column %in% focus_levels, as.character(var_column),"Other")
  p1$data$.marker_alpha <- .marker_alpha
  n_levels <- .marker_alpha %>% unique %>% length
  alpha_values <- rep(alpha_focus,n_levels)
  names(alpha_values) <- .marker_alpha %>% unique()
  alpha_values["Other"] = alpha_other
  p1 <- p1 + aes(alpha=.marker_alpha) + scale_alpha_manual(values=alpha_values,breaks=NULL)
  return(p1)
}