#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const BENCHMARK_FILE = path.join(__dirname, "../benchmarks.md");

function rand() {
  return Math.floor(Math.random() * 100);
}

function generateRandomBenchmark() {
  fs.writeFileSync(BENCHMARK_FILE,
`
<!--This file is auto generated. DO NOT EDIT-->
# Benchmark

\`\`\`
Name              Metric 1\tMetric 2
plugin.timing.a   ${rand()}\t\t${rand()}
plugin.timing.b   ${rand()}\t\t${rand()}
plugin.timing.c   ${rand()}\t\t${rand()}
plugin.timing.d   ${rand()}\t\t${rand()}
plugin.timing.e   ${rand()}\t\t${rand()}
plugin.timing.f   ${rand()}\t\t${rand()}
plugin.timing.g   ${rand()}\t\t${rand()}
\`\`\`
`
  );
}

if (require.main === module) {
  generateRandomBenchmark();
}