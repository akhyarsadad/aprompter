"""Builds the night owly website into an output folder.

    pip install markdown==3.7
    python site/build.py _site [--url https://example.com/base]

Copies site/ as is, then renders the app's legal pages from the repository's
Markdown (docs/PRIVACY.md, docs/TERMS.md), so the website always shows the
same text the app links to and there is one copy to edit.

--url is the address the site is served from (GitHub Pages gives it). It
fills {{SITE_URL}} in pages that need absolute links: share previews and the
404 page, which is served at whatever address was asked for.
"""

import html
import re
import shutil
import sys
from pathlib import Path

import markdown

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / "site"
REPO = "https://github.com/akhyarsadad/aprompter"

# Rendered pages: (Markdown source, output folder, page title, nav key)
PAGES = [
    ("docs/PRIVACY.md", "aprompter/privacy", "APrompter Privacy Policy", "privacy"),
    ("docs/TERMS.md", "aprompter/terms", "APrompter Terms of Use", "terms"),
]

# Links between the Markdown files become links between the pages.
LINKS = {"PRIVACY.md": "../privacy/", "TERMS.md": "../terms/"}

BARE_URL = re.compile(r"(?<![<(\"'=])\b(https?://[^\s<>()]+[^\s<>().,;:!?])")
BARE_EMAIL = re.compile(r"(?<![<\w.@/])([\w.+-]+@[\w-]+(?:\.[\w-]+)+)(?![\w>])")

TEMPLATE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>{title}</title>
<meta name="description" content="{description}">
<meta name="theme-color" content="#f5f4fb" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#0e1126" media="(prefers-color-scheme: dark)">
<link rel="icon" href="../img/icon-64.png" type="image/png">
<link rel="apple-touch-icon" href="../img/icon-180.png">
<link rel="stylesheet" href="../../assets/site.css">
</head>
<body>
<a class="skip" href="#main">Skip to content</a>

<header class="site-header">
  <div class="wrap">
    <a class="brand" href="../">
      <img src="../img/icon-256.webp" alt="" width="34" height="34">
      APrompter
    </a>
    <nav class="nav" aria-label="APrompter">
      <a href="../">Overview</a>
      <a href="../support/">Support</a>
      <a href="../privacy/"{privacy_current}>Privacy</a>
      <a href="../terms/"{terms_current}>Terms</a>
    </nav>
  </div>
</header>

<main id="main" class="doc">
  <div class="wrap">
    <article>
{body}
      <p class="source-note">This page shows <a href="{source_url}">{source}</a> from the APrompter
      repository, where every change to it is recorded.</p>
    </article>
  </div>
</main>

<footer class="site-footer">
  <div class="wrap">
    <span>APrompter by <a href="../../">night owly</a></span>
    <nav aria-label="Footer">
      <a href="../privacy/">Privacy policy</a>
      <a href="../terms/">Terms of use</a>
      <a href="../support/">Support</a>
    </nav>
  </div>
</footer>
</body>
</html>
"""


def link_bare_addresses(text: str) -> str:
    """Turns bare URLs and email addresses into Markdown autolinks, leaving
    ones that are already inside a link alone."""
    out = []
    for line in text.splitlines(keepends=True):
        line = BARE_URL.sub(r"<\1>", line)
        line = BARE_EMAIL.sub(r"<\1>", line)
        out.append(line)
    return "".join(out)


def render(source: str, title: str, nav: str) -> str:
    text = (ROOT / source).read_text(encoding="utf-8")
    text = link_bare_addresses(text)
    body = markdown.markdown(
        text,
        extensions=["tables", "toc", "sane_lists"],
        extension_configs={"toc": {"permalink": False}},
        output_format="html",
    )
    for name, href in LINKS.items():
        body = body.replace(f'href="{name}"', f'href="{href}"')
    # Wide tables scroll inside their own box on phones.
    body = body.replace("<table>", '<div class="table-scroll"><table>')
    body = body.replace("</table>", "</table></div>")
    plain = re.sub(r"<[^>]+>", " ", body)
    first = re.search(r"Short version:(.*?)(?:\.|$)", plain, re.S) or re.search(
        r"These terms (.*?)\.", plain, re.S
    )
    description = " ".join((first.group(0) if first else title).split())[:155]
    return TEMPLATE.format(
        title=html.escape(title),
        description=html.escape(description, quote=True),
        body=body,
        source=html.escape(source),
        source_url=f"{REPO}/blob/main/{source}",
        privacy_current=' aria-current="page"' if nav == "privacy" else "",
        terms_current=' aria-current="page"' if nav == "terms" else "",
    )


def main() -> None:
    args = sys.argv[1:]
    site_url = ""
    if "--url" in args:
        i = args.index("--url")
        site_url = args[i + 1].rstrip("/")
        del args[i : i + 2]
    if len(args) != 1:
        sys.exit("usage: python site/build.py OUTPUT_DIR [--url SITE_URL]")
    out = Path(args[0]).resolve()
    if out == SITE or SITE in out.parents:
        sys.exit("pick an output folder outside site/")
    if out.exists():
        shutil.rmtree(out)
    shutil.copytree(SITE, out, ignore=shutil.ignore_patterns("build.py", "__pycache__"))
    for source, folder, title, nav in PAGES:
        page = out / folder / "index.html"
        page.parent.mkdir(parents=True, exist_ok=True)
        page.write_text(render(source, title, nav), encoding="utf-8")
    for page in out.rglob("*.html"):
        text = page.read_text(encoding="utf-8")
        if "{{SITE_URL}}" in text:
            page.write_text(text.replace("{{SITE_URL}}", site_url), encoding="utf-8")
    # GitHub Pages: serve files as they are (no Jekyll processing).
    (out / ".nojekyll").write_text("")
    print(f"Built {out}")


if __name__ == "__main__":
    main()
