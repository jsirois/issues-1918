def make_lib(name, org, rev, alias=None, dependencies=None, apidocs=None):
  """
  A simple wrapper method to make this BUILD file a little easier on the eyes.
  We'll default our jar_libraries to with_sources() because why not?

  Prefer to not specify 'alias' unless the name is egregiously unclear as to the nature of the
  dependency in the depending BUILD files.

  Jars are referenced by the `name` param, unless `alias` is provided.
  """
  if dependencies is None:
    dependencies = []
  if alias is None:
    alias = name

  jar_library(
    name=alias,
    dependencies=dependencies,
    jars=[
      jar(org=org, name=name, rev=rev, apidocs=apidocs)
    ]
  )

_FINAGLE_REV = '5.3.1'  # common rev for all com.twitter%finagle* artifacts

make_lib('slf4j-api', 'org.slf4j', '1.6.3')
make_lib('commons-lang', 'commons-lang', '2.6')
make_lib('libthrift', 'org.apache.thrift', '0.5.0-1')
make_lib('finagle-thrift', 'com.twitter', _FINAGLE_REV)
make_lib('finagle-core', 'com.twitter', _FINAGLE_REV)

target(name='thrift-0.5.0',
       dependencies=[
         ':commons-lang',
         ':libthrift',
         ':slf4j-api',
       ])

target(name='thrift-0.5.0-finagle',
       dependencies=[
         ':thrift-0.5.0',
         # finagle thrift extra deps
         ':finagle-core',
         ':finagle-thrift',
       ])
