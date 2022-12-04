# Design of kboapi #

This is a high-level overview of the design for KB-OneAPI library.
Essentially, we re-create the endpoints as functions in the module,
`TheOneAPI`.  However, we properly pluralize the endpoints, except in the case
of `quote`, since this is an Elixir keyword.

Much of the work is baked into the dependency on [`Tesla`][0] which offers nice
middleware API construction for Elixir.  Furthermore, we leverage Elixir's
pattern matching to handle success and failure for each endpoint.  If we
receive the standard `{:ok, _}` tuple from `Tesla`, we can move forward and
parse the returned object into an internally represented structure.  However,
if we do not receive an `:ok` tuple, we log the error and return an empty list.

The tests are flaky at the moment, but with more time could be made stable.
Essentially the errors come down to the randomized order returned from the API
which the tests do not consider.  Two approaches would easily work to resolve
this issue: 1) generalize the tests so that the structure or length of objects
returned are acceptable; or 2) adjust the query parameters to ensure specific
datasets are returned.


[0]: https://hex.pm/packages/tesla
