library(magrittr)
library(bezier)
library(foreach)
library(png)
library(magick)
library(glue)


# Helper functions & syntactic sugars ---------------------------

bezier_curve <- pointsOnBezier

draw.bezier_curve <- function(n1, n2, s) {
  l1 <- length(n1)
  l2 <- length(n2)
  v <- as.integer(as.numeric(c(n1[l1 - 1], n2[2], n2[4])) / s)
  w <- as.integer(as.numeric(c(n1[l1], n2[3], n2[5])) / s)
  return(bezier_curve(cbind(v, w), method = 'adjoining')$points)
}

indices_of_rect <- function(left, top, width, height, scale = 1) {
  l <- as.integer(left)
  t <- as.integer(top)
  w <- as.integer(width)
  h <- as.integer(height)

  #Build the top side
  topside <- foreach(i = 1:(w), .combine = rbind) %do% round(c(t, (l + i)))
  bottomside <- foreach(i = 1:(w), .combine = rbind) %do% round(c(t + h, (l + i)))

  leftside <- foreach(j = 1:h, .combine = rbind) %do% round(c(t + j, l))
  rightside <- foreach(j = 1:h, .combine = rbind) %do% round(c(t + j, l + w))

  return(rbind(topside, bottomside, leftside, rightside) * scale)
}

indices_of_line <- function(left, top, width, height, shape, scale = 1) {
  center <- round(0.5 * shape)
  x1 <- as.integer(center[1] - round(left))
  x2 <- as.integer(x1 + round(width))
  y2 <- as.integer(center[2] - round(top))
  y1 <- as.integer(y2 + round(height))

  a <- (y2 - y1) / (x2 - x1)
  b <- y1 - a * x1

  # The indices get reversed - the points will be transposed?
  M <- foreach(i = x1:x2, .combine = rbind) %do% c(round(a * i + b), shape[1] - i)
  return(M * scale)
}

indices_of_path <- function(path, scale = 1) {

  if (!is.null(path)) {
    l <- length(path)
    t1 <- path[1:(l - 2)]
    t2 <- path[2:(l - 1)]

    points <- foreach(i = 1:(l - 2), .combine = rbind) %do% draw.bezier_curve(t1[[i]], t2[[i]], 1)

    return(points * scale)
  }
}

parse_jsonstring <- function(data, shape = NULL, scale = 1) {
  # data - JSON string of data
  # shape <- a 2-dim vector of integers, noting the dimensions
  # Returns
  # -------
  # mask: ndarray of bools
  #     a matrix of {0, 1}'s where the painted regions are one.
  #
  if (is.null(shape) || shape[1] * shape[2] < 500 ^ 2) {
    shape = c(500, 500)
  }
  rawIm <- matrix(0, nrow = shape[1], ncol = shape[2])

  types <- data[['type']]
  left <- data[['left']]
  top <- data[['top']]
  width <- data[['width']]
  height <- data[['height']]
  scaleX <- data[['scaleX']]
  s <- length(data[['path']])
  f <- "rect" %in% types || "line" %in% types

  flag <- function(k) {
    if (types[k] == "rect") {
      scale = scaleX[k]
      return(indices_of_rect(
        left[k], top[k], width[k], height[k], scale =  scale))
    }

    if (types[k] == "line") {
      scale = scaleX[k]
      return(indices_of_line(
        left[k], top[k], width[k], height[k], shape, scale =  scale))
    }
  }

  path_scale <- function(n) {
    if (types[n] == 'path') {
      return(scaleX[n])
    } else{
      return(NA)
    }
  }

  if (s > 1 && f) {
    path_scales <- na.omit(unlist(lapply(1:length(types), path_scale)))
    raw_path_lst <- data[['path']][-1]
    m <- foreach(
      i = 1:(length(raw_path_lst)), .combine = rbind) %do% indices_of_path(
        raw_path_lst[[i]], path_scales[i])
    n <- foreach(j = 2:length(types), .combine = rbind) %do% flag(j)
    n <- na.omit(n)
    M <- rbind(m, n)

    for (k in 1:nrow(m)) {
      rawIm[M[k, 2], M[k, 1]] = 1
    }

    N <- 1:nrow(n) + nrow(m)

    for (j in N) {
      rawIm[M[j, 1], M[j, 2]] = 1
    }

  } else if (f) { # When the drawn annotation contains rect or line only
    n <- foreach(j = 2:length(types), .combine = rbind) %do% flag(j)
    for (j in 1:nrow(n)) {
      rawIm[n[j, 1], n[j, 2]] = 1
    }
  }  else { # When the drawn annotation contains path only
    path_scales <- na.omit(unlist(lapply(1:length(types), path_scale)))
    raw_path_lst <- data[['path']][-1]
    m <- foreach(i = 1:(length(raw_path_lst)), .combine = rbind) %do% indices_of_path(
      raw_path_lst[[i]], path_scales[i])
    for (k in 1:nrow(m)) {
      rawIm[m[k, 2], m[k, 1]] = 1
    }
  }

  return(rawIm)
}

matrix_to_data_url <- function(m, it = 5) {
  Im <- m %>% as.raster %>% image_read %>% image_convolve(
    ., kernel = "Disk", iterations = it, scaling = NULL, bias = NULL) %>%
    image_write %>% base64_enc
  return(glue('data:image/png;base64, ', Im))
}
# ------
