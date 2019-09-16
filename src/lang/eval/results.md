## External

```bash
$ CORE_PROFILER= ./bin/scilla-profiler -s /home/vyorkin/zilliqa.sock -c crowdfunding -i 1 -n 6 -t 50
```

```
┌─────────────────────────────────────────────────┬────┬───────┬──────────┬─────────┬──────────┬──────────┬──────────┬──────────┐
│ name                                            │    │ count │     mean │     min │      max │    stdev │     5 %l │    95 %l │
├─────────────────────────────────────────────────┼────┼───────┼──────────┼─────────┼──────────┼──────────┼──────────┼──────────┤
│ StateIPCClient:fetch-b,fetch-e                  │ dt │   250 │  24.95ms │ 24.37ms │   25.7ms │ 258.07us │  24.56ms │  25.46ms │
│ StateIPCClient:fetch-e,fetch-b                  │ dt │   100 │  50.93ms │  3.15us │ 102.34ms │  51.18ms │   3.31us │ 102.26ms │
│ StateIPCClient:fetch-e,update-b                 │ dt │   150 │  38.97us │ 22.65us │ 204.73us │  24.87us │   23.2us │  67.98us │
│ StateIPCClient:update-b,update-e                │ dt │   150 │  25.31ms │  24.9ms │  25.57ms │ 156.66us │  25.04ms │  25.53ms │
│ StateIPCClient:update-e,fetch-b                 │ dt │   149 │  51.16ms │  50.6ms │  51.61ms │  261.4us │  50.67ms │  51.53ms │
│ eval:init-module-b,init-module-e                │ dt │   250 │  32.85us │ 21.21us │ 313.16us │  30.21us │  21.86us │  93.83us │
│ StateIPCTestClient:update-b,update-b            │ dt │   999 │  22.75ms │   389ns │  76.78ms │  19.41ms │    428ns │  51.17ms │
│ RunnerUtil:import-lib-b,import-lib-e            │ dt │   250 │  69.03us │ 52.27us │ 264.46us │  32.02us │  53.01us │ 135.87us │
│ RunnerUtil:import-lib-e,import-libs-b           │ dt │   250 │   6.32us │  3.34us │ 266.57us │  18.47us │   3.55us │   5.87us │
│ RunnerUtil:import-libs-b,import-lib-b           │ dt │   250 │  34.96us │ 27.55us │ 303.22us │  21.16us │  28.04us │  59.63us │
│ scilla_runner:parse-contract-b,parse-contract-e │ dt │   250 │ 236.57us │ 181.3us │  511.4us │  56.26us │ 183.78us │  348.6us │
│ scilla_runner:parse-contract-e,check-libs-b     │ dt │   250 │ 115.04us │ 85.92us │ 364.26us │  43.19us │  87.76us │ 200.11us │
│ scilla_runner:check-libs-b,check-libs-e         │ dt │   250 │  25.28us │ 14.91us │ 296.78us │  29.15us │  15.63us │  82.11us │
│ scilla_runner:check-libs-e,get-initargs-b       │ dt │   250 │     52ns │    30ns │    211ns │     20ns │     33ns │     89ns │
│ scilla_runner:gas-remaining-b,gas-remaining-e   │ dt │   250 │   5.69us │  3.83us │  31.96us │    3.1us │   4.08us │  10.76us │
│ scilla_runner:gas-remaining-e,parse-contract-b  │ dt │   250 │    134ns │    46ns │  17.43us │    1.1us │     50ns │     77ns │
│ scilla_runner:get-initargs-b,get-initargs-e     │ dt │   250 │  27.33us │ 21.85us │ 130.58us │  13.36us │  22.31us │  53.98us │
│ scilla_runner:get-initargs-e,get-state-b        │ dt │   250 │    429ns │   271ns │   1.43us │    151ns │    295ns │    676ns │
│ scilla_runner:get-state-b,get-state-e           │ dt │   250 │   8.91us │  7.42us │  46.61us │   3.78us │   7.62us │  11.39us │
│ scilla_runner:get-state-e,get-message-b         │ dt │   250 │     62ns │    40ns │    146ns │     13ns │     48ns │     87ns │
│ scilla_runner:get-message-b,get-message-e       │ dt │   250 │   9.31us │  7.46us │    105us │   7.12us │   7.56us │   9.96us │
│ ipc mode:handle-msg-ipc-b,handle-msg-ipc-e      │ dt │   250 │   33.9us │ 21.96us │ 314.32us │  30.29us │  22.55us │  94.83us │
└─────────────────────────────────────────────────┴────┴───────┴──────────┴─────────┴──────────┴──────────┴──────────┴──────────┘
```

## Mock (extracted)

```bash
$ CORE_PROFILER= ./bin/scilla-profiler -s /home/vyorkin/mockserver.sock -c crowdfunding -i 1 -n 6 -t 50
```

```
┌─────────────────────────────────────────────────┬────┬───────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ name                                            │    │ count │     mean │      min │      max │    stdev │     5 %l │    95 %l │
├─────────────────────────────────────────────────┼────┼───────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ StateIPCClient:fetch-b,fetch-e                  │ dt │   250 │  67.38us │  27.45us │ 214.13us │  30.21us │  31.58us │ 118.26us │
│ StateIPCClient:fetch-e,fetch-b                  │ dt │   100 │ 609.47us │   2.31us │    1.7ms │ 615.83us │   2.33us │   1.42ms │
│ StateIPCClient:fetch-e,update-b                 │ dt │   150 │  27.84us │  16.87us │ 147.46us │  20.12us │  17.02us │  72.26us │
│ StateIPCClient:update-b,update-e                │ dt │   150 │   58.2us │  28.34us │ 150.65us │   25.9us │  30.21us │  98.41us │
│ StateIPCClient:update-e,fetch-b                 │ dt │   149 │ 607.41us │ 490.95us │ 978.73us │  85.83us │ 513.59us │ 766.15us │
│ eval:init-module-b,init-module-e                │ dt │   250 │  25.93us │  18.84us │ 141.09us │  19.31us │  19.05us │   70.8us │
│ StateIPCTestClient:update-b,update-b            │ dt │   999 │ 184.35us │    129ns │   2.83ms │ 277.25us │    183ns │ 717.34us │
│ RunnerUtil:import-lib-b,import-lib-e            │ dt │   250 │  61.66us │   48.3us │ 180.27us │  26.66us │   48.6us │ 125.68us │
│ RunnerUtil:import-lib-e,import-libs-b           │ dt │   250 │   3.76us │   2.97us │  65.65us │   4.94us │   3.05us │   3.62us │
│ RunnerUtil:import-libs-b,import-lib-b           │ dt │   250 │  30.24us │  24.05us │  303.6us │   23.5us │  24.34us │  47.48us │
│ scilla_runner:parse-contract-b,parse-contract-e │ dt │   250 │ 204.08us │ 164.79us │ 448.45us │  49.12us │ 165.35us │  290.7us │
│ scilla_runner:parse-contract-e,check-libs-b     │ dt │   250 │  99.15us │  77.54us │ 386.25us │  40.39us │  78.04us │ 175.25us │
│ scilla_runner:check-libs-b,check-libs-e         │ dt │   250 │  20.16us │  13.05us │ 234.23us │  27.95us │  13.22us │  54.05us │
│ scilla_runner:check-libs-e,get-initargs-b       │ dt │   250 │     48ns │     27ns │    135ns │     17ns │     34ns │     79ns │
│ scilla_runner:gas-remaining-b,gas-remaining-e   │ dt │   250 │   2.74us │    2.3us │  34.15us │   2.11us │   2.36us │   3.38us │
│ scilla_runner:gas-remaining-e,parse-contract-b  │ dt │   250 │     44ns │     31ns │     83ns │      7ns │     35ns │     55ns │
│ scilla_runner:get-initargs-b,get-initargs-e     │ dt │   250 │  27.19us │  21.18us │ 118.78us │  14.82us │  21.46us │  63.88us │
│ scilla_runner:get-initargs-e,get-state-b        │ dt │   250 │    287ns │    233ns │    655ns │     39ns │    248ns │    337ns │
│ scilla_runner:get-state-b,get-state-e           │ dt │   250 │   8.35us │   6.69us │  60.09us │   5.04us │   6.84us │  13.48us │
│ scilla_runner:get-state-e,get-message-b         │ dt │   250 │     47ns │     28ns │    278ns │     21ns │     31ns │     76ns │
│ scilla_runner:get-message-b,get-message-e       │ dt │   250 │   8.34us │   6.83us │  35.87us │   3.93us │   6.96us │   9.52us │
│ ipc mode:handle-msg-ipc-b,handle-msg-ipc-e      │ dt │   250 │  26.67us │  19.51us │ 143.88us │  19.73us │  19.71us │  71.59us │
└─────────────────────────────────────────────────┴────┴───────┴──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
```
