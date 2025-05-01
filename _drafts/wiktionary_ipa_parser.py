import re
import json
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor

grammar = Grammar(
    r"""
    line          = (template ws?)+
    template      = area / qualifier / ipa / ref
    area          = "{{a|" dialects "}}"
    dialects      = dialect ("|" dialect)*
    dialect       = ~r"[^|}]+"
    ipa           = "{{IPA|ga|" ipa_variants "}}" ws?
    ipa_variants  = ipa_value ("|" ipa_value)* (qualifiers)?
    ipa_value     = ipa_text / keyval
    ipa_text      = ~r"/[^/]+/"
    keyval        = ~r"(qual\d+=.+|ref\d+=.+)"
    qualifiers    = ("|qual1=" text)? ("|qual2=" text)? ("|qual3=" text)?
    qualifier     = "{{qualifier|" text "}}" / "{{q|" text "}}"
    ref           = "<ref>" ref_content "</ref>"
    ref_content   = ~r"[^<]+"
    text          = ~r"[^|}}]+"
    ws            = ~r"\\s+"
    """
)

def simplify_templates_in_text(text):
    def replacer(match):
        parts = match.group(1).split("|")
        if parts[0] == "m" and len(parts) >= 3:
            return parts[2]
        elif parts[0].startswith("R:") and len(parts) >= 2:
            return f"{parts[0]} p. {parts[1]}"
        return match.group(0)
    return re.sub(r"{{(.*?)}}", replacer, text)

def parse_reference_template(text):
    text = text.strip()
    m = re.match(r"{{\s*(R:[^|}}]+)\|([^|}}]+)\|([^|}}]+)\s*}}", text)
    if m:
        return {
            "type": "reference_template",
            "source": m.group(1),
            "book": m.group(2),
            "page": m.group(3)
        }
    m = re.match(r"{{\s*(R:[^|}}]+)\|([^|}}]+)\s*}}", text)
    if m:
        return {
            "type": "reference_template",
            "source": m.group(1),
            "page": m.group(2)
        }
    return None

class IPAVisitor(NodeVisitor):
    def visit_line(self, node, visited_children):
        flat = [item for sublist in visited_children for item in sublist if item]
        result = []
        i = 0
        while i < len(flat):
            if flat[i]["type"] == "qualifier":
                if i + 1 < len(flat) and flat[i+1]["type"] == "ipa":
                    ipa_entry = flat[i+1]
                    ipa_entry.setdefault("context_qualifier", []).append(flat[i]["value"])
                    result.append(ipa_entry)
                    i += 2
                    continue
                else:
                    result.append(flat[i])
            else:
                result.append(flat[i])
            i += 1

        for entry in result:
            if entry.get("type") == "ipa" and isinstance(entry.get("note", ""), str):
                m = re.search(r"spelling {{m\\|ga\\|(?:\\|)?([a-záéíóúḃċḋḟġṁṗṡṫ]+)}}", entry["note"])
                if m:
                    entry["spelled_as"] = m.group(1)
                    del entry["note"]
        return result

    def visit_template(self, node, visited_children):
        return visited_children[0]

    def visit_area(self, node, visited_children):
        _, dialect_info, _ = visited_children
        all_values = dialect_info
        dialects = []
        notes = []
        for val in all_values:
            if re.match(r"[A-Z][a-z]+$", val):
                dialects.append(val)
            else:
                notes.append(val)
        area = {"type": "area"}
        if dialects:
            area["dialects"] = dialects
        if notes:
            area["note"] = " ".join(notes)
        return area

    def visit_dialects(self, node, visited_children):
        first, rest = visited_children
        return [first] + [r[1] for r in rest]

    def visit_dialect(self, node, _):
        return node.text.strip()

    def visit_ipa(self, node, visited_children):
        _, _, ipa_info, *_ = visited_children
        entry = {"type": "ipa", "variants": ipa_info["variants"]}
        return entry

    def visit_ipa_variants(self, node, visited_children):
        variant_nodes = [visited_children[0]] + [v[1] for v in visited_children[1]]
        extra_fields = visited_children[2]

        variants = []
        qualifier_map = {}
        ref_map = {}

        for i, val in enumerate(variant_nodes):
            if isinstance(val, str) and val.startswith("qual"):
                m = re.match(r"qual(\\d+)=\\s*(.+)", val)
                if m:
                    qualifier_map[int(m.group(1)) - 1] = simplify_templates_in_text(m.group(2))
            elif isinstance(val, str) and val.startswith("ref"):
                m = re.match(r"ref(\\d+)=\\s*(.+)", val)
                if m:
                    parsed_ref = parse_reference_template(m.group(2))
                    if parsed_ref:
                        ref_map[int(m.group(1)) - 1] = [parsed_ref]
            else:
                variants.append({"ipa": val.strip("/")})

        for i, var in enumerate(variants):
            if i in qualifier_map:
                var["qualifier"] = qualifier_map[i]
            if i in ref_map:
                var["refs"] = ref_map[i]

        return {
            "variants": variants
        }

    def visit_ipa_text(self, node, _):
        return node.text

    def visit_keyval(self, node, _):
        return node.text

    def visit_qualifier(self, node, visited_children):
        _, text, _ = visited_children
        return {"type": "qualifier", "value": simplify_templates_in_text(text)}

    def visit_ref(self, node, visited_children):
        return visited_children[1]

    def visit_ref_content(self, node, visited_children):
        text = node.text.strip()
        ref_template = parse_reference_template(text)
        if ref_template:
            return ref_template
        return {"raw": text}

    def visit_text(self, node, _):
        return node.text.strip()

    def visit_ws(self, node, _):
        return None

    def generic_visit(self, node, visited_children):
        return visited_children or node

def parse_ipa_block(text: str) -> str:
    tree = grammar.parse(text)
    result = IPAVisitor().visit(tree)
    return json.dumps(result, indent=2, ensure_ascii=False)