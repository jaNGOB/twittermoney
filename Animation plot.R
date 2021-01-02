library(plotly)
library(quantmod)

df <- data.frame(topIndexReturn)
df$ID <- seq.int(nrow(df))

accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

df <- df %>% accumulate_by(~ID)
fig <- df %>% plot_ly(
  x = ~ID, 
  y = ~Long.Short.Strategy,
  frame = ~frame,
  type = 'scatter', 
  mode = 'lines', 
  fill = 'tozeroy', 
  fillcolor='rgba(114, 186, 59, 0.5)',
  line = list(color = 'rgb(114, 186, 59)'),
  text = ~paste("Day:", ID, "Date:", index(topIndexReturn), "Index Level:", topIndexReturn[,1]), 
  hoverinfo = 'text'
)

fig <- fig %>% layout(
  title = "Twitter Strategy",
  yaxis = list(
    title = "Index", 
    range = c(80,130), 
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
  )
)

fig

