# Heat Resource

## Create stack

```yaml
resource_types:
- name: heat
  type: docker-image
  source:
    repository: kvivan/concourse-resource-heat

resources:
- name: stack_repo
  type: git
  source:
    uri: ((GIT_URL))

- name: heat-executor
  type: heat
  source:
    os_auth_url: ((OS_AUTH_URL))
    os_username: ((OS_USERNAME))
    os_password: ((OS_PASSWORD))
    os_project_id: ((OS_PROJECT_ID))
    stack_name: ((stack_name))
    debug: true

jobs:
- name: Create Stack
  plan:
    - get: stack_repo
      trigger: true
    - put: heat-executor
      params:
        action: create
        environment: stack_repo/env.yaml
        template: stack_repo/stack.yaml

```
## Source configuration

### Must be set:

- `os_auth_url`
- `os_username`
- `os_password`
- `os_project_id`
- `stack_name`

### Optional:

- `debug` (default `False`)
- `validation` (default `False`) wait for stack modification or not
- `max_retries` (default `20`) on status validation if enabled
- `retry_interval` (default `3`) on status validation if enabled

## Params configuration (put)

- `action`: possible values
  - `create`
  - `delete`

If `action` is `create`:
- `environment`: path to env file
- `template`: path to template file



# Job create and delete

``` yaml
jobs:
- name: Create Stack
  plan:
    - get: stack_repo
      trigger: true
    - put: heat-executor
      params:
        action: create
        environment: stack_repo/env.yaml
        template: stack_repo/stack.yaml
      on_failure:
        put: heat-executor
        params:
          action: delete
- name: TODO Add actions, then
- name: Delete Stack
  plan:
    - get: heat-executor
      passed: [Create Stack]
    - put: heat-executor
      params:
        action: delete
```
# Author

Kourosh VIVAN <kourosh.vivan@gmail.com>
