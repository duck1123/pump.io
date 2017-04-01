{
  "driver":  "mongodb",
  "params":  {
    "dbname": "${PUMPIO_DB_NAME:-"pumpio"}",
    "host":   "${PUMPIO_DB_HOST:-"mongo"}",
    "port":   ${PUMPIO_DB_PORT:-27017}
  },
  "secret":      "this is really a secret",
  "noweb":       false,
  "site":        "My pump.io site using Docker",
  "owner":       "Daniel E. Renfer",
  "ownerURL":    "https://github.com/duck1123",
  "port":        ${PUMPIO_PORT:-80},
  "hostname":    "${PUMPIO_HOST:-"pump.docker"}",
  "address":     "0.0.0.0",
  "nologger":    false,
  "serverUser":  "root",
  "uploaddir":   "/var/local/pump.io/uploads",
  "debugClient": ${DEBUG_CLIENT:-false},
  "firehose":    "ofirehose.example",
  "sockjs":      false
}
