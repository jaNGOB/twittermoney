library(plotly)
library(quantmod)

df <- data.frame(MarketIndex)
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
  y = ~X2020.01.01, 
  frame = ~frame,
  type = 'scatter', 
  mode = 'lines', 
  fill = 'tozeroy', 
  fillcolor='rgba(114, 186, 59, 0.5)',
  line = list(color = 'rgb(114, 186, 59)'),
  text = ~paste("Day:", ID, "Date:", index(MarketIndex), "Index Level:", MarketIndex[,1]), 
  hoverinfo = 'text'
)

fig <- fig %>% layout(
  title = "Market Index",
  yaxis = list(
    title = "Index", 
    range = c(0,600), 
    zeroline = F
    #tickprefix = "$"
  ),
  xaxis = list(
    title = "Day", 
    range = c(0,243), 
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

