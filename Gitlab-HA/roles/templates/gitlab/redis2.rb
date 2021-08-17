gitlab_rails['object_store']['enabled'] = false
gitlab_rails['object_store']['connection'] = {}
gitlab_rails['object_store']['proxy_download'] = false
gitlab_rails['object_store']['objects']['artifacts']['bucket'] = nil
gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = nil
gitlab_rails['object_store']['objects']['lfs']['bucket'] = nil
gitlab_rails['object_store']['objects']['uploads']['bucket'] = nil
gitlab_rails['object_store']['objects']['packages']['bucket'] = nil
gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = nil
gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = nil

gitlab_rails['auto_migrate'] =  false

registry_external_url 'https://registry.example.com'



redis['enable'] = true
bootstrap['enable'] = false
nginx['enable'] = false
unicorn['enable'] = false
sidekiq['enable'] = false
postgresql['enable'] = true
gitlab_workhorse['enable'] = false
mailroom['enable'] = false

# Redis configuration
redis['port'] = 6379
redis['bind'] = '0.0.0.0'

# If you wish to use Redis authentication (recommended)
redis['password'] = 'P@ssw0rd'

## Slave redis instance
redis['master_ip'] = '192.168.100.111' # IP of master Redis server
redis['master_port'] = 6379 # Port of master Redis server
redis['master_password'] = "P@ssw0rd"
