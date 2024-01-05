# Introduction

This is a Mac OS X command to make the system after an integer amount of seconds, minutes or hours.

The command only accepts an **integer** number followed by a unit of time denoted by `s`,`m` and `h`. If **no unit** of time is passed, it will use **second** as the **default** unit.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/mrbing47/slp/main/install.sh | bash
```

## Usage

### Seconds (s)

```bash
$> slp 120s
```

The above command will make the system after 120 seconds or 2 minutes.

### Minutes (m)

```bash
$> slp 90m
```

The above command will make the system after 90 minutes or 1.5 hours.

### Hours (h)

```bash
$> slp 1h
```

The above command will make the system after 60 minutes or 1 hour.
