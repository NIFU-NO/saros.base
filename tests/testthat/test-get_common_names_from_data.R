testthat::test_that("get_common_names_from_data works with typical input", {
  data <- data.frame(
    col1 = c("apple", "apricot", "apartment"),
    col2 = c("banana", "band", "banner"),
    col3 = c("cat", "car", "can")
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "ap_ban_ca")
})

testthat::test_that("get_common_names_from_data handles no common characters", {
  data <- data.frame(
    col1 = c("dog", "cat", "mouse"),
    col2 = c("elephant", "tiger", "lion"),
    col3 = c("fish", "bird", "snake")
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "dog_cat_mouse_elephant_tiger_lion_fish_bird_snake")
})

testthat::test_that("get_common_names_from_data handles single column input", {
  data <- data.frame(
    col1 = c("apple", "apricot", "apartment")
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "ap")
})

testthat::test_that("get_common_names_from_data handles empty column input", {
  data <- data.frame(
    col1 = character(0)
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "")
})

testthat::test_that("get_common_names_from_data handles NA values in input", {
  data <- data.frame(
    col1 = c("pear", NA, "peach"),
    col2 = c(NA, "plum", "pineapple"),
    col3 = c("grape", "grapefruit", "graph")
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "pea_pl_grap")
})

testthat::test_that("get_common_names_from_data handles max_width", {
  data <- data.frame(
    col1 = c("strawberry", "straw", "string"),
    col2 = c("blueberry", "blue", "blunt"),
    col3 = c("raspberry", "rasp", "racing")
  )
  result <- saros.base:::get_common_names_from_data(data, max_width = 2)
  testthat::expect_equal(result, "st_bl_ra")
})

testthat::test_that("get_common_names_from_data handles special characters", {
  data <- data.frame(
    col1 = c("hello_world", "hello_worlds", "hello_worldly"),
    col2 = c("goodbye_world", "goodbye_worlds", "goodbye_worldly")
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "helo_wrd_godbye_wrl")
})

testthat::test_that("get_common_names_from_data handles numeric characters", {
  data <- data.frame(
    col1 = c("12345", "123", "12"),
    col2 = c("67890", "678", "67")
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "12_67")
})

testthat::test_that("get_common_names_from_data handles columns with spaces", {
  data <- data.frame(
    col1 = c("new york", "new year", "new"),
    col2 = c("old york", "old year", "old")
  )
  result <- saros.base:::get_common_names_from_data(data)
  testthat::expect_equal(result, "new_old")
})
