library(plotly)
library(quantmod)

df2 <- data.frame(merge(topIndexReturn,IndicesNormReturn[,1]))
df2$ID2 <- seq.int(nrow(df2))

accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

df2 <- df2 %>% accumulate_by(~ID2)

fig <- df2 %>% plot_ly(
  x = ~ID2, 
  y = ~Long.Short.Strategy,
  frame = ~frame,
  type = 'scatter', 
  mode = 'lines', 
  #fill = 'tozeroy', 
  #fillcolor='rgba(29, 161, 242, 0.5)',
  line = list(color = 'rgb(29, 161, 242)'),
  text = ~paste("Day:", ID2, "Date:", index(topIndexReturn), "Index Level:", round(topIndexReturn, 2)), 
  hoverinfo = 'text',
  name = "Twitter Index"
)
fig <- fig %>% add_trace(x = ~ID2, y = ~Market.Index, frame = ~frame,
                         type = 'scatter', 
                         mode = 'lines', 
                         #fill = 'tozeroy',
                         #fillcolor='rgba(220,20,60, 0.5)',
                         line = list(color = 'rgb(220,20,60)'),
                         text = ~paste("Day:", ID2, "Date:", index(IndicesNormReturn[,1]), "Index Level:", round(IndicesNormReturn[,1], 2)),
                         hoverinfo = 'text',
                         name = "Market Index")
fig <- fig %>% layout(
  title = "Twitter Strategy",
  yaxis = list(
    title = "Index", 
    range = c(60,120), 
    zeroline = F
  ),
  xaxis = list(
    title = "Day", 
    range = c(0,239), 
    zeroline = F, 
    showgrid = F
  )
) 
fig <- fig %>% animation_opts(
  frame = 100, 
  transition = 0, 
  redraw = FALSE
)
fig <- fig %>% animation_slider(
  currentvalue = list(
    prefix = "Day "
  ),
  activebgcolor = 'rgba(29, 161, 242, 0.5)',
  bgcolor = 'rgb(29, 161, 242)',
  offset = 7
)
fig <- fig %>% animation_button(
    label = "Start",
    bgcolor = 'rgb(29, 161, 242)'
)


fig



