---
output: authorized_keys.tmpl
---

One cool feature of Chezmoi is that we can automatically import keys from Github.

You can view any users by adding `.keys` on their profile so in my case, you can view my public SSH keys at [https://github.com/marcus-crane.keys](https://github.com/marcus-crane.keys).

```bash
{{ range (gitHubKeys .social.github) -}}
{{ .Key }}
{{ end -}}
```
