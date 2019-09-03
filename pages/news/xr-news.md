---
layout: page
title: XR News
permalink: /news/xr-news/
backgroud: "bg-light-gray"
header-class: "bg-black text-light-gray"
---

{% atom_read url='https://social.rebellion.global/users/news_en.atom' limit='30' body='content' title="0" template="atom-reader-mastodon.html" %}
