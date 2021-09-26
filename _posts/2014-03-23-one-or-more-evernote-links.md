---
toc: false
layout: post
hidden: true
description: No idea what the note was for
title: lttoolbox oneOrMore
categories: [evernote, lttoolbox]
---

## oneOrMore

This is code from [lttoolbox](https://github.com/apertium/lttoolbox), licence [GPL 2](https://github.com/apertium/lttoolbox/blob/master/COPYING)

```c++
 void 
Transducer::oneOrMore(int const epsilon_tag)
{
  joinFinals(epsilon_tag);
  int state = newState();
  linkStates(state, initial, epsilon_tag);
  initial = state;

  state = newState();
  linkStates(*finals.begin(), state, epsilon_tag);
  finals.clear();
  finals.insert(state);
  linkStates(state, initial, epsilon_tag);
}

void 
Transducer::joinFinals(int const epsilon_tag)
{
  if(finals.size() > 1)
  {
    int state = newState();

    for(set<int>::iterator it = finals.begin(), limit = finals.end();
        it != limit; it++)
    {
      linkStates(*it, state, epsilon_tag);
    }

    finals.clear();
    finals.insert(state);
  }
  else if(finals.size() == 0)
  {
    wcerr << L"Error: empty set of final states" <<endl;
    exit(EXIT_FAILURE);
  }
}

void 
Transducer::linkStates(int const source, int const destino,
                   int const etiqueta)
{

  if(transitions.find(source) != transitions.end() &&
     transitions.find(destino) != transitions.end())
  {
    // new code
    pair<multimap<int, int>::iterator, multimap<int, int>::iterator> range;
    range = transitions[source].equal_range(etiqueta);
    for(;range.first != range.second; range.first++)
    {
      if(range.first->first == etiqueta && range.first->second == destino)
      {
        return;
      }
    }
    // end of new code
    transitions[source].insert(pair<int, int>(etiqueta, destino));
  }
  else
  {
    wcerr << L"Error: Trying to link nonexistent states (" << source;
    wcerr << L", " << destino << L", " << etiqueta << L")" << endl;
    exit(EXIT_FAILURE);
  }
}
```


