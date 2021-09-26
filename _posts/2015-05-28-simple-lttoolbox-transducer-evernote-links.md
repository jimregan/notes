---
toc: false
layout: post
hidden: true
description: Old notes
title: Simple lttoolbox transducer
categories: [evernote]
---

```
hexdump /tmp/test2.bin 
0000000 1a 40 61 40 62 40 63 40 64 40 65 40 66 40 67 40
0000010 68 40 69 40 6a 40 6b 40 6c 40 6d 40 6e 40 6f 40
0000020 70 40 71 40 72 40 73 40 74 40 75 40 76 40 77 40
0000030 78 40 79 40 7a 01 01 40 6e 08 01 01 01 40 74 01
0000040 00 40 67 40 67 40 70 40 70 40 63 40 63 40 62 40
0000050 62 40 73 40 73 02 12 40 69 40 6e 40 63 40 6f 40
0000060 40 40 69 40 6e 40 63 40 6f 40 6e 40 64 40 69 40
0000070 74 40 69 40 6f 40 6e 40 61 40 6c 00 01 05 06 01
0000080 05 01 01 06 01 01 07 01 01 01 01 01 02 01 00 0d
0000090 40 6d 40 61 40 69 40 6e 40 40 40 73 40 74 40 61
00000a0 40 6e 40 64 40 61 40 72 40 64 00 01 05 06 01 03
00000b0 01 01 04 01 01 04 01 01 01 01 01 02 01 00     
00000be
```


```
^Z@a@b@c@d@e@f@g@h@i@j@k@l@m@n@o@p@q@r@s@t@u@v@w@x@y@z
^A^A@^A^A^A@t^A^@@g@g@p@p@c@c@b@b@s@s^B^R@i@n@c@o@@@i
@n@c@o@n@d@i@t@i@o@n@a@l^@^A^E^F^A^E^A^A^F^A^A^G^A^A
^A^A^A^B^A^@^M@m@a@i@n@@@s@t@a@n@d@a@r@d^@^A^E^F^A^C
^A^A^D^A^A^D^A^A^A^A^A^B^A^@
```

```
$ lt-print /tmp/test2.bin
0     1     b     b    
1     2     a     a    
2     3     r     r    
3     4     ε     s    
4     5     ε     <n>    
5
--
0     1     f     f    
1     2     o     o    
2     3     o     o    
3     4     ε     s    
4     5     ε     <n>    
5
```

```
^@
^A^E^F^A^E^A^A^F^A^A^G^A^A^A^A^A^B^A
^@
^M
```

`$ cat /tmp/test.dix`

```xml
<dictionary>
  <alphabet>abcdefghijklmnopqrstuvwxyz</alphabet>
  <sdefs>
    <sdef n="n"/>
  </sdefs>
  <pardefs>
    <pardef n="one">
      <e><p><l></l><r>s<s n="n"/></r></p></e>
    </pardef>
  </pardefs>
  <section id="main" type="standard">
    <e><i>foo</i><par n="one"/></e>
  </section>
  <section id="inco" type="inconditional">
    <e><i>bar</i><par n="one"/></e>
  </section>
</dictionary>
```
