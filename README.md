# The Poolpi Challenge

1. Each proxy must contain a function that is able to trigger an event, `MyEvent`, emitted from the factory.
2. Factory must enforce that the `MyEvent` cannot be emitted via calls from contracts that were not cloned from itself.
3. Access control cannot use state (must use immutables).
