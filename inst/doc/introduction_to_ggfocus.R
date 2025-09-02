## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  warning = FALSE,
  message = FALSE
)

## ----setup, echo = FALSE------------------------------------------------------
library(ggfocus)

## ----create_example-----------------------------------------------------------
set.seed(2)
# Create an example dataset
df <- data.frame(u1 = runif(300) + 1*rbinom(300, size = 1, p = 0.01), 
                 u2 = runif(300),
                 grp = sample(LETTERS[1:10], 300, replace = TRUE))
dplyr::glimpse(df)

## ----bad_plot-----------------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, color = grp)) + 
  geom_point()

## ----bad_filter---------------------------------------------------------------
library(dplyr)
df |> 
  filter(grp %in% c("A", "B")) |>
  ggplot(aes(x = u1, y = u2, color = grp)) +
  geom_point()

## ----base_solution------------------------------------------------------------
df |>
  mutate(grp = ifelse(grp %in% c("A", "B"), as.character(grp), "other")) |>
  ggplot(aes(x = u1, y = u2, color = grp)) +
  geom_point() +
  scale_color_manual(values = c("A" = "red", "B" = "blue", "other" = "gray"))

## ----color_focus_usage, eval = FALSE------------------------------------------
# scale_color_focus(focus_levels, color_focus = NULL,
#                   color_other = "gray", palette_focus = "Set1")
# 
# scale_fill_focus(focus_levels, color_focus = NULL,
#   color_other = "gray", palette_focus = "Set1")

## ----example_color------------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, color = grp)) +
  geom_point() +
  scale_color_focus(c("A", "B"))

ggplot(iris, aes(x = Petal.Length, fill = Species)) + 
  geom_histogram() +
  scale_fill_focus("virginica")

## ----example_onecolor---------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, color = grp)) +
  geom_point() +
  scale_color_focus(c("A", "B"), color_focus = "red")

## ----alpha_focus_usage, eval = FALSE------------------------------------------
# scale_alpha_focus(focus_levels, alpha_focus = 1, alpha_other = 0.2)

## ----example_alpha------------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, alpha = grp)) +
  geom_point() +
  scale_alpha_focus(c("A", "B")) # Does not distinguish A and B.

## ----example_alpha_color------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, alpha = grp, color = grp)) +
  geom_point() +
  scale_alpha_focus(c("A", "B"), alpha_other = 0.5) +
  scale_color_focus(c("A", "B")) +
  theme_bw() # White background

## ----usage_linetype, eval = FALSE---------------------------------------------
# scale_linetype_focus(focus_levels, linetype_focus = 1, linetype_other = 3)

## ----example_linetype---------------------------------------------------------
ggplot(datasets::airquality, aes(x = Day, y = Temp, linetype = factor(Month),
                                 group = factor(Month))) + 
  geom_line() +
  scale_linetype_focus(focus_levels = c(5,7))

## ----example_linetype2--------------------------------------------------------
ggplot(datasets::airquality, aes(x = Day, y = Temp, linetype = factor(Month),
                                 group = factor(Month))) + 
  geom_line() +
  scale_linetype_focus(focus_levels = c(5,7), linetype_focus = c(1,5))

## ----usage_shape, eval = FALSE------------------------------------------------
# scale_shape_focus(focus_levels, shape_focus = 8, shape_other = 1)

## ----example_shape------------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, shape = grp)) + 
  geom_point() +
  scale_shape_focus(c("A", "B"))

## ----example_shape2-----------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, shape = grp)) + 
  geom_point() +
  scale_shape_focus(c("A", "B"), shape_focus = c(2,3))

## ----usage_size, eval = FALSE-------------------------------------------------
# scale_size_focus(focus_levels, size_focus = 3, size_other = 1)

## ----example_usage------------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, size = grp)) + 
  geom_text(aes(label = grp)) +
  scale_size_focus(c("A", "B"))

## ----usage_size_point---------------------------------------------------------
ggplot(df, aes(x = u1, y = u2, size = grp, shape = grp)) + 
  geom_point() +
  scale_size_focus(c("A", "B")) +
  scale_shape_focus(c("A", "B"))

## ----example_ggrepel----------------------------------------------------------
library(dplyr)
library(ggrepel)
iris |> 
  mutate(id = row_number()) |>
  ggplot(aes(x = Petal.Length, y = Sepal.Length, label = id, size = id)) +
  geom_text_repel() +
  scale_size_focus(c(100,127), size_focus = 8, size_other = 2)

## ----example_maps-------------------------------------------------------------
library(maps)
wm <- map_data("world")
ggplot(wm, aes(x=long, y = lat, group = group, fill = region)) + 
  geom_polygon(color="black") +
  theme_void() +
  scale_fill_focus(c("Brazil", "Canada", "Australia", "India"), color_other = "gray")

