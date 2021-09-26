---
toc: false
layout: post
hidden: true
description: Old notes
title: Evernote, 21/12/2014
categories: [evernote, phash]
---

## phash.cc

```c++
 #include <iostream> 
#include <string>
#include <pHash.h>

int main (int argc, char** argv)
{
     ulong64 hash = 0;
     string name;
     while(std::getline(std::cin, name))
     {
          ph_dct_imagehash(name.c_str(), hash);
          std::cout << "<http://" << name << "> ";
          std::cout << "<http://imgmeta.sourceforge.net/0.1/props#pHash>";
          std::cout << " \"" << hash << "\" ." << endl;
          hash = 0;
     }
     return 0;
}
```
