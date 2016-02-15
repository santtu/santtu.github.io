---
title: Dynamic devtest deployments
tags: ["devtest", "docker", "ecs"]
---

While I work less and less on down-to-earth development, there are
times when I get a chance to hack something. In this post I'll
describe a devtest deployment system I got a chance to be work on.

In a system we are developing we wanted to do a persistent deployment
of the whole system to [ECS](https://aws.amazon.com/ecs/) on each
branch repository push where each subservice would be accessible as
`<branch>-<service>.dev.example.com`[^examplecom]. This would make it
easy for developer to verify integration tests before merging (pull
request) to master[^integration], to show their work to other
developers and to allow non-developer stakeholders easy access to
features as they are being developed.

<figure>
<a href="/assets/posts/devtest-deployments-process.svg"><img
src="/assets/posts/devtest-deployments-process.svg" alt="Testing pipeline"></a>

<figcaption>Flow of each push through the CI. Integration tests are
run against a deployment on ECS.
</figcaption>

</figure>

There are multiple ways to accomplish this such as using dynamic DNS
updates, ELBs and so on, and after some discussions and testing we
settled on the following setup.

1. There is a separate *frontend* deployment that consists of etcd and
   nginx servers.

2. Each branch deployment service registers itself to the frontend by
   addings its address to etcd registry with its branch and service
   names.

3. A watcher process on nginx container notices changes to etcd
   registry and updates nginx configuration so that the
   **branch**-**service**.dev address gets proxied to the correct
   docker container.


<figure>
<a href="/assets/posts/devtest-deployment-operation.svg"><img
src="/assets/posts/devtest-deployment-operation.svg" alt="Request processing in deployment"></a>

<figcaption>Request processing with multiple branch deployments. Each
service registers its address and port to etcd registry.
</figcaption>

</figure>

Registration is done during service startup and is also pretty simple
(`REGISTRY_URL`, `SERVICE`, `NAME` and `PORT` are passed as Docker
environment variables, `ip` is fetched from EC2 metadata service):

~~~ shell
if [ -n "$REGISTRY_URL" -a -n "$PORT" -a -n "$SERVICE" -a -n "$NAME" ]; then
    echo "INFO: Registering to $REGISTRY_URL as $NAME/$SERVICE at $ip:$PORT" >&2
    url=$REGISTRY_URL/v2/keys/deployment/$NAME/service/$SERVICE
    now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    $curl $url/ip -XPUT -d value=$ip >/dev/null || exit 1
    $curl $url/port -XPUT -d value=$PORT >/dev/null || exit 1
    $curl $REGISTRY_URL/v2/keys/deployment/$NAME/created -XPUT -d value=$now >/dev/null || exit 1
fi
~~~

Similarly when the service is shut down it'll issue `DELETE` on its
keys to unregister itself.

The nginx container is based on the standard docker registry `nginx`
container, but it will start a "regenerate" process alongside the
actual nginx server. It uses
[etcdwatch](https://github.com/santtu/etcdwatch) to keep track of
registry changes and then finally a separate `regenerate.py` script
takes the registry contents and updates the nginx configuration
file[^regenerate].

~~~ shell
if [ -n "$REGISTRY_URL" ]; then
    echo "Registry is at $REGISTRY_URL" >&2
    echo "Starting etcdwatch to generate configuration files" >&2
    etcdwatch -u $REGISTRY_URL -d /deployment -- sh -c './regenerate.py && nginx -s reload && echo `date -u`: Regenerated configuration' &
    pids="$!"
fi
~~~

Now some caveats. **THIS IS NOT FOR PRODUCTION USE.** We use this only
for devtest deployments. This setup is meant to make it easy and
straighforward to test and verify things *during development*, even
when working on incomplete and definitely-not-ready-for-merge code
changes.

I have also omitted a lot of details. Where does `PORT` come from?
(It needs to be container's *host port*, and it needs to be unique per
*container instance*.) How to use frontend also on local (developer
machine) deployment? What to use as `REGISTRY_URL`? How to actually
integrate all of this into a CI pipeline? — I'll leave those as a home
exercise either to solve yourself, or to pester me to write about them
:-)

Anyway we are pretty happy about the setup. It means that *any* branch
will get full integration test love on an ECS-deployed setup,
automatically and without any extra work on developer's side. It also
means that errors and problems are a bit easier to debug, since any
URL from any log or test user report will automatically reveal branch
and service names.

It is also easy to determine a correct url to pass to other people
(developers, stakeholders, internal alpha testers) as it is *always*
**branch**.dev.example.com. We special-cased the default entry point
to drop the service name.

Sprint demo coming up? Merge `master` to `demo`, push and it'll be up
in a jiffy.

----

[^examplecom]: Not `example.com` in reality, of course.
[^integration]: Before you say that a developer should be able to run integration tests locally and tests should always match ECS-based tests thanks to the magic of docker I'll answer that yes, they can, it's one command, and no, since there are inherent differences in deployment in local vs. remote deployment the results are not always the same. Although usually there are no problems, and when there are they usually are configuration and not code problems.
[^regenerate]: The regenerate script actually just dumps the registry information to a Jinja2 template, writing the result to `/etc/nginx/conf.d` directory.
