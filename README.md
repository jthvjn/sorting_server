sorting_server
=====

An OTP application. Requires rebar3 to be available locally.
Two APIs are available `http://localhost:8080/sort_tasks` & `http://localhost:8080/bash_script`.

# Build

   ```$ rebar3 compile```

# Run
   ```$ rebar3 shell```
    

# Test

```
    $ curl -X POST http://localhost:8080/bash_script \
            -H "Content-Type: application/json" \
            -d '{
                "tasks": [
                {
                    "name": "task-1",
                    "command": "touch /tmp/file1"
                },
                {
                    "name": "task-2",
                    "command": "cat /tmp/file1",
                    "requires": [
                    "task-3"
                    ]
                },
                {
                    "name": "task-3",
                    "command": "echo Hello World! > /tmp/file1",
                    "requires": [
                    "task-1"
                    ]
                },
                {
                    "name": "task-4",
                    "command": "rm /tmp/file1",
                    "requires": [
                    "task-2",
                    "task-3"
                    ]
                }
                ]
            }'
```

```
        $ curl -X POST http://localhost:8080/sort_tasks \
            -H "Content-Type: application/json" \
            -d '{
                "tasks": [
                {
                    "name": "task-1",
                    "command": "touch /tmp/file1"
                },
                {
                    "name": "task-2",
                    "command": "cat /tmp/file1",
                    "requires": [
                    "task-3"
                    ]
                },
                {
                    "name": "task-3",
                    "command": "echo Hello World! > /tmp/file1",
                    "requires": [
                    "task-1"
                    ]
                },
                {
                    "name": "task-4",
                    "command": "rm /tmp/file1",
                    "requires": [
                    "task-2",
                    "task-3"
                    ]
                }
                ]
            }'
```
