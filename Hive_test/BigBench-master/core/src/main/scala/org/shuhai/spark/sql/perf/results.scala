package org.shuhai.spark.sql.perf

/**
 * The performance results of all given queries for a single iteration.
 *
 * @param timestamp The timestamp indicates when the entire experiment is started.
 * @param iteration The index number of the current iteration.
 * @param tags Tags of this iteration (variations are stored at here).
 * @param configuration Configuration properties of this iteration.
 * @param results The performance results of queries for this iteration.
 */
case class ExperimentRun(
    timestamp: Long,
    iteration: Int,
    tags: Map[String, String],
    configuration: BenchmarkConfiguration,
    results: Seq[BenchmarkResult])

/**
 * The configuration used for an iteration of an experiment.
 *
 * @param sparkVersion The version of Spark.
 * @param sqlConf All configuration properties related to Spark SQL.
 * @param sparkConf All configuration properties of Spark.
 * @param defaultParallelism The default parallelism of the cluster.
 *                           Usually, it is the number of cores of the cluster.
 */
case class BenchmarkConfiguration(
    sparkVersion: String = org.apache.spark.SPARK_VERSION,
    sqlConf: Map[String, String],
    sparkConf: Map[String, String],
    defaultParallelism: Int,
    buildInfo: Map[String, String])

/**
 * The result of a query.
 *
 * @param name The name of the query.
 * @param mode The ExecutionMode of this run.
 * @param parameters Additional parameters that describe this query.
 * @param joinTypes The type of join operations in the query.
 * @param tables The tables involved in the query.
 * @param parsingTime The time used to parse the query.
 * @param analysisTime The time used to analyze the query.
 * @param optimizationTime The time used to optimize the query.
 * @param planningTime The time used to plan the query.
 * @param executionTime The time used to execute the query.
 * @param result the result of this run. It is not necessarily the result of the query.
 *               For example, it can be the number of rows generated by this query or
 *               the sum of hash values of rows generated by this query.
 * @param breakDown The breakdown results of the query plan tree.
 * @param queryExecution The query execution plan.
 * @param failure The failure message.
 * @param mlResult The result metrics specific to MLlib.
 * @param benchmarkId An optional ID to identify a series of benchmark runs.
 *                    In ML, this is generated based on the benchmark name and
 *                    the hash value of params.
 */
case class BenchmarkResult(
    name: String,
    mode: String,
    parameters: Map[String, String] = Map.empty[String, String],
    joinTypes: Seq[String] = Nil,
    tables: Seq[String] = Nil,
    parsingTime: Option[Double] = None,
    analysisTime: Option[Double] = None,
    optimizationTime: Option[Double] = None,
    planningTime: Option[Double] = None,
    executionTime: Option[Double] = None,
    result: Option[Long] = None,
    breakDown: Seq[BreakdownResult] = Nil,
    queryExecution: Option[String] = None,
    failure: Option[Failure] = None,
    mlResult: Option[Array[MLMetric]] = None,
    benchmarkId: Option[String] = None)

/**
 * The execution time of a subtree of the query plan tree of a specific query.
 *
 * @param nodeName The name of the top physical operator of the subtree.
 * @param nodeNameWithArgs The name and arguments of the top physical operator of the subtree.
 * @param index The index of the top physical operator of the subtree
 *              in the original query plan tree. The index starts from 0
 *              (0 represents the top physical operator of the original query plan tree).
 * @param executionTime The execution time of the subtree.
 */
case class BreakdownResult(
    nodeName: String,
    nodeNameWithArgs: String,
    index: Int,
    children: Seq[Int],
    executionTime: Double,
    delta: Double)

case class Failure(className: String, message: String)

/**
 * Class wrapping parameters for ML tests.
 *
 * KEEP CONSTRUCTOR ARGUMENTS SORTED BY NAME.
 * It simplifies lookup when checking if a parameter is here already.
 */
class MLParams(
    // *** Common to all algorithms ***
    val randomSeed: Option[Int] = Some(42),
    val numExamples: Option[Long] = None,
    val numTestExamples: Option[Long] = None,
    val numPartitions: Option[Int] = None,
    // *** Specialized and sorted by name ***
    val bucketizerNumBuckets: Option[Int] = None,
    val depth: Option[Int] = None,
    val docLength: Option[Int] = None,
    val elasticNetParam: Option[Double] = None,
    val family: Option[String] = None,
    val featureArity: Option[Int] = None,
    val itemSetSize: Option[Int] = None,
    val k: Option[Int] = None,
    val link: Option[String] = None,
    val maxIter: Option[Int] = None,
    val numClasses: Option[Int] = None,
    val numFeatures: Option[Int] = None,
    val numHashTables: Option[Int] = Some(1),
    val numSynonymsToFind: Option[Int] = None,
    val numInputCols: Option[Int] = None,
    val numItems: Option[Int] = None,
    val numUsers: Option[Int] = None,
    val optimizer: Option[String] = None,
    val regParam: Option[Double] = None,
    val relativeError: Option[Double] = Some(0.001),
    val rank: Option[Int] = None,
    val smoothing: Option[Double] = None,
    val tol: Option[Double] = None,
    val vocabSize: Option[Int] = None) {

  /** Returns a copy of the current MLParams instance */
  def copy(
      // *** Common to all algorithms ***
      randomSeed: Option[Int] = randomSeed,
      numExamples: Option[Long] = numExamples,
      numTestExamples: Option[Long] = numTestExamples,
      numPartitions: Option[Int] = numPartitions,
      // *** Specialized and sorted by name ***
      bucketizerNumBuckets: Option[Int] = bucketizerNumBuckets,
      depth: Option[Int] = depth,
      docLength: Option[Int] = docLength,
      elasticNetParam: Option[Double] = elasticNetParam,
      family: Option[String] = family,
      featureArity: Option[Int] = featureArity,
      itemSetSize: Option[Int] = itemSetSize,
      k: Option[Int] = k,
      link: Option[String] = link,
      maxIter: Option[Int] = maxIter,
      numClasses: Option[Int] = numClasses,
      numFeatures: Option[Int] = numFeatures,
      numHashTables: Option[Int] = numHashTables,
      numSynonymsToFind: Option[Int] = numSynonymsToFind,
      numInputCols: Option[Int] = numInputCols,
      numItems: Option[Int] = numItems,
      numUsers: Option[Int] = numUsers,
      optimizer: Option[String] = optimizer,
      regParam: Option[Double] = regParam,
      relativeError: Option[Double] = relativeError,
      rank: Option[Int] = rank,
      smoothing: Option[Double] = smoothing,
      tol: Option[Double] = tol,
      vocabSize: Option[Int] = vocabSize): MLParams = {
    new MLParams(
      randomSeed = randomSeed,
      numExamples = numExamples,
      numTestExamples = numTestExamples,
      numPartitions = numPartitions,
      bucketizerNumBuckets = bucketizerNumBuckets,
      depth = depth,
      docLength = docLength,
      elasticNetParam = elasticNetParam,
      family = family,
      featureArity = featureArity,
      itemSetSize = itemSetSize,
      k = k,
      link = link,
      maxIter = maxIter,
      numClasses = numClasses,
      numFeatures = numFeatures,
      numHashTables = numHashTables,
      numSynonymsToFind = numSynonymsToFind,
      numInputCols = numInputCols,
      numItems = numItems,
      numUsers = numUsers,
      optimizer = optimizer,
      regParam = regParam,
      relativeError = relativeError,
      rank = rank,
      smoothing = smoothing,
      tol = tol,
      vocabSize = vocabSize)
  }
}

object MLParams {
  val empty = new MLParams()
}

/**
 * Metrics specific to MLlib benchmark.
 *
 * @param metricName the name of the metric
 * @param metricValue the value of the metric
 * @param isLargerBetter the indicator showing whether larger metric value is better
 */
case class MLMetric(
    metricName: String,
    metricValue: Double,
    isLargerBetter: Boolean)

object MLMetric {
  val Invalid = MLMetric("Invalid", 0.0, false)
}