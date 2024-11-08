## How to run the project

- Use Ruby version: `3.3.5`
- Run `./build.sh` to setup the project
- Run `./run.sh` to run the project

## Considerations
Q: How does your system work?

A: Every time the server starts it will preprocess the file and create an array of byte positions for where each line starts. Then it will seek inside the file for the requested position. This solution never loads the whole file into memory and only saves the byte offset making it a lightweight solution.

----
Q: How will your system perform with a 1 GB file? a 10 GB file? a 100 GB file?

A:
  - With a 1GB file the system will perform very well. The indexing is done line by line so doesn't require much memory and since the only thing saved is the offset the created array will be a simple array of integers.
  - With a 10GB the system will still perform. The preprocessing will be longer but memory usage will remain low. **OOM** will start to happen if the file has tens or hundredrs million lines.
  - With a 100GB the indexing array will start to occupy upwards of 50Mb and the process of indexing will be slower but still feasible.
  - The retrieval of the request line shouldn't be impacted in all situations due to using `seek` each will open the file and only retrieve that specific part of the text
----
Q: How will your system perform with 100 users? 10000 users? 1000000 users?

A:
  - With 100 users the server should behave without any issue. WEBrick is a lightweight but still performant webserver. Any modern hardware would have no problem handling this amount of connections.
  - With 10000 WEBrick will start to be impacted. Although highly performant for small applications it wasn't designed to handle so many concurrenct requests. Moving to Puma, and maybe load balancing multiple servers, would be the ideal solution
  - Handling 1000000 connections starts to be a system architectural problem. Possible solutions include introducint a cache system, servers for each world region and probably a more in-depth refactor
----
Q: Documentation consulted

A: [The Ruby File and IO official docs](https://www.rubydoc.info/stdlib/core/IO)

----
Q: Libraries used

A: I opted to used WEBrick. It's a lightweight webserver that will handle the  simple scope of the project until it gets into a number of concurrent users where just by using a different webserver would probably not be enough.

----
Q: Time spent on the project

A: From reading the description to finishing these docs 3 to 4 hours
