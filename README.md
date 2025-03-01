# The Poolpi Challenge

1. Create a factory that clones minimal proxies.
1. Each proxy MUST be able to trigger an event, `MyEvent`, to be emitted from the factory.
1. Factory MUST enforce access control such that `MyEvent` can only be emitted via calls from contracts that were cloned from it.
1. Access control in the prior step MUST NOT access state.
