#!/usr/bin/env bash
# =============================================================================
# configure-component.sh — turn a copy of component-template into a component.
#
# Usage:   ./configure-component.sh <PascalName> [package-slug] "<description>"
#   <PascalName>    PSR-4 segment, e.g. RateLimiter → Waffle\Commons\RateLimiter
#   [package-slug]  lowercase Composer/repo name; defaults to the kebab-case of
#                   <PascalName> (RateLimiter → rate-limiter). Pass it when the
#                   repository name differs, e.g. `OpenApi openapi`.
#   <description>   one sentence for composer.json and the README (it is what
#                   Packagist shows). No double quotes or backslashes.
#
# Placeholders: {COMPONENT_NAME} (PascalCase), {COMPONENT_SLUG} (package name),
# {COMPONENT_DESCRIPTION}. The script also installs README.component.md as the
# README, drops the template-only images/, and deletes itself on success.
# =============================================================================
set -euo pipefail

if [ $# -lt 2 ]; then
  cat >&2 <<'USAGE'
Usage: ./configure-component.sh <PascalName> [package-slug] "<description>"
  e.g. ./configure-component.sh RateLimiter "Token-bucket rate limiting for the Waffle framework."
       ./configure-component.sh OpenApi openapi "OpenAPI 3.1 generation for the Waffle framework."
USAGE
  exit 1
fi

NAME="$1"
if [ $# -ge 3 ]; then
  SLUG="$2"
  DESCRIPTION="$3"
else
  SLUG="$(printf '%s' "$NAME" | sed -E 's/([a-z0-9])([A-Z])/\1-\2/g; s/([A-Z]+)([A-Z][a-z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')"
  DESCRIPTION="$2"
fi

[[ "$NAME" =~ ^[A-Z][A-Za-z0-9]*$ ]] || { echo "✗ <PascalName> must be PascalCase alphanumerics (got '$NAME')" >&2; exit 1; }
[[ "$SLUG" =~ ^[a-z0-9]([_.-]?[a-z0-9]+)*$ ]] || { echo "✗ package slug '$SLUG' is not a valid Composer name" >&2; exit 1; }
[ -n "$DESCRIPTION" ] || { echo "✗ the description must not be empty" >&2; exit 1; }
case "$DESCRIPTION" in
  *'"'* | *'\'* | *'{'* ) echo "✗ the description must not contain double quotes, backslashes or braces" >&2; exit 1 ;;
esac

cd "$(dirname -- "$0")"
SELF="$(basename -- "$0")"

echo "Configuring waffle-commons/$SLUG (Waffle\\Commons\\$NAME)…"

# 1. Component README replaces the template's how-to README.
if [ -f README.component.md ]; then
  mv README.component.md README.md
fi

# 2. Replace placeholders in text files (never .git, vendor, graphify or images).
export CC_NAME="$NAME" CC_SLUG="$SLUG" CC_DESC="$DESCRIPTION"
find . -type f \
  -not -path './.git/*' -not -path './vendor/*' -not -path './graphify-out/*' -not -path './images/*' \
  -not -name "$SELF" -print0 \
  | xargs -0 perl -pi -e 's/\{COMPONENT_SLUG\}/$ENV{CC_SLUG}/g; s/\{COMPONENT_DESCRIPTION\}/$ENV{CC_DESC}/g; s/\{COMPONENT_NAME\}/$ENV{CC_NAME}/g'

# 3. Rename files or directories that carry a placeholder in their name.
find . -depth \( -name '*{COMPONENT_NAME}*' -o -name '*{COMPONENT_SLUG}*' \) -not -path './.git/*' -not -path './vendor/*' \
  | while IFS= read -r path; do
      target="$(printf '%s' "$path" | sed -e "s/{COMPONENT_NAME}/$NAME/g" -e "s/{COMPONENT_SLUG}/$SLUG/g")"
      mv -- "$path" "$target"
    done

# 4. Template-only assets.
rm -rf images/

# 5. Fail loudly if anything was missed.
if grep -rIl --exclude-dir=.git --exclude-dir=vendor --exclude-dir=graphify-out --exclude="$SELF" \
     -e '{COMPONENT_NAME}' -e '{COMPONENT_SLUG}' -e '{COMPONENT_DESCRIPTION}' . ; then
  echo "✗ placeholders remain in the files listed above" >&2
  exit 1
fi

rm -- "$SELF"

cat <<EOF
✓ waffle-commons/$SLUG configured.

Next (see the component-scaffold skill for the full checklist):
  1. composer install inside the dev container, then: wfl dod $SLUG
  2. umbrella: .gitmodules + gitlink, the umbrella-ci paths filter, git hooks
     (scripts/install-git-hooks.sh); RELEASE_INCLUDE at release preparation
  3. GitHub: merge commits only + delete branch on merge; wfl rulesets:check $SLUG
  4. Packagist: register waffle-commons/$SLUG before its first tag
EOF
