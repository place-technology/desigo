# Desigo

Siemens Desigo driver to control hardware.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     desigo:
       github: place-technology/desigo
   ```

2. Run `shards install`

## Usage

```crystal
require "desigo"


client = Desigo::Client.new(base_url: "https://127.0.0.1:8080/api", username: "admin", password: "admin")

spawn do
  loop do
    client.heartbeat.signal
    sleep 60
  end
end
```

## Contributing

1. Fork it (<https://github.com/place-technology/desigo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Giorgi Kavrelishvili](https://github.com/grkek) - creator and maintainer
