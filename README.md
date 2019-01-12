# StlParser


#### Instructions
1. From the CLI in the cloned repo, start the interactive shell: iex -S mix
2. Call the runner: StlParser.runner


#### Design
Choosing a map with labeled keys to collect the parsed data allowed easier enumeration through it for the later arithemetic calculations.


#### Roadmap
* Add a CLI prompt to pass in a file path.

* Performance improvements: to handle an stl file model with millions of triangles, I would try using chunking the source data & using separate processes to handle the chunks concurrently, possibly using one of the built-in patterns like GenServer.

