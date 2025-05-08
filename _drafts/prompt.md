Got it. The grammar must explicitly handle **`&lt;` and `&gt;` as standalone tokens**, treating them as literal characters within the grammar itself.

Here’s a more precise prompt:

---

### ✅ **Precise Prompt for Parsing Wikitext with Specific HTML Entities:**

**Objective:**
Develop a grammar to parse Wikitext that accurately handles structured templates (`{{...}}`), nested parameters, and the specific HTML entities `&lt;` and `&gt;`, **without normalizing or interpreting them**. This grammar must:

1. **Treat `&lt;` and `&gt;` as standalone tokens**, not as HTML tags or structural markers.
2. **Preserve Wikitext structure**, treating `{{...}}` as nestable templates.
3. **Support Nested Templates:** Allow templates within templates, maintaining parameter context.
4. **Handle Qualifiers and Named Parameters:**

   * Recognize `qual1=`, `qual2=`, etc.
   * Support `ref1=`, `ref2=`, and `ref=`.

---

**Input Examples:**

```plaintext
{{IPA|ga|/n̪ˠõːsˠ/|ref={{R:ga:Quiggin|17}}}}
{{a|Munster|Aran}} {{IPA|ga|/kɑt̪ˠ/}}
{{IPA|ga|/bʲɪɟ/}}&lt;ref&gt;{{R:ga:Quiggin|43}}&lt;/ref&gt;&lt;ref&gt;{{R:ga:SjPh|30}}&lt;/ref&gt;
{{a|Ulster}} {{IPA|ga|/kɾˠʌpˠ/}}&lt;ref&gt;{{R:ga:Quiggin|26}}&lt;/ref&gt; {{q|corresponding to the alternative form {{m|ga|crup}}}}
{{IPA|ga|/ɛɾʲ/|/əɾʲ/|qual1=stressed|qual2=unstressed}}
{{qualifier|before ''a'', ''o'', ''u'', ''fha'', ''fho'', ''fhu''}} {{IPA|ga|[xan̪ˠ]}}
```

---

**Expected Output Structure:**

* Templates are treated as structured objects with `name` and `args`.
* `&lt;` and `&gt;` are preserved as literal text tokens.

**Output Example:**

```json
{
  "templates": [
    {
      "name": "IPA",
      "args": ["ga", "/n̪ˠõːsˠ/", {
        "name": "ref",
        "args": [
          {
            "name": "R:ga:Quiggin",
            "args": ["17"]
          }
        ]
      }]
    },
    {
      "name": "a",
      "args": ["Munster", "Aran"]
    },
    {
      "name": "IPA",
      "args": ["ga", "/bʲɪɟ/"]
    }
  ],
  "text": [
    "&lt;ref&gt;",
    {
      "name": "R:ga:Quiggin",
      "args": ["43"]
    },
    "&lt;/ref&gt;",
    "&lt;ref&gt;",
    {
      "name": "R:ga:SjPh",
      "args": ["30"]
    },
    "&lt;/ref&gt;"
  ]
}
```

---

**Grammar Construction Requirements:**

* **Entity Tokens:** Define `&lt;` and `&gt;` as specific tokens, separate from text.
* **Template Structure:** Recognize `{{...}}` as a structured, nestable entity.
* **Parameter Handling:** Allow named and positional parameters within templates.
* **Context-Sensitive Parsing:** Handle nested templates and parameters, maintaining positional context.

---

**Deliverables:**

* Full grammar definition using `Parsimonious`, `Lark`, or another context-sensitive parser.
* Parsing implementation that outputs the expected structure without interpreting entities.
* Test cases based on the provided examples to validate parsing accuracy.

---

Would you like further refinement, or is this ready for submission?

