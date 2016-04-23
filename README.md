mozconfig-env
=============

This repo contains a small group of shell helpers (implemented for *zsh*, *bash*
and *fish*) to switch a between the set of `MOZCONFIG` files in the `mozconfigs`
dir from this repo, from any `mozilla-central` clones you are working from.

**CAUTION!!! USE AT YOUR OWN RISK**

Usage
-----

From your current zsh (or bash or fish) interactive shell,
enter your `mozilla-central` clone and then activate
the `mozconfig-env/zsh` (or `mozconfig-env/bash` or `mozconfig-env/fish`)
helpers by including it into your current shell session:

```
$ . ~/mozconfig-env/zsh artifact
Installing mozconfig-env helpers...
Activating MOZCONFIG=../mozconfig-env/mozconfigs/artifact
Available mozconfig-env commands:
        - mozconfig-help        prints this help
        - mozconfig-list        prints the available mozconfig environments
        - mozconfig-switch NAME switch into the NAME mozconfig environment
        - mozconfig-deativate   deactive the mozconfig-env helpers from the session

If you want to exit the current MOZCONFIG:
        $ mozconfig-deativate

If you want to switch the current MOZCONFIG:
        $ mozconfig-switch MOZCONFIG_NEW

If you want to exit the shell:
        $ exit
(artifact) $ echo $MOZCONFIG
/home/user/mozconfig-env/mozconfigs/artifact
(artifact) $
```

The first part of the prompt will show the current activated MOZCONFIG profile name,
and 4 `mozconfig-*` new functions are available in the shell session:

- `mozconfig-help`
- `mozconfig-list`
- `mozconfig-switch NAME`
- `mozconfig-deactivate`

### mozconfig-list

To list the available MOZCONFIG profiles:

```
(artifact) $ mozconfig-list
Available MOZCONFIG profiles:
artifact
artifact-android
artifact-debug
build-debug
(artifact) $
```

### mozconfig-switch

To switch to a different MOZCONFIG profile:

```
(artifact) $ mozconfig-switch artifact-android
(artifact-android) $ echo $MOZCONFIG
/home/user/mozconfig-env/mozconfigs/artifact-android
(artifact-android) $
```

### mozconfig-deactivate

To remove the helpers included from `mozconfig-env` from the current session:

```
(artifact-debug) $ mozconfig-deactivate
$ echo $MOZCONFIG

$
```
