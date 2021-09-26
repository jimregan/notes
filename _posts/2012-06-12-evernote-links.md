---
toc: false
layout: post
hidden: true
description: Old links
title: Evernote web clips, 12/6/2012
categories: [evernote, web clip, rpg, tesseract]
---

[Tesseract iterator](https://stackoverflow.com/a/8990396)

```c++
tess.SetImage(...); 
tess.Recognize(0); 

tesseract::ResultIterator* ri = tess.GetIterator();
tesseract::ChoiceIterator* ci; 

if(ri != 0)
{
    do
    {
        const char* symbol = ri->GetUTF8Text(tesseract::RIL_SYMBOL);

        if(symbol != 0)
        {
            float conf = ri->Confidence(tesseract::RIL_SYMBOL); 
            std::cout << "\tnext symbol: " << symbol << "\tconf: " << conf << "\n"; 

            const tesseract::ResultIterator itr = *ri; 
            ci = new tesseract::ChoiceIterator(itr);

            do
            {
                const char* choice = ci->GetUTF8Text(); 
                std::cout << "\t\t" << choice << " conf: " << ci->Confidence() << "\n"; 
            }
            while(ci->Next()); 

            delete ci; 
        }

        delete[] symbol;
    }
    while((ri->Next(tesseract::RIL_SYMBOL)));
}
```

[System/36-Compatible RPG II User’s Guide and Reference](http://elsas.com.tr/edu_docs/c0918180.pdf)

