---
layout: page
title: keys
permalink: /keys
---

below are my public keys for both [gpg](#gpg) and [ssh](#ssh).

## gpg

```
curl https://joel.tokyo/keys/gpg.asc | gpg --import
```

```
{% include_relative gpg.asc %}
```

## ssh

```
curl https://joel.tokyo/keys/id_rsa.pub >> ~/.ssh/authorized_keys
```

```
{% include_relative id_rsa.pub %}
```
