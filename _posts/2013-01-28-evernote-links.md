---
toc: false
layout: post
hidden: true
description: Old links
title: Evernote web clips, 28/1/2013
categories: [evernote, web clip]
---

```
mysql> SELECT COUNT(DISTINCT p.product_id) AS total FROM oc_product p LEFT 
JOIN oc_product_description pd ON (p.product_id = pd.product_id) LEFT JOIN 
oc_product_to_store p2s ON (p.product_id = p2s.product_id) LEFT JOIN 
oc_product_to_category p2c ON (p.product_id = p2c.product_id) WHERE 
pd.language_id = '1' AND p.status = '1' AND p.date_available <= NOW() 
AND p2s.store_id = '0' AND (p2c.category_id = '2101'); 
+-------+
| total |
+-------+
|    19 |
+-------+
1 row in set (15.58 sec)
```

[Keynote DTD](http://web.archive.org/web/20040203003742/http://developer.apple.com/technotes/tn2002/tn2067.html)

[keynote-apxl.html](http://web.archive.org/web/20140715191015/https://developer.apple.com/appleapplications/keynote-apxl.html)
