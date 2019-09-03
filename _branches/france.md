---
name: France
lang: fr
links:
  diaspora: 'https://framasphere.org/u/xrfrance'
  facebook: 'https://facebook.com/xrfrance'
  instagram: 'https://www.instagram.com/extinctionrebellionfrance'
  mastodon: 'https://social.rebellion.global/@xrfrance'
  peertube: 'https://tube.extinctionrebellion.fr'
  twitter: 'https://twitter.com/XtinctionRebel'
  website: 'https://ExtinctionRebellion.fr'
  youtube: 'https://www.youtube.com/channel/UCSJFmDCxyjkxVsZNJUymZWQ'
location: '{"type":"Point","coordinates":[2.213749,46.227638]}'
country: France
---
{% atom_read url='https://tube.extinctionrebellion.fr/feeds/videos.json?sort=-publishedAt&videoChannelId=2' limit='6' title="Vidéos" template="atom-reader-peertube.html" %}

{% atom_read url='https://social.rebellion.global/users/xrfrance.atom' limit='15' title="@xfrance" body='content' template="atom-reader-mastodon.html" %}
