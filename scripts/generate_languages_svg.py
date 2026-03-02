#!/usr/bin/env python3
"""
Generate docs/languages.svg from tokei JSON output.

Requires:
  - tokei (available in workflow via taiki-e/install-action)
  - Python 3 (preinstalled on GitHub runners)

Usage:
  tokei --output json ... > /tmp/tokei.json
  python3 scripts/generate_languages_svg.py /tmp/tokei.json docs/languages.svg
"""
from __future__ import annotations

import json
import math
import sys
from pathlib import Path
from typing import Dict, Any, List, Tuple


def _load_tokei(path: Path) -> Dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def _extract_languages(data: Dict[str, Any]) -> List[Tuple[str, int]]:
    items: List[Tuple[str, int]] = []
    for k, v in data.items():
        if k.lower() == "total":
            continue
        if isinstance(v, dict) and "code" in v:
            try:
                code = int(v.get("code") or 0)
            except Exception:
                code = 0
            if code > 0:
                items.append((k, code))
    items.sort(key=lambda x: x[1], reverse=True)
    return items


def _fmt_pct(p: float) -> str:
    # Keep it tidy: 0–9.9 => 1dp, else integer
    if p < 10:
        return f"{p:.1f}%"
    return f"{p:.0f}%"


def _escape(s: str) -> str:
    return (
        s.replace("&", "&amp;")
         .replace("<", "&lt;")
         .replace(">", "&gt;")
         .replace('"', "&quot;")
         .replace("'", "&apos;")
    )


def render_svg(
    lang_codes: List[Tuple[str, int]],
    out_path: Path,
    title: str = "Languages (by lines of code)",
    top_n: int = 10,
) -> None:
    top = lang_codes[:top_n]
    total = sum(c for _, c in top)
    if total <= 0:
        # Empty chart (still valid SVG)
        svg = f"""<svg xmlns="http://www.w3.org/2000/svg" width="920" height="140" viewBox="0 0 920 140" role="img" aria-label="{_escape(title)}">
  <rect width="100%" height="100%" fill="#ffffff"/>
  <text x="20" y="44" font-family="system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif" font-size="20" font-weight="700" fill="#111827">{_escape(title)}</text>
  <text x="20" y="84" font-family="system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif" font-size="14" fill="#6b7280">No code detected yet.</text>
</svg>"""
        out_path.write_text(svg, encoding="utf-8")
        return

    # Layout
    width = 920
    pad = 20
    title_h = 44
    row_h = 26
    gap = 10
    bar_x = 280
    bar_w = width - bar_x - pad
    bar_h = 12
    height = pad + title_h + (len(top) * (row_h + gap)) + pad - gap

    # Colors: neutral + one accent (keeps it brand-agnostic)
    text_primary = "#111827"
    text_muted = "#6b7280"
    bar_bg = "#e5e7eb"
    bar_fg = "#2563eb"  # restrained blue (readable on white)
    border = "#e5e7eb"

    lines: List[str] = []
    lines.append(f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-label="{_escape(title)}">')
    lines.append(f'  <rect width="100%" height="100%" fill="#ffffff"/>')
    lines.append(f'  <rect x="0.5" y="0.5" width="{width-1}" height="{height-1}" rx="14" fill="none" stroke="{border}"/>')
    lines.append(f'  <text x="{pad}" y="{pad+24}" font-family="system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif" font-size="20" font-weight="700" fill="{text_primary}">{_escape(title)}</text>')
    lines.append(f'  <text x="{pad}" y="{pad+44}" font-family="system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif" font-size="13" fill="{text_muted}">Top {len(top)} languages • Source: repository code counts</text>')

    y0 = pad + title_h + 10
    for i, (lang, code) in enumerate(top):
        pct = (code / total) * 100.0
        y = y0 + i * (row_h + gap)

        # Bars
        w = max(2.0, (pct / 100.0) * bar_w)

        lines.append(f'  <text x="{pad}" y="{y+12}" font-family="system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif" font-size="14" fill="{text_primary}">{_escape(lang)}</text>')
        lines.append(f'  <rect x="{bar_x}" y="{y+2}" width="{bar_w}" height="{bar_h}" rx="6" fill="{bar_bg}"/>')
        lines.append(f'  <rect x="{bar_x}" y="{y+2}" width="{w:.2f}" height="{bar_h}" rx="6" fill="{bar_fg}"/>')
        lines.append(f'  <text x="{bar_x+bar_w}" y="{y+12}" text-anchor="end" font-family="system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif" font-size="13" fill="{text_muted}">{_fmt_pct(pct)}</text>')

    lines.append("</svg>")
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: generate_languages_svg.py <tokei.json> <out.svg>", file=sys.stderr)
        return 2

    inp = Path(sys.argv[1]).resolve()
    out = Path(sys.argv[2]).resolve()

    data = _load_tokei(inp)
    lang_codes = _extract_languages(data)
    render_svg(lang_codes, out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
