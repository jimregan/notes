---
toc: false
layout: post
hidden: true
description: Old notes
title: LuaJ / Scribunto
categories: [evernote]
---

## LuaJ / Scribunto

### LuaJ Field Access / function calls

```java
LuaValue globals = JsePlatform.standardGlobals();
LuaValue sqrt = globals.get("math").get("sqrt");
LuaValue print = globals.get("print");
LuaValue d = sqrt.call(a);
print.call(LuaValue.valueOf("sqrt(5):"), a);
```

### varargs / multiple returns
use `invoke(Varargs)` or `invokemethod(LuaValue, Varargs)`

```java
LuaValue modf = globals.get("math").get("modf");
Varargs r = modf.invoke(d);
print.call(r.arg(1), r.arg(2));
```

### To load / run script: `LoadState`
```java
LoadState.load(new FileInputStream("main.lua"), "main.lua", globals).call();
```

or `require`

```java
globals.get("require").call(LuaValue.valueOf("main"))
```

### preinit tables:

- `listOf(LuaValue[])` - for unnamed elements
- `tableOf (LuaValue[])` - for named
- `tableOf(LuaValue[], LuaValue[], Varargs)` - mixture

### LuaJ - date not implemented

```java
if (format[0] == '!') {
     calendar = Calendar.getInstance(TimeZone.getTimeZone("GMT");
} else {
     calendar = Cak,getInst(TimeZone.getDefault());
}
```

also adjust format


```
DST: TimeZone tz = TimeZone.getDefault();
     bool.isdst = tz.useDaylightTime();

function setTTL ($ttl) {
     $args = func_get_args();
     $this->checkNumber('setTTL', $args, 0);
     $frame = $this->getFrameById('current');
     if (is_callable(array($frame, 'setTTL'))) {
          $frame->setTTL($ttl); // ??
     }
}
```

## Scribunto

### Module: Bananas

```lua
local p = {}
function p.hello(frame)
     return "Hello world"
end
return p
```

other page:

```
{{\#invoke:Bananas\|hello}}
```
