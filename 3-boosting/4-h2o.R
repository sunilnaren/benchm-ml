
library(h2o)

h2oServer <- h2o.init(max_mem_size="60g", nthreads=-1)

dx_train <- h2o.importFile(h2oServer, path = "train-10m.csv")
dx_test <- h2o.importFile(h2oServer, path = "test.csv")


Xnames <- names(dx_train)[which(names(dx_train)!="dep_delayed_15min")]


system.time({
  md <- h2o.gbm(x = Xnames, y = "dep_delayed_15min", data = dx_train, distribution = "bernoulli", 
          n.trees = 1000, 
          interaction.depth = 16, shrinkage = 0.01, n.minobsinnode = 1,
          n.bins = 100)
})


system.time({
  phat <- h2o.predict(md, dx_test)[,"Y"]
})

h2o.performance(phat, dx_test[,"dep_delayed_15min"])@model$auc


