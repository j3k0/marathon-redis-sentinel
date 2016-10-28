# marathon redis sentinel

Sentinel for redis instances running on marathon.

#### Usage

```
docker run --net=host -e PORT0=12345 jeko/marathon-redis-sentinel:latest \
    "name1:http://marathon1.example.com/v2/apps/my-name-1,http://marathon2.example.com/v2/apps/my-name-1,http://marathon3.example.com/v2/apps/my-name-1" \
    "name2:http://marathon1.example.com/v2/apps/my-name-2,http://marathon2.example.com/v2/apps/my-name-2,http://marathon3.example.com/v2/apps/my-name-2"
```

Argument format: `(group-name:url1,url2,...)+`

`group-name` is the internal name for this group of redis instances.

Then you specify a list of marathon endpoints (`url1,url2,...`). Sentinel will connect to the first valid task retrieve in one of those urls.

#### Environment variables

 * QUORUM (default: 1)
 * DOWN_AFTER_MS (default: 30000)
 * FAILOVER_TIMEOUT (default: 60000)
 * PARALLEL_SYNCS (default: 1)

See [redis sentinel configuration](http://redis.io/topics/sentinel) for details.

