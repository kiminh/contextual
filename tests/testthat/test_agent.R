context("Agent")

test_that("Agent", {

  policy             <- EpsilonGreedyPolicy$new(epsilon = 0.1)
  expect_identical(typeof(policy), "environment")

  bandit             <- BasicBernoulliBandit$new(c(0.6, 0.1, 0.1))
  expect_identical(typeof(bandit), "environment")

  agent              <- Agent$new(policy, bandit, name = "testme", sparse = 0.5)
  expect_identical(typeof(agent), "environment")
  expect_equal(agent$name, "testme")
  expect_equal(agent$sparse, 0.5)
  expect_equal(agent$bandit$d, 1)
  expect_equal(agent$bandit$k, 3)
  expect_equal(agent$policy$class_name, "EpsilonGreedyPolicy")
  expect_equal(agent$policy$epsilon, 0.1)
  expect_equal(agent$policy$theta$mean[[1]], 0)

  history            <- Simulator$new(agents = agent,
                                      horizon = 10,
                                      simulations = 10,
                                      do_parallel = FALSE,
                                      log_interval = 1,
                                      progress_file = TRUE)$run()

  expect_identical(history$cumulative$testme$reward,0.4)

  t                  <- agent$get_t()
  agent$set_t(t+1)
  t                  <- agent$get_t()

  expect_identical(agent$get_t(),1)

  Sys.sleep(0.1)
  expect_true(file.exists("parallel.log"))
  expect_true(file.exists("workers_progress.log"))
  expect_true(file.exists("agents_progress.log"))
  if (file.exists("workers_progress.log")) file.remove("workers_progress.log")
  if (file.exists("agents_progress.log")) file.remove("agents_progress.log")
  if (file.exists("progress.log")) file.remove("progress.log")

})
