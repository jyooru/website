---
layout: page
title: keys
permalink: /keys
---

below are my public keys for both [gpg](#gpg) and [ssh](#ssh).

## gpg

```
curl https://joel.tokyo/keys/gpg | gpg --import
```

```
{% include_relative gpg %}
```

## ssh

```
curl https://joel.tokyo/keys/ssh >> ~/.ssh/authorized_keys
```

```
{% include_relative ssh %}
```
