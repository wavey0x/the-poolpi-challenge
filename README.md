# The Poolpi Challenge

Create a Factory which clones minimal proxies.

- Each proxy must contain a function that is able to trigger an event, `MyEvent`, emitted from the factory.
- Factory must enforce that the `MyEvent` cannot be emitted via calls from contracts that were not cloned from itself.
- Access control cannot use state (must use immutables).
