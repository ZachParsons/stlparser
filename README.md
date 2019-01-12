# STLParser


#### Instructions
1. From the CLI in the cloned repo, start the interactive shell: iex -S mix
2. Call tbe run function & pass it a file path, example file included in repo: STLParser.run 'Moon.stl'


#### Design
Using a struct for its standardized keys to collect the parsed data gives meaning to the data and allows programmatic access that I used in later enumeration and arithmetic calculations.


#### Roadmap
* Performance improvements: to handle an stl file model with millions of triangles, I would try chunking the source data & using separate processes to handle the chunks concurrently, possibly using one of the built-in patterns like GenServer.

