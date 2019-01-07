#'  scale_color_focus
#'
#' @description    Color scale for `color` aesthetics. This is an alternative use for \link{ggfocus} that uses the usual grammar of graphics.
#'
#' @param focus_levels character vector with levels to focus.
#' @param color_focus `color` for focused levels.
#' @param color_other `color` for other levels.
#'
#' @examples
#'  p <- ggplot(iris,aes(x = Petal.Length, y = Sepal.Length, color = Species)) + geom_point() +
#'  scale_color_focus(focus_levels = "setosa", color_focus = "red")
#'
#' @export
scale_color_focus <- function(focus_levels,color_focus=NULL,color_other="black"){
  structure(list(focus_levels = focus_levels,
                 color_focus = color_focus,
                 color_other = color_other),class="ggfocus_color")
}

#' @export
#' @method ggplot_add ggfocus_color
ggplot_add.ggfocus_color <- function(object, plot, object_name){
  p1 <- plot
  focus_levels <- object$focus_levels
  color_focus <- object$color_focus
  color_other <- object$color_other
  var <- p1$mapping$colour
  if(is.null(var)){stop("'color' isn't mapped by any variable. Use 'aes(color=...) + scale_color_focus(...)")}
  data <- p1$data
  var_column <- data %>% select(!!var) %>% lapply(as.character) %>% unlist
  if(".marker" %in% colnames(data)){data$.marker=NULL}
  .marker <- ifelse(var_column %in% focus_levels, as.character(var_column),"Other")
  p1$data$.marker <- .marker
  n_levels <- .marker %>% unique %>% length
  if(is.null(color_focus)){
    color_focus <- suppressWarnings(RColorBrewer::brewer.pal(n_levels-1,"Set1")[1:(n_levels-1)])
  }
  if(length(color_focus)!=1 & length(color_focus)!=length(focus_levels)){
    stop("color_focus must be of length 1 or same length as focus_levels.")}
  color_values <- rep(color_other,n_levels)
  names(color_values) <- .marker %>% unique()
  color_values[focus_levels] = color_focus
  p1 <- p1 + aes(color=.marker) + scale_color_manual(values=color_values,
                                                     breaks=as.list(as.character(focus_levels)),
                                                     name=(var))
  return(p1)
}

