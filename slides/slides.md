---
title: Infrastructure tests for lazy people
pdf: infrastructure-tests.pdf
standalone: infrastructure-tests.html
transition: slide
backgroundTransition: fade
slideNumber: true
controls: false
controlsTutorial: false
asciinema: true
---

# Infrastructure tests for lazy people {bgcss=sky-gradient-10}

```render_dot
digraph G {
    bgcolor=transparent;
    node [style="filled,solid",fillcolor=white,color=black,fontname="EB Garamond 12"];
    "RSpec tests";
    "pen tests";
    "vulnerability scans";
    "monitoring";
}
```

```render_dot
digraph H {
    bgcolor=transparent;
    node [style="filled,solid",fillcolor=white,color=black,fontname="EB Garamond 12"];
    "chaos engineering";
    "load tests";
}
```

```render_dot
digraph I {
    bgcolor=transparent;
    node [style="filled,solid",fillcolor=white,color=black,fontname="EB Garamond 12"];
    "  ";
}
```

# Let someone else do the testing {bgcss=sky-gradient-11}

```{.render_ditaa args="--transparent --scale 2 --font 'EB Garamond 12'"}
/=-----------------------------------------------------------\
:                                                            :
|  +--------------------+           +---------------------+  |         +-----------------+
|  |                    |           |                     |  |         |                 |
|  | CronJob            |           | Pod                 |  |         | etcd            |
|  |                    +---------->+     /-------\ /---\ +<---------->+ {s}             |
|  |             Nightly|           |     |shunit2| |oc | |  :         |                 |
|  |                    |       +-->+     \-------/ \---/ |  |         |                 |
|  +--------------------+       |   +----------+----------+  |         +-----------------+
|                               |              ^             | 
|                               |              |             | 
|                               |   +----------+----------+  |         +-----------------+
|                               |   |                     |  |         |                 |
|                               |   | ServiceAccount      |  |         | ClusterRole     |
|                               |   |                     +<-----------+                 |
|                               |   |                     |  :         |   cluster–reader|
|                               |   |                     |  |         |                 |
|                               |   +---------------------+  |         +-----------------+
|                               |                            | 
|                               |                            | 
|                               |   +---------------------+  |         +-----------------+
|                               |   |                     |  |         |                 |
|                               |   | ConfigMap           |  |         | Git             |
|                               +---+                     +<-----------+                 |
|                                   |                     |  |         |     Test scripts|
|                                   |                     |  |         | {d}             |
|                                   +---------------------+  |         +-----------------+
|Namespace cluster–tests                                     |  
\=-----------------------------------------------------------/
```

# Let someone else write the brief {bgcss=sky-gradient-12}

```{.render_ditaa args="--transparent --scale 2 --font 'EB Garamond 12'"}
/=----------------------------------------------------------------\
|Somebody else’s problem                                          |
|    +---------------+   +---------------+   +---------------+    |
|    |Ops handbook   |   |Dev guidelines |   |Architecture   |    |
|    |               |   |               |   |               |    |
|    |               |   |               |   |               |    |
|    |{d}            |   |{d}            |   |{d}            |    |
|    |               |   |               |   |               |    |
|    +-------+-------+   +-------+-------+   +-------+-------+    |
|            |                   |                   |            |
\=-----------|=------------------|=------------------|------------/
             |                   |                   |
             \-------------------+-------------------/
                                 |
                                 v
                           +-----+-----+
                           |           |
                           |Test cases |
                           |{s}        |
                           |           |
                           +-----------+
```

# Get someone else to write the tests {bgcss=sky-gradient-13 .light-on-dark}

```render_vegalite
{
  "$schema": "https://vega.github.io/schema/vega-lite/v2.0.json",
  "width": 500,
  "height": 250,
  "data": {
    "values": [
      {"percentage": 71.5, "language": "JavaScript"},
      {"percentage": 54.4, "language": "Java"},
      {"percentage": 40.4, "language": "Bash/Shell"},
      {"percentage": 37.9, "language": "Python"},
      {"percentage": 10.3, "language": "Ruby"},
      {"percentage": 7.2, "language": "Go"},
      {"percentage": 4.3, "language": "Groovy"},
      {"percentage": 4.2, "language": "Perl"}
    ]
  },
  "mark": "bar",
  "encoding": {
    "x": {
      "field": "percentage",
      "type": "quantitative",
      "axis": { "title": "Developers (%)" },
      "legend": false
    },
    "y": {
      "field": "language",
      "type": "nominal",
      "axis": {
        "title": "Language",
        "offset": 5,
        "ticks": false,
        "minExtent": 60,
        "domain": false,
        "legend": false
      },
      "sort": {"op": "mean", "field": "percentage"}
    },
    "color": {
      "field": "percentage",
      "type": "quantitative",
      "legend": false,
      "scale": {
        "range": ["#c30d24", "#f3a583", "#cccccc", "#94c6da", "#1770ab"],
        "type": "ordinal"
      }
    }
  },
  "config": {
    "axis": {
      "labelFont": "EB Garamond",
      "legendFont": "EB Garamond",
      "labelFontSize": 18,
      "titleFont": "EB Garamond",
      "titleFontSize": 24,
      "titleAngle": 0,
      "labelColor": "white",
      "titleColor": "white"
    },
    "axisX": {
        "labelAngle": 0
    }
  }
}
```
<small>Source: "Programming, scripting and markup languages", [Stack Overflow survey 2018](https://insights.stackoverflow.com/survey/2018/)</small>

# Operations {bgcss=sky-gradient-14 .light-on-dark}
```bash
test_self_provisioner() {
  count_self_provisioner=`oc adm policy who-can create projectrequests \
    2>/dev/null | grep -c system:authenticated`
  assertEquals " non-admin users must not create project requests;" \
    0 ${count_self_provisioner}
}
suite_addTest test_self_provisioner
```
# Development {bgcss=sky-gradient-15 .light-on-dark}

```bash
test_anyuid() {
  scc_anyuid=`oc describe scc anyuid 2>/dev/null`
  for project in ${USER_PROJECTS}; do
    count_anyuid_default=`echo ${scc_anyuid} | \
      grep -c "Users:.*system:serviceaccount:${project}:default"`
    assertEquals \
      " service account default in project ${project} has SCC anyuid;" \
      0 ${count_anyuid_default}
  done
}
suite_addTest test_anyuid
```

# Architecture {bgcss=sky-gradient-16 .light-on-dark}

```bash
test_high_availability() {
  for svc in ${HA_SERVICES}; do
    nodes=`oc get po --all-namespaces -o wide | grep ${svc} | \
      awk '{ print $8 }'`
    zones=""
    for node in ${nodes}; do
      zones="${zones} `oc get node/${node} -L zone | \
        awk '{print $6}' | tail -n +2`"
    done
    zone_count=`echo ${zones} | tr ' ' '\n' | sort -u | wc -l`
    ha=$((zone_count > 2))
    assertTrue " ${svc} must be distributed across 3 zones;" ${ha}
  done
}
suite_addTest test_high_availability
```

# Let others build the infrastructure for you {bgcss=sky-gradient-17 .light-on-dark}

```{.render_ditaa args="--transparent --scale 2 --font 'EB Garamond 12'"}
                           :
+-----------------------+  |  +------------------+    +---------------------+
|Initial project setup  |  |  |CronJob           |    |Pod                  |
|                       |  |  |                  |    | /-----------------\ |
|                “make” |  |  |                  |    | |SCC restricted   | |
|                       +---->+                  +--->+ \-----------------/ |
|  /------------------\ |  :  | /--------------\ |    | /-----------------\ |
|  |cluster–admin     | |  |  | |cluster–reader| |    | |SC non–privileged| |
|  \------------------/ |  |  | \--------------/ |    | \-----------------/ |
+-----------------------+  |  +------------------+    +----------+----------+
                           |                                     |
                           |                        /=-----------|------------\
                           |                        |            v            |
                           |                        |     /------+--------\   |
                           |                        |     |Central logging|   |
                           |                        |     |{s}            |   |
                           |                        |     |               |   |
                           |                        |     \------+--------/   |
                           |                        |            ^            |
                           |                        |            |            |
                           |                        |            |            |
                           |                        |     /------+--------\   |
                           |                        |     |Dashboard      |   |
                           |                        |     |               |   |
                           |                        |     |               |   |
                           |                        |     \---------------/   |
                           |                        |Somebody else’s problem  |
              trigger once |scheduler runs daily    \=------------------------/
```

# What's left? {bgcss=sky-gradient-18 .light-on-dark}

<asciinema-player src="./assets/img/openshift-unit.json" poster="npt:0:05" idle-time-limit=1 speed=2 rows=18 font-size="medium"></asciinema-player>

# Why do today what can be done tomorrow? {bgcss=sky-gradient-23 .light-on-dark}

Do use tests to define the desired cluster state

Don't fret if it takes longer than expected to reach it

Do take pride in the work not done

# Unwind on GitHub {bgcss=sky-gradient-03 .light-on-dark}

<small>OpenShift cluster tests [gerald1248/openshift-unit](https://github.com/gerald1248/openshift-unit)</small>

<small>OpenShift project backup [gerald1248/openshift-backup](https://github.com/gerald1248/openshift-backup)</small>

<small>Slides courtesy of markdeck by @arnehilmann [arnehilmann/markdeck](https://github.com/arnehilmann/markdeck)</small>

<img width="100" src="assets/img/codecentric-logo-only.png" alt="codecentric AG"/>

